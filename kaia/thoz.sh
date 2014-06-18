#!/bin/bash

BASE="$(dirname "$0")"
INIT=/sbin/init

exec qemu-system-arm -M vexpress-a9 -m 1G                               \
    -kernel "$BASE/../vexpress/vmlinuz-3.2.0-4-vexpress"                \
    -initrd "$BASE/../vexpress/initrd.img-3.2.0-4-vexpress"             \
    -drive "file=$BASE/thoz.qcow2,if=sd,cache=writeback"                \
    -net nic                                                            \
    -net user,hostfwd=tcp::2225-:22                                     \
    -append "root=/dev/mmcblk0p1 rw mem=1G init=$INIT"
