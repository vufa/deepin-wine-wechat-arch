# 在 Archlinux 及衍生发行版上运行微信(WeChat) <!-- omit in toc -->

<p align="center">
  <a href="https://github.com/vufa/deepin-wine-wechat-arch/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/vufa/deepin-wine-wechat-arch/ci.yml?branch=action&logo=github&style=flat-square">
  </a>
  <a href="https://pc.weixin.qq.com/">
    <img src="https://img.shields.io/badge/WeChat-3.8.0.41-blue?style=flat-square&logo=wechat" alt="WeChat Version">
  </a>
  <a href="https://aur.archlinux.org/packages/deepin-wine-wechat/">
    <img src="https://img.shields.io/aur/version/deepin-wine-wechat?label=AUR&logo=arch-linux&style=flat-square" alt="AUR Version">
  </a>
  <a href="https://github.com/vufa/deepin-wine-wechat-arch/releases">
    <img src="https://img.shields.io/github/downloads/vufa/deepin-wine-wechat-arch/total?logo=github&style=flat-square" alt="GitHub Release">
  </a>
  <a href="https://github.com/vufa/deepin-wine-wechat-arch/issues">
    <img src="https://img.shields.io/github/issues/vufa/deepin-wine-wechat-arch?logo=github&style=flat-square" alt="GitHub Issues">
  </a>
</p>

Deepin 打包的微信容器(`com.qq.weixin.deepin`)移植到 Archlinux，包含定制的运行脚本，微信安装包替换为官方最新

