#!/bin/bash

# -nographic -serial stdio
# -append '... console=ttyAMA0'
# -initrd di-2014-06-15/initrd.gz

# exec qemu-system-arm -M versatilepb                     \
#     -kernel aurel32/vmlinuz-3.2.0-4-versatile           \
#     -initrd aurel32/initrd.img-3.2.0-4-versatile        \
#     -hda debian.qcow2                                   \
#     -hdb tizen.img                                      \
#     -hdc tizen.qcow2                                    \
#     -append 'root=/dev/sda1'

#     -drive file=base.qcow2,if=sd,cache=writeback
#     -drive file=platform-tmp.img,if=sd,cache=writeback
#     -append 'root=/dev/mmcblk0p1 rw mem=1G'
#     -append 'root=/dev/mmcblk0 rw mem=1G'
#     -smp cores=2
#        ^ breaks?

# INIT=/bin/bash
INIT=/sbin/init

exec qemu-system-arm -M vexpress-a9 -m 1G                               \
    -kernel vexpress/vmlinuz-3.2.0-4-vexpress                           \
    -initrd vexpress/initrd.img-3.2.0-4-vexpress                        \
    -drive file=teiz.qcow2,if=sd,cache=writeback                        \
    -net nic                                                            \
    -net user,hostfwd=tcp::2222-:22                                     \
    -append "root=/dev/mmcblk0p1 rw mem=1G init=$INIT"
