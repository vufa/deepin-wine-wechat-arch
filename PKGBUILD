# Maintainer: Codist <countstarlight@gmail.com>

pkgname=deepin-wine-wechat
pkgver=3.3.5.42
wechat_installer=WeChatSetup
deepinwechatver=3.2.1.154deepin8
debpkgname="com.qq.weixin.deepin"
pkgrel=1
pkgdesc="Tencent WeChat on Deepin Wine(${debpkgname}) For Archlinux"
arch=("x86_64")
url="https://weixin.qq.com/"
license=('custom')
depends=('p7zip' 'wine' 'wine-mono' 'wine-gecko' 'xorg-xwininfo' 'wqy-microhei' 'lib32-alsa-lib' 'lib32-alsa-plugins' 'lib32-libpulse' 'lib32-openal' 'lib32-mpg123' 'lib32-libldap')
conflicts=('deepin-wechat')
install="deepin-wine-wechat.install"
_mirror="https://com-store-packages.uniontech.com"
source=("$_mirror/appstore/pool/appstore/c/${debpkgname}/${debpkgname}_${deepinwechatver}_i386.deb"
  "${wechat_installer}-${pkgver}.exe::https://dldir1.qq.com/weixin/Windows/${wechat_installer}.exe"
  "run.sh"
  "reg.patch")
md5sums=('3246f43cdfd2a4de9597d7018cb21753'
         '4204a40f3b9f4123c5347365a453473e'
         'fe6d9165926762788de03e9c67038c0a'
         'f3257f8fc9e73ea88b3a46372634f82f')

build() {
  msg "Extracting DPKG package ..."
  mkdir -p "${srcdir}/dpkgdir"
  tar -xvf data.tar.xz -C "${srcdir}/dpkgdir"
  sed "s/\(Categories.*$\)/\1Network;/" -i "${srcdir}/dpkgdir/opt/apps/${debpkgname}/entries/applications/${debpkgname}.desktop"
  sed "13s/WeChat.exe/wechat.exe/" -i "${srcdir}/dpkgdir/opt/apps/${debpkgname}/entries/applications/${debpkgname}.desktop"
  sed "s/run.sh\".*/run.sh\"/" -i "${srcdir}/dpkgdir/opt/apps/${debpkgname}/entries/applications/${debpkgname}.desktop"
  msg "Extracting Deepin Wine WeChat archive ..."
  7z x -aoa "${srcdir}/dpkgdir/opt/apps/${debpkgname}/files/files.7z" -o"${srcdir}/deepinwechatdir"
  msg "Cleaning up the original package directory ..."
  rm -r "${srcdir}/deepinwechatdir/drive_c/Program Files/Tencent/WeChat"
  msg "Patching reg files ..."
  patch -p1 -d "${srcdir}/deepinwechatdir/" < "${srcdir}/reg.patch"
  msg "Creating font file link ..."
  ln -sf "/usr/share/fonts/wenquanyi/wqy-microhei/wqy-microhei.ttc" "${srcdir}/deepinwechatdir/drive_c/windows/Fonts/wqy-microhei.ttc"
  msg "Copying latest WeChat installer to ${srcdir}/deepinwechatdir/drive_c/Program Files/Tencent/ ..."
  install -m644 "${srcdir}/${wechat_installer}-${pkgver}.exe" "${srcdir}/deepinwechatdir/drive_c/Program Files/Tencent/"
  #find -L "${srcdir}/deepinwechatdir/dosdevices" -maxdepth 1 -type l -delete
  msg "Repackaging app archive ..."
  7z a -t7z -r "${srcdir}/files.7z" "${srcdir}/deepinwechatdir/*"
}

package() {
  msg "Preparing icons ..."
  install -d "${pkgdir}/usr/share/applications"
  install -Dm644 "${srcdir}/dpkgdir/opt/apps/${debpkgname}/entries/applications/${debpkgname}.desktop" "${pkgdir}/usr/share/applications/${debpkgname}.desktop"
  cp -r "${srcdir}/dpkgdir/opt/apps/${debpkgname}/entries/icons/" "${pkgdir}/usr/share/"
  msg "Copying deepin files ..."
  install -d "${pkgdir}/opt/apps/${debpkgname}/files"
  install -m644 "${srcdir}/files.7z" "${pkgdir}/opt/apps/${debpkgname}/files/"
  cp ${srcdir}/dpkgdir/opt/apps/${debpkgname}/files/helper_archive* "${pkgdir}/opt/apps/${debpkgname}/files/"
  install -m755 "${srcdir}/dpkgdir/opt/apps/${debpkgname}/files/gtkGetFileNameDlg" "${pkgdir}/opt/apps/${debpkgname}/files/"
  md5sum "${srcdir}/files.7z" | awk '{ print $1 }' > "${pkgdir}/opt/apps/${debpkgname}/files/files.md5sum"
  install -m755 "${srcdir}/run.sh" "${pkgdir}/opt/apps/${debpkgname}/files/"
}
