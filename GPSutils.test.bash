#!/bin/bash

# Required libraries
. GPSutils.bash
# ---

Date="2012 9 22"
GPSDate=$(Date2GPS "$Date")
echo "GPS Date of $Date is $GPSDate"

GPSDate=17066
Date=$(GPS2Date $GPSDate)
echo "Date of GPS Date $GPSDate is $Date"

exit 0
