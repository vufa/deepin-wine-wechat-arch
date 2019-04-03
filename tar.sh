#!/bin/sh

pre_reg_md5=`md5sum reg_files.tar.bz2|cut -d ' ' -f1`

cd reg_tmp && \
   tar -cvjSf reg_files.tar.bz2 * && \
   mv reg_files.tar.bz2 ../ && \
   cd ../

new_reg_md5=`md5sum reg_files.tar.bz2|cut -d ' ' -f1`

if [ "$pre_reg_md5" = "$new_reg_md5" ];
then
    echo -e "\033[33mReg files have not changed\033[0m"
else
    sed -i "s#$pre_reg_md5#$new_reg_md5#" PKGBUILD
    echo Done
fi
