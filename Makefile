DOCSET_NAME = GNU_Autoconf_Archive

DOCSET_DIR    = $(DOCSET_NAME).docset
CONTENTS_DIR  = $(DOCSET_DIR)/Contents
RESOURCES_DIR = $(CONTENTS_DIR)/Resources
DOCUMENTS_DIR = $(RESOURCES_DIR)/Documents

INFO_PLIST_FILE = $(CONTENTS_DIR)/Info.plist
INDEX_FILE      = $(RESOURCES_DIR)/docSet.dsidx
ICON_FILE       = $(DOCSET_DIR)/icon.png
ARCHIVE_FILE    = $(DOCSET_NAME).tgz

MANUAL_VERSION = 2023.02.20
MANUAL_URL  = https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-$(MANUAL_VERSION).tar.xz
MANUAL_SRC = tmp/autoconf-archive-$(MANUAL_VERSION)
MANUAL_SRC_MAKEFILE = $(MANUAL_SRC)/Makefile
MANUAL_FILE = $(MANUAL_SRC)/doc/autoconf-archive.html

DOCSET = $(INFO_PLIST_FILE) $(INDEX_FILE) $(ICON_FILE)

all: $(DOCSET)

archive: $(ARCHIVE_FILE)

clean:
	rm -rf $(DOCSET_DIR) $(ARCHIVE_FILE)

tmp:
	mkdir -p $@

$(ARCHIVE_FILE): $(DOCSET)
	tar --exclude='.DS_Store' -czf $@ $(DOCSET_DIR)

$(MANUAL_SRC): tmp
	curl -o $@.tar.xz $(MANUAL_URL)
	tar -x -J -f $@.tar.xz -C tmp

$(MANUAL_SRC_MAKEFILE): $(MANUAL_SRC)
	cd $(MANUAL_SRC) && ./configure

$(MANUAL_FILE): $(MANUAL_SRC_MAKEFILE)
	cd $(MANUAL_SRC) && make html

$(DOCSET_DIR):
	mkdir -p $@

$(CONTENTS_DIR): $(DOCSET_DIR)
	mkdir -p $@

$(RESOURCES_DIR): $(CONTENTS_DIR)
	mkdir -p $@

$(DOCUMENTS_DIR): $(RESOURCES_DIR) $(MANUAL_FILE)
	mkdir -p $@
	cp -r $(MANUAL_FILE)/* $@

$(INFO_PLIST_FILE): src/Info.plist $(CONTENTS_DIR)
	cp src/Info.plist $@

$(INDEX_FILE): src/index.sh $(DOCUMENTS_DIR)
	rm -f $@
	src/index.sh $@ $(DOCUMENTS_DIR)/*.html

$(ICON_FILE): src/icon.png $(DOCSET_DIR)
	cp src/icon.png $@
