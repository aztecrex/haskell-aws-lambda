# AWS Lambda Function in Haskell

Proof-of-concept.

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

The test project shows:
* marshall JSON to and from code written in Haskell
* converting a pure or effectful function into a compatible one


## Deploy to Lambda

The test project can be packaged using the `package.sh` script.
Working on making that all more convenient so stay tuned.

Push `hslambda.zip` up to your Lambda function.

For my own experimentation, `update.sh` repeatably packages and
pushes the test project to AWS Lambda.
