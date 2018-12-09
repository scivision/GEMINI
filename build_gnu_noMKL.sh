#!/bin/bash
# this convenience script initally (one-time) setups up Gemini for gfortran
# *** for subsequent builds, you can just type "make" in the objects/ directory ***
# (I keep a second Terminal tab for this purpose)

# MUMPS is provided for Gfortran by:
# apt install libmumps-dev

(
# this temporarily disables Intel compiler (if installed) from messing up your gfortran environment.
MKLROOT=

rm -r objects/*  # need this one-time in case different compiler e.g. ifort was previously used.
cd objects

FC=/usr/bin/mpif90.openmpi cmake ..

)

# Requires CMake 3.12
cmake --build objects -j
