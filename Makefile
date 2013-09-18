# -*- makefile -*-

RSYNC_OPTS	= -avzcC -e ssh

# # waffle
# REMOTE_HOST1	= tetsuji.jp
# REMOTE_USER1	= www-data
# REMOTE_PATH1	= /usr/local/lib/site_perl

# sakura vps
REMOTE_HOST2	= sakura.vps.tetsuji.jp
REMOTE_USER2	= www-data
REMOTE_PATH2	= /usr/local/lib/site_perl

usage:
	@echo "Usage:"
	@: echo "  make install1"
	@: echo "  make dry-install1"
	@: echo "  make show-variables1"
	@echo "  make install2"
	@echo "  make dry-install2"
	@echo "  make show-variables2"

ABORT:
	exit 1

### Apache1
show-variables1: ABORT
	@echo "  RSYNC_OPTS=$(RSYNC_OPTS)"
	@echo "  REMOTE_HOST=$(REMOTE_HOST1)"
	@echo "  REMOTE_USER=$(REMOTE_USER1)"
	@echo "  REMOTE_PATH=$(REMOTE_PATH1)"

install1: ABORT
	rsync $(RSYNC_OPTS) lib/ModPerl/ $(REMOTE_USER1)@$(REMOTE_HOST1):$(REMOTE_PATH1)/ModPerl/

dry-install1: ABORT
	$(MAKE) install1 RSYNC_OPTS="--dry-run $(RSYNC_OPTS)"

### Apache2
show-variables2:
	@echo "  RSYNC_OPTS=$(RSYNC_OPTS)"
	@echo "  REMOTE_HOST=$(REMOTE_HOST2)"
	@echo "  REMOTE_USER=$(REMOTE_USER2)"
	@echo "  REMOTE_PATH=$(REMOTE_PATH2)"

install2:
	rsync $(RSYNC_OPTS) lib/ModPerl/ $(REMOTE_USER2)@$(REMOTE_HOST2):$(REMOTE_PATH2)/ModPerl/

dry-install2:
	$(MAKE) install2 RSYNC_OPTS="--dry-run $(RSYNC_OPTS)"
