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

TIZEN_VM__distcc_TARBALL = \
	distcc-3.1.tar.bz2

TIZEN_VM__distcc_URL = \
	https://distcc.googlecode.com/files/$(TIZEN_VM__distcc_TARBALL)

TIZEN_VM__distcc_FILES =			\
	bundles/distcc/files/install-distcc.sh	\
	bundles/distcc/files/setup-distcc.sh

$(TMP)/vm-$(NAME)/distcc.setup:					\
		$(TMP)/vm-$(NAME)/mono-tizen-devel.setup	\
		$(TMP)/distcc.tar
	@mkdir -p $(dir $@)
	cp $< $@.tmp
	echo bundles/distcc/setup.sh >> $@.tmp
	mv $@.tmp $@

$(TMP)/distcc.tar:				\
		$(TMP)/distcc/tar.stamp
	@mkdir -p $(dir $@)
	tar cf $@.tmp -C $(TMP)/distcc/tar .
	@mv $@.tmp $@

$(TMP)/distcc/tar.stamp:				\
		$(TMP)/$(TIZEN_VM__distcc_TARBALL)	\
		$(TIZEN_VM__distcc_FILES)
	@rm -rf $(dir $@)tar
	mkdir -p $(dir $@)tar/home/developer/sources
	tar xjf $(TMP)/$(TIZEN_VM__distcc_TARBALL)	\
		-C $(dir $@)tar/home/developer/sources
	cd $(dir $@)tar/home/developer/sources &&	\
		ln -s distcc-* distcc
	for F in $(TIZEN_VM__distcc_FILES); do			\
		cp $$F $(dir $@)tar/home/developer/sources;	\
	done
	mkdir -p $(dir $@)tar/home/developer/.distcc
	touch $(dir $@)tar/home/developer/.distcc/hosts
	touch $@

$(TMP)/$(TIZEN_VM__distcc_TARBALL):
	@mkdir -p $(dir $@)
	wget -O $@.tmp $(TIZEN_VM__distcc_URL)
	@mv $@.tmp $@
