

os-dep:
	# glfw
	# mac
	brew install glfw
	# linux
	#apt install libglfw
	# windows ?

	# Using go-flutter
	go get -u github.com/go-flutter-desktop/hover

SAMPLE=example
flu-mob-run:
	cd $(LIB_FSPATH)/$(SAMPLE) && flutter clean
	cd $(LIB_FSPATH)/$(SAMPLE) && flutter pub get
	cd $(LIB_FSPATH)/$(SAMPLE) && flutter run -d all

flu-desk-init:
	cd $(LIB_FSPATH)/$(SAMPLE) && hover init $(LIB)/$(SAMPLE)
flu-desk-init-clean:
	rm -rf $(LIB_FSPATH)/$(SAMPLE)/go
flu-desk-run:
	cd $(LIB_FSPATH)/$(SAMPLE) && hover run
flu-desk-build:
	cd $(LIB_FSPATH)/$(SAMPLE) && hover build
flu-desk-buildrun: flu-desk-build
	open $(LIB_FSPATH)/$(SAMPLE)/go/build/outputs/darwin/
	open $(LIB_FSPATH)/$(SAMPLE)/go/build/outputs/darwin/$(SAMPLE)


