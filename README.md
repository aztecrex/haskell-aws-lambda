# AWS Lambda Function in Haskell

Proof-of-concept.

## First Steps: call a Haskell dynamic library function

Initially, going to try to get nh2's msgpack-based solution
running on Linux. I'm on a Mac, so Vagrant. CentOS 7 is likely
a reasonable facsimile for the AWS Lambda container so try
that first.

`vagrant up`
`vagrant ssh`

On the Linux VM now.

``` sh
# need git
sudo yum install -y git

# need epel for python things
sudo yum install epel-release

# python
sudo yum install pip  # not really needed but whatever
sudo yum install python2-msgpack

# haskell stack
curl -sSL https://get.haskellstack.org/ | sh

# clone nh2's repo and set it up
git clone https://github.com/nh2/call-haskell-from-anything
cd call-haskell-from-anything/
stack setup

# build it
stack build
# wait and wait and wait...

