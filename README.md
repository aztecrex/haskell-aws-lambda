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
pushes the test project to AWS Lambda. `invoke.sh` invokes
the function and displays the results.

## Template Haskell

This branch was an attempt to use TH to generate function names,
exports, and host code. This effort was blocked by the seeming
fact that you can't lift functions into TH Expressions. So,
providing a makeLambda for some (a -> IO B), where a and
b are ToJSON and FromJSON respectively, is beyond my current
ability in TH. I suspect there is a way and I'll possibly
revisit it sometime.

Meanwhile I'm just going to tag this in case I wans to re-open
it someday.




