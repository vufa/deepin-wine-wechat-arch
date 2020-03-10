在Archlinux及衍生发行版上运行微信(WeChat)
=======

<p align="center">
  <a href="https://travis-ci.org/countstarlight/deepin-wine-wechat-arch">
    <img src="https://travis-ci.org/countstarlight/deepin-wine-wechat-arch.svg?branch=master" alt="Build Status">
  </a>
  <a href="https://pc.weixin.qq.com/">
    <img src="https://img.shields.io/badge/WeChat-2.8.0.133-blue.svg" alt="WeChat Version">
  </a>
  <a href="https://aur.archlinux.org/packages/deepin-wine-wechat/">
    <img src="https://img.shields.io/aur/version/deepin-wine-wechat.svg" alt="AUR Version">
  </a>
  <a href="https://github.com/countstarlight/deepin-wine-wechat-arch/releases">
    <img src="https://img.shields.io/github/downloads/countstarlight/deepin-wine-wechat-arch/total.svg" alt="GitHub Release">
  </a>
  <a href="https://github.com/countstarlight/deepin-wine-wechat-arch/issues">
    <img src="https://img.shields.io/github/issues/countstarlight/deepin-wine-wechat-arch.svg" alt="GitHub Issues">
  </a>
</p>

Deepin打包的微信(WeChat)容器移植到Archlinux，不依赖`deepin-wine`，包含定制的注册表配置，微信安装包替换为官方最新

<!-- TOC -->

