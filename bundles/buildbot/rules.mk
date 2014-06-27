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

BUILDBOT_MASTER_HOST =				\
	MASTER.HOST.NOT.SET

BUILDBOT_MASTER_PASSWORD =

TIZEN_VM__buildbot_PYPI_BASE_URL =		\
	https://pypi.python.org/packages/source

# In dependency order!
TIZEN_VM__buildbot_PYPI_PATHS =				\
	z/zope.interface/zope.interface-4.1.1.tar.gz	\
	T/Twisted/Twisted-14.0.0.tar.bz2		\
	b/buildbot-slave/buildbot-slave-0.8.9.tar.gz

TIZEN_VM__buildbot_DOWNLOADS =				\
	$(addprefix $(DOWNLOADS)/buildbot/,		\
		$(TIZEN_VM__buildbot_PYPI_PATHS))

TIZEN_VM__buildbot_RPM_LIST =			\
	python-setuptools-devel

TIZEN_VM__buildbot_SUBDIRS =						\
	$(patsubst %.tar.bz2,%,						\
		$(patsubst %.tar.gz,%,					\
			$(notdir $(TIZEN_VM__buildbot_PYPI_PATHS))))

$(TMP)/vm-$(NAME)/buildbot.setup:				\
		$(TMP)/vm-$(NAME)/mono-tizen-devel.setup	\
		$(TMP)/buildbot.tar
	@mkdir -p $(dir $@)
	cp $< $@.tmp
	echo bundles/buildbot/setup.sh >> $@.tmp
	mv $@.tmp $@

$(TMP)/buildbot.tar:			\
		$(TMP)/buildbot/tar.stamp
	@mkdir -p $(dir $@)
	tar cf $@.tmp -C $(TMP)/buildbot/tar .
	@mv $@.tmp $@

$(TMP)/buildbot/tar.stamp:					\
		bundles/buildbot/install.sh.in			\
		bundles/buildbot/create.env.in			\
		bundles/buildbot/files/buildbot-create.sh	\
		$(TIZEN_VM__buildbot_DOWNLOADS)
	@rm -rf $(dir $@)tar
	mkdir -p $(dir $@)tar/root/rpms/install.d
	echo $(TIZEN_VM__buildbot_RPM_LIST)				\
		> $(dir $@)tar/root/rpms/install.d/buildbot.list
	mkdir -p $(dir $@)tar/root/sources
	for F in $(TIZEN_VM__buildbot_DOWNLOADS); do		\
		xf=zxf;						\
		case $$F in					\
			*.tar.bz2)				\
				xf=jxf;				\
				;;				\
		esac;						\
		tar $$xf $$F -C $(dir $@)tar/root/sources;	\
	done
	mkdir -p $(dir $@)tar/root/setup.d
	mkdir -p $(dir $@)tar/usr/local/lib/python2.7/site-packages/
	sed < $< > $(dir $@)tar/root/setup.d/25-buildbot-install.sh	\
		-e 's|@@SUBDIRS@@|$(TIZEN_VM__buildbot_SUBDIRS)|'
	chmod 755 $(dir $@)tar/root/setup.d/25-buildbot-install.sh
	mkdir -p $(dir $@)tar/home/developer/mono-tizen
	sed < bundles/buildbot/create.env.in				 \
		> $(dir $@)tar/home/developer/.buildbot-create.env	 \
		-e 's|@@BUILDBOT_MASTER_HOST@@|$(BUILDBOT_MASTER_HOST)|' \
		-e 's|@@BUILDBOT_MASTER_PASSWORD@@|$(BUILDBOT_MASTER_PASSWORD)|'
	cp bundles/buildbot/files/buildbot-create.sh		\
		$(dir $@)tar/root/setup.d/50-buildbot-create.sh
	touch $@

$(TIZEN_VM__buildbot_DOWNLOADS):
	mkdir -p $(dir $@)
	wget -O $@.tmp $(TIZEN_VM__buildbot_PYPI_BASE_URL)/$(subst	\
		$(DOWNLOADS)/buildbot/,,$@)
	@mv $@.tmp $@
