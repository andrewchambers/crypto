
function printbytes(num)
{
	printf("\t\t[")
	for (i = 1; i <= length($3); i += 2) {
		printf("0x%s, ", substr($3, i, 2))
		if(i != length($3)-1 && (i+1) % 16 == 0) {
			printf("\\\n\t\t ")
		}
	}
	printf("]")
}

BEGIN {
	n = -1
}

$1 == "[ENCRYPT]" {
	PT="inp"
	CT="out"
	printf("const %sencvecs : %stest = \\\n", TESTNAME, TESTNAME)
	printf("[ \\\n")
}

# Assumed Encrypt came before decrypt
$1 == "[DECRYPT]" {
	PT="out"
	CT="inp"
	printf("] \\\n]\n")
	n = -1
	printf("const %sdecvecs : %stest = \\\n", TESTNAME, TESTNAME)
	printf("[ \\\n")
}

$1 == "COUNT" {
	n++
	if(n != 0) {
		printf("],\n")
	}
	printf("\t[ \\")
}

$1 == "KEY" { 
	printf("\n\t\t.key = \\\n")
	printbytes($3)
	printf("[:],")
}
$1 == "PLAINTEXT" { 
	printf("\n\t\t.%s = \\\n", PT)
	printbytes($3)
	printf(",")
}
$1 == "CIPHERTEXT" { 
	printf("\n\t\t.%s = \\\n", CT)
	printbytes($3)
	printf(",")
}

END {
	printf("] \\\n]\n")
}

