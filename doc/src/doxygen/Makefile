.PHONY: all
.SUFFIXES: .lua .lua.cpp

# ######################################## #

# ntopng root
ROOT_DIR=../../..
# ntopng Lua modules dir
MODULES_DIR=$(ROOT_DIR)/scripts/lua/modules/
# Lua API doc directory
LUA_API_DIR=../api/

# Automatic rules for Lua C API
DOC_SOURCES = $(shell find ../api/lua_c/ -type f -name *.lua)
TARGETS = $(DOC_SOURCES:.lua=.lua.cpp)

# Specific rule for Lua API to document
# NOTE: doxygen finds the files via the INPUT directive in the Doxyfile
TARGETS += $(LUA_API_DIR)/timeseries/ts_utils.lua.cpp
TARGETS += $(LUA_API_DIR)/timeseries/driver.lua.cpp
TARGETS += $(LUA_API_DIR)/recording/recording_utils.lua.cpp
TARGETS += $(LUA_API_DIR)/alerts/alerts_api.lua.cpp

# ######################################## #

all: $(TARGETS)
	#grep "//Lua" ../../../src/Lua.cpp | sed -e 's/^[[:space:]]*\/\/Lua //' > api.lua.cpp
	doxygen Doxyfile

%.lua.cpp : %.lua
	./lua2dox $< > $@

clean:
	rm -rf html xml
	rm -f DoxygenLayout.xml
	rm -f *.tmp

# ######################################## #

# Specific rule for Lua API to document
$(LUA_API_DIR)/timeseries/ts_utils.lua.cpp : ${MODULES_DIR}/timeseries/ts_utils_core.lua
	./lua2dox $< > $@

$(LUA_API_DIR)/timeseries/driver.lua.cpp : ${MODULES_DIR}/timeseries/drivers/sample.lua
	./lua2dox $< > $@

$(LUA_API_DIR)/recording/recording_utils.lua.cpp : ${MODULES_DIR}/recording_utils.lua
	./lua2dox $< > $@

$(LUA_API_DIR)/alerts/alerts_api.lua.cpp : ${MODULES_DIR}/alerts_api.lua
	./lua2dox $< > $@
