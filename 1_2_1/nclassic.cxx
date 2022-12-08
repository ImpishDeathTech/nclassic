
/*
 * nclassic.cxx
 * 
 * MIT License
 * 
 * Copyright (c) 2022 Christopher Stephen Rafuse, ImpishDeathTech
 * Copyright (c) 2014, rxi (https://github.com/rxi/classic)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "nclassic.h"
#include <string>

/**
 * A stripped down version of classic's code with added 'fields' method
 */
NCLASSIC_LUA NCLASSIC_OBJECT = {
R"_lua_(
local o = {}
o.__index = o
o.__name  = "class"
function o:new()
end
function o:delete()
end
function o:fields(...)
  for _, cls in pairs({...}) do
    for k, v in pairs(cls) do
      if type(v) ~= "function" then
        self[k] = v
      end
    end
  end
end
function o:implement(...)
  for _, cls in pairs({...}) do
    for k, v in pairs(cls) do
      if self[k] == nil and type(v) == "function" then
        self[k] = v
      end
    end
  end
end
function o:__call(...)
  local obj = setmetatable({}, self)
  obj:new(...)
  return obj
end
function o:__gc()
  self:delete()
end
return o
)_lua_" };

/**
 * Extend a class into a new class
 *
 * @param class is the class table to extend
 * @param name is the typename of the class
 *
 * \a class.extends(class)      -> class
 * \b class.extends(class,name) -> class
 */
NCLASSIC_LUA NCLASSIC_EXTENDS = {
R"_lua_(
return function (target, name)
  local cls = {}
  for k, v in pairs(target) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.__name  = name or target.__name
  cls.super   = target
  setmetatable(cls, target)
  return cls
end
)_lua_" };

/**
 * Compares two classes to see if one is derived from the other
 *
 * @param class is the base class to compare
 * @param target is the target class to compare
 *
 * \a class.is(target,class) -> boolean
 */
NCLASSIC_LUA NCLASSIC_IS = {
R"_lua_(
return function (target, cls)
  local mt = getmetatable(target)
  
  while mt do
    local eq  = mt.__eq
    local ceq = cls.__eq
    
    mt.__eq  = nil
    cls.__eq = nil
    if mt == cls then
      cls.__eq = ceq
      mt.__eq  = eq
      return true
    end
  
    mt.__eq  = eq
    cls.__eq = ceq
    mt = getmetatable(mt)
  
  end
  
  return false
end
)_lua_" };

/**
 * Compares two classes to see if they are equal
 *
 * @param cls is the base class to compare
 * @param target is the target class to compare
 *
 * \a class.equals(class,target) -> boolean
 */
NCLASSIC_LUA NCLASSIC_EQUALS = {
R"_lua_(
return function (cls, target) 
  local retVal = true
  for k, v in pairs(target) do
    if (cls[k] == nil) or (cls[k] ~= v) then
      retVal = false
      break
    end
  end
  return retVal
end
)_lua_"};

/**
 * Define a class locally
 * @param name is the typename of the class to be defined
 * 
 * @returns an object table with the typename 'name'
 * \a class.object 'name' -> class
 * \b class.object(name)  -> class
 */
