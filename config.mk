SRC_ICON_FILE=$(SOURCE_DIR)/icon.png

VERSION = 2024.10.16
MANUAL_URL  = https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-$(VERSION).tar.xz
MANUAL_SRC = tmp/autoconf-archive-$(VERSION)
MANUAL_SRC_MAKEFILE = $(MANUAL_SRC)/Makefile
MANUAL_FILE = $(MANUAL_SRC)/doc/autoconf-archive.html

$(MANUAL_SRC): tmp
	curl -o $@.tar.xz $(MANUAL_URL)
	tar -x -J -f $@.tar.xz -C tmp

$(MANUAL_SRC_MAKEFILE): $(MANUAL_SRC)
	cd $(MANUAL_SRC) && ./configure

$(MANUAL_FILE): $(MANUAL_SRC_MAKEFILE)
	cd $(MANUAL_SRC) && make html

$(DOCUMENTS_DIR): $(RESOURCES_DIR) $(MANUAL_FILE)
	mkdir -p $@
	cp -r $(MANUAL_FILE)/* $@

#$(INDEX_FILE): $(SOURCE_DIR)/src/index-pages.sh $(DOCUMENTS_DIR)
#	rm -f $@
#	$(SOURCE_DIR)/src/index-pages.sh $@ $(DOCUMENTS_DIR)/*.html

$(INDEX_FILE): $(SOURCE_DIR)/src/index-pages.py $(DOCUMENTS_DIR)
	rm -f $@
	$(SOURCE_DIR)/src/index-pages.py $@ $(DOCUMENTS_DIR)/*.html
