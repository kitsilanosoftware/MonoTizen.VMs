# MonoTizen VMs

Infrastructure for building and running VM images (ARM, x86) for Mono
development and qualification on Tizen.

## Licenses

This infrastructure part of MonoTizen, Copyright 2014 Kitsilano
Software Inc.

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

## Usage

    ./build-vm.sh <proto> <vm-name> [OPTION=value...]

Builds a MonoTizen VM named `<vm-name>` based on prototype `<proto>`.

The following "protos" are available:

| Name         | Arch   | Kernel           | Base image                 |
|--------------|--------|------------------|----------------------------|
| 2.2-armv7l   | armv7l | 3.2.0-4-vexpress | tizen-2.2_20130719.3_RD-PQ |
| 2.2.1-armv7l | armv7l | 3.2.0-4-vexpress | tizen-2.2_20131107.3_RD-PQ |
| 2.2.1-i686   | i686   | Tizen 2.2.1 SDK  | Tizen 2.2.1 SDK[^1]        |

Prototypes are subdirs in `protos/`, and consist in a main `rules.mk`
file as well as a number of patches, scripts, etc. describing how to
alter the upstream-provided files to turn them into a VM image.

[^1]: Note that `build-vm.sh` is currently unable to automatically
download the Tizen SDK images; the standard SDK installer has to be
used, and the files `bzImage.x86` and `emulimg-2.2.x86` copied/linked
into `data/downloads/2.2.1-i686/`.

### Example

Here is an example invocation:

    $ ./build-vm.sh 2.2.1-i686 thux  \
        VM_SSH_PORT_FWD=2227       \
        VM_BUNDLES=mono-tizen-rpm

creates a new VM in `data/vms/thux/` with the following files:

  * `start.sh`: A startup script for the VM.  Running the following
    (from any working directory):

        $ .../path/to/thux/start.sh

    should suffice to get a VM which can be ssh-ed into (once
    booted!);

  * `ssh_config`: A fragment to add to `~/.ssh/config` to be able to
    shell into the running VM via a simple `ssh thux`;

  * `disk.qcow2`: A thin-provisioned disk/SD card image for the VM.

    For convenience, the initial QCOW image is snapshotted so that a
    simple `qemu-img snapshot -a initial data/vms/thux/disk.qcow2`
    restores it to its logical initial state.

### Options

  * `VM_SSH_PORT_FWD=<port-nr>`: Tell QEMU to forward connections to
    host port `<port-nr>` to the SSH port (22) of the VM. Once the vm
    is created,

        $ cat data/vms/<vm-name>/ssh_config >> ~/.ssh/config

    should be sufficient to be able to do:

        $ ssh <vm-name>

    and get logged as `developer` in the new VM;

  * `VM_HOST_HOSTNAME=<host-name>`: Modifies `ssh_config` (if created)
    for a VM that is to be hosted on host `<host-name>`;

  * `VM_BUNDLES=<bundle-list>`: Installs the bundles listed in
    `<bundle-list>`, a space-separated list of bundles, inside the VM.

    Note that the list has to be quoted if more than one bundle is to
    be installed, e.g.:

        VM_BUNDLES='mono-tizen-sources mono-tizen-rpm'

    Cf. "Bundles" section for a list of available bundles.

### Bundles

Bundles are subdirs in `bundles/`, and currently include:

  * `mono-tizen-devel`: Prepares the VM for MonoTizen development by
    including (but not pre-installing!) the required RPM packages in
    the image, and creating a series of initialization scripts.

    Note that when the VM is first booted, it is necessary to run the
    following simple command:

        $ su -c /root/setup.sh

    before proceeding with actual development;

  * `mono-tizen-build`: Installs the build scripts from the
    `MonoTizen.BuildScripts` repository within the VM, and prepares
    the build environment under `/home/developer/mono-tizen`;

  * `mono-tizen-sources`: Installs a fresh Git clone of the Mono
    source tree within the VM, for "on-device" building, debugging and
    fixing, e.g.:

        $ mono-tizen/build/build-mono.sh --autogen --build --install

    is sufficient to get a custom build of Mono installed in
    `/home/developer/mono-tizen/mono`;

  * `mono-tizen-rpm`: Installs a dist tarball and RPM `.spec` file of
    Mono within the VM, for building full RPMs.  With this,

        $ rpmbuild -bb   \
            mono-tizen/rpm-build/SPECS/mono-core-3.6.1-1.spec

    is sufficient to get standard platform RPMs built into
    `/home/developer/mono-tizen/rpm-build/RPMS/`;

  * `distcc`: Installs the source of the `distcc` distributed
    compilation framework within the VM.  The `distcc` binary is built
    and configured (once) with:

        $ /home/developer/sources/install-distcc.sh

    The compilation host setup is done via:

        $ vi /home/developer/.distcc/hosts

    and each session must start with:

        $ source /home/developer/sources/setup-distcc.sh

  * `buildbot`: Installs the required infrastructure to run `buildbot`
    in the VM.  When this bundle is selected, `mono-tizen-devel`'s
    setup step will take care of building and installing the required
    Python modules, and of creating a default build slave.  The latter
    can then be started with the following command:

        $ /usr/local/bin/buildslave start \
            /home/developer/mono-tizen/buildbot

    It is then a "simple matter" of configuring the master to pull
    from the repository and to submit a job which uses
    `mono-tizen-build` to perform compilation and/or testing.

Note that bundle dependencies are automatically resolved;
e.g. `mono-tizen-rpm` depends on `mono-tizen-devel`, but using
`VM_BUNDLES=mono-tizen-rpm` is sufficient.
