#!/bin/sh

#   Copyright (C) 2016 Deepin, Inc.
#
#   Author:     Li LongYu <lilongyu@linuxdeepin.com>
#               Peng Hao <penghao@linuxdeepin.com>

#               Vufa <countstarlight@gmail.com>

version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }

BOTTLENAME="Deepin-WeChat"
APPVER="3.4.0.38deepin6"
WINEPREFIX="$HOME/.deepinwine/$BOTTLENAME"
WECHAT_FONTS="$WINEPREFIX/drive_c/windows/Fonts"
WECHAT_VER="3.7.0.29"
EXEC_PATH="c:/Program Files/Tencent/WeChat/WeChat.exe"
EXEC_FILE="$WINEPREFIX/drive_c/Program Files/Tencent/WeChat/WeChat.exe"
START_SHELL_PATH="/opt/deepinwine/tools/run_v4.sh"
WECHAT_INSTALLER="WeChatSetup"
WECHAT_INSTALLER_PATH="c:/Program Files/Tencent/$WECHAT_INSTALLER-$WECHAT_VER.exe"
export MIME_TYPE=""
export DEB_PACKAGE_NAME="com.qq.weixin.deepin"
export APPRUN_CMD="deepin-wine6-stable"
DISABLE_ATTACH_FILE_DIALOG=""
EXPORT_ENVS=""

export SPECIFY_SHELL_DIR=`dirname $START_SHELL_PATH`

ARCHIVE_FILE_DIR="/opt/apps/$DEB_PACKAGE_NAME/files"

export WINEDLLPATH=/opt/$APPRUN_CMD/lib:/opt/$APPRUN_CMD/lib64

export LD_LIBRARY_PATH=/opt/apps/$DEB_PACKAGE_NAME/files/lib32

export WINEPREDLL="$ARCHIVE_FILE_DIR/dlls"

msg()
{
	ECHO_LEVEL=("\033[1;32m==> " "\033[1;31m==> ERROR: ")
	echo -e "${ECHO_LEVEL[$1]}\033[1;37m$2\033[0m"
}

OpenWinecfg()
{
    msg 0 "Launching winecfg with $APPRUN_CMD in $WINEPREFIX ..."
    env WINEPREFIX=$WINEPREFIX $APPRUN_CMD winecfg
}

DeployApp()
{
    # backup fonts
    if [ -d "$WECHAT_FONTS" ];then
        msg 0 "Backing up fonts ..."
        mkdir -p $HOME/.deepinwine/.wechat_tmp
        cp $WECHAT_FONTS/* $HOME/.deepinwine/.wechat_tmp/
    fi

    # deploy bottle
    msg 0 "Deploying $WINEPREFIX ..."
    rm -rf "$WINEPREFIX"
    # run installer
    msg 0 "Launching $WECHAT_INSTALLER_PATH ..."
    env WINEDLLOVERRIDES="winemenubuilder.exe=d" $START_SHELL_PATH $BOTTLENAME $APPVER "$WECHAT_INSTALLER_PATH" "$@"

    # restore fonts
    if [ -d "$HOME/.deepinwine/.wechat_tmp" ];then
        msg 0 "Restoring fonts ..."
        cp -n $HOME/.deepinwine/.wechat_tmp/* $WECHAT_FONTS/
        rm -rf "$HOME/.deepinwine/.wechat_tmp"
    fi
    touch $WINEPREFIX/reinstalled
    msg 0 "Creating $WINEPREFIX/PACKAGE_VERSION ..."
    cat /opt/apps/$DEB_PACKAGE_NAME/files/files.md5sum > $WINEPREFIX/PACKAGE_VERSION
}

Run()
{
    if [ -z "$DISABLE_ATTACH_FILE_DIALOG" ];then
        export ATTACH_FILE_DIALOG=1
    fi

    if [ -n "$EXPORT_ENVS" ];then
        export $EXPORT_ENVS
    fi

    if [ -n "$EXEC_PATH" ];then
        if [ ! -f "$WINEPREFIX/reinstalled" ];then
            DeployApp
        else
            # missing exec file
            if [ ! -f "$EXEC_FILE" ];then
                msg 1 "Missing $EXEC_FILE, re-deploying ..."
                DeployApp
                exit 0
            fi

            if [ -z "${EXEC_PATH##*.lnk*}" ];then
                msg 0 "Launching  $EXEC_PATH lnk file ..."
                $START_SHELL_PATH $BOTTLENAME $APPVER "C:/windows/command/start.exe" "/Unix" "$EXEC_PATH" "$@"
            else
                msg 0 "Launching  $EXEC_PATH ..."
                $START_SHELL_PATH $BOTTLENAME $APPVER "$EXEC_PATH" "$@"
            fi
        fi
    else
        $START_SHELL_PATH $BOTTLENAME $APPVER "uninstaller.exe" "$@"
    fi
}

HelpApp()
{
	echo " Extra Commands:"
	echo " winecfg        Open winecfg"
	echo " -h/--help      Show program help info"
}

if [ -z $1 ]; then
	Run "$@"
	exit 0
fi
case $1 in
	"winecfg")
		OpenWinecfg
		;;
	"-h" | "--help")
		HelpApp
		;;
	*)
		Run "$@"
		;;
esac
exit 0
