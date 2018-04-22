#!/usr/bin/env bash

DIR=$(cd $(dirname "$0") && pwd)

source ${DIR}/setup.sh

ASM_FILES=$(ls ./src/ch-$1/*.asm)

rm -rf ${DIST_DIR}/build && mkdir ${DIST_DIR}/build

for ASM_FILE in ${ASM_FILES}; do
  nasm -f bin -o ${DIST_DIR}/build/$(basename ${ASM_FILE}).img ${ASM_FILE}
done

IMG_FILES=$(ls ${DIST_DIR}/build/*.img)

touch ${DIST_DIR}/build/BOOT.img

for IMG in $IMG_FILES; do
  cat $IMG >> ${DIST_DIR}/build/BOOT.img
done

VM_NAME=x86_study

# VBoxManage storagectl

VBoxManage storageattach $VM_NAME \
    --storagectl Floppy --device 0 --port 0 --port 0 \
    --medium ${DIST_DIR}/build/BOOT.img

VBoxManage controlvm $VM_NAME poweroff
sleep 1
VBoxManage startvm $VM_NAME