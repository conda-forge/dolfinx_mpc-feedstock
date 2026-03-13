set -eux

if [[ "$target_platform" =~ "osx" ]]; then
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
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
