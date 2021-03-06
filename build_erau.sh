#!/bin/bash
#
# "-d" option makes this a Debug build
#
# This is for Matt's machine, so he can use the older libraries he's been working with for some time.

#OPTS="-DMUMPS_ROOT=~/lib/MUMPS_4.10.0 -DSCALAPACK_ROOT=~/lib/scalapack-2.0.2"


[[ $1 == "-d" ]] && OPTS="-DCMAKE_BUILD_TYPE=Debug"
[[ $1 == "-t" ]] && OPTS="-DTRACE:BOOL=on $OPTS"

MKLROOT=
LD_LIBRARY_PATH=

export FC=mpifort
export CC=gcc

rm -r objects/*  # need this one-time in case different compiler e.g. ifort was previously used.

cmake $OPTS -B objects .

cmake --build objects -j

