#!/usr/bin/env bash

base=$(dirname $0)

# ./$base/package.sh
aws lambda update-function-code --function-name ICallHaskell --zip-file "fileb://${base}/test-project/output/hslambda.zip"

