#!/bin/bash

perl -pi -e 's/[[:^ascii:]]//g' $0
