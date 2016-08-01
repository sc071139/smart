

CONFIGFILE=~/student/mengyue/drill/db_java/db_manager/config/param.config
PERTURBSCRIPTFILE=~/student/mengyue/drill/dem.csv2demand.dat_converter/Perturb_demand.py
PERTURBDEMANDDATPATH=~/student/mengyue/drill/test/demand_dat/
PERTURBDEMANDCSVPATH=~/student/mengyue/drill/test/demand_csv/
DYNAMITPATH=~/student/mengyue/drill/test/DynaMIT/
MITSIMPATH=~/student/mengyue/drill/test/MITSIM/
DTAPARAMPATH=~/student/mengyue/drill/test/DynaMIT/
GSONJAR=~/student/mengyue/drill/db_java/db_manager/lib/gson-2.5.jar
POSTGRESQLJAR=~/student/mengyue/drill/db_java/db_manager/lib/postgresql-9.4.1209.jre6.jar
SRCPATH=~/student/mengyue/drill/db_java/db_manager/out/production/db_manager

#TODO: Check the validity of the parameters and path to increase robust.


#TODO: Algorithm to generate the proper historical OD flow for the on-going simulation.



# Generate a number of mitsim demand dat file
echo -e
echo -e
echo -e "\e[36;1mgenerating pertubation demand \e[0m"
python $PERTURBSCRIPTFILE

# For-loop for simulation and insertion to database
for I in 1 2 3
do
	printf -v index "%02d" $I
	echo -e
	echo -e
	echo -e "\e[36;1mLOOP$I|=> \e[0m"

	# Alternate the demand file in MITSIM directory with the ith demand file genertated
	(cp ${PERTURBDEMANDDATPATH}demand_MY_${index}.dat ${MITSIMPATH}demand_MITSIM.dat)
	(cp ${PERTURBDEMANDCSVPATH}demand_MY_${index}.csv ${MITSIMPATH}demand_MITSIM.csv)

	# Cleanup files from the backup dir
	echo -e
	echo -e
	echo -e "\e[36;1mClear backup... \e[0m"
	(cd  ${DYNAMITPATH};./backupToDir)

	# Run DynaMIT and MITSIM to get the new estimated od flow
	#TODO: At run-time, save hmatrix to the database
	echo -e
	echo -e
	echo -e "\e[36;1mRun DynaMIT&MITSIM...\e[0m"

	gnome-terminal -e "bash -c \"cd $MITSIMPATH; ./run_xmitsim.sh; exit;exec bash\""
	(cd ${DYNAMITPATH};./runDynaMIT.sh dtaparam.dat)
	
	# Insert to database
	echo -e
	echo -e
	echo -e "\e[36;1mInsert to database...\e[0m"
	java -cp $GSONJAR:$POSTGRESQLJAR:${SRCPATH} util/InsertProcess $CONFIGFILE

	# Make a copy of DynaMIT file at the test file from origin DynaMIT.
	echo -e
	echo -e
	echo -e "\e[36;1mCopy DynaMIT... \e[0m"
	(cd ${DYNAMITPATH};cd ..;rm -fr DynaMIT_$index;cp -r DynaMIT DynaMIT_$index) 

	read

	echo -e
	echo -e
	echo -e
	echo -e "\e[36;1mFinished Process!\e[0m"
done

