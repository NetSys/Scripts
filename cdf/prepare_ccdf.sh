#!/bin/bash

# Given an unsorted data file, sort it into a CCDF format apporiate for
# input to ./compile_ccdf.pl

sort -nr $1
