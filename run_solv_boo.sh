#!/bin/bash

###pre-work###
/bin/cat > tleap.in<<EOF
source leaprc.water.tip3p
loadamberparams frcmod.ionsjc_tip3p  
source leaprc.gaff
loadamberparams ./TS-1_resp.frcmod 
loadoff ./boo.lib
pdb = loadpdb ./BOO.pdb
solvateBox pdb TIP3PBOX 8.0
saveamberparm pdb min.prmtop min.inpcrd
EOF
tleap -f tleap.in >tleap.log

mkdir min
cp min.prmtop min.inpcrd ./min
cd min

############################

###Full Minimize###
/bin/cat > min.in<<mEOF
initial minimisation whole system
 &cntrl
  imin   = 1,
  maxcyc = 10000,
  ncyc   = 20000,
  ntb    = 1,             
  ntr    = 0,            
  cut    = 10.0
  ibelly = 1,
  bellymask = '@O,H1,H2'
 /
mEOF
sander -O -i min.in -o min.out -p min.prmtop -c min.inpcrd -r min.nrst

############################
cd ..


mkdir heating
cp min.prmtop min/min.nrst heating/
cd heating
/bin/cat > heat.in<<hEOF
ACD-KTP : initial minimisation solvent
 &cntrl 
  ig     = -1,  
  irest  = 0,   
  ntx    = 1,   
  ntb    = 1,   
  cut    = 10.0,
  ntr    = 1,   
  ntc    = 2,   
  ntf    = 2,   
  ntxo   = 2,
  restraint_wt = 500.0,
  restraintmask = ':1',    
  tempi  = 0.0,
  temp0  = 300.0,
  ntt    = 3,
  gamma_ln = 5.0,    
  nstlim = 10000, dt = 0.002,                     
  ntpr = 1000, ntwx = 100, ntwe = 0, ntwr = 1000, 
 /
hEOF
sander -O -i heat.in -o heat.out -p min.prmtop -c min.nrst -r heat.nrst  -ref min.nrst 


############################
cd ..

mkdir equil
cp min.prmtop heating/heat.nrst equil/
cd equil

/bin/cat > equil.in<<eEOF
BCD-KTP : initial minimisation whole system
 &cntrl
  ig     = -1,
  irest  = 1,
  ntx    = 5,
  ntb    = 2,   
  pres0  = 1.0,
  ntp    = 1,
  taup   = 2.0,
  cut    = 10.0,
  ntr    = 1,
  ntc    = 2,
  ntf    = 2,
  ntxo   = 2,
  restraint_wt = 500.0,
  restraintmask = ':1',
  tempi  = 300.0,
  temp0  = 300.0,
  ntt    = 3,
  gamma_ln = 5.0,
  nstlim = 500000, dt = 0.002,
  ntpr = 500, ntwx = 50000, ntwr = 5000,
 /
eEOF
sander -O -i equil.in -o equil.out -p min.prmtop -c heat.nrst -r equil.nrst  -ref heat.nrst 

cd ..

mkdir produc_0
cp min.prmtop equil/equil.nrst produc_0/
cd produc_0

######Production simulation stage###
/bin/cat > 04Production.in<<EOF
Production simulation
 &cntrl
  imin   = 0,
  ig     = -1,
  irest  = 0,
  ntx    = 5,
  ntb    = 2,
  pres0  = 1.0,
  ntp    = 1,
  cut    = 10.0,
  ntr    = 1,
  ntc    = 2,
  ntf    = 2,
  ntxo   = 2,
  restraint_wt = 500.0,
  restraintmask = ':1',
  tempi  = 300.0,
  temp0  = 300.0,
  ntt    = 3,
  gamma_ln = 5.0,
  nstlim = 10000000, dt = 0.002,
  ntpr = 25000, ntwx = 50000, ntwr = 50000,
 /
EOF
sander -O -i 04Production.in -o 04Production.out -p min.prmtop -c equil.nrst -r 04Production.nrst -x 04Production.mdcrd -ref equil.nrst 
 
