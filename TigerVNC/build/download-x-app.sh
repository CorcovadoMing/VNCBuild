#!/bin/bash

mkdir app &&
cd app &&
grep -v '^#' ../app-7.7.md5 | awk '{print $2}' | wget -i- -c \
    -B http://ftp.x.org/pub/individual/app/ &&
md5sum -c ../app-7.7.md5
