#!/bin/bash

for i in {1..200} 
do
   for j in {1..4}
   do
	if (test -f ./mdcrd/md_qm_f"$i""$j".mdcrd) then	
        	sed -e "s/md_qm_f11/md_qm_f"$i""$j"/g;s/md_qm_r11/md_qm_r"$i""$j"/g;s/md_qm_w11/md_qm_w"$i""$j"/g" parm.in > trans.in
		cpptraj -i trans.in
	fi
   done
done

