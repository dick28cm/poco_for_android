# poco_for_android
贼傻瓜化的poco c++库 android编译脚本，至于ios或者其他版本自行解决

编译环境为ubuntu lts 20.4 
win10安装ubuntu步骤：  
   &nbsp;1：打开控制面板->程序->启动或关闭windows功能，然后勾选“适用linux的windows子系统”，等待完毕（提示需要重启的话，记得重启再进行下一步操作）    
   &nbsp;2：打开Microsoft Store(win+R后，输入ms-windows-store://home)搜索“ubuntu”安装并且进入ubuntu配置（最好修改root密码，以root权限运行）    

准备环境： apt-get install -y wget git curl unzip pkg-config  make cmake  //安装必须的命令    
     wget： 下载工具  
     git： 同步  
     unzip：解压缩   
     pkg-config：包信息    
     make：GUN构建工具   
     cmake：c++编译构建工具   

# 1：安装andorid-ndk     
    设定安装目录为：/mnt/d/dev_env/android-sdk/ndk/    
    //假如你是windows子系统。这个目录就相当于windows的D:\dev_env\android-sdk\ndk目录，在windows内也能访问
    //目录不存在则使用mkdir创建。cd跳进目录，具体linux命令请百度
    
    wget https://dl.google.com/android/repository/android-ndk-r21d-linux-x86_64.zip    //下载ndk   
    unzip android-ndk-r21d-linux-x86_64.zip                                            //解压zip包   
      
# 2：编译openssl     
    下载一键编译openssl的脚本到本地
    git clone https://github.com/dick28cm/poco_for_android.git
    
    进入tools目录。
    cd poco_for_android
    cd tools
    
    编译之前设置环境变量
    export ANDROID_NDK_ROOT=/mnt/d/dev_env/android-sdk/ndk/android-ndk-r21d
    export api=21                   //目标api=21
    export version=1.1.1k           //openssl版本为1.1.1k 
    ./build-android-openssl.sh      //开始编译构建openssl  后面加参数arm64代表之构建arm64

# 3：编译poco     
    ./build-android-poco.sh         //开始编译构建poco  后面加参数arm64代表之构建arm64
