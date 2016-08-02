#!/bin/bash
#----------------------------------------------#
# Perform backups of DynaMIT simulation results #
# Currently save following files:
#-> dtaparam.dat
#-> network
#-> supplyparam
#-> demand
#-> behavior
#-> Sim*
#-> temp/estimatedOD
#-> temp/oc_est_od_
#-> output/sen_flw_Est
#-> output/sen_spd_Est

SOURCE=DynaMIT
DEST=DynaMIT_DATA$1
rm -fr $DEST
mkdir $DEST
mkdir $DEST/temp
mkdir $DEST/output

cp $SOURCE/dtaparam.dat $DEST
cp $SOURCE/*network* $DEST
cp $SOURCE/supplyparam.dat $DEST
cp $SOURCE/demand* $DEST
cp $SOURCE/BehavioralParameters.dat $DEST
cp $SOURCE/Sim* $DEST
cp $SOURCE/temp/estimatedOD* $DEST/temp
cp $SOURCE/temp/oc_est_od* $DEST/temp
cp $SOURCE/output/sen_spd_Est* $DEST/output
cp $SOURCE/output/sen_flw_Est* $DEST/output