echo off
title Clean Data and Store into Iterim
:: Runs all py files to clean and organize data files in data/raw

echo Processing Data in ../../data/raw/
echo ----------------------
echo Cleaning up data and storing into ../../data/iterim..
Rscript clean_raw.R

echo ALL DONE! Have a good day :)