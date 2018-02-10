#!/usr/bin/env bash

here=$(pwd)
base=$(dirname ${0})

d() {
    cd $here; cd $base/$1
}


d .
rm hslambda.zip
d test-project/output
zip -r9 ../../hslambda *
d .
zip -g hslambda lambda_function.py


