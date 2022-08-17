# Maintainer: Vufa <countstarlight@gmail.com>

pkgname=deepin-wine-wechat
pkgver=3.7.5.31
wechat_installer=WeChatSetup
deepinwechatver=3.4.0.38deepin6
debpkgname="com.qq.weixin.deepin"
pkgrel=1
pkgdesc="Tencent WeChat on Deepin Wine(${debpkgname}) For Archlinux"
arch=("x86_64")
url="https://weixin.qq.com/"
license=('custom')
depends=('p7zip' 'deepin-wine6-stable>=6.0.0.24-1' 'deepin-wine-helper>=5.1.39_1-1' 'xorg-xwininfo' 'wqy-microhei' 'lib32-alsa-lib' 'lib32-alsa-plugins' 'lib32-libpulse' 'lib32-openal' 'lib32-mpg123' 'lib32-libldap')
optdepends=('noto-fonts-sc: display some Chinese characters'
            'lib32-nvidia-utils: required for nvidia graphics card')
conflicts=('deepin-wechat')
install="deepin-wine-wechat.install"
_mirror="https://com-store-packages.uniontech.com"
_mirror_lib="https://community-packages.deepin.com/deepin/pool/main"
source=("$_mirror/appstore/pool/appstore/c/${debpkgname}/${debpkgname}_${deepinwechatver}_i386.deb"
  "${wechat_installer}-${pkgver}.exe::https://dldir1.qq.com/weixin/Windows/${wechat_installer}.exe"
  "$_mirror_lib/o/openldap/libldap-2.4-2_2.4.47+dfsg.4-1+eagle_i386.deb"
  "$_mirror_lib/c/cyrus-sasl2/libsasl2-2_2.1.27.1-1+dde_i386.deb"
  "run.sh"
  "reg.patch")
md5sums=('6c4edb108a0593bab7a556a6c9e8a012'
         '930141b82ed317250274c3aeb3750ae2'
         'cf87ad9db0bf279ddf9e5c1dce64a716'
         '89b10711889f52ab0a386f37b4eb3212'
         '543ccf3fdb5e00a2fde68971294d8265'
         '05b05416ef1fa4e1baaf64736e15a057')

build() {
  msg "Extracting DPKG package ..."
  mkdir -p "${srcdir}/dpkgdir"
  ar -x ${debpkgname}_${deepinwechatver}_i386.deb
  tar -xvf data.tar.xz -C "${srcdir}/dpkgdir"
  ar -x libldap-2.4-2_2.4.47+dfsg.4-1+eagle_i386.deb
  tar -xvf data.tar.xz -C "${srcdir}/dpkgdir"
  ar -x libsasl2-2_2.1.27.1-1+dde_i386.deb
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
  msg "Creating 'XPlugin/Plugins/XWeb' to forbid wechat browser creating crash logs ..."
  mkdir -p "${srcdir}/deepinwechatdir/drive_c/users/@current_user@/Application Data/Tencent/WeChat/XPlugin/Plugins/"
  touch "${srcdir}/deepinwechatdir/drive_c/users/@current_user@/Application Data/Tencent/WeChat/XPlugin/Plugins/XWeb"
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
  cp -r "${srcdir}/dpkgdir/opt/apps/${debpkgname}/files/dlls" "${pkgdir}/opt/apps/${debpkgname}/files/"
  install -m644 "${srcdir}/files.7z" "${pkgdir}/opt/apps/${debpkgname}/files/"
  # cp ${srcdir}/dpkgdir/opt/apps/${debpkgname}/files/helper_archive* "${pkgdir}/opt/apps/${debpkgname}/files/"
  # install -m755 "${srcdir}/dpkgdir/opt/apps/${debpkgname}/files/gtkGetFileNameDlg" "${pkgdir}/opt/apps/${debpkgname}/files/"
  md5sum "${srcdir}/files.7z" | awk '{ print $1 }' > "${pkgdir}/opt/apps/${debpkgname}/files/files.md5sum"
  install -m755 "${srcdir}/run.sh" "${pkgdir}/opt/apps/${debpkgname}/files/"
  msg "Copying deepin lib32 files ..."
  install -d "${pkgdir}/opt/apps/${debpkgname}/files/lib32"
  # cp ${srcdir}/dpkgdir/usr/lib/i386-linux-gnu/{liblber-2.4.so.2,libldap-2.4.so.2,libldap_r-2.4.so.2,libsasl2.so.2} "${pkgdir}/opt/apps/${debpkgname}/files/lib32"
  cp ${srcdir}/dpkgdir/usr/lib/i386-linux-gnu/* "${pkgdir}/opt/apps/${debpkgname}/files/lib32"
}
