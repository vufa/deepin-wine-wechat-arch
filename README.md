在Archlinux及衍生发行版上运行微信(WeChat)
========

<p align="center">
  <a href="https://github.com/countstarlight/deepin-wine-wechat-arch/actions">
    <img src="https://img.shields.io/github/workflow/status/countstarlight/deepin-wine-wechat-arch/CI/action?logo=github&style=flat-square">
  </a>
  <a href="https://pc.weixin.qq.com/">
    <img src="https://img.shields.io/badge/WeChat-3.3.0.115-blue?style=flat-square&logo=wechat" alt="WeChat Version">
  </a>
  <a href="https://aur.archlinux.org/packages/deepin-wine-wechat/">
    <img src="https://img.shields.io/aur/version/deepin-wine-wechat?label=AUR&logo=arch-linux&style=flat-square" alt="AUR Version">
  </a>
  <a href="https://github.com/countstarlight/deepin-wine-wechat-arch/releases">
    <img src="https://img.shields.io/github/downloads/countstarlight/deepin-wine-wechat-arch/total?logo=github&style=flat-square" alt="GitHub Release">
  </a>
  <a href="https://github.com/countstarlight/deepin-wine-wechat-arch/issues">
    <img src="https://img.shields.io/github/issues/countstarlight/deepin-wine-wechat-arch?logo=github&style=flat-square" alt="GitHub Issues">
  </a>
</p>

Deepin打包的微信容器(`com.qq.weixin.deepin`)移植到Archlinux，不依赖`deepin-wine`，包含定制的运行脚本，微信安装包替换为官方最新

<!-- TOC -->

