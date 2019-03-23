echo off
title Add service era column to data
:: Runs all py files to clean and organize data files in data/raw

echo Adding service era to main dataset
echo This will take up to 20 minutes
echo ----------------------
Rscript Create_Service_ERA.R

echo ALL DONE! Have a good day :)