#!/usr/bin/env bash

op=${1}

tempin=$(mktemp)
case $op in
    add)
cat << EOIN > "$tempin"
{
    "y": 993,
    "x": 1003,
    "tag":"MathAdd"
}
EOIN
    ;;
    multiply)
cat << EOIN > "$tempin"
{
    "y": 993,
    "x": 1003,
    "tag":"MathMultiply"
}
EOIN
    ;;
    zoo)
cat << EOIN > "$tempin"
{
    "animal": "giraffe",
    "tag":"MathZoo"
}
EOIN
    ;;
    *)
cat << EOIN > "$tempin"
{
    "some": "thing"
}
EOIN
    ;;
esac


echo Request:
cat "$tempin"

echo Response:

tempout=$(mktemp)

aws lambda invoke --payload file://${tempin} --function-name ICallHaskell "$tempout"
rm "$tempin"

cat "$tempout"
rm "$tempout"

echo

# {"y": 993, "x": 101, "tag": "MathAdd"}


