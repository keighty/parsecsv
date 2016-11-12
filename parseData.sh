#!/bin/sh

DATAFILE="amazon-upload.csv"

tL=`awk 'NF!=0 {++c} END {print c}' $DATAFILE`
echo $tL
# for i in `seq $NUMWORDS`
# do
# rnum=$((RANDOM%$tL+1))
# sed -n "$rnum p" $DATAFILE
# done
