mkdir g09
for j in {1..200}
do
    for i in {1..4}
    do
      if (test -f ./ts_out_txt/frames_$j.ts.log.txt) then
         sh g09.sh ./ts_out_txt/frames_$j.ts.log.txt
         mv geoPlusVel ./g09/geoPlusVel_$j.$i
      fi
    done
rm temp*
done
