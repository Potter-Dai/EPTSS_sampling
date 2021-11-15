mkdir coms
echo "Input the number of atoms in your system"
read N_atom
echo "Input the name of prmtop"
read Name
#make sure the 8th line correspond to the charge and multiplicity information in template file.
awk 'NR>=1&&NR<=8 {print $0;}' ./com/template.com> head.txt
awk 'NR>=9&&NR<='$(($N_atom+8))' {print $1;}' ./com/template.com> temp1.txt
awk 'NR>=9&&NR<='$(($N_atom+8))' {print $2;}' ./com/template.com> temp2.txt
awk 'NR>=9&&NR<='$(($N_atom+8))' {print $6;}' ./com/template.com> temp6.txt
awk 'NR>='$(($N_atom+9))' {print $0;}' ./com/template.com> end.txt
find ./rsts/ -name "*.rst" |
while read name; do
ambpdb -p ./$Name.prmtop -c $name> ${name%.*}.pdb
sed -i /^TER*/d ${name%.*}.pdb
sed -i /^REMARK*/d ${name%.*}.pdb
sed -i /^END*/d ${name%.*}.pdb
sed -i /^CRYST*/d ${name%.*}.pdb   #删掉pdb的第一行
awk '{print $6,$7,$8;}' ${name%.*}.pdb> temp345.txt
paste temp1.txt temp2.txt temp345.txt temp6.txt>middle.txt
cat head.txt middle.txt end.txt>${name%.*}.com
mv ${name%.*}.com ./coms
rm ${name%.*}.pdb
done
rm head.txt
rm temp1.txt
rm temp2.txt
rm temp345.txt
rm temp6.txt
rm middle.txt
rm end.txt
