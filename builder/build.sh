#!/usr/bin/env bash

set -e

cd /build
stack clean
stack build
stack install

productdir="/output/"

product="/output/hslambda"

lib='/build/.stack-work/install/x86_64-linux/lts-10.5/8.2.2/lib/libhelloFromHaskell.so'

work=$(mktemp -d)
dest="$work/lib"
mkdir -p "$dest"

cp "$lib" "/$work/$(basename $lib)"
tmpfile=$(mktemp)
ldd "$lib" | cut -d' ' -f 3 > $tmpfile
for i in $(cat $tmpfile); do
   cp "$i" "${dest}/$(basename $i)"
done

cd "$work"
zip ${opts[@]} -r9 "$product" *
cd /artifacts
zip ${opts[@]} -g "$product" lambda_function.py


