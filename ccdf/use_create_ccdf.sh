#!/bin/bash


cd /home/cs/Networks/Results/name_conformance/rate_limiting/outputs/responses_per_IP
 
let count="1"
for FILE in `ls *unbalanced | sort`; do
#Horrible horrible horrible
	if [ $count == 1 ]; then
    let num="10"
	elif [ $count == 2 ]; then
		let num="1"
	elif [ $count == 3 ]; then
		let num="20"
	elif [ $count == 4 ]; then
		let num="40"
	elif [ $count == 5 ]; then
		let num="5"
	elif [ $count == 6	]; then
		let num="80"
		let count="0"
	fi
	let count="$count + 1"

	~/Networks/Scripts/create_ccdf.rb  $FILE $num
	sort -nr ${FILE}.ccdf > sorted
	mv sorted ${FILE}.ccdf

done