- [安装](#安装)
    - [从AUR安装](#从aur安装)
    - [用安装包安装](#用安装包安装)
    - [本地打包安装](#本地打包安装)
- [兼容性记录](#兼容性记录)
- [切换到 `deepin-wine`](#切换到-deepin-wine)
    - [自动切换](#自动切换)
    - [手动切换](#手动切换)
        - [1. 安装 deepin-wine](#1-安装-deepin-wine)
        - [2. 修改 `deepin-wine-wechat` 的启动文件](#2-修改-deepin-wine-wechat-的启动文件)
        - [3. 对于非 GNOME 桌面(KDE, XFCE等)](#3-对于非-gnome-桌面kde-xfce等)
        - [4. 删除原先的微信目录](#4-删除原先的微信目录)
        - [5. 修复 `deepin-wine` 字体渲染发虚](#5-修复-deepin-wine-字体渲染发虚)
- [常见问题](#常见问题)
- [感谢](#感谢)
- [更新日志](#更新日志)

<!-- /TOC -->

## 安装

`deepin-wine-wechat`依赖`Multilib`仓库中的`wine`，`wine_gecko`和`wine-mono`，Archlinux默认没有开启`Multilib`仓库，需要编辑`/etc/pacman.conf`，取消对应行前面的注释([Archlinux wiki](https://wiki.archlinux.org/index.php/Official_repositories#multilib)):

```diff
# If you want to run 32 bit applications on your x86_64 system,
# enable the multilib repositories as required here.

#[multilib-testing]
#Include = /etc/pacman.d/mirrorlist

-#[multilib]
-#Include = /etc/pacman.d/mirrorlist
+[multilib]
+Include = /etc/pacman.d/mirrorlist
```

**注意：由于新版微信可能需要 `wine` 还没有实现的一些win api，这会导致一些功能不可用，安装前先根据[兼容性记录](#兼容性记录)选择一个合适的版本**

### 从AUR安装

已添加到AUR [deepin-wine-wechat](https://aur.archlinux.org/packages/deepin-wine-wechat/)，可使用 `yay` 或 `yaourt` 安装:

```shell
yay -S deepin-wine-wechat
```

### 用安装包安装

> 由 [Travis CI](https://travis-ci.org/countstarlight/deepin-wine-wechat-arch) 在 Docker 容器 [mikkeloscar/arch-travis](https://hub.docker.com/r/mikkeloscar/arch-travis) 中自动构建的 ArchLinux 安装包

在[GitHub Release](https://github.com/countstarlight/deepin-wine-wechat-arch/releases)页面下载 `.pkg.tar.xz`后缀的安装包，使用`pacman`安装：

```bash
sudo pacman -U #下载的包名
```

### 本地打包安装

```shell
 git clone https://github.com/countstarlight/deepin-wine-wechat-arch.git

 cd deepin-wine-wechat-arch
  
 makepkg -si
```

* 运行应用菜单中创建的WeChat，开始安装

  **注意：安装微信时不需要修改安装路径，如果修改默认路径，要对应修改 `deepin-wine-wechat` 的启动脚本：**

  `/opt/deepinwine/apps/Deepin-WeChat/run.sh`

  ```bash
  env WINEPREFIX="$WINEPREFIX" WINEDEBUG=-msvcrt $WINE_CMD "c:\\Program Files\\Tencent\\WeChat\\WeChat.exe" &
  ```

  改为修改后的安装路径，否则只有安装后第一次能够运行

* 安装完可直接启动

  **注意：登录后请在`设置`里关闭微信的`自动更新`，微信启动时会检查更新并加载自动更新程序，由于默认屏蔽了微信的自动更新程序，会导致找不到更新程序而不能启动**

## 兼容性记录

| 微信版本  | wine版本 | 兼容性 |                             备注                             | deepin-wine版本 | 兼容性 | 备注 |
| :-------: | :------: | :----: | :----------------------------------------------------------: | :-------------: | :----: | :--: |
| 2.8.0.133 |   5.3    |  部分  | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |                 |        |      |
| 2.8.0.112 | 5.0-rc4  |  部分  | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |                 |        |      |
| 2.8.0.106 |  4.19-1  |  部分  | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |                 |        |      |
| 2.7.1.88  |  4.19-1  |  支持  |                                                              |                 |        |      |
| 2.7.1.88  |  4.18-1  |  部分  |                      不能使用中文输入法                      |                 |        |      |
| 2.7.1.85  |  4.18-1  |  部分  |                      不能使用中文输入法                      |    2.18_18-2    |   ?    |      |
| 2.7.1.82  |  4.18-1  |  部分  |                      不能使用中文输入法                      |    2.18_18-2    | 不支持 | 闪退 |
| 2.7.1.82  |  4.17-1  |  部分  |                      不能使用中文输入法                      |    2.18_18-2    | 不支持 | 闪退 |
| 2.6.8.65  |  4.16-1  |  支持  |                                                              |    2.18_18-2    |  支持  |      |

## 切换到 `deepin-wine`

由于原版 `wine` 在 [DDE(Deepin Desktop Environment)](https://www.deepin.org/dde/) 上，存在托盘图标无法响应鼠标事件([deepin-wine-tim-arch#21](https://github.com/countstarlight/deepin-wine-tim-arch/issues/21))，边框穿透显示([deepin-wine-wechat-arch#15](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/15)), 无法截图等问题，且原版 `wine` 尚不能实现保存登录密码等功能，可以选择切换到 `deepin-wine`。

**注意：切换前先确保 `deepin-wine` 支持**

根据 [deepin-wine-wechat-arch#15](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/15#issuecomment-515455845)，[deepin-wine-wechat-arch#27](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/27)，由 [@feileb](https://github.com/feileb), [@violetbobo](https://github.com/violetbobo), [@HE7086](https://github.com/HE7086)提供的方法：

### 自动切换

```bash
/opt/deepinwine/apps/Deepin-WeChat/run.sh -d
```

这会安装需要的依赖并移除已安装的微信目录

切换回 `wine`：

```bash
rm ~/.deepinwine/Deepin-WeChat/deepin
```

如果要卸载自动安装的依赖：

```bash
sudo pacman -Rns deepin-wine gnome-settings-daemon lib32-freetype2-infinality-ultimate
```

### 手动切换

#### 1. 安装 deepin-wine

```bash
yay -S deepin-wine
```

#### 2. 修改 `deepin-wine-wechat` 的启动文件

修改如下两个文件中的 `WINE_CMD` 的值：

`/opt/deepinwine/apps/Deepin-WeChat/run.sh`

`/opt/deepinwine/tools/run.sh`

```diff
-WINE_CMD="wine"
+WINE_CMD="deepin-wine"
```

#### 3. 对于非 GNOME 桌面(KDE, XFCE等)

需要安装 `gnome-settings-daemon`

```bash
sudo pacman -Sy gnome-settings-daemon
```
并在 `/opt/deepinwine/apps/Deepin-WeChat/run.sh` 中加入如下几行：

```diff
 RunApp()
 {
+    if [[ -z "$(ps -e | grep -o gsd-xsettings)" ]]
+    then
+        /usr/lib/gsd-xsettings &
+    fi
        if [ -d "$WINEPREFIX" ]; then
                UpdateApp
        else
```

**注意：对 `/opt/deepinwine/apps/Deepin-WeChat/run.sh` 的修改会在 `deepin-wine-wechat` 更新或重装时被覆盖，可以单独拷贝一份作为启动脚本**

#### 4. 删除原先的微信目录

```bash
rm -rf ~/.deepinwine/Deepin-WeChat
```

#### 5. 修复 `deepin-wine` 字体渲染发虚

```bash
yay -S lib32-freetype2-infinality-ultimate
```

**注意：切换到 `deepin-wine` 后，对 `wine` 的修改，如更改dpi，都改为对 `deepin-wine` 的修改**

## 常见问题

- [ ] 1.不能视频通话
- [x] 2.不能截图(切换到 `deepin-wine` 后解决)
- [x] 3.在 2k/4k 屏幕下字体和图标都非常小, 参见[issue1](https://github.com/countstarlight/deepin-wine-tim-arch/issues/1)
- [x] 4.使用全局截图快捷键和解决Gnome上窗口化问题，参见[issue2](https://github.com/countstarlight/deepin-wine-tim-arch/issues/2)

## 感谢

* [Wuhan Deepin Technology Co.,Ltd.](http://www.deepin.org/)

## 更新日志

* 2020-03-08 WeChat-2.8.0.133
* 2020-02-10 WeChat-2.8.0.121
* 2020-01-20 WeChat-2.8.0.116
* 2020-01-10 WeChat-2.8.0.112
* 2020-01-04 WeChat-2.8.0.106
* 2019-11-07 WeChat-2.7.1.88
* 2019-10-23 WeChat-2.7.1.85
* 2019-10-19 WeChat-2.7.1.82
* 2019-07-25 WeChat-2.6.8.65
* 2019-06-02 WeChat-2.6.8.52
* 2019-05-29 WeChat-2.6.8.51
* 2019-04-03 WeChat-2.6.7.57
* 2019-01-03 WeChat-2.6.2
