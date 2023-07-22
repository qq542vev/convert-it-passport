#! /usr/bin/awk -f

BEGIN {
	detectclass();
	if (!ematch_lib) {
		if (ARGC != 3)
			errorout("usage: ematch.awk <string> <ERE>");
		exit !match(ARGV[1], convertere(ARGV[2]));
	}
}

function errorout(s, ere, i) {
	if (s) printf("%s: %s\n", ematch_lib ? ematch_lib : "str ematch", s) | "cat >&2";
	if (ere) printf("%s\n", ere) | "cat >&2";
	if (i) printf(i>1 ? ("%")(i-1)("c^\n") : "^\n", " ") | "cat >&2";
	exit 2;
}

function mylocale() {
	if ("LC_ALL" in ENVIRON && ENVIRON["LC_ALL"] != "")
		return ENVIRON["LC_ALL"];
	else if ("LC_CTYPE" in ENVIRON && ENVIRON["LC_CTYPE"] != "")
		return ENVIRON["LC_CTYPE"];
	else if ("LANG" in ENVIRON && ENVIRON["LANG"] != "")
		return ENVIRON["LANG"];
	else
		return "C";
}

function detectclass() {



	hasclass = match("1", /[[:alpha:][:digit:]]/);




	if (hasclass && match(mylocale(), /[Uu][Tt][Ff]-?8/))
		hasclass = match("éïÑ", /^[[:alpha:]][[:alpha:]][[:alpha:]]$/);





	if (!hasclass)
		bug_brexpr = !match("\t", "^\\t$");
}


function convertere(ere, par, \
	eere, piece, atom, L, c, i, isave, j, b, m, n, d1, d2, havepunct)
{
	par += 0;

	L = length(ere);
	c = substr(ere, 1, 1);
	i = 1;
	while (i <= L) {
		#### Parse just enough ERE grammar to know one atom from the next.
		if (c == "(") {

			atom = ("(")(convertere(substr(ere, ++i), par + 1))(")");
			i += (_Msh_eB_isave - 1);
		} else if (par && c == ")") {

			_Msh_eB_isave = i;
			return eere;
		} else if (c == "|" || c == "^" || c == "$") {

			eere = (eere)(c);
			c = substr(ere, ++i, 1);
			continue;
		} else if (c == "\\" && i < L) {


			c = substr(ere, ++i, 1);
			if (match(c, /[.[\\()*+?{|^$]/))
				atom = ("\\")(c);
			else
				atom = c;
		} else if (c == "[") {

			havepunct = 0;
			atom = "";
			isave = i;
			i++;
			if (substr(ere, i, 1) == "^") {
				i++;
				atom = (atom)("^");
			}
			if (substr(ere, i, 1) == "]") {
				i++;
				atom = (atom)("]");
			}
			while (i <= L && (c = substr(ere, i, 1)) != "]") {
				if (match(d1 = substr(ere, i, 2), /\[[.=:]/)) {

					d2 = (substr(ere, i+1, 1))("]");
					i += 2;
					isave = i - 1;
					while (i < L && substr(ere, i, 2) != d2)
						i++;
					i++;
					if (i > L)
						errorout("unterminated class", ere, isave);
					j = substr(ere, isave, i - isave);
					if (!hasclass) {


						if (j == ":alnum:" ) {
							j = "A-Za-z0-9";
						} else if (j == ":alpha:") {
							j = "A-Za-z";
						} else if (j == ":blank:") {
							if (bug_brexpr) j = " \t"; else j = " \\t";
						} else if (j == ":cntrl:") {
							if (bug_brexpr) j = "\1-\37\177"; else j = "\\1-\\37\\177";
						} else if (j == ":digit:") {
							j = "0-9";
						} else if (j == ":graph:") {
							if (bug_brexpr) j = "\41-\176"; else j = "\\41-\\176";
						} else if (j == ":lower:") {
							j = "a-z";
						} else if (j == ":print:") {
							if (bug_brexpr) j = "\40-\176"; else j = "\\40-\\176";
						} else if (j == ":punct:") {
							havepunct++;
							j = "";
						} else if (j == ":space:") {


							if (bug_brexpr) j = " \t\r\n\13\f"; else j = " \\t\\r\\n\\13\\f";
						} else if (j == ":upper:") {
							j = "A-Z";
						} else if (j == ":xdigit:") {
							j = "A-Fa-f0-9";
						} else if (match(j, /^[=.].*[=.]$/)) {

							if (length(j) > 3)
								errorout("invalid collation character", ere, isave + 1);
							j = substr(j, 2, 1);
							if (j == "\\")
								j = "\\\\";
						} else {
							errorout("invalid character class", ere, isave);
						}
						atom = (atom)(j);
					} else {

						atom = (atom)("[")(j)("]");
					}
				} else if (c == "\\") {



					atom = (atom)("\\\\");
				} else {

					atom = (atom)(c);
				}
				i++;
			}
			if (i > L)
				errorout("unterminated bracket expression", ere, isave);
			if (havepunct) {


				if (substr(atom, 1, 1) == "]") {
					atom = ("][!\"#$%&'()*+,\\./:;<=>?@^_`{|}~")(substr(atom, 2));
				} else {
					atom = ("][!\"#$%&'()*+,\\./:;<=>?@^_`{|}~")(atom);
				}
				if (substr(atom, length(atom), 1) != "-") {
					atom = (atom)("-");
				}
			}
			atom = ("[")(atom)("]");
		} else if (c == "*" || c == "+" || c == "?") {
			errorout("repetition operator not valid here", ere, i);
		} else {

			atom = c;
		}

		#### Now that we've got an atom, parse repetitions to get a piece.
		c = substr(ere, ++i, 1);
		if (c == "*" || c == "+" || c == "?") {

			piece = (atom)(c);
			c = substr(ere, ++i, 1);
		} else if (c == "{" && match(substr(ere, i+1, 1), /[0123456789]/)) {


			piece = "";
			isave = i;
			b = 1;
			m = ""; n = "";
			while ( (c = substr(ere, ++i, 1)) != "}" && i <= L ) {
				if (c == ",")
					b++;
				else if (!match(c, /[0123456789]/))
					errorout("bound: bad number", ere, i);
				else if (b == 1)
					m = ( (m)(c) ) + 0;
				else if (b == 2)
					n = ( (n)(c) ) + 0;
			}
			if (i > L)
				errorout("unterminated bound", ere, isave);
			if (b > 2)
				errorout("bound: too many parameters", ere, isave);
			if (b == 1) {

				for (j = 1; j <= m; j++)
					piece = (piece)(atom);
			} else if (n == "") {

				if (m == 0) {
					piece = (atom)("*");
				} else {
					for (j = 1; j <= m; j++)
						piece = (piece)(atom);
					piece = (piece)("+");
				}
			} else {

				if (n < m)
					errorout("bad bound: max < min", ere, isave);
				for (j = 1; j <= m; j++)
					piece = (piece)(atom);
				for (; j <= n; j++)
					piece = (piece)(atom)("?");
			}
			c = substr(ere, ++i, 1);
		} else {

			piece = atom;
		}
		eere = (eere)(piece);
	}

	if (par)
		errorout("unbalanced parentheses", ere);
	return eere;
}
