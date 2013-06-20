#!/bin/bash

# Given an unsorted data file, sort it into a CDF format apporiate for
# input to ./compile_ccdf.pl

sort -n $1