:warning: `deepin-wine-wechat` 从 `v3.5.0.46-2` 开始，默认使用 AUR 仓库 [deepin-wine6-stable](https://aur.archlinux.org/packages/deepin-wine6-stable/)，不再依赖 `wine`，可以进行一些清理操作来保持系统整洁，具体参照： [从 `wine`/`deepin-wine 2.x` 迁移](#从-winedeepin-wine-2x-迁移)

- [安装](#安装)
  - [从 AUR 安装](#从aur安装)
  - [用安装包安装](#用安装包安装)
  - [本地打包安装](#本地打包安装)
- [设置](#设置)
- [兼容性记录](#兼容性记录)
- [切换到 `deepin-wine`](#切换到-deepin-wine)
  - [自动切换(推荐)](#自动切换推荐)
  - [从 `wine`/`deepin-wine 2.x` 迁移](#从-winedeepin-wine-2x-迁移)
- [卸载](#卸载)
- [常见问题及解决](#常见问题及解决)
  - [中文字体显示为方框/显示模糊](#中文字体显示为方框显示模糊)
  - [小程序中字体显示为方框](#小程序中字体显示为方框)
  - [不能截图](#不能截图)
  - [高分辨率屏幕支持](#高分辨率屏幕支持)
  - [GNOME 桌面上的托盘图标](#gnome-桌面上的托盘图标)
  - [消除阴影边框](#消除阴影边框)
  - [唤出已运行的 WeChat 窗口](#唤出已运行的-wechat-窗口)
- [感谢](#感谢)
- [更新日志](#更新日志)

## 安装

`deepin-wine-wechat`依赖`Multilib`仓库中的一些 32 位库，Archlinux 默认没有开启`Multilib`仓库，需要编辑`/etc/pacman.conf`，取消对应行前面的注释并更新本地数据库([Archlinux wiki](https://wiki.archlinux.org/index.php/Official_repositories#multilib)):

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

保存后执行

```shell
sudo pacman -Sy
```

:warning: **注意：由于新版微信可能需要 `wine` 还没有实现的一些 win api，这会导致一些功能不可用，安装前先根据[兼容性记录](#兼容性记录)选择一个合适的版本**

:bulb: 以下三种安装方式效果相同，选择一种即可

### 从 AUR 安装

已添加到 AUR [deepin-wine-wechat](https://aur.archlinux.org/packages/deepin-wine-wechat/)，可使用 `yay` 或 `yaourt` 安装:

```shell
yay -S deepin-wine-wechat
```

### 用安装包安装

> 由 [GitHub Action](https://github.com/vufa/deepin-wine-wechat-arch/actions) 在 Docker 容器 [countstarlight/makepkg](https://hub.docker.com/r/countstarlight/makepkg) 中自动构建的 ArchLinux 安装包

在 [GitHub Release](https://github.com/vufa/deepin-wine-wechat-arch/releases) 页面下载后缀为 `.pkg.tar.xz` 或 `.pkg.tar.zst` 的安装包，使用`pacman`安装：

```bash
sudo pacman -U #下载的包名
```

`.md5` 文件用于校验包完整性：

```bash
md5sum -c *.md5
```

### 本地打包安装

```shell
 git clone https://github.com/vufa/deepin-wine-wechat-arch.git

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

:warning: **注意：所有版本的摄像头均不可用**

|      微信版本       |   wine    |   兼容性   |                                           备注                                            | deepin-wine | 兼容性 |                                                                                      备注                                                                                      |
| :-----------------: | :-------: | :--------: | :---------------------------------------------------------------------------------------: | :---------: | :----: | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|      3.8.0.41~      |    \      |     \      |                                            \                                              | 6.0.0.39-1  |  部分  |                                       截图不可用，内置浏览器出现问题([#225](https://github.com/vufa/deepin-wine-wechat-arch/issues/225))                                       |
|  3.7.0.30~3.7.6.44  |    \      |     \      |                                            \                                              | 6.0.0.24-1  |  部分  |                                   截图和表情包不可用，内置浏览器出现问题([#225](https://github.com/vufa/deepin-wine-wechat-arch/issues/225))                                   |
|  3.5.0.46~3.7.0.30  |    \      |     \      |                                            \                                              | 6.0.0.24-1  |  部分  | 小程序和公众号可用，截图([#192](https://github.com/vufa/deepin-wine-wechat-arch/issues/192))和表情包不可用([#177](https://github.com/vufa/deepin-wine-wechat-arch/issues/188)) |
|  3.3.0.93~3.5.0.46  |    \      |     \      |                                            \                                              |  5.0.16-1   |  支持  |                                                                                                                                                                                |
| 3.2.1.141~3.2.1.154 |    6.6    |            |     截图功能不可用：[#87](https://github.com/vufa/deepin-wine-wechat-arch/issues/87)      |  5.0.16-1   |  支持  |                                                                                                                                                                                |
|      3.2.1.127      |    6.5    |    部分    | 群聊闪退&截图功能不可用：[#87](https://github.com/vufa/deepin-wine-wechat-arch/issues/87) |  5.0.16-1   |  支持  |                                                                                                                                                                                |
|  3.1.0.41~3.1.0.72  | 5.22~6.0  |    部分    |     截图功能不可用：[#73](https://github.com/vufa/deepin-wine-wechat-arch/issues/73)      |  5.0.16-1   |  支持  |                                                                                                                                                                                |
|      3.0.0.57       |   5.22    | **不支持** |  微信安装程序不能启动：[#92](https://github.com/vufa/deepin-wine-wechat-arch/issues/92)   |  5.0.16-1   |  支持  |                                                                                                                                                                                |
|      3.0.0.57       |   5.19    |    支持    |                                                                                           |  2.18_24-3  |  支持  |                                                                                                                                                                                |
| 2.8.0.106~2.9.5.56  | 4.19~5.13 |    部分    |     发送图片有问题: [#42](https://github.com/vufa/deepin-wine-wechat-arch/issues/42)      |  2.18_22-3  |  部分  |                                                发送图片有问题: [#42](https://github.com/vufa/deepin-wine-wechat-arch/issues/42)                                                |
|  2.7.1.82~2.7.1.88  |   4.19+   |    支持    |                                                                                           |             |        |                                                                                                                                                                                |
|  2.7.1.82~2.7.1.88  | 4.17~4.18 |    部分    |                                    不能使用中文输入法                                     |  2.18_18-2  | 不支持 |                                                                                      闪退                                                                                      |
|      2.6.8.65       |   4.16    |    支持    |                                                                                           |  2.18_18-2  |  支持  |                                                                                                                                                                                |

## 切换到 `deepin-wine`

:warning: `deepin-wine-wechat` 从 `v3.5.0.46-2` 开始，默认使用 AUR 仓库 [deepin-wine6-stable](https://aur.archlinux.org/packages/deepin-wine6-stable/)，无需再进行任何切换操作，对于之前的版本，可以查看[旧版 README](https://github.com/vufa/deepin-wine-wechat-arch/blob/120d2dedd5dd9d018a14e8ff832f34fe2fcc57a3/README.md)。

### 自动切换(推荐)

对于之前的版本，可以查看[旧版 README](https://github.com/vufa/deepin-wine-wechat-arch/blob/120d2dedd5dd9d018a14e8ff832f34fe2fcc57a3/README.md)。

### 从 `wine`/`deepin-wine 2.x` 迁移

更新到 `deepin-wine-wechat v3.5.0.46-2` 及之后的版本后，依赖变更为 `deepin-wine6-stable`，

如果此时没有其他应用在使用 `wine`, `deepin-wine 2.x` 和 `deepin-wine5`，就可以放心的卸载 `wine`, `deepin-wine 2.x` 和 `deepin-wine5` 及其依赖：

```bash
# 卸载 deepin-wine 2.x (如果有)
sudo pacman -S lib32-freetype2 #用原版替换lib32-freetype2-infinality-ultimate
sudo pacman -Rns deepin-wine xsettingsd # 卸载 deepin-wine 2.x

# 卸载 deepin-wine5 (如果有)
sudo pacman -Rns deepin-wine5

# 卸载 wine (如果有)
sudo pacman -Rns wine wine-mono wine-gecko
```

同时，由于 deepin 的打包中不再包含 `deepin-wine-helper`，现改为使用 AUR 仓库[deepin-wine-helper](https://aur.archlinux.org/packages/deepin-wine-helper)，可以删除之前的 `deepin-wine-helper`：

```bash
rm -rf $HOME/.deepinwine/deepin-wine-helper
```

## 卸载

无论用何种方式安装，卸载都是：

```bash
sudo pacman -Rns deepin-wine-wechat
```

卸载的同时会删除用户目录下的整个 `WINEPREFIX` 环境，路径为：`~/.deepinwine/Deepin-WeChat`

微信在本地保存的数据不会被删除，如保存在用户文档下的数据(默认：`~/Documents/WeChat Files`)

## 常见问题及解决

### 中文字体显示为方框/显示模糊

`deepin-wine-wechat` 的字体文件夹在：`$HOME/.deepinwine/Deepin-WeChat/drive_c/windows/Fonts`

经测试将 `微软雅黑` 伪装成 `宋体(simsun)` 的显示效果最好，具体可以参照 [bbs.deepin.org](https://bbs.deepin.org/zh/post/213530?offset=0&postId=1269543)，将 `fake_simsun.ttc` 放到字体文件夹

### 小程序中字体显示为方框

> 参照 [deepin-wine-wechat-arch#186](https://github.com/vufa/deepin-wine-wechat-arch/issues/186)

可以安装 `deepin-wine-wechat` 的可选依赖 [noto-fonts-sc](https://aur.archlinux.org/packages/noto-fonts-sc/)(只包含 `noto-fonts-cjk` 中的简体中文字体)：

```bash
yay -S noto-fonts-sc
```

或安装 `noto-fonts-cjk` 并参照[ArchWiki](<https://wiki.archlinux.org/title/Localization_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)/Simplified_Chinese_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#.E4.BF.AE.E6.AD.A3.E7.AE.80.E4.BD.93.E4.B8.AD.E6.96.87.E6.98.BE.E7.A4.BA.E4.B8.BA.E5.BC.82.E4.BD.93.EF.BC.88.E6.97.A5.E6.96.87.EF.BC.89.E5.AD.97.E5.BD.A2>)进行配置

### 不能截图

对于之前的版本，可以查看[旧版 README](https://github.com/vufa/deepin-wine-wechat-arch/blob/120d2dedd5dd9d018a14e8ff832f34fe2fcc57a3/README.md)。

### 高分辨率屏幕支持

参照[设置](#设置)打开 `winecfg` ，在选项卡 `Graphics` 中修改 dpi，如 修改为`192`

:bulb: 这一修改会在更新或重装后被重置，如果要在更新后保留 dpi 设置，可以添加环境变量

> 根据 [deepin-wine-wechat-arch#173](https://github.com/vufa/deepin-wine-wechat-arch/issues/173)，由[abcfy2](https://github.com/abcfy2)提供的方法

编辑 `/etc/environment`，添加：

```
DEEPIN_WINE_SCALE=1.25
```

`1.25` 为缩放比例，计算方法和其他注意事项参照 [deepin-wine-wechat-arch#173(comment)](https://github.com/vufa/deepin-wine-wechat-arch/issues/173#issuecomment-989944258)

### GNOME 桌面上的托盘图标

安装 GNOME 插件: [AppIndicator and KStatusNotifierItem Support](https://extensions.gnome.org/extension/615/appindicator-support/)

### 消除阴影边框

对于之前的版本，可以查看[旧版 README](https://github.com/vufa/deepin-wine-wechat-arch/blob/120d2dedd5dd9d018a14e8ff832f34fe2fcc57a3/README.md)。

### 唤出已运行的 WeChat 窗口

#### 旧方法：

运行命令：

```bash
/opt/apps/com.qq.weixin.deepin/files/run.sh -w
```

可以参考 [deepin-wine-wechat-arch#96](https://github.com/vufa/deepin-wine-wechat-arch/issues/96) 和 [deepin-wine-wechat-arch#263](https://github.com/vufa/deepin-wine-wechat-arch/issues/263) 将该命令存入脚本并添加到全局快捷键中，方便使用

#### 新方法：

点击图标时如果已有正在运行的实例会导致错误的 kill，原因是`/opt/deepinwine/tools/kill.sh`中：

```shell
get_tray_window()
{
    # get_tray_window 是一个基于 python2 写的脚本，
    # python2 已是被扔进历史垃圾堆的产物，这个垃圾在
    # debian 10 中是关键组件，但在 Archlinux 中却
    # 没有必要再安装这个垃圾。
    $SHELL_DIR/get_tray_window | grep window_id: | awk -F: '{print $2}'
}
```

我们需要安装一个依赖：

```bash
sudo pacman -S dbus-python
```

再将脚本`/opt/deepinwine/tools/get_tray_window`内容修改成如下代码：

```python
#!/usr/bin/env python

def get_tray_window():
    try:
        import dbus
    except ImportError:
        return False

    bus = dbus.SessionBus()
    traymanager = bus.get_object("com.deepin.dde.TrayManager", "/com/deepin/dde/TrayManager")

    windows = traymanager.Get("com.deepin.dde.TrayManager","TrayIcons")
    str="window_id:"
    for i in range(len(windows)):
        str += '{:#x} '.format(windows[i])

    print(str)

if __name__ == "__main__":
    get_tray_window()
```

保存退出后，点击图标就不会再退出原实例，而是会唤出原实例窗口了。

## 感谢

- [Wuhan Deepin Technology Co.,Ltd.](http://www.deepin.org/)

## 更新日志

<details open>
<summary>2022</summary>

- 2022-11-30 WeChat-3.8.0.41
- 2022-09-06 WeChat-3.7.6.44
- 2022-08-20 WeChat-3.7.6.29
- 2022-08-20 WeChat-3.7.6.24
- 2022-08-17 WeChat-3.7.5.31
- 2022-07-21 WeChat-3.7.5.23
- 2022-06-09 WeChat-3.7.0.30
- 2022-06-02 WeChat-3.7.0.29
- 2022-03-20 WeChat-3.6.0.18 3.4.0.38deepin6
- 2022-02-03 WeChat-3.5.0.46 3.4.0.38deepin4
- 2022-01-27 WeChat-3.5.0.46
- 2022-01-03 WeChat-3.4.5.45

</details>

<details>
<summary>2021</summary>

- 2021-12-11 WeChat-3.4.5.27
- 2021-12-04 WeChat-3.4.0.54
- 2021-11-12 WeChat-3.4.0.38 3.2.1.154deepin14
- 2021-10-21 WeChat-3.4.0.38
- 2021-08-29 WeChat-3.3.5.50
- 2021-08-25 WeChat-3.3.5.42 3.2.1.154deepin13
- 2021-08-13 WeChat-3.3.5.42
- 2021-08-08 WeChat-3.3.5.34
- 2021-07-05 WeChat-3.3.0.115
- 2021-06-21 WeChat-3.3.0.93
- 2021-05-07 WeChat-3.2.1.154 3.2.1.154deepin8
- 2021-04-23 WeChat-3.2.1.154
- 2021-04-19 WeChat-3.2.1.151
- 2021-04-18 WeChat-3.2.1.141
- 2021-04-02 WeChat-3.2.1.127
- 2021-01-29 WeChat-3.1.0.72

</details>
<details>
<summary>2020</summary>

- 2020-12-29 WeChat-3.1.0.41
- 2020-11-26 WeChat-3.0.0.57 2.9.5.41deepin7
- 2020-10-16 WeChat-3.0.0.57
- 2020-07-20 WeChat-2.9.5.56
- 2020-07-02 WeChat-2.9.5.41
- 2020-05-10 WeChat-2.9.0.123
- 2020-04-24 WeChat-2.9.0.114
- 2020-04-20 WeChat-2.9.0.112
- 2020-03-08 WeChat-2.8.0.133
- 2020-02-10 WeChat-2.8.0.121
- 2020-01-20 WeChat-2.8.0.116
- 2020-01-10 WeChat-2.8.0.112
- 2020-01-04 WeChat-2.8.0.106

</details>
<details>
<summary>2019</summary>

- 2019-11-07 WeChat-2.7.1.88
- 2019-10-23 WeChat-2.7.1.85
- 2019-10-19 WeChat-2.7.1.82
- 2019-07-25 WeChat-2.6.8.65
- 2019-06-02 WeChat-2.6.8.52
- 2019-05-29 WeChat-2.6.8.51
- 2019-04-03 WeChat-2.6.7.57
- 2019-01-03 WeChat-2.6.2

</details>
