PICO8 ?= /Applications/PICO-8.app/Contents/MacOS/pico8
PICO8_BUNDLE_ID := com.lexaloffle.pico8
PICO8_CARTS := $(HOME)/Library/Application Support/pico-8/carts
CART := $(CURDIR)/mesh_quest.p8
STORY_SOURCE := $(CURDIR)/story/intro.story
STORY_OUTPUT := $(CURDIR)/src/story_intro.lua
STORY_COMPILER := $(CURDIR)/tools/build_story.py
STORY_ART_SOURCE := $(CURDIR)/ref/scene_0
STORY_ART_COMPILER := $(CURDIR)/tools/build_story_art.py
STORY_PLACEHOLDER_SOURCE := $(CURDIR)/ref/scene_0/placeholders
STORY_PLACEHOLDER_OUTPUT := $(CURDIR)/src/story_placeholders.lua
STORY_PLACEHOLDER_COMPILER := $(CURDIR)/tools/build_story_placeholders.py
MUSIC_COMPILER := $(CURDIR)/tools/build_music.py
GAME_SOURCE := $(CURDIR)/mesh_game.p8
GAME_COMPILER := $(CURDIR)/tools/build_game_cart.py
SHOP_SOURCE := $(CURDIR)/ref/scene_0/slide_4.png
SHOP_LUA := $(CURDIR)/src/shop_art.lua
CHECKOUT_SOURCE := $(CURDIR)/mesh_checkout.p8
CHECKOUT_COMPILER := $(CURDIR)/tools/build_checkout_cart.py
CHECKOUT_ART_SOURCE := $(CURDIR)/ref/scene_0/slide_6.png
CHECKOUT_LUA := $(CURDIR)/src/checkout_art.lua
CODE_CART_COMPILER := $(CURDIR)/tools/build_code_cart.py
DELIVERY_SOURCE := $(CURDIR)/mesh_delivery.p8
SETUP_SOURCE := $(CURDIR)/mesh_setup.p8
CHAT_SOURCE := $(CURDIR)/mesh_chat.p8
RUN_DIR := $(PICO8_CARTS)/mesh-quest-dev
RUN_CART := $(RUN_DIR)/mesh_quest.p8
RUN_GAME_CART := $(RUN_DIR)/mesh_game.p8
RUN_CHECKOUT_CART := $(RUN_DIR)/mesh_checkout.p8
RUN_DELIVERY_CART := $(RUN_DIR)/mesh_delivery.p8
RUN_SETUP_CART := $(RUN_DIR)/mesh_setup.p8
RUN_CHAT_CART := $(RUN_DIR)/mesh_chat.p8
RUN_BUILD_DIR := $(RUN_DIR)/build
BUILD_DIR := $(CURDIR)/build

.PHONY: play play-game web check story story-art story-placeholders music game checkout delivery setup chat stage regen-story

check:
	@test -x "$(PICO8)" || (echo "PICO-8 not found at $(PICO8)" && exit 1)

story:
	@python3 "$(STORY_COMPILER)" "$(STORY_SOURCE)" "$(STORY_OUTPUT)"

story-art:
	@python3 "$(STORY_ART_COMPILER)" "$(STORY_ART_SOURCE)" "$(CART)"

story-placeholders:
	@python3 "$(STORY_PLACEHOLDER_COMPILER)" "$(STORY_PLACEHOLDER_SOURCE)" "$(STORY_PLACEHOLDER_OUTPUT)"

music:
	@python3 "$(MUSIC_COMPILER)" "$(CART)"

game:
	@python3 "$(GAME_COMPILER)" "$(GAME_SOURCE)" "$(CART)" "$(SHOP_SOURCE)" "$(SHOP_LUA)" "$(RUN_GAME_CART)"

checkout:
	@python3 "$(CHECKOUT_COMPILER)" "$(CHECKOUT_SOURCE)" "$(CART)" "$(CHECKOUT_ART_SOURCE)" "$(CHECKOUT_LUA)" "$(RUN_CHECKOUT_CART)"

delivery:
	@python3 "$(CODE_CART_COMPILER)" "$(DELIVERY_SOURCE)" "$(CART)" "$(RUN_DELIVERY_CART)"

setup:
	@python3 "$(CODE_CART_COMPILER)" "$(SETUP_SOURCE)" "$(CART)" "$(RUN_SETUP_CART)"

chat:
	@python3 "$(CODE_CART_COMPILER)" "$(CHAT_SOURCE)" "$(CART)" "$(RUN_CHAT_CART)"

# Explicit only: these targets regenerate narrative data and art in mesh_quest.p8.
regen-story: story story-placeholders story-art

# Normal staging treats the manually saved intro cartridge as immutable.
stage: game checkout delivery setup chat
	@mkdir -p "$(RUN_DIR)/src/scenes"
	@awk '{if ($$0=="#include src/main.lua") print "#include src/dev.lua"; print}' "$(CART)" > "$(RUN_CART)"
	@cp $(CURDIR)/src/*.lua "$(RUN_DIR)/src/"
	@cp $(CURDIR)/src/scenes/*.lua "$(RUN_DIR)/src/scenes/"

play: check stage
	@osascript -e 'tell application id "$(PICO8_BUNDLE_ID)" to quit' >/dev/null 2>&1 || true
	@sleep 0.4
	@open -b "$(PICO8_BUNDLE_ID)" --args -run "$(RUN_CART)"

play-game: check stage
	@osascript -e 'tell application id "$(PICO8_BUNDLE_ID)" to quit' >/dev/null 2>&1 || true
	@sleep 0.4
	@open -b "$(PICO8_BUNDLE_ID)" --args -run "$(RUN_GAME_CART)"

web: check stage
	@mkdir -p "$(RUN_BUILD_DIR)" "$(BUILD_DIR)"
	@cp "$(RUN_GAME_CART)" "$(RUN_BUILD_DIR)/mesh_game.p8"
	@cp "$(RUN_CHECKOUT_CART)" "$(RUN_BUILD_DIR)/mesh_checkout.p8"
	@cp "$(RUN_DELIVERY_CART)" "$(RUN_BUILD_DIR)/mesh_delivery.p8"
	@cp "$(RUN_SETUP_CART)" "$(RUN_BUILD_DIR)/mesh_setup.p8"
	@cp "$(RUN_CHAT_CART)" "$(RUN_BUILD_DIR)/mesh_chat.p8"
	cd "$(RUN_BUILD_DIR)" && "$(PICO8)" "$(RUN_CART)" -export "mesh_quest.html mesh_game.p8 mesh_checkout.p8 mesh_delivery.p8 mesh_setup.p8 mesh_chat.p8"
	@cp "$(RUN_BUILD_DIR)/mesh_quest.html" "$(BUILD_DIR)/mesh_quest.html"
	@cp "$(RUN_BUILD_DIR)/mesh_quest.js" "$(BUILD_DIR)/mesh_quest.js"
	@echo "Web build: $(BUILD_DIR)/mesh_quest.html"
