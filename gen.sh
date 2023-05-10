#!/bin/sh

PACKAGE_NAME="deepin-wine-wechat"
PACKAGE_SUFFIX=(".pkg.tar.xz" ".pkg.tar.zst")

GenPatch() {
    diff -ruN reg_tmp/ reg_tmp_fixed/ >reg.patch
}

Extract() {
    rm -rf reg_tmp_fixed &&
        mkdir reg_tmp_fixed &&
        tar xvjf reg_files.tar.bz2 -C reg_tmp_fixed
}

GenSrcInfo() {
    makepkg --printsrcinfo >.SRCINFO
}

Clean() {
    git clean -xfd
}

Tar() {
    cd reg_tmp &&
        tar -cvjSf reg_files.tar.bz2 * &&
        mv reg_files.tar.bz2 ../ &&
        cd ../
}

MD5() {
    for i in "${PACKAGE_SUFFIX[@]}"; do
        find . -type f -name "${PACKAGE_NAME}*$i" -execdir sh -c 'md5sum "$1" > "$1.md5"' _ {} \;
    done
}

Update() {
    if [ -z $1 ]; then
        echo "Please input the new WeChat version"
        exit 1
    fi

    # Get variables from PKGBUILD
    . ./PKGBUILD

    # Some variables
    local old_pkgver=$pkgver
    local new_pkgver=$1

    local old_run_sh_md5=$(md5sum run.sh | awk '{print $1}')
    local new_run_sh_md5=""

    local old_wechat_md5=""
    local new_wechat_md5=$2

    for i in "${!source[@]}"; do
        if [[ ${source[$i]} != *"$wechat_installer.exe" ]]; then
            continue
        fi

        old_wechat_md5=${md5sums[$i]}

        # If $new_wechat_md5 is set, use it directly
        # Used in cronjob workflow to avoid download the file again
        if [ -z $new_wechat_md5 ]; then
            local download_url=$(echo ${source[$i]} | awk -F '::' '{print $2}')
            new_wechat_md5=$(curl -L $download_url | md5sum | awk '{print $1}')
        fi
    done


    # Update run.sh
    sed -i "s/^WECHAT_VER=\"$old_pkgver\"$/WECHAT_VER=\"$new_pkgver\"/g" run.sh
    new_run_sh_md5=$(md5sum run.sh | awk '{print $1}')

    # Update PKGBUILD
    sed -i "s/^pkgver=$old_pkgver$/pkgver=$new_pkgver/g" PKGBUILD
    sed -i "s/$old_run_sh_md5/$new_run_sh_md5/g" PKGBUILD
    sed -i "s/$old_wechat_md5/$new_wechat_md5/g" PKGBUILD

    # Update .SRCINFO
    GenSrcInfo

    # Update README.md
    sed -i "s/\(<img src=\"https:\/\/img.shields.io\/badge\/WeChat-\)$old_pkgver/\1$new_pkgver/g" README.md
    sed -i "/^- [0-9-]\{10\} WeChat-$old_pkgver$/i - $(date "+%Y-%m-%d") WeChat-$new_pkgver" README.md
}

HelpApp() {
    echo " Extra Commands:"
    echo " -p/--patch               Generate patch files between reg_tmp/ and reg_tmp_fixed/"
    echo " -e/--extract             Extract reg files from reg_files.tar.bz2 to dir reg_tmp_fixed/"
    echo " -g/--gen                 Generate AUR package info to .SRCINFO"
    echo " -c/--clean               Clean files which not track by git"
    echo " -t/--tar                 Package reg files"
    echo " -m/--md5                 Generate the md5 file of each package"
    echo " -u/--update <version>    Update project file according to the new WeChat version"
    echo " -h/--help                Show program help info"
}

if [ -z $1 ]; then
    # Default generate AUR package info
    GenSrcInfo
    exit 0
fi
case $1 in
"-p" | "--patch")
    GenPatch
    ;;
"-e" | "--extract")
    Extract
    ;;
"-g" | "--gen")
    GenSrcInfo
    ;;
"-c" | "--clean")
    Clean
    ;;
"-t" | "--tar")
    Tar
    ;;
"-m" | "--md5")
    MD5
    ;;
"-u" | "--update")
    Update $2 $3
    ;;
"-h" | "--help")
    HelpApp
    ;;
*)
    echo -e "\033[31mgen: unrecognized option '$1' \033[0m"
    echo "Use -h|--help to get help"
    exit 1
    ;;
esac
exit 0
