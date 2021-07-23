#!/bin/bash
#
# Copyright 2016 leenjewel
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# # read -n1 -p "Press any key to continue..."

###############################
####cmake方式一键编译protobuf库  目前只支持static静态库
####
####

#遇到错误停止
set -u    

#应用别的
source ./build-android-common.sh

#判断参数version
if [[ -z ${ANDROID_NDK_ROOT} ]]; then
  echo "ANDROID_NDK_ROOT not defined"
  exit 1
fi

#判断版本
if [ -z ${version+x} ]; then 
  version="3.17.3"
fi

#初始化日志颜色
init_log_color

#本地运行路径
TOOLS_ROOT=$(pwd)

SOURCE="$0"
while [ -h "$SOURCE" ]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
pwd_path="$(cd -P "$(dirname "$SOURCE")" && pwd)"

echo pwd_path=${pwd_path}
echo TOOLS_ROOT=${TOOLS_ROOT}

PROTOBUF_NAME="protobuf-${version}"

#判断目录是否存在
if [ ! -d ${PROTOBUF_NAME} ];then
    log_info "wget ${PROTOBUF_NAME} to local..."
    #下载到本地  https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/protobuf-cpp-3.17.3.zip
    rm -rf ${PROTOBUF_NAME}
    rm -rf protobuf-cpp-${version}.zip
    wget --no-check-certificate http://github.com/protocolbuffers/protobuf/releases/download/v${version}/protobuf-cpp-${version}.zip
    unzip "protobuf-cpp-${version}.zip"
fi
rm -rf protobuf-cpp-${version}.zip
cd ${PROTOBUF_NAME}


#配置cmake
function configure_make() {
    ARCH=$1
    ABI=$2
    ABI_TRIPLE=$3

    log_info "configure make  protobuf-${ABI} start..."

    CMAKE_PATH=$(pwd)/cmake
    CMAKE_PROJECT_PATH=$(pwd)/cmake-$ABI
    CMAKE_OUT_PATH="$TOOLS_ROOT/../output/android/protobuf-$ABI"

    rm -rf $CMAKE_PROJECT_PATH

    echo  cmake ${CMAKE_PATH} -B${CMAKE_PROJECT_PATH} -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=${CMAKE_OUT_PATH} -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake -DANDROID_NATIVE_API_LEVEL=${api} -DANDROID_ABI=${ABI} -DBUILD_SHARED_LIBS=OFF -Dprotobuf_BUILD_TESTS=OFF
    cmake ${CMAKE_PATH} -B${CMAKE_PROJECT_PATH} -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=${CMAKE_OUT_PATH} -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake -DANDROID_NATIVE_API_LEVEL=${api} -DANDROID_ABI=${ABI} -DBUILD_SHARED_LIBS=OFF -Dprotobuf_BUILD_TESTS=OFF

    log_info "make $ABI start..."

    cd cmake-$ABI
    cmake --build . --target install

    cd ../
    rm -rf $CMAKE_PROJECT_PATH

    log_info "make $ABI end..."
}

log_info "begin build-android-protobuf..."

for ((i = 0; i < ${#ARCHS[@]}; i++)); do
    if [[ $# -eq 0 || "$1" == "${ARCHS[i]}" ]]; then
         configure_make "${ARCHS[i]}" "${ABIS[i]}" "${ARCHS[i]}-linux-android"
    fi
done

log_info "build-android-protobuf done..."
