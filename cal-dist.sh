#!/bin/bash

for i in {1..200} 
do
   for j in {1..4}
   do
	if (test -f ./FRnc/md_qm_w"$i""$j".nc) then	
		sed -e "s/md_qm_w11/md_qm_w"$i""$j"/g;s/1.1Bond/"$i"."$j"Bond/g" distance.in > cal-distance.in
		cpptraj -i cal-distance.in
			for k in {1..3}
			do
				sed -i '/@/d' ./bond-dist/"$i"."$j"Bond"$k".agr
				awk '{lines[NR]=$0} END{i=NR; while(i>0) {print lines[i]; --i} }' ./bond-dist/"$i"."$j"Bond"$k".agr | tail -n 150 > ./bond-dist/new-"$i"."$j"Bond"$k".agr
				cat ./bond-dist/"$i"."$j"Bond"$k".agr | tail -n 150 >> ./bond-dist/new-"$i"."$j"Bond"$k".agr
			done
	fi
   done
done

