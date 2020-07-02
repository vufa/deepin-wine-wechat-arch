#!/bin/sh

#   Copyright (C) 2016 Deepin, Inc.
#
#   Author:     Li LongYu <lilongyu@linuxdeepin.com>
#               Peng Hao <penghao@linuxdeepin.com>

#               Codist <countstarlight@gmail.com>

WINEPREFIX="$HOME/.deepinwine/Deepin-WeChat"
APPDIR="/opt/deepinwine/apps/Deepin-WeChat"
APPVER="2.6.8.65deepin0"
WECHAT_INSTALLER="WeChatSetup"
WECHAT_VER="2.9.5.41"
APPTAR="files.7z"
PACKAGENAME="com.wechat"
WINE_CMD="wine"

HelpApp()
{
	echo " Extra Commands:"
	echo " -r/--reset     Reset app to fix errors"
	echo " -e/--remove    Remove deployed app files"
	echo " -d/--deepin    Switch to 'deepin-wine'"
	echo " -h/--help      Show program help info"
}
CallApp()
{
	if [ ! -f "$WINEPREFIX/reinstalled" ]
	then
		touch $WINEPREFIX/reinstalled
		# stop the previous version of 'shadow.exe'
		pkill -f "shadow.exe"
		env WINEDLLOVERRIDES="winemenubuilder.exe=d" WINEPREFIX="$WINEPREFIX" $WINE_CMD $APPDIR/$WECHAT_INSTALLER-$WECHAT_VER.exe &
	else
        #Support use native file dialog
        export ATTACH_FILE_DIALOG=1

        env WINEPREFIX="$WINEPREFIX" WINEDEBUG=-msvcrt $WINE_CMD "c:\\Program Files\\Tencent\\WeChat\\WeChat.exe" &
	fi

	if [ ! -f "$WINEPREFIX/deepin" ]; then
        # run 'shadow.exe' if process not exist
        if [[ -z "$(ps -e | grep -o 'shadow.exe')" ]]; then
		    env WINEPREFIX="$WINEPREFIX" WINEDEBUG=-msvcrt $WINE_CMD "c:\\shadow.exe" &
        fi
	fi
}
ExtractApp()
{
	mkdir -p "$1"
	7z x "$APPDIR/$APPTAR" -o"$1"
	mv "$1/drive_c/users/@current_user@" "$1/drive_c/users/$USER"
	sed -i "s#@current_user@#$USER#" $1/*.reg
}
DeployApp()
{
	ExtractApp "$WINEPREFIX"
	echo "$APPVER" > "$WINEPREFIX/PACKAGE_VERSION"
}
RemoveApp()
{
	rm -rf "$WINEPREFIX"
}
ResetApp()
{
	echo "Reset $PACKAGENAME....."
	read -p "*	Are you sure?(Y/N)" ANSWER
	if [ "$ANSWER" = "Y" -o "$ANSWER" = "y" -o -z "$ANSWER" ]; then
		EvacuateApp
		DeployApp
		CallApp
	fi
}
UpdateApp()
{
	if [ -f "$WINEPREFIX/PACKAGE_VERSION" ] && [ "$(cat "$WINEPREFIX/PACKAGE_VERSION")" = "$APPVER" ]; then
		return
	fi
	if [ -d "${WINEPREFIX}.tmpdir" ]; then
		rm -rf "${WINEPREFIX}.tmpdir"
	fi
	ExtractApp "${WINEPREFIX}.tmpdir"
	/opt/deepinwine/tools/updater -s "${WINEPREFIX}.tmpdir" -c "${WINEPREFIX}" -v
	rm -rf "${WINEPREFIX}.tmpdir"
	echo "$APPVER" > "$WINEPREFIX/PACKAGE_VERSION"
}
RunApp()
{
 	if [ -d "$WINEPREFIX" ]; then
 		UpdateApp
 	else
 		DeployApp
 	fi
 	CallApp
}

CreateBottle()
{
    if [ -d "$WINEPREFIX" ]; then
        UpdateApp
    else
        DeployApp
    fi
}

SwitchToDeepinWine()
{
	PACKAGE_MANAGER="yay"
	if ! [ -x "$(command -v yay)" ]; then
		if ! [ -x "$(command -v yaourt)" ]; then
			echo "Error: Need to install 'yay' or 'yaourt' first." >&2
			exit 1
		else
			$PACKAGE_MANAGER="yaourt"
		fi
    fi
	echo -e "\033[0;34mInstalling dependencies ...\033[0m"
	$PACKAGE_MANAGER -S deepin-wine xsettingsd lib32-freetype2-infinality-ultimate --needed
	echo -e "\033[0;34mRedeploying app ...\033[0m"
	if [ -d "$WINEPREFIX" ]; then
		RemoveApp
	fi
	DeployApp
	echo -e "\033[0;34mReversing the patch ...\033[0m"
	patch -p1 -R -d  ${WINEPREFIX} < $APPDIR/reg.patch
	echo -e "\033[0;34mCreating flag file '$WINEPREFIX/deepin' ...\033[0m"
	touch -f $WINEPREFIX/deepin
	echo -e "\033[0;34mDone.\033[0m"
}

# Init
if [ -f "$WINEPREFIX/deepin" ]; then
	WINE_CMD="deepin-wine"
	if [[ -z "$(ps -e | grep -o gsd-xsettings)" ]] && [[ -z "$(ps -e | grep -o xsettingsd)" ]]; then
		/usr/bin/xsettingsd &
	fi
fi

if [ -z $1 ]; then
	RunApp
	exit 0
fi
case $1 in
	"-r" | "--reset")
		ResetApp
		;;
	"-c" | "--create")
		CreateBottle
		;;
	"-e" | "--remove")
		RemoveApp
		;;
	"-d" | "--deepin")
		SwitchToDeepinWine
		;;
	"-u" | "--uri")
		RunApp $2
		;;
	"-h" | "--help")
		HelpApp
		;;
	*)
		echo "Invalid option: $1"
		echo "Use -h|--help to get help"
		exit 1
		;;
esac
exit 0
