# Maintainer: Codist <countstarlight@gmail.com>

pkgname=deepin-wine-wechat
pkgver=3.0.0.57
wechat_installer=WeChatSetup
deepinwechatver=2.6.8.65deepin0
pkgrel=1
pkgdesc="Tencent WeChat (com.wechat) on Deepin Wine For Archlinux"
arch=("x86_64")
url="https://weixin.qq.com/"
license=('custom')
depends=('p7zip' 'wine' 'wine-mono' 'wine-gecko' 'xorg-xwininfo' 'wqy-microhei' 'lib32-alsa-lib' 'lib32-alsa-plugins' 'lib32-libpulse' 'lib32-openal' 'lib32-mpg123' 'lib32-libldap')
conflicts=('deepin-wechat')
install="deepin-wine-wechat.install"
_mirror="https://packages.deepin.com"
source=("$_mirror/pool/non-free/d/deepin.com.wechat/deepin.com.wechat_${deepinwechatver}_i386.deb"
  "${wechat_installer}-${pkgver}.exe::https://dldir1.qq.com/weixin/Windows/${wechat_installer}.exe"
  "run.sh"
  "reg.patch"
  "shadow.exe")
md5sums=('fe31cf4f0f6186fc1c99adc1512f5305'
  '2b103d675a045a2ef68c23c6c7339471'
  'f6027f842f18f23137a33f0d97f38715'
  'f264f961704f2aa1d480971b0e58617a'
  'd83f1c3845f28abd81cbfd215089d3d8')

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
  msg "Adding shadow.exe..."
  cp "${srcdir}/shadow.exe" "${srcdir}/deepinwechatdir/drive_c/"
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
  install -m644 "${srcdir}/reg.patch" "${pkgdir}/opt/deepinwine/apps/Deepin-WeChat/"
  install -m755 "${srcdir}/run.sh" "${pkgdir}/opt/deepinwine/apps/Deepin-WeChat/"
  install -m644 "${srcdir}/${wechat_installer}-${pkgver}.exe" "${pkgdir}/opt/deepinwine/apps/Deepin-WeChat/"
}
