origdir=./
randdir=./
proggramdir=./
freqfile=$1
# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1 generate geoPlusVel and first input file
	echo 3 > runpointnumber
 	$randdir/randgen > temp811
# the next 8 lines would have to be changed to use low-precision modes
 	awk '/A         A         A         A         A/,/Harmonic frequencies/{print}' $freqfile > temp401
 	awk '/Frequencies --/ {print $3;print $4;print $5;print $6;print $7}' temp401 > tempfreqs
 	awk '/Reduced masses/ {print $4;print $5;print $6;print $7;print $8}' temp401 > tempredmass
 	awk '/Force constants/ {print $4;print $5;print $6;print $7;print $8}' temp401 > tempfrc
mv tempfreqs tempfreqs_1
mv tempfrc tempfrc_1
 	python2 revisefreq.py
 	awk '/0/ && ((length($1) < 2) && ($1 < 4)) {print}' $freqfile > tempmodes
 	awk '/has atomic number/ {print}' $freqfile > tempmasses
 	awk '/Input orientation:/,/tional const/ {if ( $2 < 50 && $2 > 0) print}' $freqfile > tempstangeos
 	awk -f $proggramdir/proggenHP $freqfile > geoPlusVel
 	if (test -f isomernumber) then
	    cp isomernumber temp533
 	    awk 'BEGIN {getline;i=$1+1;print i,"----trajectory isomer number----"}' temp533 > isomernumber
	    rm temp533
 	else
 	    echo "1 ----trajectory isomer number----" > isomernumber
 	fi
