#!/bin/sh
#
# "-d" option makes this a Debug build
#
# This is for Matt's machine, so he can use the older libraries he's been working with for some time.

module load blas/gcc/64/3.7.0
module load lapack/gcc/64/3.7.0
module load openmpi/gcc/64/1.10.3

OPTS="-DMUMPS_ROOT=~/zettergmdata/lib/MUMPS_4.10.0 -DSCALAPACK_ROOT=~/zettergmdata/lib/scalapack-2.0.2"

[[ $1 == "-d" ]] && OPTS="-DCMAKE_BUILD_TYPE=Debug $OPTS"
[[ $1 == "-t" ]] && OPTS="-DTRACE:BOOL=on $OPTS"

rm -r objects/*  # need this one-time in case different compiler e.g. ifort was previously used.

cmake $OPTS -B objects .

cmake --build objects -j
