set -eux

if [[ "$target_platform" =~ "osx" ]]; then
  # jthread with clang 19 is behind a flag
  export CXXFLAGS="${CXXFLAGS} -fexperimental-library -D_LIBCPP_DISABLE_AVAILABILITY"
fi

cmake \
  ${CMAKE_ARGS} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_COMPILER=$(basename $CXX) \
  -B build \
  cpp/
cmake --build build --parallel "${CPU_COUNT}"
cmake --install build
