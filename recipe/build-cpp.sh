set -eux

if [[ "$target_platform" =~ "osx" ]]; then
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  # workaround double compiler activation
  # https://github.com/conda-forge/ctng-compiler-activation-feedstock/issues/140
  # fenics-dolfinx package needs to switch to gcc_impl instead of ${{ compiler('c') }}
  unset CFLAGS
  unset CXXFLAGS
  unset LDFLAGS
  echo $BUILD_PREFIX
  ls -l "$BUILD_PREFIX/etc/conda/activate.d/"
  for f in "${BUILD_PREFIX}"/etc/conda/activate.d/*_${target_platform}.sh; do
    echo "reactivating $f"
    source "$f"
  done
fi

cmake \
  ${CMAKE_ARGS} \
  -DCMAKE_BUILD_TYPE=Release \
  -DPython3_FIND_STRATEGY=LOCATION \
  -DCMAKE_CXX_COMPILER=$(basename $CXX) \
  -B build \
  cpp/
cmake --build build --parallel "${CPU_COUNT}"
cmake --install build
