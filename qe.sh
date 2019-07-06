cd; 

while getopts d: option
do
    case "${option}"
        in
        d) DATABASE=${OPTARG};;
    esac
done

if [ ! -d $DATABASE"_EXPORTED" ] 
then
    mkdir $DATABASE"_EXPORTED";    
fi

cd $DATABASE"_EXPORTED";

if [ -f LOG ] 
then
    rm LOG;
fi

echo 'show collections' | mongo $DATABASE > FILE;
head -n -1 FILE > TMP; mv TMP FILE;
tail -n +4 FILE > TMP; mv TMP FILE;

declare -a COLLECTIONS;

while read FILE ; 
do
    COLLECTIONS+=($FILE)
done < FILE;

if [ ${#COLLECTIONS[@]} -eq 0 ]; then
    echo $DATABASE" is empty or does not exist.";
    exit;
fi

cd;

for i in "${COLLECTIONS[@]}"; 
do 
    mongoexport --db $DATABASE -c "$i" --out EXPORTED_"$i".json 2>> LOG;
    mv EXPORTED_"$i".json $DATABASE"_EXPORTED/EXPORTED_"$i".json";   
done

mv LOG $DATABASE"_EXPORTED/LOG";

cd $DATABASE"_EXPORTED";

rm FILE;

echo $DATABASE" exported, for more details check LOG file.";

nautilus . ;