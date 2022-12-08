#ifndef IMPISH_DEATH_TECH_NCLASSIC_H 
#define IMPISH_DEATH_TECH_NCLASSIC_H
    #endif
    #define NCLASSIC_BADARGUMENT "bad argument #%d to '%s' (%s expected, got %s)"
    #define NCLASSIC_VERSION "1.2.1"
    #define NCLASSIC_LUA static const char*
    #define NCLASSIC_CALLBACK static int
    #if defined(__cplusplus)
        #include <lua.hpp>
        #define NCLASSIC_CAPI extern "C"
        
        NCLASSIC_CAPI int luaopen_nclassic(lua_State* L);
    #else
        #include <lua.h>
        #include <lualib.h>
        #include <lauxlib.h>
        
        int luaopen_nclassic(lua_State* L);
#endif