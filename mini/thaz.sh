#!/bin/bash

BASE="$(dirname "$0")"

exec qemu-system-i386 -m 1G -enable-kvm                         \
    -kernel "$BASE/../sdk-2.2/bzImage.x86"                      \
    -drive "file=$BASE/thaz.qcow2,if=virtio,index=1" -boot c    \
    -net nic                                                    \
    -net user,hostfwd=tcp::2223-:22