NCLASSIC_CALLBACK nclassic_object(lua_State* L) {
    if (lua_gettop(L) == 1) {
        if (lua_isstring(L, 1)) {
            std::string name = lua_tostring(L, 1);
            lua_pop(L, 1);
            lua_getglobal(L, "class");
            lua_getfield(L, -1, "extends");

            luaL_dostring(L, NCLASSIC_OBJECT);
            lua_pushlstring(L, name.c_str(), name.length());
            lua_call(L, 2, 1);
            lua_gc(L, LUA_GCCOLLECT);
            return 1;
        }
        else {
            std::string type = lua_typename(L, lua_type(L, -1));
            lua_settop(L, 0);
            return luaL_error(L, NCLASSIC_BADARGUMENT, 1, "object", "string", type.c_str());
        }
    }
    else if (lua_gettop(L) == 2) {
        if (lua_isstring(L, -2)) {
            std::string name = lua_tostring(L, -2);
            lua_pop(L, -2);

            if (lua_istable(L, -1)) {
                luaL_dostring(L, NCLASSIC_OBJECT);
                lua_setmetatable(L, -2);
                lua_pushlstring(L, name.c_str(), name.length());
                lua_setfield(L, -2, "__name");
                lua_gc(L, LUA_GCCOLLECT);
                return 1;
            }
            else {
                std::string type = lua_typename(L, lua_type(L, -1));
                lua_settop(L, 0);
                return luaL_error(L, NCLASSIC_BADARGUMENT, 2, "object", "table", type.c_str());
            }
        }
        else {
            std::string type = lua_typename(L, lua_type(L, -2));
            lua_settop(L, 0);
            return luaL_error(L, NCLASSIC_BADARGUMENT, 1, "object", "string", type.c_str());
        }
    }
    else {
        lua_settop(L, 0);
        return luaL_error(L, NCLASSIC_BADARGUMENT, 1, "object", "string", "no value");
    }
    return 0;
}

/**
 * Defines a class globally
 * @param name is the string value name of the class
 *
 * \a class 'name'
 * \b class(name)
 */
NCLASSIC_CALLBACK nclassic_classdef(lua_State* L) {
    if (lua_gettop(L) == 2) {
        if (lua_isstring(L, -1)) {
            std::string name = lua_tostring(L, -1);
            lua_settop(L, 0);
            lua_pushlstring(L, name.c_str(), name.length());
            nclassic_object(L);
            lua_setglobal(L, name.c_str());
            lua_settop(L, 0);
            return 0;
        }
        else {
            std::string type = lua_typename(L, lua_type(L, -1));
            lua_settop(L, 0);
            return luaL_error(L, NCLASSIC_BADARGUMENT, 1, "__call", "string", type.c_str());
        }
    }
    else {
        lua_settop(L, 0);
        return luaL_error(L, NCLASSIC_BADARGUMENT, 1, "__call", "string", "no value");
    }

    return 0;
}
/**
 *  Get the typename of a value
 *
 * @param value is the value to be typechecked
 *
 * @returns __name or the type of the value
 *
 * \a typename(value) -> string
 */
NCLASSIC_CALLBACK nclassic_typename(lua_State* L) {
    if (lua_istable(L, -1)) {
        luaL_getmetafield(L, -1, "__name");
        if (!lua_isnil(L, -1) && lua_isstring(L, -1)) {
            std::string type = lua_tostring(L, -1);
            lua_settop(L, 0);
            lua_pushlstring(L, type.c_str(), type.length());
        }
        else {
          lua_settop(L, 0);
          lua_pushstring(L, "table");
        }
    }
    else {
        std::string type = lua_typename(L, lua_type(L, -1));
        lua_settop(L, 0);
        lua_pushlstring(L, type.c_str(), type.length());
    }
    return 1;
}

NCLASSIC_CAPI 
int luaopen_nclassic(lua_State* L) {
    lua_pushcfunction(L, nclassic_typename);
    lua_setglobal(L, "typename");

    lua_newtable(L);
    lua_pushcfunction(L, nclassic_object);
    lua_setfield(L, -2, "object");
    luaL_dostring(L, NCLASSIC_EXTENDS);
    lua_setfield(L, -2, "extends");
    luaL_dostring(L, NCLASSIC_IS);
    lua_setfield(L, -2, "is");
    luaL_dostring(L, NCLASSIC_EQUALS);
    lua_setfield(L, -2, "equals");
    
    lua_newtable(L);
    lua_pushcfunction(L, nclassic_classdef);
    lua_setfield(L, -2, "__call");
    lua_pushstring(L, "class");
    lua_setfield(L, -2, "__name");
    lua_setmetatable(L, -2);
    lua_setglobal(L, "class");

    lua_pushstring(L, NCLASSIC_VERSION);
    lua_setglobal(L, "_CLASSVER");
    lua_settop(L, 0);
    lua_gc(L, LUA_GCCOLLECT);
    return 0;
}

