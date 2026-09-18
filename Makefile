PICO8 ?= /Applications/PICO-8.app/Contents/MacOS/pico8
PICO8_BUNDLE_ID := com.lexaloffle.pico8
PICO8_CARTS := $(HOME)/Library/Application Support/pico-8/carts
CART := $(CURDIR)/mesh_quest.p8
RUN_DIR := $(PICO8_CARTS)/mesh-quest-dev
RUN_CART := $(RUN_DIR)/mesh_quest.p8
RUN_BUILD_DIR := $(RUN_DIR)/build
BUILD_DIR := $(CURDIR)/build

.PHONY: play web check stage

check:
	@test -x "$(PICO8)" || (echo "PICO-8 not found at $(PICO8)" && exit 1)

stage:
	@mkdir -p "$(RUN_DIR)/src/scenes"
	@cp "$(CART)" "$(RUN_CART)"
	@cp $(CURDIR)/src/*.lua "$(RUN_DIR)/src/"
	@cp $(CURDIR)/src/scenes/*.lua "$(RUN_DIR)/src/scenes/"

play: check stage
	@osascript -e 'tell application id "$(PICO8_BUNDLE_ID)" to quit' >/dev/null 2>&1 || true
	@sleep 0.4
	@open -b "$(PICO8_BUNDLE_ID)" --args -run "$(RUN_CART)"

web: check stage
	@mkdir -p "$(RUN_BUILD_DIR)" "$(BUILD_DIR)"
	cd "$(RUN_BUILD_DIR)" && "$(PICO8)" "$(RUN_CART)" -export "mesh_quest.html"
	@cp "$(RUN_BUILD_DIR)/mesh_quest.html" "$(BUILD_DIR)/mesh_quest.html"
	@cp "$(RUN_BUILD_DIR)/mesh_quest.js" "$(BUILD_DIR)/mesh_quest.js"
	@echo "Web build: $(BUILD_DIR)/mesh_quest.html"
