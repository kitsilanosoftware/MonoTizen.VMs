# MonoTizen VMs

Ready-to-run Tizen VM images (ARM, x86; binaries via Git-Annex) for
Mono development and qualification.

## Licenses

The contents of the images are licensed under their original terms.

This infrastructure is currently "all rights reserved"; the licensing
terms (MIT?) are to be decided by Bob Summerwill and Damien Diederen
<dd@crosstwine.com>.

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