- [安装](#安装)
    - [从AUR安装](#从aur安装)
    - [用安装包安装](#用安装包安装)
    - [本地打包安装](#本地打包安装)
- [设置](#设置)
- [兼容性记录](#兼容性记录)
- [切换到 `deepin-wine`](#切换到-deepin-wine)
    - [自动切换(推荐)](#自动切换推荐)
    - [从 `deepin-wine 2.x` 迁移](#从-deepin-wine-2x-迁移)
- [卸载](#卸载)
- [常见问题及解决](#常见问题及解决)
    - [不能截图](#不能截图)
    - [高分辨率屏幕支持](#高分辨率屏幕支持)
    - [GNOME 桌面上的悬浮窗口问题](#gnome-桌面上的悬浮窗口问题)
    - [消除阴影边框](#消除阴影边框)
    - [唤出已运行的WeChat窗口](#唤出已运行的wechat窗口)
- [感谢](#感谢)
- [更新日志](#更新日志)

<!-- /TOC -->

## 安装

`deepin-wine-wechat`依赖`Multilib`仓库中的`wine`，`wine-gecko`和`wine-mono`，Archlinux默认没有开启`Multilib`仓库，需要编辑`/etc/pacman.conf`，取消对应行前面的注释([Archlinux wiki](https://wiki.archlinux.org/index.php/Official_repositories#multilib)):

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

:warning: **注意：由于新版微信可能需要 `wine` 还没有实现的一些win api，这会导致一些功能不可用，安装前先根据[兼容性记录](#兼容性记录)选择一个合适的版本**

:bulb: 以下三种安装方式效果相同，选择一种即可

### 从AUR安装

已添加到 AUR [deepin-wine-wechat](https://aur.archlinux.org/packages/deepin-wine-wechat/)，可使用 `yay` 或 `yaourt` 安装:

```shell
yay -S deepin-wine-wechat
```

### 用安装包安装

> 由 [GitHub Action](https://github.com/countstarlight/deepin-wine-wechat-arch/actions) 在 Docker 容器 [countstarlight/makepkg](https://hub.docker.com/r/countstarlight/makepkg) 中自动构建的 ArchLinux 安装包

在 [GitHub Release](https://github.com/countstarlight/deepin-wine-wechat-arch/releases) 页面下载后缀为 `.pkg.tar.xz` 或 `.pkg.tar.zst` 的安装包，使用`pacman`安装：

```bash
sudo pacman -U #下载的包名
```

`.md5` 文件用于校验包完整性：

```bash
md5sum -c *.md5
```

### 本地打包安装

```shell
 git clone https://github.com/countstarlight/deepin-wine-wechat-arch.git

 cd deepin-wine-wechat-arch
  
 makepkg -si
```

用上述三种安装方式之一安装完成后，运行应用菜单中创建的 WeChat 快捷方式，首次运行会用 WeChat 的安装包进行安装

:warning: **注意：安装微信时不建议修改安装路径，如果修改默认路径，要对应修改 `deepin-wine-wechat` 的启动脚本(`/opt/apps/com.qq.weixin.deepin/files/run.sh`)：**

```bash
EXEC_PATH="c:/Program Files/Tencent/WeChat/WeChat.exe"
```
改为修改后的安装路径，否则只有安装后第一次能够运行

:warning: **注意：登录后请在`设置`里关闭微信的`自动更新`，微信启动时会检查更新并加载自动更新程序，由于默认屏蔽了微信的自动更新程序，会导致找不到更新程序而不能启动**

## 设置

dpi，系统版本，目录映射等可以在 `winecfg` 进行设置，打开 `winecfg` 的命令为：

```bash
/opt/apps/com.qq.weixin.deepin/files/run.sh winecfg
```

## 兼容性记录

|   微信    |  wine   |   兼容性   |                             备注                             | deepin-wine | 兼容性 |                             备注                             |
| :-------: | :-----: | :--------: | :----------------------------------------------------------: | :---------: | :----: | :----------------------------------------------------------: |
| 3.3.0.115 |  6.12   |            |                                                              |  5.0.16-1   |  支持  |                                                              |
| 3.3.0.93  |  6.11   |            |                                                              |  5.0.16-1   |  支持  |                                                              |
| 3.2.1.154 |   6.6   |            | 截图功能不可用：[#87](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/87) |  5.0.16-1   |  支持  |                                                              |
| 3.2.1.151 |   6.6   |            | 截图功能不可用：[#87](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/87) |  5.0.16-1   |  支持  |                                                              |
| 3.2.1.141 |   6.6   |            |                                                              |  5.0.16-1   |  支持  |                                                              |
| 3.2.1.127 |   6.5   |    部分    | 群聊闪退&截图功能不可用：[#87](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/87) |  5.0.16-1   |  支持  |                                                              |
| 3.1.0.72  |   6.0   |    部分    | 截图功能不可用：[#73](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/73) |  5.0.16-1   |  支持  |                                                              |
| 3.1.0.41  |  5.22   |    部分    | 截图功能不可用：[#73](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/73) |  5.0.16-1   |  支持  |                                                              |
| 3.0.0.57  |  5.22   | **不支持** | 微信安装程序不能启动：[#92](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/92) |  5.0.16-1   |  支持  |                                                              |
| 3.0.0.57  |  5.19   |    支持    |                                                              |  2.18_24-3  |  支持  |                                                              |
| 2.9.5.56  |  5.13   |    部分    | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |  2.18_24-3  |  部分  | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |
| 2.9.5.41  |  5.11   |    部分    | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |  2.18_22-3  |  部分  | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |
| 2.9.0.123 |   5.7   |    部分    | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |  2.18_22-3  |  部分  | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |
| 2.9.0.114 |   5.6   |    部分    | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |             |        |                                                              |
| 2.9.0.112 |   5.5   |    部分    | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |             |        |                                                              |
| 2.8.0.133 |   5.3   |    部分    | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |             |        |                                                              |
| 2.8.0.112 | 5.0-rc4 |    部分    | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |             |        |                                                              |
| 2.8.0.106 |  4.19   |    部分    | 发送图片有问题: [#42](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/42) |             |        |                                                              |
| 2.7.1.88  |  4.19+  |    支持    |                                                              |             |        |                                                              |
| 2.7.1.88  |  4.18   |    部分    |                      不能使用中文输入法                      |             |        |                                                              |
| 2.7.1.85  |  4.18   |    部分    |                      不能使用中文输入法                      |  2.18_18-2  |   ?    |                                                              |
| 2.7.1.82  |  4.18   |    部分    |                      不能使用中文输入法                      |  2.18_18-2  | 不支持 |                             闪退                             |
| 2.7.1.82  |  4.17   |    部分    |                      不能使用中文输入法                      |  2.18_18-2  | 不支持 |                             闪退                             |
| 2.6.8.65  |  4.16   |    支持    |                                                              |  2.18_18-2  |  支持  |                                                              |

## 切换到 `deepin-wine`

> 根据 [deepin-wine-wechat-arch#15](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/15#issuecomment-515455845)，[deepin-wine-wechat-arch#27](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/27)，由 [@feileb](https://github.com/feileb), [@violetbobo](https://github.com/violetbobo), [@HE7086](https://github.com/HE7086)提供的方法

`deepin-wine-wechat` 默认使用官方仓库中的 `wine`，原版 `wine` 在 [DDE(Deepin Desktop Environment)](https://www.deepin.org/dde/) 上，有托盘图标无法响应鼠标事件([deepin-wine-tim-arch#21](https://github.com/countstarlight/deepin-wine-tim-arch/issues/21))的问题，截图功能也不可用，可以选择切换到 `deepin-wine`。

:warning: **注意：切换前先确保 `deepin-wine` 支持**

### 自动切换(推荐)

```bash
/opt/apps/com.qq.weixin.deepin/files/run.sh -d
```

这会安装需要的依赖，移除已安装的微信目录并回退对注册表文件的修改

> 从 `v3.0.0.57-2` 开始，该命令会切换到 AUR 仓库：[deepin-wine5](https://aur.archlinux.org/packages/deepin-wine5)


如果想切换回原版 `wine` 并卸载为 `deepin-wine` 自动安装的依赖：

```bash
rm $HOME/.deepinwine/Deepin-WeChat/deepin
sudo pacman -Rns deepin-wine5
```

### 从 `deepin-wine 2.x` 迁移

若之前使用的是 `deepin-wine 2.x`，更新到 `deepin-wine-wechat v3.0.0.57-2` 及之后的版本会自动切换回 `wine`，运行命令：

```bash
/opt/apps/com.qq.weixin.deepin/files/run.sh -d
```

就会自动安装并切换到 `deepin-wine5`

若此时没有其他应用在使用旧版 `deepin-wine`，就可以放心的卸载旧版 `deepin-wine` 及其依赖：

```bash
sudo pacman -S lib32-freetype2 #用原版替换lib32-freetype2-infinality-ultimate
sudo pacman -Rns deepin-wine xsettingsd
```

## 卸载

无论用何种方式安装，卸载都是：

```bash
sudo pacman -Rns deepin-wine-wechat
```

卸载的同时会删除用户目录下的整个 `WINEPREFIX` 环境，路径为：`~/.deepinwine/Deepin-WeChat`

微信在本地保存的数据不会被删除，如保存在用户文档下的数据(默认：`~/Documents/WeChat Files`)

## 常见问题及解决

### 不能截图

参照[切换到 `deepin-wine`](#切换到-deepin-wine) 解决

### 高分辨率屏幕支持

参照[设置](#设置)打开 `winecfg` ，在选项卡 `Graphics` 中修改dpi，如 修改为`192`

### GNOME 桌面上的悬浮窗口问题

> 根据 [deepin-wine-tim-arch#2](https://github.com/countstarlight/deepin-wine-tim-arch/issues/2)，由[EricDracula](https://github.com/EricDracula)提供的方法

安装 GNOME 插件: [TopIcons Plus](https://extensions.gnome.org/extension/1031/topicons/)

### 消除阴影边框

微信窗口不在最上方时，在其他窗口上会显示一个阴影边框，参照[切换到 `deepin-wine`](#切换到-deepin-wine) 解决

### 唤出已运行的WeChat窗口

> 根据 [deepin-wine-wechat-arch#96](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/96)，由[szy132](https://github.com/szy132)提供的方法

运行命令：

```bash
bash $HOME/.deepinwine/deepin-wine-helper/sendkeys.sh w wechat 4
```

可以参考 [deepin-wine-wechat-arch#96](https://github.com/countstarlight/deepin-wine-wechat-arch/issues/96) 将该命令添加到桌面环境的全局快捷键中，方便使用

## 感谢

* [Wuhan Deepin Technology Co.,Ltd.](http://www.deepin.org/)

## 更新日志

<details open>
<summary>2021</summary>

* 2021-07-05 WeChat-3.3.0.115
* 2021-06-21 WeChat-3.3.0.93
* 2021-05-07 WeChat-3.2.1.154 3.2.1.154deepin8
* 2021-04-23 WeChat-3.2.1.154
* 2021-04-19 WeChat-3.2.1.151
* 2021-04-18 WeChat-3.2.1.141
* 2021-04-02 WeChat-3.2.1.127
* 2021-01-29 WeChat-3.1.0.72

</details>
<details>
<summary>2020</summary>

* 2020-12-29 WeChat-3.1.0.41
* 2020-11-26 WeChat-3.0.0.57 2.9.5.41deepin7
* 2020-10-16 WeChat-3.0.0.57
* 2020-07-20 WeChat-2.9.5.56
* 2020-07-02 WeChat-2.9.5.41
* 2020-05-10 WeChat-2.9.0.123
* 2020-04-24 WeChat-2.9.0.114
* 2020-04-20 WeChat-2.9.0.112
* 2020-03-08 WeChat-2.8.0.133
* 2020-02-10 WeChat-2.8.0.121
* 2020-01-20 WeChat-2.8.0.116
* 2020-01-10 WeChat-2.8.0.112
* 2020-01-04 WeChat-2.8.0.106

</details>
<details>
<summary>2019</summary>

* 2019-11-07 WeChat-2.7.1.88
* 2019-10-23 WeChat-2.7.1.85
* 2019-10-19 WeChat-2.7.1.82
* 2019-07-25 WeChat-2.6.8.65
* 2019-06-02 WeChat-2.6.8.52
* 2019-05-29 WeChat-2.6.8.51
* 2019-04-03 WeChat-2.6.7.57
* 2019-01-03 WeChat-2.6.2

</details>
