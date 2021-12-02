import glob
lookup1 = 'Input orientation:'
lookup2 = 'Harmonic frequencies (cm**-1), IR intensities (KM/Mole), Raman scattering'
filename= './sampling/*.out'
for out in glob.glob(filename):
	NUM_1=1
	NUM_2=1
	with open(out) as myFile:
	     for num,line in enumerate(myFile, 1):
 		if lookup1 in line: NUM_1=num
 		if lookup2 in line: NUM_2=num
	fileout=open(out+'.txt','w')
	with open(out) as myFile:
	     for num, line in enumerate(myFile, 1):
		if num >= NUM_1 and num <= NUM_2 : fileout.write(line)
 		if num > NUM_2 : break
