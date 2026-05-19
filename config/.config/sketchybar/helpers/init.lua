-- Add the sketchybar module to the package cpath
--
local config_dir = os.getenv("CONFIG_DIR")
local user_name = os.getenv("USER")

package.cpath = package.cpath .. ";/Users/" .. user_name .. "/.local/share/sketchybar_lua/?.so"

os.execute("(cd helpers && make)")
