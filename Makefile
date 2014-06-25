PROTO   ?= no-proto
NAME    ?= unnamed-vm

BASH = bash

DATA = data
DOWNLOADS = $(DATA)/downloads
TMP = tmp

VM_SSH_PORT_FWD =
VM_HOST_HOSTNAME = 127.0.0.1
VM_HOME_ALLOC =

include protos/$(PROTO)/rules.mk

MAYBE_SSH_CONFIG = $(if $(VM_SSH_PORT_FWD),$(DATA)/vms/$(NAME)/ssh_config)

$(DATA)/vms/$(NAME)/disk.qcow2:				\
		$(DATA)/images/$(PROTO)/base.qcow2	\
		protos/$(PROTO)/mount.guestfish		\
		$(TMP)/vm-$(NAME)/setup.tar		\
		tools/setup.sh
	@mkdir -p $(dir $@)
	cd $(dir $@) && qemu-img create -f qcow2			\
		-o backing_file=../../images/$(PROTO)/$(notdir $<)	\
		$(notdir $@).tmp
	$(BASH) tools/setup.sh $@.tmp		\
		protos/$(PROTO)/mount.guestfish	\
		$(TMP)/vm-$(NAME)/setup.tar	\
		'$(VM_HOME_ALLOC)'
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
