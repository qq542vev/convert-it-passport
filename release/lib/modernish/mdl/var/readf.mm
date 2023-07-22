#! /module/for/moderni/sh
\command unalias readf 2>/dev/null


readf() {
	unset -v _Msh_rFo_h
	forever do
		case ${1-} in
		( -h )	export _Msh_rFo_h=y ;;
		( -- )	shift; break ;;
		( -* )	die "readf: invalid option: $1" ;;
		( * )	break ;;
		esac
		shift
	done
	let "$# == 1" || die "readf: 1 variable name expected"
	str isvarname "$1" || die "readf: invalid variable name: $1"
	command eval "$1"'=$(
		command export LC_ALL=C "PATH=$DEFPATH" POSIXLY_CORRECT=y || die "readf: export failed"
		(command od -vb || die "readf: od failed") | command awk '\''
		BEGIN {


			for (i=0; i<=31; i++)
				c[sprintf("%o",i)]="OCT";
			for (i=32; i<=255; i++) {
				c[sprintf("%o",i)]=sprintf("%c",i);
			}
			c[7]="\\a";
			c[10]="\\b";
			c[11]="\\t";
			c[12]="\n";
			c[13]="\\v";
			c[14]="\\f";
			c[15]="\\r";
			c[45]="%%";
			c[134]="\\\\";
			prevo=0;
			odline="";
			ORS="";
		}
		NR>1 && NF>1 {
			print odline;
			odline="";
		}
		{
			for (i=2; i<=NF; i++) {
				v=$i+0;
				if ( (v>=200 && ENVIRON["_Msh_rFo_h"]=="y") ||
				  ! (v>=177 || c[v]=="OCT" || (prevo && v>=60 && v<=67)) ) {
					odline=(odline)(c[v]);
					prevo=0;
				} else {
					odline=(odline)("\\")(v);
					prevo=1;
				}
			}
		}
		END {


			if (odline ~ /\n$/)
				print substr(odline,1,length(odline)-1) "\\n";
			else
				print odline;
		}
		'\'' || die "readf: awk failed") || die "readf: assignment failed"
	' || die "readf: eval failed"
	unset -v _Msh_rFo_h
}

if thisshellhas ROFUNC; then
	readonly -f readf
fi
