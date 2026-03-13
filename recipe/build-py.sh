set -eux

# https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

# cross-compile doesn't allow retrieving include-dirs from Python imports
# get them ourselves:
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  # we need:
  # dolfinx.wrappers.get_include_path()
  # petsc4py.get_include()
  # cross-python moves site-packages out of host, into  $BUILD_PREFIX/lib/python$PY_VER/site-packages/
  export BUILD_SPDIR="$BUILD_PREFIX/lib/python$PY_VER/site-packages"
  
  export CMAKE_ARGS="${CMAKE_ARGS} 
    -DPETSC4PY_INCLUDE_DIR=${BUILD_SPDIR}/petsc4py/include
    -DDOLFINX_PY_DIR=${BUILD_SPDIR}/dolfinx/wrappers
  "
  # make sure these exist
  test -d ${BUILD_SPDIR}/dolfinx/wrappers
  test -d ${BUILD_SPDIR}/petsc4py/include
fi

# show compilation commands for easier debugging
export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_VERBOSE_MAKEFILE=ON"
${PYTHON} -m pip install --no-build-isolation --no-deps -vv ./python
