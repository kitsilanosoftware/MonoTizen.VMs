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

TIZEN_VM__mono_tizen_build_HOME =		\
	home/developer
TIZEN_VM__mono_tizen_build_MT =				\
	$(TIZEN_VM__mono_tizen_build_HOME)/mono-tizen
TIZEN_VM__mono_tizen_build_MONO_SOURCES =		\
	$(TIZEN_VM__mono_tizen_build_MT)/mono-sources
TIZEN_VM__mono_tizen_build_RPM_BUILD =			\
	$(TIZEN_VM__mono_tizen_build_MT)/rpm-build

MONO_TIZEN_BUILD = ../MonoTizen.BuildScripts

$(TMP)/vm-%/mono-tizen-build.setup:			\
		$(TMP)/vm-%/mono-tizen-devel.setup	\
		$(TMP)/mono-tizen-build.tar
	@mkdir -p $(dir $@)
	cp $< $@.tmp
	echo bundles/mono-tizen-build/setup.sh >> $@.tmp
	mv $@.tmp $@

$(TMP)/mono-tizen-build.tar:				\
		$(TMP)/mono-tizen-build/tar.stamp
	@mkdir -p $(dir $@)
	tar cf $@.tmp -C $(TMP)/mono-tizen-build/tar .
	@mv $@.tmp $@

$(TMP)/mono-tizen-build/tar.stamp:			\
		bundles/mono-tizen-build/rpmmacros.in	\
		$(MONO_TIZEN_BUILD)/build-mono.sh
	@mkdir -p $(dir $@)
	@rm -rf $(dir $@)tar
	mkdir -p $(dir $@)tar/$(TIZEN_VM__mono_tizen_build_MONO_SOURCES)
	(cd $(MONO_TIZEN_BUILD) && git archive --prefix=build/ HEAD) |	\
		tar xf - -C $(dir $@)tar/$(TIZEN_VM__mono_tizen_build_MT)
	for D in BUILD BUILDROOT RPMS SOURCES SPECS SRPMS tmp; do \
		mkdir -p $(dir $@)tar/$(TIZEN_VM__mono_tizen_build_RPM_BUILD)/$$D; \
	done
	sed < $< > $(TMP)/mono-tizen-build.rpmmacros			   \
		-e 's|@@RPM_BUILD@@|/home/developer/mono-tizen/rpm-build|'
	echo '# KLUDGE.  Tizen is not well set up.'	\
		>> $(TMP)/mono-tizen-build.rpmmacros
	echo '%_host %{_target_platform}'		\
		>> $(TMP)/mono-tizen-build.rpmmacros
	mv $(TMP)/mono-tizen-build.rpmmacros				\
		$(dir $@)tar/$(TIZEN_VM__mono_tizen_build_HOME)/.rpmmacros
	touch $@
