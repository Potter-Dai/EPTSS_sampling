mkdir out
mkdir mdcrd
#echo "tell me the name of prmtop file"
#read Name
a=`pwd`
for i in {1..200} 
do
 if (test -f ./FRrst/revise_f"$i"1.rst) then
   echo "$i"
   sed -i "s#.workdir=.*#  workdir=$a#g" job_hoff_metal.cmd
   for j in {1..4}
   do
    mkdir job$i$j
    sed -e "s/j=1/j=$i/g;s/i=1/i=$j/g;" job_hoff_metal.cmd>./job$i$j/job$i.cmd   
    if (test -f ./gau_job.tpl) then
      cp gau_job.tpl ./job$i$j
    fi
   done
 fi
done
#echo "Do you want to submit them ?(y/n)"
#read yorn
#if [ "$yorn" = "y" ]; then
for i in {1..200}
do
if (test -f ./FRrst/revise_f"$i"1.rst) then  
 for j in {1..4}
 do
 cd ./job$i$j
 dos2unix job$i.cmd
 bsub < job$i.cmd
 cd ..
 done
fi
done
#else
#echo "exit"
#exit 0
#fi
