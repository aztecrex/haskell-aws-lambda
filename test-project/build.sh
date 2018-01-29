#!/usr/bin/env bash

cd $(dirname $0)

mkdir -p output
docker run --rm -it -v $(pwd):/build -v "${HOME}/.stack:/root/.stack" -v $(pwd)/output:/output aztecrex/hslambda /scripts/build.sh


