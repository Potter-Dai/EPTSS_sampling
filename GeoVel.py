import sys
import os
from numpy import *
import numpy as np
import glob
#
# extract information from geoPlusVel file
def getGeo(Geo,lines_gv,N_atom):
    for i in range(1,1+N_atom):
        for j in range (1,4):Geo.append(float(lines_gv[i].split()[j]))
    return Geo
def getVel(Vel,lines_gv,N_atom,N_solute):
    for i in range(1+N_atom,1+N_atom+N_solute):
        for j in range (0,3):Vel.append(48.89*float(lines_gv[i].split()[j]))
    return Vel
# extract information from RST file
def getVel_slv(Vel,lines_rst,N_atom,N_solute):
    # if the number of solute is odd
    if int((N_solute-1)/2) == int(N_solute/2):
        for j in range (3,6):Vel.append(float(lines_rst[(len(lines_rst)+N_solute)/2].split()[j]))
    # if the number of solute is even
    if int((N_solute+1)/2) == int(N_solute/2):
        for j in range (0,6):Vel.append(float(lines_rst[(len(lines_rst)+1+N_solute)/2].split()[j]))
    for i in range((len(lines_rst)+1+N_solute)/2+1,len(lines_rst)-2):
        for j in range (0,6):Vel.append(float(lines_rst[i].split()[j]))
    if int((N_atom-1)/2) == int(N_atom/2):
        for j in range(0,3):Vel.append(float(lines_rst[len(lines_rst)-2].split()[j]))
    if int((N_atom+1)/2) == int(N_atom/2):
        for j in range(0,6):Vel.append(float(lines_rst[len(lines_rst)-2].split()[j]))
    return Vel
# print information
def printGeo(data,fileout):
    if data>=10.0 : fileout.write("%12.7f" % round(data,7))
    if data<10.0 and data>0.0: fileout.write("%12.7f" % round(data,7))
    if data<0.0 and data>-10.0: fileout.write("%12.7f" % round(data,7))
    if data<-10.0 and data>-100.0: fileout.write("%12.7f" % round(data,7))
def printVel(data_Vel,fileout):
    if data_Vel>0.0:fileout.write("%12.7f" % round(data_Vel,7))
    else:fileout.write("%12.7f" % round(data_Vel,7))
# Main function
N_atom=input("Please input the total number of atoms in the system \n")
N_geo=input("Please input the max index of geoplusVel files in your sampling \n")  #change the discription
N_solute=input("Please input the number of solute atoms \n")
os.system("mkdir FRrst")
for num in range(1,N_geo+1):
  RST='./rsts/frames_'+str(num)+'.rst'
  if os.path.exists(RST):                                                           #add this line!
    for N_cycle in range(1,11):
        textfile= './g09/geoPlusVel_'+str(num)+'.'+str(N_cycle)
        if os.path.exists(textfile):
            filein_gv=open(textfile,'r')
            filein_rst=open(RST,'r')
            lines_gv=filein_gv.readlines()
            lines_rst=filein_rst.readlines()
            Geo=[]
            Vel=[]
            Geo=getGeo(Geo,lines_gv,N_atom)
# get solute velocity
            Vel=getVel(Vel,lines_gv,N_atom,N_solute)
# Get solvent velocity
            Vel=getVel_slv(Vel,lines_rst,N_atom,N_solute)
            nVel=np.negative(Vel)
            fileout_f=open('./FRrst/revise_f'+str(num)+str(N_cycle)+'.rst','w')
            fileout_r=open('./FRrst/revise_r'+str(num)+str(N_cycle)+'.rst','w')
# making RST file
            fileout_f.write(lines_rst[0])
            fileout_f.write(lines_rst[1])
            fileout_r.write(lines_rst[0])
            fileout_r.write(lines_rst[1])
 # copying geometry info
            for i in range(0,N_atom):
                printGeo(Geo[3*i],fileout_f)
                printGeo(Geo[3*i+1],fileout_f)
                printGeo(Geo[3*i+2],fileout_f)
                printGeo(Geo[3*i],fileout_r)
                printGeo(Geo[3*i+1],fileout_r)
                printGeo(Geo[3*i+2],fileout_r)
                if int((i-1)/2) == int(i/2) :
                    fileout_r.write('\n')
                    fileout_f.write('\n')
            if int((N_atom-1)/2) == int(N_atom/2) :
                    fileout_r.write('\n')
                    fileout_f.write('\n')
# copying Vel info
            for i in range(0,N_atom):
                printVel(Vel[3*i],fileout_f)
                printVel(Vel[3*i+1],fileout_f)
                printVel(Vel[3*i+2],fileout_f)
                printVel(nVel[3*i],fileout_r)
                printVel(nVel[3*i+1],fileout_r)
                printVel(nVel[3*i+2],fileout_r)
                if int((i-1)/2) == int(i/2) :
                    fileout_r.write('\n')
                    fileout_f.write('\n')
            if int((N_atom-1)/2) == int(N_atom/2) :
                    fileout_r.write('\n')
                    fileout_f.write('\n')
            fileout_f.write(lines_rst[len(lines_rst)-1])
            fileout_r.write(lines_rst[len(lines_rst)-1])
# close files
            fileout_f.close()
            fileout_r.close()
            filein_gv.close()
            filein_rst.close() 
