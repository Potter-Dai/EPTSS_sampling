import sys
import os
from numpy import *
import numpy as np


datain=np.genfromtxt('tempfreqs_1')
datain1=np.genfromtxt('tempfrc_1')
fileout=open('./tempfreqs','w')
fileout1=open('./tempfrc','w')
num=len(datain)
for i in range(0,num):
    if datain[i]<100 and datain[i]>0 :
        datain1[i]=datain1[i]*(100/datain[i])*(100/datain[i])
        datain[i]=100
    fileout1.write(str(datain1[i])+'\n')
    fileout.write(str(datain[i])+'\n')
fileout.close()
fileout1.close()
