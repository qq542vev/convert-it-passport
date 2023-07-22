#! /modernish/helper/script/for/awk -f

BEGIN {


	RS = "\1";
}

NR == 1 {
	text = $0;
}

NR > 1 {
	text = (text)(RS)($0);
}

END {
	$0 = "";


	FS = ENVIRON["_Msh_tac_s"];
	if ("_Msh_tac_r" in ENVIRON) {
		FS = convertere(FS);
	} else {
		gsub(/[\\.[(*+?{|^$]/, "\\\\&", FS);
	}
	if (length(FS) == 1)
		FS = ("(")(FS)(")");
	n = split(text, field);


	p = 1;
	for (i = 1; i < n; i++) {
		p += length(field[i]);
		if (match(substr(text, p), FS) != 1)
			exit 13;
		sep[i] = substr(text, p, RLENGTH);
		p += RLENGTH;
	}
	text = "";


	ORS = "";
	if ("_Msh_tac_b" in ENVIRON) {

		for (i = n; i >= 0; i--)
			print (sep[i])(field[i+1]);
	} else if ("_Msh_tac_B" in ENVIRON) {

		for (i = n; i > 0; i--)
			print (sep[i])(field[i]);
	} else {

		for (i = n; i > 0; i--)
			print (field[i])(sep[i]);
	}
}
