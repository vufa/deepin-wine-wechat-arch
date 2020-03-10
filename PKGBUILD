# Maintainer: Codist <countstarlight@gmail.com>

pkgname=deepin-wine-wechat
pkgver=2.8.0.133
wechat_installer=WeChatSetup
deepinwechatver=2.6.8.65deepin0
pkgrel=2
pkgdesc="Tencent WeChat (com.wechat) on Deepin Wine For Archlinux"
arch=("x86_64")
url="https://weixin.qq.com/"
license=('custom')
depends=('p7zip' 'wine' 'wine-mono' 'wine_gecko' 'xorg-xwininfo' 'wqy-microhei' 'lib32-alsa-lib' 'lib32-alsa-plugins' 'lib32-libpulse' 'lib32-openal' 'lib32-mpg123' 'lib32-libldap')
conflicts=('deepin-wechat')
install="deepin-wine-wechat.install"
_mirror="https://mirrors.ustc.edu.cn/deepin"
source=("$_mirror/pool/non-free/d/deepin.com.wechat/deepin.com.wechat_${deepinwechatver}_i386.deb"
  "${wechat_installer}-${pkgver}.exe::https://dldir1.qq.com/weixin/Windows/${wechat_installer}.exe"
  "run.sh"
  "reg.patch")
md5sums=('fe31cf4f0f6186fc1c99adc1512f5305'
  '562d71c57e136a8aaa3be0d135092161'
  'bb6327d7e6997a3d9e1852915bafd337'
  'f264f961704f2aa1d480971b0e58617a')

build() {
  msg "Extracting DPKG package ..."
  mkdir -p "${srcdir}/dpkgdir"
  tar -xvf data.tar.xz -C "${srcdir}/dpkgdir"
  sed "s/\(Categories.*$\)/\1Network;/" -i "${srcdir}/dpkgdir/usr/share/applications/deepin.com.wechat.desktop"
  sed "13s/WeChat.exe/wechat.exe/" -i "${srcdir}/dpkgdir/usr/share/applications/deepin.com.wechat.desktop"
  msg "Extracting Deepin Wine WeChat archive ..."
  7z x -aoa "${srcdir}/dpkgdir/opt/deepinwine/apps/Deepin-WeChat/files.7z" -o"${srcdir}/deepinwechatdir"
  msg "Removing original outdated WeChat directory ..."
  rm -r "${srcdir}/deepinwechatdir/drive_c/Program Files/Tencent/WeChat"
  msg "Patching reg files ..."
  patch -p1 -d "${srcdir}/deepinwechatdir/" < "${srcdir}/reg.patch"
  msg "Creating font file link ..."
  ln -sf "/usr/share/fonts/wenquanyi/wqy-microhei/wqy-microhei.ttc" "${srcdir}/deepinwechatdir/drive_c/windows/Fonts/wqy-microhei.ttc"
  msg "Repackaging app archive ..."
  7z a -t7z -r "${srcdir}/files.7z" "${srcdir}/deepinwechatdir/*"
}

package() {
  msg "Preparing icons ..."
  install -d "${pkgdir}/usr/share"
  cp -a ${srcdir}/dpkgdir/usr/share/* "${pkgdir}/usr/share/"
  msg "Copying WeChat to /opt/deepinwine/apps/Deepin-WeChat ..."
  install -d "${pkgdir}/opt/deepinwine/apps/Deepin-WeChat"
  install -m644 "${srcdir}/files.7z" "${pkgdir}/opt/deepinwine/apps/Deepin-WeChat/"
  install -m755 "${srcdir}/run.sh" "${pkgdir}/opt/deepinwine/apps/Deepin-WeChat/"
  install -m644 "${srcdir}/${wechat_installer}-${pkgver}.exe" "${pkgdir}/opt/deepinwine/apps/Deepin-WeChat/"
  msg "Printing help info ..."
  echo -e "\033[0;34m============================提示/INFO==============================="
  echo -e "\033[0;34m* 报告问题(Report issue):"
  echo -e "\033[0;34m  https://github.com/countstarlight/deepin-wine-wechat-arch/issues"
  echo -e "\033[0;34m* 切换到 'deepin-wine'(Switch to 'deepin-wine'):"
  echo -e "\033[0;34m  https://github.com/countstarlight/deepin-wine-wechat-arch"
  echo -e "\033[0;34m* 安装包下载(Installation package download):"
  echo -e "\033[0;34m  https://github.com/countstarlight/deepin-wine-wechat-arch/releases"
  echo -e "\033[0;34m===================================================================="
}
