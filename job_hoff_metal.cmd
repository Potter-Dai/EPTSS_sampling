#!/bin/bash 
 
#BSUB -J sptss
#BSUB -q short 
#BSUB -n 40 
#BSUB -R "span[ptile=40]"
#BSUB -W 24:00 
#BSUB -o Jobname.out  
#BSUB -e Jobname.err 
#
#
source /work/chem-daibt/Apps/amber19-with-patches/amber.sh
source ~/Apps/g09-env.sh
workdir=/work/chem-daibt/qmmm/graduation/SPTSS/qmtraj
module load intel/2017.8
#
i=1
j=1
while [ $i -le 4 ]
do
    sander -O -i $workdir/input/md_qm.in -o $workdir/out/md_qm_f$j$i.out -p $workdir/prmtop/min.prmtop -c $workdir/FRrst/revise_f$j$i.rst  -r md_qm_f.rst -x $workdir/mdcrd/md_qm_f$j$i.mdcrd
#  $AMBERHOME/bin/sander -O -i input/md_qm.in -o out/md_qm_f101.out -p prmtop/LUF.prmtop -c FRrst/revise_f101.rst -ref FRrst/revise_f101.rst -r md_qm_f.rst -x mdcrd/md_qm_f101.mdcrd
    sander -O -i $workdir/input/md_qm.in -o $workdir/out/md_qm_r$j$i.out -p $workdir/prmtop/min.prmtop -c $workdir/FRrst/revise_r$j$i.rst  -r md_qm_r.rst -x $workdir/mdcrd/md_qm_r$j$i.mdcrd
    let i++
done
 
