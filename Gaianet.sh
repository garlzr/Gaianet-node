#!/bin/bash

# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

# 脚本保存路径
SCRIPT_PATH="$HOME/Gaianet.sh"

function install_node(){

    if ! dpkg -s libgomp1 &> /dev/null
    then
        echo "libgomp1 未安装，正在安装..."
        sudo apt-get update
        sudo apt-get install -y libgomp1
    else
        echo "libgomp1 已安装"
    fi
    
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash
    source /root/.bashrc && gaianet start && gaianet info

}

function restart() {
    gaianet stop
    gaianet start
    echo "节点已重启。"
}

function backup() {
    # 定义目标文件夹
    TARGET_DIR="/root/gaianet_key"

    # 检查目标文件夹是否存在，如果不存在则创建它
    if [ ! -d "$TARGET_DIR" ]; then
        mkdir -p "$TARGET_DIR"
    fi

    # 复制文件到目标文件夹
    cp /root/gaianet/nodeid.json "$TARGET_DIR"
    # 复制文件到目标文件夹
    cp /root/gaianet/nodeid.json "$TARGET_DIR"
    echo "钱包数据已成功拷贝到 $TARGET_DIR"
}

function uninstall() {
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/uninstall.sh' | bash
    rm -rf $HOME/gaianet
    echo "Gaianet 节点已卸载。"
}

function update() {
    curl -sSfL 'https://github.com/GaiaNet-AI/gaianet-node/releases/latest/download/install.sh' | bash -s -- --reinstall
}

function info(){
    gaianet info
}


# 主菜单
function main_menu() {
    clear
    echo "请选择要执行的操作:"
    echo "1. 安装节点"
    echo "2. 更新节点(已最新)"
    echo "3. 重启节点"
    echo "4. 备份节点数据"
    echo "5. 查看节点信息"
    echo "6. 卸载节点"
    read -p "请输入选项（1-5）: " OPTION

    case $OPTION in
    1) install_node ;;
    2) update ;;
    3) restart ;;
    4) backup ;;
    5) info ;;
    6) uninstall ;;
    *) 
        echo "无效选项。" 
        read -p "按任意键返回主菜单..."
        main_menu
        ;;
    esac
}

# 显示主菜单
main_menu
