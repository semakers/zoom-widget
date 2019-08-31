
LIB_FSPATH=$(PWD)

print:
	@echo
	@echo LIB_FSPATH: $(LIB_FSPATH)
	@echo SAMPLE_DIR: $(SAMPLE_DIR)
	@echo MOB_SAMPLE_FSPATH: $(MOB_SAMPLE_FSPATH)
	@echo DESK_SAMPLE_FSPATH: $(DESK_SAMPLE_FSPATH)
	@echo

os-dep:
	# glfw
	# mac
	brew install glfw
	# linux
	#apt install libglfw
	# windows ?

	# Using go-flutter
	go get -u github.com/go-flutter-desktop/hover

SAMPLE_DIR=examples
MOB_SAMPLE_NAME=mobile
MOB_SAMPLE_FSPATH=$(LIB_FSPATH)/$(SAMPLE_DIR)/$(MOB_SAMPLE_NAME)
flu-mob-run:
	#cd $(LIB_FSPATH)/$(SAMPLE) && flutter clean
	cd $(MOB_SAMPLE_FSPATH) && flutter pub get
	cd $(MOB_SAMPLE_FSPATH) && flutter run -d all

DESK_SAMPLE_NAME=desktop
DESK_SAMPLE_FSPATH=$(LIB_FSPATH)/$(SAMPLE_DIR)/$(DESK_SAMPLE_NAME)

flu-desk-init:
	cd $(DESK_SAMPLE_FSPATH) && hover init $(LIB)/$(DESK_SAMPLE_NAME)
flu-desk-init-clean:
	rm -rf $(DESK_SAMPLE_FSPATH)/go
flu-desk-run:
	cd $(DESK_SAMPLE_FSPATH) && hover run
flu-desk-build:
	cd $(DESK_SAMPLE_FSPATH) && hover build
flu-desk-buildrun: flu-desk-build
	open $(DESK_SAMPLE_FSPATH)/go/build/outputs/darwin/$(DESK_SAMPLE_NAME)


