# MonoTizen VMs

Infrastructure for building and running VM images (ARM, x86) for Mono
development and qualification on Tizen.

## Licenses

The contents of the images are licensed under their original terms;
they should be obtained from upstream providers (the Tizen project,
Samsung, Intel, etc.).

This infrastructure part of MonoTizen, which is Copyright 2014
Kitsilano Software Inc.

MonoTizen is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

MonoTizen is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MonoTizen.  If not, see <http://www.gnu.org/licenses/>.

## VMs

| Name   | Arch     | Kernel             | Base image                   |
|--------|----------|--------------------|------------------------------|
| `tizn` | `armv7l` | `3.2.0-4-vexpress` | `tizen_20140602.4_RD-PQ`     |
| `teiz` | `armv7l` | `3.2.0-4-vexpress` | `tizen_20140602.4_RD-PQ`     |
| `thaz` | `i586`   | `bzImage.x86`      | `emulimg-2.2.x86`            |
| `thuz` | `i586`   | `bzImage.x86`      | `emulimg-2.2.x86`            |
| `thoz` | `armv7l` | `3.2.0-4-vexpress` | `tizen-2.2_20130719.3_RD-PQ` |
| `tinz` | `armv7l` | `3.2.0-4-vexpress` | `tizen-2.2_20130719.3_RD-PQ` |

## Hosts

The VMs are currently organized according to the physical host on
which they are supposed to run.

Please **avoid** running these VMs on other hosts if you intend to
keep the changes, as merging disk images is very painful in the
general case.  Cloning a VM is fine (Git-Annexed images will be
de-duplicated in Bup special remotes).

| Machine | Arch     | OS                 |
|---------|----------|--------------------|
| `mini`  | `x86_64` | Debian Testing     |
| `kaia`  | `x86_64` | Mac OS X Mavericks |
