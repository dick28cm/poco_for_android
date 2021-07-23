# poco_for_android
贼傻瓜化的poco c++库 android编译脚本，至于ios或者其他版本自行解决

编译环境为ubuntu lts 20.4 
win10安装ubuntu步骤：  
   &nbsp;1：打开控制面板->程序->启动或关闭windows功能，然后勾选“适用linux的windows子系统”，等待完毕  
   &nbsp;2：打开Microsoft Store(win+R后，输入ms-windows-store://home)搜索“ubuntu”安装并且进入ubuntu配置  

准备环境： apt-get install -y wget git curl unzip    //安装必须的命令

# 1：安装andorid-ndk     
    设定安装目录为：/mnt/d/dev_env/android-sdk/ndk/ 
    
    wget https://dl.google.com/android/repository/android-ndk-r21d-linux-x86_64.zip    //下载ndk   
    unzip android-ndk-r21d-linux-x86_64.zip                                            //解压zip包   
      
# 2：编译openssl     
    下载一键编译openssl的脚本到本地
    git clone https://github.com/leenjewel/openssl_for_ios_and_android.git
    
    进入tools目录。编译之前设置环境变量
    export ANDROID_NDK_ROOT=/mnt/d/dev_env/android-sdk/ndk/android-ndk-r21d
    
