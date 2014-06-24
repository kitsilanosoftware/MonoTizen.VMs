PROTO   ?= no-proto
NAME    ?= unnamed-vm

BASH = bash

DATA = data
DOWNLOADS = $(DATA)/downloads
TMP = tmp

SSH_FWD_PORT =

include protos/$(PROTO)/rules.mk

$(DATA)/vms/$(NAME)/disk.qcow2:				\
		$(DATA)/images/$(PROTO)/base.qcow2
	@mkdir -p $(dir $@)
	cd $(dir $@) && qemu-img create -f qcow2			\
		-o backing_file=../../images/$(PROTO)/$(notdir $<)	\
		$(notdir $@).tmp
	@mv $@.tmp $@

$(DATA)/vms/$(NAME)/start.sh:			\
		protos/$(PROTO)/start.sh.in	\
		$(DATA)/vms/$(NAME)/disk.qcow2	\
		$(PROTO)-kernel
	@mkdir -p $(dir $@)
	sed < $< > $@.tmp					\
		-e 's|@@SSH_FWD_PORT@@|$(SSH_FWD_PORT)|'
	chmod 755 $@.tmp
	@mv $@.tmp $@

vm: $(DATA)/vms/$(NAME)/start.sh

.PHONY:						\
	vm					\
	2.2-armv7l-kernel