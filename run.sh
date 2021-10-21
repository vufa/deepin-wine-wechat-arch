#!/bin/sh

#   Copyright (C) 2016 Deepin, Inc.
#
#   Author:     Li LongYu <lilongyu@linuxdeepin.com>
#               Peng Hao <penghao@linuxdeepin.com>

#               Codist <countstarlight@gmail.com>

version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }

BOTTLENAME="Deepin-WeChat"
APPVER="3.2.1.154deepin13"
WINEPREFIX="$HOME/.deepinwine/$BOTTLENAME"
WECHAT_VER="3.4.0.38"
EXEC_PATH="c:/Program Files/Tencent/WeChat/WeChat.exe"
START_SHELL_PATH="/opt/deepinwine/tools/run_v4.sh"
WECHAT_INSTALLER="WeChatSetup"
WECHAT_INSTALLER_PATH="c:/Program Files/Tencent/$WECHAT_INSTALLER-$WECHAT_VER.exe"
export MIME_TYPE=""
export DEB_PACKAGE_NAME="com.qq.weixin.deepin"
export APPRUN_CMD="deepin-wine6-stable"
DISABLE_ATTACH_FILE_DIALOG=""

export SPECIFY_SHELL_DIR=`dirname $START_SHELL_PATH`

ARCHIVE_FILE_DIR="/opt/apps/$DEB_PACKAGE_NAME/files"

export WINEDLLPATH=/opt/$APPRUN_CMD/lib:/opt/$APPRUN_CMD/lib64

export WINEPREDLL="$ARCHIVE_FILE_DIR/dlls"

OpenWinecfg()
{
    env WINEPREFIX=$WINEPREFIX $APPRUN_CMD winecfg
}

Run()
{
    if [ -z "$DISABLE_ATTACH_FILE_DIALOG" ];then
        export ATTACH_FILE_DIALOG=1
    fi

    if [ -n "$EXEC_PATH" ];then
        if [ ! -f "$WINEPREFIX/reinstalled" ];then
            # run installer
            env WINEDLLOVERRIDES="winemenubuilder.exe=d" $START_SHELL_PATH $BOTTLENAME $APPVER "$WECHAT_INSTALLER_PATH" "$@"
            touch $WINEPREFIX/reinstalled
        else
            if [ -z "${EXEC_PATH##*.lnk*}" ];then
                $START_SHELL_PATH $BOTTLENAME $APPVER "C:/windows/command/start.exe" "/Unix" "$EXEC_PATH" "$@"
            else
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
