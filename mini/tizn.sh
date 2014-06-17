#!/bin/bash

exec qemu-system-arm -M vexpress-a9 -m 1G                               \
    -kernel vexpress/vmlinuz-3.2.0-4-vexpress                           \
    -initrd vexpress/initrd.img-3.2.0-4-vexpress                        \
    -drive file=tizn.qcow2,if=sd,cache=writeback                        \
    -net nic                                                            \
    -net user,hostfwd=tcp::2222-:22                                     \
    -append 'root=/dev/mmcblk0p1 rw mem=1G init=/usr/bin/systemd'
