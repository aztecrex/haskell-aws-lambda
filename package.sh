#!/usr/bin/env bash

here=$(pwd)
base=$(dirname ${0})

d() {
    cd $here; cd $base/$1
}


opts=()
if [ -f "$base/hslambda.zip" ]; then
    opts+=(-f)
fi

d test-project/output
zip ${opts[@]} -r9 ../../hslambda *
d .
zip ${opts[@]} -g hslambda lambda_function.py


