
LIB_FSPATH=$(PWD)

print:
	@echo
	@echo LIB_FSPATH: $(LIB_FSPATH)
	@echo SAMPLE_DIR: $(SAMPLE_DIR)
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


SAMPLE_NAME=desktop
flu-desk-init:
	hover init $(SAMPLE_NAME)
flu-desk-init-clean:
	rm -rf $(PWD)/go
flu-desk-run:
	hover run
flu-desk-build:
	hover build
flu-desk-buildrun: flu-desk-build
	open $(PWD)/go/build/outputs/darwin/$(SAMPLE_NAME)


