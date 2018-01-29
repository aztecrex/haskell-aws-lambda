#!/usr/bin/env bash

cd /build
stack build
stack install

lib='/build/.stack-work/install/x86_64-linux/lts-10.4/8.2.2/lib/libhelloFromHaskell.so'
dest='/output/lib'

rm -rf /output/*
mkdir -p "$dest"
cp "$lib" "/output/$(basename $lib)"
tmpfile=$(mktemp)
ldd "$lib" | cut -d' ' -f 3 > $tmpfile
for i in $(cat $tmpfile); do
   cp "$i" "${dest}/$(basename $i)"
done
rm $tmpfile
