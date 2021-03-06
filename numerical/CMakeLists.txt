cmake_minimum_required (VERSION 3.12)  
# 3.9: MPI::MPI_Fortran, 3.11: Lapack, 3.12 for find_ROOT
project(gem-num Fortran)
enable_testing()

get_directory_property(hasParent PARENT_DIRECTORY)
if(NOT hasParent)
  if(NOT realbits)
    set(realbits 64)
  endif()
  list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/../cmake/Modules/)
  include(../cmake/compilers.cmake)
  include(../cmake/libraries.cmake)
endif()

add_library(const constants/phys_consts.F90)
target_compile_definitions(const PRIVATE REALBITS=${realbits})
target_compile_options(const PRIVATE ${FFLAGS})
# set_target_properties(const PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_SOURCE_DIR}/objects)

add_library(interp interpolation/interpolation.f90)
target_link_libraries(interp PRIVATE const)
target_compile_options(interp PRIVATE ${FFLAGS})
# set_target_properties(interp PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_SOURCE_DIR}/objects)


if(CMAKE_BUILD_TYPE STREQUAL Debug)
  include(interpolation/test_interp.cmake)
endif()


add_library(mpimod mpimod/mpimod.F90)
target_link_libraries(mpimod PRIVATE const MPI::MPI_Fortran)
target_compile_definitions(mpimod PRIVATE REALBITS=${realbits})
target_compile_options(mpimod PRIVATE ${FFLAGS})
# set_target_properties(mpimod PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_SOURCE_DIR}/objects)

add_library(grid grid/grid.f90)
target_link_libraries(grid PUBLIC const mpimod MPI::MPI_Fortran) # PUBLIC necessary for ifort, even with MPI target
target_compile_options(grid PRIVATE ${FFLAGS})
# set_target_properties(grid PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_SOURCE_DIR}/objects)

add_library(calculus calculus/calculus.f90)
target_link_libraries(calculus PRIVATE grid)
target_compile_options(calculus PRIVATE ${FFLAGS})
# set_target_properties(calculus PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_SOURCE_DIR}/objects)


# ----- diffusion
add_library(diffusion diffusion/diffusion.F90)
target_link_libraries(diffusion PRIVATE grid)
target_compile_options(diffusion PRIVATE ${FFLAGS})
if(LAPACK95_FOUND)
  target_link_libraries(diffusion PRIVATE ${LAPACK95_LIBRARIES})
  target_include_directories(diffusion PRIVATE ${LAPACK95_INCLUDE_DIRS})
else()
  target_sources(diffusion PRIVATE ${PROJECT_SOURCE_DIR}/../vendor/lapack95/gbsv.F90)
  target_compile_definitions(diffusion PRIVATE REALBITS=${realbits})
  target_link_libraries(diffusion PRIVATE ${LAPACK_LIBRARIES})
endif()
# set_target_properties(diffusion PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_SOURCE_DIR}/objects)

if(CMAKE_BUILD_TYPE STREQUAL Debug)
  include(test_diffusion.cmake)
endif()

# -- more libs

add_library(advec advection/advec_mpi.f90)
target_link_libraries(advec PRIVATE const mpimod grid)
target_compile_options(advec PRIVATE ${FFLAGS})
# set_target_properties(advec PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_SOURCE_DIR}/objects)

