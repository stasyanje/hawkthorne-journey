UNAME := $(shell uname)
LOVE_DOWNLOAD_URL = https://github.com/love2d/love/releases/download
LOVE_VERSION = 11.5
MACOS_APP=build/Playground.app

ifeq ($(UNAME), Darwin)
	LOVE = bin/love.app/Contents/MacOS/love
	# macOS cannot create a Linux AppImage
	BINARIES = build/hawkthorne-macos.zip build/hawkthorne-win32.zip build/hawkthorne-win64.zip
else
	LOVE = bin/love.AppImage
	BINARIES = build/hawkthorne-macos.zip build/hawkthorne-win32.zip build/hawkthorne-win64.zip build/hawkthorne-linux.AppImage
endif

ifeq ($(shell which wget),)
	WGET = curl -s -O -L
else
	WGET = wget -q --no-check-certificate
endif

love: build/playground.love

love.js: build/playground.love
	mkdir -p build/web
	npm install
	npx love.js -m 77594624 -c build/playground.love build/web

build/playground.love: src/*
	mkdir -p build
	rm -f build/playground.love
	cd src && zip --symlinks -q -r ../build/playground.love . \
		-x ".*" \
		-x "*.DS_Store" \

run: $(LOVE)
	$(LOVE) src

bin/win32/love.exe:
	$(WGET) $(LOVE_DOWNLOAD_URL)/$(LOVE_VERSION)/love-$(LOVE_VERSION)-win32.zip
	unzip -q love-$(LOVE_VERSION)-win32.zip
	mv love-$(LOVE_VERSION)-win32 bin/win32
	rm -f love-$(LOVE_VERSION)-win32.zip
	rm bin/win32/changes.txt bin/win32/game.ico bin/win32/love.ico bin/win32/readme.txt

bin/win64/love.exe:
	$(WGET) $(LOVE_DOWNLOAD_URL)/$(LOVE_VERSION)/love-$(LOVE_VERSION)-win64.zip
	unzip -q love-$(LOVE_VERSION)-win64.zip
	mv love-$(LOVE_VERSION)-win64 bin/win64
	rm -f love-$(LOVE_VERSION)-win64.zip
	rm bin/win64/changes.txt bin/win64/game.ico bin/win64/love.ico bin/win64/readme.txt

bin/love.app/Contents/MacOS/love:
	mkdir -p bin
	$(WGET) $(LOVE_DOWNLOAD_URL)/$(LOVE_VERSION)/love-$(LOVE_VERSION)-macos.zip
	unzip -q love-$(LOVE_VERSION)-macos.zip
	rm -f love-$(LOVE_VERSION)-macos.zip
	mv love.app bin

bin/love.AppImage:
	mkdir -p bin
	$(WGET) $(LOVE_DOWNLOAD_URL)/$(LOVE_VERSION)/love-$(LOVE_VERSION)-x86_64.AppImage
	mv love-$(LOVE_VERSION)-x86_64.AppImage bin/love.AppImage
	chmod a+x bin/love.AppImage

bin/appimagetool.AppImage:
	mkdir -p bin
	$(WGET) https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage
	mv appimagetool-x86_64.AppImage bin/appimagetool.AppImage
	chmod a+x bin/appimagetool.AppImage

build/win32/hawkthorne.exe: build/hawkthorne.love bin/win32/love.exe
	mkdir -p build/win32
	cat bin/win32/love.exe build/hawkthorne.love > build/win32/hawkthorne.exe

build/win64/hawkthorne.exe: build/hawkthorne.love bin/win64/love.exe
	mkdir -p build/win64
	cat bin/win64/love.exe build/hawkthorne.love > build/win64/hawkthorne.exe

build/hawkthorne-win32.zip: build/win32/hawkthorne.exe
	cp -R bin/win32/* build/win32/
	zip --symlinks -q -r hawkthorne-win32 build/win32/ -x "*/love*.exe"
	mv hawkthorne-win32.zip build

build/hawkthorne-win64.zip: build/win64/hawkthorne.exe
	cp -R bin/win64/* build/win64/
	zip --symlinks -q -r hawkthorne-win64 build/win64/ -x "*/love*.exe"
	mv hawkthorne-win64.zip build

$(MACOS_APP): build/hawkthorne.love bin/love.app/Contents/MacOS/love
	cp -R bin/love.app $(MACOS_APP)
	cp build/hawkthorne.love $(MACOS_APP)/Contents/Resources/hawkthorne.love
	cp templates/macos/Info.plist $(MACOS_APP)/Contents/Info.plist
	cp templates/macos/Hawkthorne.icns $(MACOS_APP)/Contents/Resources/GameIcon.icns

build/hawkthorne-macos.zip: $(MACOS_APP)
	mkdir -p build
	zip --symlinks -q -r hawkthorne-macos $(MACOS_APP)
	mv hawkthorne-macos.zip build

build/hawkthorne-linux.AppImage: build/hawkthorne.love bin/love.AppImage bin/appimagetool.AppImage
	mkdir -p build/linux
	bin/love.AppImage --appimage-extract
	mv squashfs-root build/linux/
	cat build/linux/squashfs-root/bin/love build/hawkthorne.love > build/linux/squashfs-root/bin/hawkthorne
	chmod a+x build/linux/squashfs-root/bin/hawkthorne
	cp templates/linux/{AppRun,hawkthorne.png,love.desktop} build/linux/squashfs-root/
	rm build/linux/squashfs-root/bin/love build/linux/squashfs-root/love.svg
	./bin/appimagetool.AppImage build/linux/squashfs-root build/hawkthorne-linux.AppImage
	chmod a+x build/hawkthorne-linux.AppImage

binaries: $(BINARIES)

venv:
	python3 -m venv venv
	venv/bin/pip install -q -r requirements.txt

contributors: venv
	venv/bin/python scripts/credits.py > src/credits.lua

validate: venv lint
	venv/bin/python scripts/validate.py src

lint:
	touch src/maps/init.lua
	find src -name "*.lua" | grep -v "src/vendor" | grep -v "src/test" | \
		xargs -I {} ./scripts/lualint.lua -r "{}"

clean:
	rm -rf bin/
	rm -rf build/
	rm -rf venv/
	rm -rf node_modules/
	rm -rf scripts/*.pyc
	rm -rf src/maps/*.lua
