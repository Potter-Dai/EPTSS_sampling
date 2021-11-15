#!/bin/bash

cat number.txt | while read line
do 
echo "$line"

/bin/cat > ./rsts/frames_$line.in <<EOF
parm ./min.prmtop
trajin ./Production1-15.nc $line $line
trajout ./rsts/frames_$line.pdb
strip :WAT,Na+,Cl-
autoimage
go
quit
EOF

cpptraj -i ./rsts/frames_$line.in
done
rm ./rsts/*.in
