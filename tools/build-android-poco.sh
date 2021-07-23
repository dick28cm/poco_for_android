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
####cmake方式一键编译poco库  目前只支持static静态库
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

#删除之前的
if [ ! -d "poco" ];then
    log_info "git clone poco to local..."
    #下载到本地
    git clone https://github.com/pocoproject/poco.git
fi
cd poco

#cmake --build . --target install



#配置cmake
function configure_cmake() {
    ARCH=$1
    ABI=$2

    log_info "configure cmake  poco-${ABI} start..."

    #设置cmake目录
    CMAKE_PROJECT_PATH="cmake-$ABI"
    CMAKE_OUT_PATH="$TOOLS_ROOT/../output/android/poco-$ABI"
    OPENSSL_PATH="$TOOLS_ROOT/../output/android/openssl-$ABI"
    #删除之前的
    if [ ! -d ${OPENSSL_PATH} ];then
        log_info "openssl ${OPENSSL_PATH} not exists..."
        exit 1
    fi

    #文件夹不存在则新建一个文件夹
    if [ ! -d ${CMAKE_PROJECT_PATH} ];then
        mkdir $CMAKE_PROJECT_PATH
    fi
    
    echo  cmake -B${CMAKE_PROJECT_PATH} -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=${CMAKE_OUT_PATH} -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake -DANDROID_NATIVE_API_LEVEL=${api} -DANDROID_ABI=${ABI} -DBUILD_SHARED_LIBS=OFF  -DOPENSSL_USE_STATIC_LIBS=TRUE -DOPENSSL_ROOT_DIR=${OPENSSL_PATH} -DOPENSSL_CRYPTO_LIBRARY=${OPENSSL_PATH}/lib -DOPENSSL_SSL_LIBRARY=${OPENSSL_PATH}/lib -DOPENSSL_INCLUDE_DIR=${OPENSSL_PATH}/include
    cmake -B${CMAKE_PROJECT_PATH} -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=${CMAKE_OUT_PATH} -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake -DANDROID_NATIVE_API_LEVEL=${api} -DANDROID_ABI=${ABI} -DBUILD_SHARED_LIBS=OFF  -DOPENSSL_USE_STATIC_LIBS=TRUE -DOPENSSL_ROOT_DIR=${OPENSSL_PATH} -DOPENSSL_CRYPTO_LIBRARY=${OPENSSL_PATH}/lib -DOPENSSL_SSL_LIBRARY=${OPENSSL_PATH}/lib -DOPENSSL_INCLUDE_DIR=${OPENSSL_PATH}/include
    
    log_info "cmake build and install poco-${ABI} ..."

    cd $CMAKE_PROJECT_PATH
    cmake --build . --target install

    cd ../
    #rm -rf $CMAKE_PROJECT_PATH
    #popd
}

log_info "begin build-android-poco..."

for ((i = 0; i < ${#ARCHS[@]}; i++)); do
    if [[ $# -eq 0 || "$1" == "${ARCHS[i]}" ]]; then
         configure_cmake "${ARCHS[i]}" "${ABIS[i]}"
    fi
done

log_info "build-android-poco done..."
