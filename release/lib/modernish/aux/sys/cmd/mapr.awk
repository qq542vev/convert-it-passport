#! /modernish/helper/script/for/awk -f

function round8(num) {
	return (num % 8 == 0) ? num : (num - num % 8 + 8);
}

function printsh(arg) {
	shlen += length(arg);
	if (shlen >= 65533) {
		print "\\\n";
		shlen = length(arg);
	}
	print arg;
}

BEGIN {
	RS = ENVIRON["_Msh_Mo_d"];


	opt_s = ENVIRON["_Msh_Mo_s"] + 0;
	opt_n = ENVIRON["_Msh_Mo_n"] + 0;
	opt_c = ENVIRON["_Msh_Mo_c"] + 0;
	opt_m = ENVIRON["_Msh_Mo_m"] + 0;
	arg_max = ENVIRON["_Msh_ARG_MAX"] + 0;

	L_cmd = 0;
	for (i=1; i<ARGC; i++) {
		if (opt_m) {
			L_cmd += length(ARGV[i]) + 1;
		} else {

			L_cmd += round8(length(ARGV[i]) + 1) + 8;
		}
	}
	ARGC=1;

	c = 0;
	L = L_cmd;
	tL = 0;
}

NR == 1 {
	ORS = "";
	shlen = 0;
	printsh("\"$@\" ");
}

NR <= opt_s {
	next;
}

opt_n && NR > opt_n + opt_s {
	exit 0;
}

{
	if (opt_m) {
		L += length($0) + 1;
	} else {

		L += round8(length($0) + 1) + 8;
	}


	if ((opt_c && c >= opt_c) || (opt_m ? L >= opt_m : L >= arg_max)) {
		printsh("||_Msh_mapr_ckE \"$@\"\n");
		shlen = 0;
		printsh("\"$@\" ");
		c = 0;
		L = L_cmd;
	}

	c++;


	numsegs = split($0, seg, /'/);
	if (numsegs == 0) {
		printsh("'' ");
	} else {
		for (n = 1; n <= numsegs; n++) {
			printsh( ("'") (seg[n]) (n < numsegs ? "'\\'" : "' ") );
		}
	}
}

END {
	if (NR) {
		printsh("||_Msh_mapr_ckE \"$@\"");
	}
	print ("\n! _Msh_M_status=0\n");
}
