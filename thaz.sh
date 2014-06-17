#!/bin/bash

exec qemu-system-i386 -m 1G -enable-kvm                 \
    -kernel sdk-2.2/bzImage.x86                         \
    -drive file=thaz.qcow2,if=virtio,index=1 -boot c    \
    -net nic                                            \
    -net user,hostfwd=tcp::2223-:22                     \
    -append 'text'