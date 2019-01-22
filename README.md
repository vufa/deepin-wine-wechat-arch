# 在Archlinux及衍生发行版上运行微信(WeChat)

Deepin打包的微信(WeChat)容器移植到Archlinux

构建状态: [![travis-ci](https://travis-ci.org/countstarlight/deepin-wine-wechat-arch.svg?branch=master)](https://travis-ci.org/countstarlight/deepin-wine-wechat-arch)

感谢:

* [Wuhan Deepin Technology Co.,Ltd.](http://www.deepin.org/)

**注意：**
微信最新版本是2.6.6(2019.1.3)，经测试能正常运行，但不能固定下载的版本(下载文件名都是WeChatSetup，不能确定下载到的是2.6.6还是更新的版本，也没有找到提供历史版本下载)，所以还是直接使用deepin官方打包的2.6.2版本。

存在如下问题：
  * 1.不能视频通话
  * 2.不能截图(微信2.6.2和最新的2.6.6,2019.1.3)
  * 3.请用[issue](https://github.com/countstarlight/deepin-wine-wechat-arch/issues)反馈给我

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

* 1.已添加到AUR [deepin-wine-wechat](https://aur.archlinux.org/packages/deepin-wine-wechat/)，可直接安装:
```shell
yaourt deepin-wine-wechat
```

* 2.手动安装

```shell
 git clone https://github.com/countstarlight/deepin-wine-wechat-arch.git

 cd deepin-wine-wechat-arch
  
 makepkg -si
```

* 运行开始菜单中创建的WeChat，点击运行
* 默认使用文泉驿微米黑(`wqy-microhei`)字体，要使用其他字体，如 微软雅黑或者微软宋体放进`～/.deepinwine/Deepin-TIM/drive_c/windows/Fonts`中。
## 常见问题

* 1.在 2k/4k 屏幕下字体和图标都非常小, 参见[issue1](https://github.com/countstarlight/deepin-wine-tim-arch/issues/1)
* 2.使用全局截图快捷键和解决Gnome上窗口化问题，参见[issue2](https://github.com/countstarlight/deepin-wine-tim-arch/issues/2)
## 更新日志

* 2019-01-03 WeChat-2.6.2