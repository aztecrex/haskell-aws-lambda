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
* access AWS Lambda context in Haskell
* access AWS Lambda event in Haskell
* return AWS Lambda result from Haskell
* converting a pure or effectful function into a compatible one
* handle invalid event data (currently also handle bad context -- that will change, tho)

## Deploy to Lambda

The test project can be packaged using the `package.sh` script.
Working on making that all more convenient so stay tuned.

Push `hslambda.zip` up to your Lambda function.

For my own experimentation, `update.sh` repeatably packages and
pushes the test project to AWS Lambda.
`invoke.sh` invokes
the function and displays the results:
- `invoke.sh add`: add two arbitrary numbers, show context with result
- `invoke.sh multiply`: multiply two arbitrary numbers, show context with result
- `invoke.sh zoo`: try to do math at the zoo
- `invoke.sh`: demonstrate unmarshallable input

## A Library to Support This

The test project now depends on
[`aws-lambda`](https://github.com/aztecrex/haskell-lib-aws-lambda) which
takes some of this projects ideas and makes them a Haskell package.
I'll continue moving code toward that project from here. Eventually
this project will just be a demo for how to use that and possibley
other interop modules to build AWS Lambda functions in Haskell.

