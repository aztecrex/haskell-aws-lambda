#!/usr/bin/env bash



tempin=$(mktemp)
cat << EOIN > "$tempin"
{
    "yo":"lo",
    "177":"yes",
    "bar":"foo"
}
EOIN

tempout=$(mktemp)

aws lambda invoke --payload file://${tempin} --function-name ICallHaskell "$tempout"
rm "$tempin"

cat "$tempout"
rm "$tempout"

echo

