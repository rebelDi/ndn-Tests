#!/bin/bash


max=10
pro = 1
pchange = "1.5"
for (( i=1; i <= $max; ++i ))
        do
                NS_GLOBAL_VALUE="RngRun=$i" ./waf --run="ndn-edge --Run=$i --PECChange=$pchange --Proactive=$pro"  &

                echo "Start instance $i for id $Test"
done
wait
echo "Finished for $Test at $(date)!"
#echo "All Simulations Complete"
echo "All Simulations Complete for New Run"

