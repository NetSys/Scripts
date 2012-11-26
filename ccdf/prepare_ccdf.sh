#!/bin/bash


cd /home/cs/Networks/Results/name_conformance/rate_limiting/outputs/responses_per_IP
 
for FILE in `ls *unbalanced | sort`; do
	#~/Networks/Scripts/create_ccdf.rb  $FILE $num
	sort -nr ${FILE}.ccdf > sorted
	mv sorted ${FILE}.ccdf

done
