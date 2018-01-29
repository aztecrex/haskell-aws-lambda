# AWS Lambda Function in Haskell

Proof-of-concept.

## First Steps: call a Haskell dynamic library function

Got nh2's msgpack-based solution working. Converted it
to use foreign-libraries stanza and it's pretty sweet.

But now am intending to replace that solution in favor
of something more simple.

## Docker

Using docker to build. The builder Dockerfiles are
in the `builder` directory. No automation for building
the containers yet. Both will be in Docker Hub under aztecrex account.

## Test Project

The test project has a script `build.sh` that will compile
the code using the build container.

There's also the `interact.sh` script availbe while I'm
working ont it. It simply puts you in a shell with the
container all running and volumed.

## Deploy to Lambda

After building, you can zip up the files in the test
project output directory `cd output; zip -r9 ../../hslambda *` .

Then, from the main directory, add the python handler
with `zip -g hslambda lambda_function.py` .

Push `hslambda.zip` up to your Lambda function. You'll get green
on test but no output from the Haskell code

## Not sure if it's calling the Haskell code

I get green and the funciton seems to succeed but I don't get
any output to the logs. I might have to flush. I'm
going to try to do some parameters and return values next to
see what's up.





