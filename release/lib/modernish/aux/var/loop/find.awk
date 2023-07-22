#! /modernish/helper/script/for/awk -f

BEGIN {
	ORS = "";
	base = ("_loop_base" in ENVIRON ? ENVIRON["_loop_base"] : "");

	if (_loop_exec && _loop_SIGCONT)
		write_exec_command();
	else if ("_loop_xargs" in ENVIRON)
		write_xargs_iteration();
	else
		write_iterations();

	if (_loop_SIGCONT) {


		print ("command kill -s CONT ")(_loop_SIGCONT)("; continue\n");
	}
}

function write_iterations() {
	v = ENVIRON["_loop_V"];
	for (i = 1; i < ARGC; i++) {
		print (v)("=")(shellquote((base)(ARGV[i])))("\n");
	}
}

function write_xargs_iteration() {
	if (ENVIRON["_loop_xargs"] == "") {

		print "set --";
		for (i = 1; i < ARGC; i++) {
			print (" ")(shellquote((base)(ARGV[i])));
		}
		print "\n";
	} else {

		print (ENVIRON["_loop_xargs"])("=(");
		for (i = 1; i < ARGC; i++) {
			print (" ")(shellquote((base)(ARGV[i])));
		}
		print " )\n";
	}
}

function write_exec_command() {
	for (i = 1; i < ARGC; i++) {
		print (shellquote(ARGV[i]))(" ");
	}
	print ("|| command kill -s USR1 ")(_loop_SIGCONT)("; ");
}

function replace(s, old, new,
b, L, ns) {
	if (index(s, old)) {
		L = length(old);
		ns = "";
		while (b = index(s, old)) {
			ns = (ns)(substr(s, 1, b - L))(new);
			s = substr(s, b + L);
		}
		return (ns)(s);
	} else {
		return s;
	}
}

function shellquote(s) {
	s = replace(s, "\\", "\\\\");
	s = replace(s, "\"", "\\\"");
	s = replace(s, "$", "\\$");
	s = replace(s, "`", "\\`");
	if (match(s, /[\1\2\3\4\5\6\7\10\11\12\13\14\15\16\17\20\21\22\23\24\25\26\27\30\31\32\33\34\35\36\37\177]/)) {
		s = replace(s, "\1", "${CC01}");
		s = replace(s, "\2", "${CC02}");
		s = replace(s, "\3", "${CC03}");
		s = replace(s, "\4", "${CC04}");
		s = replace(s, "\5", "${CC05}");
		s = replace(s, "\6", "${CC06}");
		s = replace(s, "\7", "${CCa}");
		s = replace(s, "\10", "${CCb}");
		s = replace(s, "\11", "${CCt}");
		s = replace(s, "\12", "${CCn}");
		s = replace(s, "\13", "${CCv}");
		s = replace(s, "\14", "${CCf}");
		s = replace(s, "\15", "${CCr}");
		s = replace(s, "\16", "${CC0E}");
		s = replace(s, "\17", "${CC0F}");
		s = replace(s, "\20", "${CC10}");
		s = replace(s, "\21", "${CC11}");
		s = replace(s, "\22", "${CC12}");
		s = replace(s, "\23", "${CC13}");
		s = replace(s, "\24", "${CC14}");
		s = replace(s, "\25", "${CC15}");
		s = replace(s, "\26", "${CC16}");
		s = replace(s, "\27", "${CC17}");
		s = replace(s, "\30", "${CC18}");
		s = replace(s, "\31", "${CC19}");
		s = replace(s, "\32", "${CC1A}");
		s = replace(s, "\33", "${CCe}");
		s = replace(s, "\34", "${CC1C}");
		s = replace(s, "\35", "${CC1D}");
		s = replace(s, "\36", "${CC1E}");
		s = replace(s, "\37", "${CC1F}");
		s = replace(s, "\177", "${CC7F}");
	}
	return ("\"")(s)("\"");
}
