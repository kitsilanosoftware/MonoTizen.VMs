# Copyright 2014 Kitsilano Software Inc.
#
# This file is part of MonoTizen.
#
# MonoTizen is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# MonoTizen is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MonoTizen.  If not, see <http://www.gnu.org/licenses/>.

PROTO   ?= no-proto
NAME    ?= unnamed-vm

BASH = bash

DATA = data
DOWNLOADS = $(DATA)/downloads
TMP = tmp

VM_SSH_PORT_FWD =
VM_HOST_HOSTNAME = 127.0.0.1
VM_BUNDLES =

TIZEN_VM_PROTO = $(PROTO)
export TIZEN_VM_PROTO

include protos/$(PROTO)/rules.mk
include bundles/mono-tizen-devel/rules.mk
include bundles/mono-tizen-build/rules.mk
include bundles/mono-tizen-sources/rules.mk
include bundles/mono-tizen-rpm/rules.mk

MAYBE_SSH_CONFIG = $(if $(VM_SSH_PORT_FWD),$(DATA)/vms/$(NAME)/ssh_config)

BUNDLE_SETUPS =							\
	$(foreach B,$(VM_BUNDLES),$(TMP)/vm-$(NAME)/$(B).setup)

$(TMP)/vm-$(NAME)/all.setup:			\
		$(BUNDLE_SETUPS)
	@mkdir -p $(dir $@)
	sort -u /dev/null $^ > $@.tmp
	@mv $@.tmp $@

$(DATA)/vms/$(NAME)/disk.qcow2:				\
		$(DATA)/images/$(PROTO)/base.qcow2	\
		protos/$(PROTO)/mount.guestfish		\
		$(TMP)/vm-$(NAME)/setup.tar		\
		$(TMP)/vm-$(NAME)/all.setup		\
		tools/tar-in.sh
	@mkdir -p $(dir $@)
	cd $(dir $@) && qemu-img create -f qcow2			\
		-o backing_file=../../images/$(PROTO)/$(notdir $<)	\
		$(notdir $@).tmp
	$(BASH) tools/tar-in.sh $@.tmp		\
		protos/$(PROTO)/mount.guestfish	\
		$(TMP)/vm-$(NAME)/setup.tar
	for S in $(shell cat $(TMP)/vm-$(NAME)/all.setup); do	\
		$(BASH) $$S $@.tmp				\
			protos/$(PROTO)/mount.guestfish;	\
	done
	qemu-img snapshot -c initial $@.tmp
	@mv $@.tmp $@

$(DATA)/vms/$(NAME)/ssh_config:			\
		templates/ssh_config.in
	@mkdir -p $(dir $@)
	sed < $< > $@.tmp						\
		-e 's|@@VM_HOSTNAME@@|$(NAME)|'				\
		-e 's|@@VM_SSH_PORT_FWD@@|$(VM_SSH_PORT_FWD)|'		\
		-e 's|@@VM_HOST_HOSTNAME@@|$(VM_HOST_HOSTNAME)|'
	@mv $@.tmp $@

$(DATA)/vms/$(NAME)/start.sh:			\
		protos/$(PROTO)/start.sh.in	\
		$(MAYBE_SSH_CONFIG)		\
		$(DATA)/vms/$(NAME)/disk.qcow2	\
		$(PROTO)-kernel
	@mkdir -p $(dir $@)
	sed < $< > $@.tmp					\
		-e 's|@@VM_SSH_PORT_FWD@@|$(VM_SSH_PORT_FWD)|'
	chmod 755 $@.tmp
	@mv $@.tmp $@

$(TMP)/vm-$(NAME)/setup.env:
	@mkdir -p $(dir $@)
	rm -f $@.tmp
	echo TIZEN_VM_HOSTNAME='$(NAME)' >> $@.tmp
	@mv $@.tmp $@

vm: $(DATA)/vms/$(NAME)/start.sh

.PHONY:						\
	vm					\
	2.2-armv7l-kernel
