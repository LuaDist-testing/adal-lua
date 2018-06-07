-- This file was automatically generated for the LuaDist project.

package = "adal-lua"
version = "0.0.2-1"
-- LuaDist source
source = {
  tag = "0.0.2-1",
  url = "git://github.com/LuaDist-testing/adal-lua.git"
}
-- Original source
-- source = {
--    url = "git://github.com/alexeldeib/adal-lua.git",
--    tag = "v0.0.2"
-- }
description = {
   license = "MIT"
}
dependencies = {
    "lua-requests >= 1.1",
    "lua-cjson >= 1.0",
    "lbase64 >= 20120820",
    "luacrypto >= 0.3.2"
}
build = {
   type = "builtin",
   modules = {
      adal = "adal.lua",
      hex = "hex.lua",
      utils = "utils.lua"
   }
}