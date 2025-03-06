include(ExternalProject)

if(LINUX_AARCH64 OR APPLE_AARCH64)
    set(OPENBLAS_TARGET "ARMV8")
else()
    set(OPENBLAS_TARGET "NEHALEM")
endif()

ExternalProject_Add(
    ext_openblas
    PREFIX openblas
    URL https://github.com/xianyi/OpenBLAS/releases/download/v0.3.20/OpenBLAS-0.3.20.tar.gz
    URL_HASH SHA256=8495c9affc536253648e942908e88e097f2ec7753ede55aca52e5dead3029e3c
    DOWNLOAD_DIR "${OPEN3D_THIRD_PARTY_DOWNLOAD_DIR}/openblas"
    PATCH_COMMAND ${GIT_EXECUTABLE} init
    COMMAND       ${GIT_EXECUTABLE} apply --ignore-space-change --ignore-whitespace
                  ${CMAKE_CURRENT_LIST_DIR}/3760.patch
    CMAKE_ARGS
        ${ExternalProject_CMAKE_ARGS}
        -DTARGET=${OPENBLAS_TARGET}
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
    BUILD_COMMAND "make HOSTCC=gcc CC=${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android33-clang NOFORTRAN=0 TARGET=ARMV8 PREFIX=../../ -j16 install"
)

ExternalProject_Get_Property(ext_openblas INSTALL_DIR)
set(OPENBLAS_INCLUDE_DIR ${INSTALL_DIR}/include/openblas/) # "/" is critical.
set(OPENBLAS_LIB_DIR ${INSTALL_DIR}/${Open3D_INSTALL_LIB_DIR})
set(OPENBLAS_LIBRARIES openblas)

message(STATUS "OPENBLAS_INCLUDE_DIR: ${OPENBLAS_INCLUDE_DIR}")
message(STATUS "OPENBLAS_LIB_DIR ${OPENBLAS_LIB_DIR}")
message(STATUS "OPENBLAS_LIBRARIES: ${OPENBLAS_LIBRARIES}")
