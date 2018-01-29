#!/usr/bin/env bash

cd $(dirname $0)

docker run --rm -it -v $(pwd):/build -v "${HOME}/.stack:/root/.stack" aztecrex/hslambda bash


