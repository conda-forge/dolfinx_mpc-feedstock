set -eux

# https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

# cross-compile doesn't allow retrieving include-dirs from Python imports
# get them ourselves:
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  # we need:
  # dolfinx.wrappers.get_include_path()
  # petsc4py.get_include()
  export CXXFLAGS="-I${SP_DIR}/dolfinx/wrappers -I${SP_DIR}/petsc4py/include ${CXXFLAGS}"
  # make sure these exist
  test -d ${SP_DIR}/dolfinx/wrappers
  test -f ${SP_DIR}/dolfinx/wrappers/array.h
  test -d ${SP_DIR}/petsc4py/include
fi

export CMAKE_ARGS="${CMAKE_ARGS} -DPython3_FIND_STRATEGY=LOCATION"
# show compilation commands for easier debugging
export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_VERBOSE_MAKEFILE=ON"
${PYTHON} -m pip install --no-build-isolation --no-deps -vv ./python
