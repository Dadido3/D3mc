
; ########################################## Konstanten ########################################

#LUA_VERSION_MAJOR    = "5"
#LUA_VERSION_MINOR    = "2"
#LUA_VERSION_NUM      = 502
#LUA_VERSION_RELEASE  = "1"

#LUA_VERSION          = "Lua "+#LUA_VERSION_MAJOR+"."+#LUA_VERSION_MINOR
#LUA_RELEASE          = #LUA_VERSION+"."+#LUA_VERSION_RELEASE
#LUA_COPYRIGHT        = #LUA_RELEASE+"  Copyright (C) 1994-2012 Lua.org, PUC-Rio"
#LUA_AUTHORS          = "R. Ierusalimschy, L. H. de Figueiredo, W. Celes"

; mark For precompiled code ('<esc>Lua')
#LUA_SIGNATURE        = "\033Lua"

; option For multiple returns in 'lua_pcall' And 'lua_call'
#LUA_MULTRET          = -1

; thread status
#LUA_OK               = 0
#LUA_YIELD            = 1
#LUA_ERRRUN           = 2
#LUA_ERRSYNTAX        = 3
#LUA_ERRMEM           = 4
#LUA_ERRGCMM          = 5
#LUA_ERRERR           = 6

; basic types
#LUA_TNONE            = -1

#LUA_TNIL             = 0
#LUA_TBOOLEAN         = 1
#LUA_TLIGHTUSERDATA   = 2
#LUA_TNUMBER          = 3
#LUA_TSTRING          = 4
#LUA_TTABLE           = 5
#LUA_TFUNCTION        = 6
#LUA_TUSERDATA        = 7
#LUA_TTHREAD          = 8

#LUA_NUMTAGS          = 9

; minimum Lua stack available To a C function
#LUA_MINSTACK         = 20

; predefined values in the registry
#LUA_RIDX_MAINTHREAD  = 1
#LUA_RIDX_GLOBALS     = 2
#LUA_RIDX_LAST        = #LUA_RIDX_GLOBALS

; Comparison And arithmetic functions
#LUA_OPADD            = 0	; ORDER TM
#LUA_OPSUB            = 1
#LUA_OPMUL            = 2
#LUA_OPDIV            = 3
#LUA_OPMOD            = 4
#LUA_OPPOW            = 5
#LUA_OPUNM            = 6

#LUA_OPEQ             = 0
#LUA_OPLT             = 1
#LUA_OPLE             = 2

; garbage-collection function And options
#LUA_GCSTOP           = 0
#LUA_GCRESTART        = 1
#LUA_GCCOLLECT        = 2
#LUA_GCCOUNT          = 3
#LUA_GCCOUNTB         = 4
#LUA_GCSTEP           = 5
#LUA_GCSETPAUSE       = 6
#LUA_GCSETSTEPMUL     = 7
#LUA_GCSETMAJORINC    = 8
#LUA_GCISRUNNING      = 9
#LUA_GCGEN            = 10
#LUA_GCINC            = 11

; pseudo-indices
#LUA_REGISTRYINDEX    = (-10000)
#LUA_ENVIRONINDEX     = (-10001)
#LUA_GLOBALSINDEX     = (-10002)

; Event codes
#LUA_HOOKCALL         = 0
#LUA_HOOKRET          = 1
#LUA_HOOKLINE         = 2
#LUA_HOOKCOUNT        = 3
#LUA_HOOKTAILRET      = 4

;  Event masks
#LUA_MASKCALL         = 1 << #LUA_HOOKCALL
#LUA_MASKRET          = 1 << #LUA_HOOKRET
#LUA_MASKLINE         = 1 << #LUA_HOOKLINE
#LUA_MASKCOUNT        = 1 << #LUA_HOOKCOUNT

; ########################################## Variablen ##########################################

; ########################################## Ladekram ############################################

; ########################################## Declares ############################################

Declare   Lua_Do_Function(Function.s, Arguments, Results)

; ########################################## Imports ##########################################

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
    ;#Lua_Import_Prefix = "_"
    ImportC #Library_Path+"lua52.x86.lib" ; Windows x86
  CompilerElse
    ;#Lua_Import_Prefix = ""
    ImportC #Library_Path+"lua52.x64.lib" ; Windows x64
  CompilerEndIf
CompilerElse
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
    ;#Lua_Import_Prefix = ""
    Import "/usr/lib/libm.so"
    EndImport
    Import "/usr/lib/libdl.so"
    EndImport
    ImportC "../../Librarys/lua52.x86.a" ;     Linux x86
  CompilerElse
    ;#Lua_Import_Prefix = ""
    ImportC "../../Librarys/lua52.x64.a" ;     Linux x64
  CompilerEndIf
CompilerEndIf
  
  ; /*
  ; ** state manipulation
  ; */
  lua_newstate    (*f, *ud)
  lua_close       (lua_State.i)
  lua_newthread   (lua_State.i)
  
  lua_atpanic     (lua_State.i, *panicf)
  
  ; /*
  ; ** basic stack manipulation
  ; */
  lua_absindex    (lua_State.i, idx.l)
  lua_gettop      (lua_State.i)
  lua_settop      (lua_State.i, idx.l)
  lua_pushvalue   (lua_State.i, idx.l)
  lua_remove      (lua_State.i, idx.l)
  lua_insert      (lua_State.i, idx.l)
  lua_replace     (lua_State.i, idx.l)
  lua_copy        (lua_State.i, fromidx.l, toidx.l)
  lua_checkstack  (lua_State.i, sz.l)
  
  lua_xmove       (lua_State_from.i, lua_State_to.i, n.l)
  
  ; /*
  ; ** access functions (stack -> C)
  ; */
  
  lua_isnumber    (lua_State.i, idx.l)
  lua_isstring    (lua_State.i, idx.l)
  lua_iscfunction (lua_State.i, idx.l)
  lua_isuserdata  (lua_State.i, idx.l)
  lua_type        (lua_State.i, idx.l)
  lua_typename    (lua_State.i, tp.l)
  
  lua_tonumberx.d (lua_State.i, idx.l, *isnum)
  lua_tointegerx  (lua_State.i, idx.l, *isnum)
  lua_tounsignedx (lua_State.i, idx.l, *isnum)
  lua_toboolean   (lua_State.i, idx.l)
  lua_tolstring   (lua_State.i, idx.l, *len)
  lua_rawlen      (lua_State.i, idx.l)
  lua_tocfunction (lua_State.i, idx.l)
  lua_touserdata  (lua_State.i, idx.l)
  lua_tothread    (lua_State.i, idx.l)
  lua_topointer   (lua_State.i, idx.l)
  
  ; /*
  ; ** Comparison And arithmetic functions
  ; */
  
  lua_arith       (lua_State.i, op.l)
  
  lua_rawequal    (lua_State.i, idx1.l, idx2.l)
  lua_compare     (lua_State.i, idx1.l, idx2.l, op.l)
  
  ; /*
  ; ** push functions (C -> stack)
  ; */
  lua_pushnil           (lua_State.i)
  lua_pushnumber        (lua_State.i, n.d)
  lua_pushinteger       (lua_State.i, n.q)
  lua_pushunsigned      (lua_State.i, n.q)
  lua_pushlstring       (lua_State.i, string.p-ascii, size.i)
  lua_pushstring        (lua_State.i, string.p-ascii)
  ;lua_pushvfstring      (lua_State.i, string.p-ascii, *argp)
  ;lua_pushfstring       (lua_State.i, string.p-ascii, ...)
  lua_pushcclosure      (lua_State.i, *fn, n.l)
  lua_pushboolean       (lua_State.i, b.l)
  lua_pushlightuserdata (lua_State.i, *p)
  lua_pushthread        (lua_State.i)
  
  ; /*
  ; ** get functions (Lua -> stack)
  ; */
  lua_getglobal         (lua_State.i, *string_var) ; Because of a memory leak with .p-ascii
  lua_gettable          (lua_State.i, idx.l)
  lua_getfield          (lua_State.i, idx.l, k.p-ascii)
  lua_rawget            (lua_State.i, idx.l)
  lua_rawgeti           (lua_State.i, idx.l, n.l)
  lua_rawgetp           (lua_State.i, idx.l, p.p-ascii)
  lua_createtable       (lua_State.i, narr.l, nrec.l)
  lua_newuserdata       (lua_State.i, sz.i)
  lua_getmetatable      (lua_State.i, objindex.l)
  lua_getuservalue      (lua_State.i, idx.l)
  
  ; /*
  ; ** set functions (stack -> Lua)
  ; */
  lua_setglobal         (lua_State.i, var.p-ascii)
  lua_settable          (lua_State.i, idx.l)
  lua_setfield          (lua_State.i, idx.l, k.p-ascii)
  lua_rawset            (lua_State.i, idx.l)
  lua_rawseti           (lua_State.i, idx.l, n.l)
  lua_rawsetp           (lua_State.i, idx.l, p.p-ascii)
  lua_setmetatable      (lua_State.i, objindex.l)
  lua_setuservalue      (lua_State.i, idx.l)

  ; /*
  ; ** 'load' And 'call' functions (load And run Lua code)
  ; */
  lua_callk             (lua_State.i, nargs.l, nresults.l, ctx.l, *k)
  lua_getctx            (lua_State.i, *ctx)
  lua_pcallk            (lua_State.i, nargs.l, nresults.l, *errfunc, ctx.l, *k)
  
  lua_load              (lua_State.i, reader.i, *dt, chunkname.p-ascii, mode.p-ascii)
  lua_dump              (lua_State.i, writer.i, *data_)
  
  ; /*
  ; ** coroutine functions
  ; */
  lua_yieldk            (lua_State.i, nresults.l, ctx.l, *k)
  
  lua_resume            (lua_State.i, lua_State_from.i, narg.l)
  lua_status            (lua_State.i)
  
  ; /*
  ; ** garbage-collection function And options
  ; */
  lua_gc                (lua_State.i, what.l, data_.i)
  
  ; /*
  ; ** miscellaneous functions
  ; */
  lua_error             (lua_State.i)
  
  lua_next              (lua_State.i, idx.l)
  
  lua_concat            (lua_State.i, n.l)
  lua_len               (lua_State.i, idx.l)
  
  lua_getallocf         (lua_State.i, *ud)
  lua_setallocf         (lua_State.i, *f, *ud)
  
  ; lualib.h
  luaopen_base          (lua_State.i)
  luaopen_coroutine     (lua_State.i)
  luaopen_table         (lua_State.i)
  luaopen_io            (lua_State.i)
  luaopen_os            (lua_State.i)
  luaopen_string        (lua_State.i)
  luaopen_bit32         (lua_State.i)
  luaopen_math          (lua_State.i)
  luaopen_debug         (lua_State.i)
  luaopen_package       (lua_State.i)
  
  ; open all previous libraries
  luaL_openlibs         (lua_State.i)
  
  ;lauxlib_h
  luaI_openlib          (lua_State.i, libname.p-ascii, *luaL_Reg.l, nup.l)
  luaL_register         (lua_State.i, libname.p-ascii, *luaL_Reg.l)
  luaL_getmetafield     (lua_State.i, obj.l, e.p-ascii)
  luaL_callmeta         (lua_State.i, obj.l, e.p-ascii)
  luaL_typerror         (lua_State.i, narg.l, tname.p-ascii)
  luaL_argerror         (lua_State.i, numarg.l, extramsg.p-ascii)
  luaL_checklstring     (lua_State.i, numarg.l, size.l)
  luaL_optlstring       (lua_State.i, numarg.l, def.p-ascii, size.l)
  luaL_checknumber      (lua_State.i, numarg.l)
  luaL_optnumber        (lua_State.i, narg, LUA_NUMBER.d)
  
  luaL_checkinteger     (lua_State.i, numarg.l)
  luaL_optinteger       (lua_State.i, narg.l, LUA_INTEGER.l)
  
  luaL_checkstack       (lua_State.i, sz.l, msg.p-ascii)
  luaL_checktype        (lua_State.i, narg.l, t.l)
  luaL_checkany         (lua_State.i, narg.l)
  
  luaL_newmetatable     (lua_State.i, tname.p-ascii)
  luaL_checkudata       (lua_State.i, ud.l, tname.p-ascii)
  
  luaL_where            (lua_State.i, lvl.l)
  ;luaL_error            (lua_State.i, const char *fmt, ...)
  
  luaL_checkoption      (lua_State.i, narg.l, def.p-ascii, *string_array.l)
  
  luaL_ref              (lua_State.i, t.l)
  luaL_unref            (lua_State.i, t.l, ref.l)
  
  ;luaL_loadfile         (lua_State.i, filename.p-ascii)
  luaL_loadfilex        (lua_State.i, filename.p-ascii, *mode)

  luaL_loadbuffer       (lua_State.i, buff.l, size.l, name.p-ascii)
  luaL_loadstring       (lua_State.i, string.p-ascii)
  
  luaL_newstate         ()
  
  luaL_gsub             (lua_State.i, s.p-ascii, p.p-ascii, r.p-ascii)
  
  luaL_findtable        (lua_State.i, Index.l, fname.p-ascii)
  
  luaL_buffinit         (lua_State.i, *luaL_Buffer.l)
  luaL_prepbuffer       (*luaL_Buffer.l)
  luaL_addlstring       (*luaL_Buffer.l, s.p-ascii, size.l)
  luaL_addstring        (*luaL_Buffer.l, s.p-ascii)
  luaL_addvalue         (*luaL_Buffer.l)
  luaL_pushresult       (*luaL_Buffer.l)
EndImport

; ########################################## Macros #############################################

Macro lua_call(L, n, r)
  lua_callk((L), (n), (r), 0, #Null)
EndMacro

Macro lua_pcall(L, n, r, f)
  lua_pcallk((L), (n), (r), (f), 0, #Null)
EndMacro

Macro lua_yield(L, n)
  lua_yieldk((L), (n), 0, #Null)
EndMacro

Procedure.d lua_tonumber(L, i)
  Protected Value.d = lua_tonumberx((L), (i), #Null)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows And #PB_Compiler_Processor = #PB_Processor_x64
    EnableASM
    MOVQ Value, XMM0
    DisableASM
  CompilerEndIf
  ProcedureReturn Value
EndProcedure

Macro lua_tointeger(L, i)
  lua_tointegerx((L), (i), #Null)
EndMacro

Macro lua_tounsigned(L, i)
  lua_tounsignedx((L), (i), #Null)
EndMacro

Macro lua_pop(L, n)
  lua_settop((L), -(n)-1)
EndMacro

Macro lua_newtable(L)
  lua_createtable((L), 0, 0)
EndMacro

Macro lua_register(L, n, f)
  lua_pushcfunction((L), (f))
  lua_setglobal((L), n)
EndMacro

Macro lua_pushcfunction(L, f)
  lua_pushcclosure((L), (f), 0)
EndMacro

Macro lua_isfunction(L, n)
  (lua_type((L), (n)) = #LUA_TFUNCTION)
EndMacro

Macro lua_istable(L, n)
  (lua_type((L), (n)) = #LUA_TTABLE)
EndMacro

Macro lua_islightuserdata(L, n)
  (lua_type((L), (n)) = #LUA_TLIGHTUSERDATA)
EndMacro

Macro lua_isnil(L, n)
  (lua_type((L), (n)) = #LUA_TNIL)
EndMacro

Macro lua_isboolean(L, n)
  (lua_type((L), (n)) = #LUA_TBOOLEAN)
EndMacro

Macro lua_isthread(L, n)
  (lua_type((L), (n)) = #LUA_TTHREAD)
EndMacro

Macro lua_isnone(L, n)
  (lua_type((L), (n)) = #LUA_TNONE)
EndMacro

Macro lua_isnoneornil(L, n)
  (lua_type((L), (n)) <= 0)
EndMacro

;#define lua_pushliteral(L, s)	\
;	lua_pushlstring(L, "" s, (SizeOf(s)/SizeOf(char))-1)

;#define lua_pushglobaltable(L)  \
;	lua_rawgeti(L, LUA_REGISTRYINDEX, LUA_RIDX_GLOBALS)

Macro lua_tostring(Result_String, Lua_State, idx)
  *Temp_String = lua_tolstring(Lua_State, idx, #Null)
  If *Temp_String : Result_String = PeekS(*Temp_String, -1, #PB_Ascii) : Else : Result_String = "" : EndIf
EndMacro

Macro luaL_dofile(Lua_State, Filename)
	luaL_loadfile(Lua_State, Filename)
	lua_pcall(Lua_State, 0, #LUA_MULTRET, 0)
EndMacro

Macro luaL_dostring(Lua_State, String)
	luaL_loadstring(Lua_State, String)
	lua_pcall(Lua_State, 0, #LUA_MULTRET, 0)
EndMacro

;Macro lua_setglobal(Lua_State, String) 
;	lua_setfield(Lua_State, #LUA_GLOBALSINDEX, String)
;EndMacro

;Macro lua_getglobal(Lua_State, String)
;	lua_getfield(Lua_State, #LUA_GLOBALSINDEX, String)
;EndMacro

;Macro lua_call(Lua_State, nargs, nresults)
;  lua_callk(Lua_State, nargs, nresults, 0, #Null)
;EndMacro

;Macro lua_pcall(Lua_State, nargs, nresults, lua_errCFunction)
;  lua_pcallk(Lua_State, nargs, nresults, lua_errCFunction, 0, #Null)
;EndMacro

Macro luaL_loadfile(L, f)
  luaL_loadfilex((L),f,#Null)
EndMacro

Macro lua_getglobal_fixed(L, String)
  Protected *String_Buffer = AllocateMemory(StringByteLength(String, #PB_Ascii)+1)
  If *String_Buffer
    PokeS(*String_Buffer, String, -1, #PB_Ascii)
  EndIf
  lua_getglobal(Lua_Main\State, *String_Buffer)
  FreeMemory(*String_Buffer)
EndMacro

; #################################### Initkram #################################################

;-################################## Proceduren in Lua ##########################################

ProcedureC Lua_Func_Entity_Add(Lua_State)
  Protected World_ID = lua_tointeger(Lua_State, 1)
  Protected X.d = lua_tonumber(Lua_State, 2)
  Protected Y.d = lua_tonumber(Lua_State, 3)
  Protected Z.d = lua_tonumber(Lua_State, 4)
  Protected Type = lua_tointeger(Lua_State, 5)
  Protected Name.s : lua_tostring(Name, Lua_State, 6)
  
  Protected *World.World = World_Get_By_ID(World_ID)
  Protected *Entity.Entity = Entity_Add(*World, X, Y, Z, Type, Name)
  
  If *Entity
    lua_pushinteger(Lua_State, *Entity\ID)
  Else
    lua_pushinteger(Lua_State, 0)
  EndIf
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Entity_Delete(Lua_State)
  Protected Entity_ID = lua_tointeger(Lua_State, 1)
  
  Protected *Entity.Entity = Entity_Get_By_ID(Entity_ID)
  Protected Result = Entity_Delete(*Entity)
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Entity_Get_Position(Lua_State)
  Protected Entity_ID = lua_tointeger(Lua_State, 1)
  
  Protected *Entity.Entity = Entity_Get_By_ID(Entity_ID)
  If *Entity
    lua_pushnumber(Lua_State, *Entity\X)
    lua_pushnumber(Lua_State, *Entity\Y)
    lua_pushnumber(Lua_State, *Entity\Z)
    ProcedureReturn 3 ; Anzahl der Rückgabeargumente
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Entity_Get_Velocity(Lua_State)
  Protected Entity_ID = lua_tointeger(Lua_State, 1)
  
  Protected *Entity.Entity = Entity_Get_By_ID(Entity_ID)
  If *Entity
    lua_pushnumber(Lua_State, *Entity\VX)
    lua_pushnumber(Lua_State, *Entity\VY)
    lua_pushnumber(Lua_State, *Entity\VZ)
    ProcedureReturn 3 ; Anzahl der Rückgabeargumente
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Entity_Get_Rotation(Lua_State)
  Protected Entity_ID = lua_tointeger(Lua_State, 1)
  
  Protected *Entity.Entity = Entity_Get_By_ID(Entity_ID)
  If *Entity
    lua_pushnumber(Lua_State, *Entity\Yaw)
    lua_pushnumber(Lua_State, *Entity\Pitch)
    lua_pushnumber(Lua_State, *Entity\Roll)
    ProcedureReturn 3 ; Anzahl der Rückgabeargumente
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Entity_Get_World(Lua_State)
  Protected Entity_ID = lua_tointeger(Lua_State, 1)
  
  Protected *Entity.Entity = Entity_Get_By_ID(Entity_ID)
  If *Entity And *Entity\World
    lua_pushinteger(Lua_State, *Entity\World\ID)
    ProcedureReturn 1 ; Anzahl der Rückgabeargumente
  EndIf
  
  ProcedureReturn 0 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Entity_Set_Position(Lua_State)
  Protected *Entity.Entity = Entity_Get_By_ID(lua_tointeger(Lua_State, 1))
  Protected X.d = lua_tonumber(Lua_State, 2)
  Protected Y.d = lua_tonumber(Lua_State, 3)
  Protected Z.d = lua_tonumber(Lua_State, 4)
  Protected To_Client = lua_tointeger(Lua_State, 5)
  
  Protected Result = Entity_Set_Position(*Entity, X, Y, Z, To_Client)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Entity_Set_Velocity(Lua_State)
  Protected *Entity.Entity = Entity_Get_By_ID(lua_tointeger(Lua_State, 1))
  Protected VX.d = lua_tonumber(Lua_State, 2)
  Protected VY.d = lua_tonumber(Lua_State, 3)
  Protected VZ.d = lua_tonumber(Lua_State, 4)
  Protected Send = lua_tointeger(Lua_State, 5)
  Protected To_Client = lua_tointeger(Lua_State, 6)
  
  Protected Result = Entity_Set_Velocity(*Entity, VX, VY, VZ, Send, To_Client)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Entity_Set_Rotation(Lua_State)
  Protected *Entity.Entity = Entity_Get_By_ID(lua_tointeger(Lua_State, 1))
  Protected Yaw.f = lua_tonumber(Lua_State, 2)
  Protected Pitch.f = lua_tonumber(Lua_State, 3)
  Protected Roll.f = lua_tonumber(Lua_State, 4)
  Protected Send = lua_tointeger(Lua_State, 5)
  Protected To_Client = lua_tointeger(Lua_State, 6)
  
  Protected Result = Entity_Set_Rotation(*Entity, Yaw, Pitch, Roll, Send, To_Client)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Entity_Set_World(Lua_State)
  Protected *Entity.Entity = Entity_Get_By_ID(lua_tointeger(Lua_State, 1))
  Protected *World.World = World_Get_By_ID(lua_tointeger(Lua_State, 2))
  
  Protected Result = Entity_Set_World(*Entity, *World)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

; ####

ProcedureC Lua_Func_Files_File_Get(Lua_State)
  Protected Name.s : lua_tostring(Name.s, Lua_State, 1)
  
  Protected Result.s
  Result = Space(Files_File_Get(Name, 0))
  If Files_File_Get(Name, @Result)
    lua_pushstring(Lua_State, Result)
  Else
    lua_pushnil(Lua_State)
  EndIf
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Files_Folder_Get(Lua_State)
  Protected Name.s : lua_tostring(Name.s, Lua_State, 1)
  
  Protected Result.s
  Result = Space(Files_File_Get(Name, 0))
  If Files_Folder_Get(Name, @Result)
    lua_pushstring(Lua_State, Result)
  Else
    lua_pushnil(Lua_State)
  EndIf
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

; ####

ProcedureC Lua_Func_Log_Add(Lua_State)
  Protected Type.s
  lua_tostring(Type.s, Lua_State, 1)
  Protected Message.s
  lua_tostring(Message.s, Lua_State, 2)
  
  Protected Result = Log_Add(Type, Message, GetFilePart(#PB_Compiler_File), #PB_Compiler_Procedure, #PB_Compiler_Line, #PB_Compiler_Thread)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

; ####

ProcedureC Lua_Func_Lua_Event_Add(Lua_State)
  Protected ID.s : lua_tostring(ID, Lua_State, 1)
  Protected Type.s : lua_tostring(Type, Lua_State, 2)
  Protected Time  = lua_tointeger(Lua_State, 3)
  Protected Function.s : lua_tostring(Function, Lua_State, 4)
  
  Select LCase(Type)
    Case "timer"          : Type_Nr = #Lua_Event_Timer
    Case "client_add"     : Type_Nr = #Lua_Event_Client_Add
    Case "client_delete"  : Type_Nr = #Lua_Event_Client_Delete
    Case "client_login"   : Type_Nr = #Lua_Event_Client_Login
    Case "client_logout"  : Type_Nr = #Lua_Event_Client_Logout
    Default : ProcedureReturn 0 ; Anzahl der Rückgabeargumente
  EndSelect
  
  Protected Result = Lua_Event_Add(ID, Type_Nr, Time, Function)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Lua_Event_Delete(Lua_State)
  Protected ID.s : lua_tostring(ID, Lua_State, 1)
  
  Protected Result = Lua_Event_Delete(ID)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

; ####

ProcedureC Lua_Func_Message_Send_2_Client(Lua_State)
  Protected Client_ID = lua_tointeger(Lua_State, 1)
  Protected Message.s : lua_tostring(Message, Lua_State, 2)
  Protected *Network_Client.Network_Client = Network_Client_Get(Client_ID)
  
  Protected Result = Message_Send_2_Client(*Network_Client, Message)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Message_Send_2_World(Lua_State)
  Protected World_ID = lua_tointeger(Lua_State, 1)
  Protected Message.s : lua_tostring(Message, Lua_State, 2)
  Protected *World.World = World_Get_By_ID(World_ID)
  
  Protected Result = Message_Send_2_World(*World, Message)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_Message_Send_2_All(Lua_State)
  Protected Message.s : lua_tostring(Message, Lua_State, 1)
  
  Protected Result = Message_Send_2_All(Message)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

; ####

ProcedureC Lua_Func_World_Block_Set(Lua_State)
  Protected *World.World = World_Get_By_ID(lua_tointeger(Lua_State, 1))
  Protected X = lua_tointeger(Lua_State, 2)
  Protected Y = lua_tointeger(Lua_State, 3)
  Protected Z = lua_tointeger(Lua_State, 4)
  Protected Type = lua_tointeger(Lua_State, 5)
  Protected Metadata = lua_tointeger(Lua_State, 6)
  Protected BlockLight = lua_tointeger(Lua_State, 7)
  Protected SkyLight = lua_tointeger(Lua_State, 8)
  Protected Playerdata = lua_tointeger(Lua_State, 9)
  Protected Send = lua_tointeger(Lua_State, 10)
  Protected Light = lua_tointeger(Lua_State, 11)
  Protected Physic = lua_tointeger(Lua_State, 12)
  Protected Current_Trigger_Time = lua_tointeger(Lua_State, 13)
  
  Protected Result = World_Block_Set(*World, X, Y, Z, Type, Metadata, BlockLight, SkyLight, Playerdata, Send, Light, Physic, Current_Trigger_Time)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_World_Block_Get(Lua_State)
  Protected *World.World = World_Get_By_ID(lua_tointeger(Lua_State, 1))
  Protected X = lua_tointeger(Lua_State, 2)
  Protected Y = lua_tointeger(Lua_State, 3)
  Protected Z = lua_tointeger(Lua_State, 4)
  Protected Type
  Protected Metadata
  Protected BlockLight
  Protected SkyLight
  Protected Playerdata
  
  Protected Result = World_Block_Get(*World, X, Y, Z, @Type, @Metadata, @BlockLight, @SkyLight, @Playerdata)
  lua_pushinteger(Lua_State, Result)
  lua_pushinteger(Lua_State, Type)
  lua_pushinteger(Lua_State, Metadata)
  lua_pushinteger(Lua_State, BlockLight)
  lua_pushinteger(Lua_State, SkyLight)
  lua_pushinteger(Lua_State, Playerdata)
  
  ProcedureReturn 6 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_World_Effect_Explosion(Lua_State)
  Protected *World.World = World_Get_By_ID(lua_tointeger(Lua_State, 1))
  Protected X.d = lua_tonumber(Lua_State, 2)
  Protected Y.d = lua_tonumber(Lua_State, 3)
  Protected Z.d = lua_tonumber(Lua_State, 4)
  Protected R.f = lua_tonumber(Lua_State, 5)
  
  Protected Result = World_Effect_Explosion(*World, X, Y, Z, R)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_World_Effect_Sound_Or_Particle(Lua_State)
  Protected *World.World = World_Get_By_ID(lua_tointeger(Lua_State, 1))
  Protected Effect_ID = lua_tointeger(Lua_State, 2)
  Protected X = lua_tointeger(Lua_State, 3)
  Protected Y = lua_tointeger(Lua_State, 4)
  Protected Z = lua_tointeger(Lua_State, 5)
  Protected Data_ = lua_tointeger(Lua_State, 6)
  
  Protected Result = World_Effect_Sound_Or_Particle(*World, Effect_ID, X, Y, Z, Data_)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_World_Effect_Sound(Lua_State)
  Protected *World.World = World_Get_By_ID(lua_tointeger(Lua_State, 1))
  Protected Sound_Name.s : lua_tostring(Sound_Name, Lua_State, 2)
  Protected X.d = lua_tonumber(Lua_State, 3)
  Protected Y.d = lua_tonumber(Lua_State, 4)
  Protected Z.d = lua_tonumber(Lua_State, 5)
  Protected Volume.f = lua_tonumber(Lua_State, 6)
  Protected Pitch.f = lua_tonumber(Lua_State, 7)
  
  Protected Result = World_Effect_Sound(*World, Sound_Name, X, Y, Z, Volume, Pitch)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_World_Effect_Action(Lua_State)
  Protected *World.World = World_Get_By_ID(lua_tointeger(Lua_State, 1))
  Protected X = lua_tointeger(Lua_State, 2)
  Protected Y = lua_tointeger(Lua_State, 3)
  Protected Z = lua_tointeger(Lua_State, 4)
  Protected Byte_1 = lua_tointeger(Lua_State, 5)
  Protected Byte_2 = lua_tointeger(Lua_State, 6)
  Protected Block_Type = lua_tointeger(Lua_State, 7)
  
  Protected Result = World_Effect_Action(*World, X, Y, Z, Byte_1, Byte_2, Block_Type)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

ProcedureC Lua_Func_World_Physic_Queue_Add(Lua_State)
  Protected *World.World = World_Get_By_ID(lua_tointeger(Lua_State, 1))
  Protected X = lua_tointeger(Lua_State, 2)
  Protected Y = lua_tointeger(Lua_State, 3)
  Protected Z = lua_tointeger(Lua_State, 4)
  Protected Trigger_Time = lua_tointeger(Lua_State, 5)
  Protected Trigger_Type = lua_tointeger(Lua_State, 6)
  Protected *World_Column.World_Column = World_Column_Get(*World, World_Get_Column_X(X), World_Get_Column_Y(Y))
  
  Protected Result = World_Physic_Queue_Add(*World, X, Y, Z, *World_Column, Trigger_Time, Trigger_Type)
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

; ####

ProcedureC Lua_Func_Network_Client_Entity_Get(Lua_State)
  Protected Network_Client_ID = lua_tointeger(Lua_State, 1)
  Protected Result = 0
  
  Protected *Network_Client.Network_Client = Network_Client_Get(Network_Client_ID)
  If *Network_Client\Entity
    Result = *Network_Client\Entity\ID
  EndIf
  
  lua_pushinteger(Lua_State, Result)
  
  ProcedureReturn 1 ; Anzahl der Rückgabeargumente
EndProcedure

; ####

;-########################################## Event-Proceduren ####################################

Procedure Lua_Do_Func_Event_Timer(Function_Name.s)
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  If Not Lua_Do_Function(Function_Name, 0, 0)
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Lua_Do_Func_Event_Client_Add(Function_Name.s, Client_ID)
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  lua_pushinteger(Lua_Main\State, Client_ID)
  If Not Lua_Do_Function(Function_Name, 1, 0)
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Lua_Do_Func_Event_Client_Delete(Function_Name.s, Client_ID)
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  lua_pushinteger(Lua_Main\State, Client_ID)
  If Not Lua_Do_Function(Function_Name, 1, 0)
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Lua_Do_Func_Event_Client_Login(Function_Name.s, Client_ID, Name.s)
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  lua_pushinteger(Lua_Main\State, Client_ID)
  lua_pushstring(Lua_Main\State, Name)
  If Not Lua_Do_Function(Function_Name, 2, 0)
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Lua_Do_Func_Event_Client_Logout(Function_Name.s, Client_ID, Name.s)
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  lua_pushinteger(Lua_Main\State, Client_ID)
  lua_pushstring(Lua_Main\State, Name)
  If Not Lua_Do_Function(Function_Name, 2, 0)
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Lua_Do_Func_Event_Column_Fill(Function_Name.s, World_ID, Column_X, Column_Y, Seed, Generation_State)
  Protected Result
  
  If Not Lua_Main\State
    ProcedureReturn 0
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  lua_pushinteger(Lua_Main\State, World_ID)
  lua_pushinteger(Lua_Main\State, Column_X)
  lua_pushinteger(Lua_Main\State, Column_Y)
  lua_pushinteger(Lua_Main\State, Seed)
  lua_pushinteger(Lua_Main\State, Generation_State)
  If Not Lua_Do_Function(Function_Name, 5, 1)
    ProcedureReturn 0
  EndIf
  Result = lua_tointeger(Lua_Main\State, -1)
  lua_pop(Lua_Main\State, 1)
  
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Func_Event_Physic(Function_Name.s, World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
  Protected Result
  
  If Not Lua_Main\State
    ProcedureReturn 0
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  lua_pushinteger(Lua_Main\State, World_ID)
  lua_pushinteger(Lua_Main\State, X)
  lua_pushinteger(Lua_Main\State, Y)
  lua_pushinteger(Lua_Main\State, Z)
  lua_pushinteger(Lua_Main\State, Type)
  lua_pushinteger(Lua_Main\State, Metadata)
  lua_pushinteger(Lua_Main\State, Current_Trigger_Time)
  If Not Lua_Do_Function(Function_Name, 7, 1)
    ProcedureReturn 0
  EndIf
  Result = lua_tointeger(Lua_Main\State, -1)
  lua_pop(Lua_Main\State, 1)
  
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Func_Event_Block_Rightclick(Function_Name.s, Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
  Protected Result
  
  If Not Lua_Main\State
    ProcedureReturn 0
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  lua_pushinteger(Lua_Main\State, Network_Client_ID)
  lua_pushinteger(Lua_Main\State, World_ID)
  lua_pushinteger(Lua_Main\State, X)
  lua_pushinteger(Lua_Main\State, Y)
  lua_pushinteger(Lua_Main\State, Z)
  lua_pushinteger(Lua_Main\State, Direction)
  lua_pushinteger(Lua_Main\State, Cursor_X)
  lua_pushinteger(Lua_Main\State, Cursor_Y)
  lua_pushinteger(Lua_Main\State, Cursor_Z)
  lua_pushinteger(Lua_Main\State, Type)
  lua_pushinteger(Lua_Main\State, Metadata)
  If Not Lua_Do_Function(Function_Name, 11, 1)
    ProcedureReturn 0
  EndIf
  Result = lua_tointeger(Lua_Main\State, -1)
  lua_pop(Lua_Main\State, 1)
  
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Func_Event_Block_Leftclick(Function_Name.s, Network_Client_ID, World_ID, X, Y, Z, Face, State, Type, Metadata)
  Protected Result
  
  If Not Lua_Main\State
    ProcedureReturn 0
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  lua_pushinteger(Lua_Main\State, Network_Client_ID)
  lua_pushinteger(Lua_Main\State, World_ID)
  lua_pushinteger(Lua_Main\State, X)
  lua_pushinteger(Lua_Main\State, Y)
  lua_pushinteger(Lua_Main\State, Z)
  lua_pushinteger(Lua_Main\State, Face)
  lua_pushinteger(Lua_Main\State, State)
  lua_pushinteger(Lua_Main\State, Type)
  lua_pushinteger(Lua_Main\State, Metadata)
  If Not Lua_Do_Function(Function_Name, 9, 1)
    ProcedureReturn 0
  EndIf
  Result = lua_tointeger(Lua_Main\State, -1)
  lua_pop(Lua_Main\State, 1)
  
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Func_Event_Entity(Function_Name.s, Entity_ID)
  Protected Result
  
  If Not Lua_Main\State
    ProcedureReturn 0
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  lua_pushinteger(Lua_Main\State, Entity_ID)
  If Not Lua_Do_Function(Function_Name, 1, 1)
    ProcedureReturn 0
  EndIf
  Result = lua_tointeger(Lua_Main\State, -1)
  lua_pop(Lua_Main\State, 1)
  
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Func_Event_Item_Place(Function_Name.s, Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
  Protected Result
  
  If Not Lua_Main\State
    ProcedureReturn 0
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  lua_pushinteger(Lua_Main\State, Network_Client_ID)
  lua_pushinteger(Lua_Main\State, World_ID)
  lua_pushinteger(Lua_Main\State, X)
  lua_pushinteger(Lua_Main\State, Y)
  lua_pushinteger(Lua_Main\State, Z)
  lua_pushinteger(Lua_Main\State, Direction)
  lua_pushinteger(Lua_Main\State, Cursor_X)
  lua_pushinteger(Lua_Main\State, Cursor_Y)
  lua_pushinteger(Lua_Main\State, Cursor_Z)
  lua_pushinteger(Lua_Main\State, Type)
  lua_pushinteger(Lua_Main\State, Metadata)
  If Not Lua_Do_Function(Function_Name, 11, 1)
    ProcedureReturn 0
  EndIf
  Result = lua_tointeger(Lua_Main\State, -1)
  lua_pop(Lua_Main\State, 1)
  
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Func_Event_Item_Dig(Function_Name.s, Network_Client_ID, World_ID, X, Y, Z, Face, State, Type, Metadata)
  Protected Result
  
  If Not Lua_Main\State
    ProcedureReturn 0
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Function_Name)
  lua_pushinteger(Lua_Main\State, Network_Client_ID)
  lua_pushinteger(Lua_Main\State, World_ID)
  lua_pushinteger(Lua_Main\State, X)
  lua_pushinteger(Lua_Main\State, Y)
  lua_pushinteger(Lua_Main\State, Z)
  lua_pushinteger(Lua_Main\State, Face)
  lua_pushinteger(Lua_Main\State, State)
  lua_pushinteger(Lua_Main\State, Type)
  lua_pushinteger(Lua_Main\State, Metadata)
  If Not Lua_Do_Function(Function_Name, 9, 1)
    ProcedureReturn 0
  EndIf
  Result = lua_tointeger(Lua_Main\State, -1)
  lua_pop(Lua_Main\State, 1)
  
  ProcedureReturn Result
EndProcedure

;-########################################## Proceduren ##########################################

Procedure Lua_Register_All()
  lua_register(Lua_Main\State, "Entity_Add", @Lua_Func_Entity_Add())
  lua_register(Lua_Main\State, "Entity_Delete", @Lua_Func_Entity_Delete())
  lua_register(Lua_Main\State, "Entity_Get_Position", @Lua_Func_Entity_Get_Position())
  lua_register(Lua_Main\State, "Entity_Get_Velocity", @Lua_Func_Entity_Get_Velocity())
  lua_register(Lua_Main\State, "Entity_Get_Rotation", @Lua_Func_Entity_Get_Rotation())
  lua_register(Lua_Main\State, "Entity_Get_World", @Lua_Func_Entity_Get_World())
  lua_register(Lua_Main\State, "Entity_Set_Position", @Lua_Func_Entity_Set_Position())
  lua_register(Lua_Main\State, "Entity_Set_Velocity", @Lua_Func_Entity_Set_Velocity())
  lua_register(Lua_Main\State, "Entity_Set_Rotation", @Lua_Func_Entity_Set_Rotation())
  lua_register(Lua_Main\State, "Entity_Set_World", @Lua_Func_Entity_Set_World())
  
  lua_register(Lua_Main\State, "Files_File_Get", @Lua_Func_Files_File_Get())
  lua_register(Lua_Main\State, "Files_Folder_Get", @Lua_Func_Files_Folder_Get())
  
  lua_register(Lua_Main\State, "Log_Add", @Lua_Func_Log_Add())
  
  lua_register(Lua_Main\State, "Lua_Event_Add", @Lua_Func_Lua_Event_Add())
  lua_register(Lua_Main\State, "Lua_Event_Delete", @Lua_Func_Lua_Event_Delete())
  
  lua_register(Lua_Main\State, "Message_Send_2_Client", @Lua_Func_Message_Send_2_Client())
  lua_register(Lua_Main\State, "Message_Send_2_World", @Lua_Func_Message_Send_2_World())
  lua_register(Lua_Main\State, "Message_Send_2_All", @Lua_Func_Message_Send_2_All())
  
  lua_register(Lua_Main\State, "Network_Client_Entity_Get", @Lua_Func_Network_Client_Entity_Get())
  
  lua_register(Lua_Main\State, "World_Block_Set", @Lua_Func_World_Block_Set())
  lua_register(Lua_Main\State, "World_Block_Get", @Lua_Func_World_Block_Get())
  lua_register(Lua_Main\State, "World_Effect_Explosion", @Lua_Func_World_Effect_Explosion())
  lua_register(Lua_Main\State, "World_Effect_Sound_Or_Particle", @Lua_Func_World_Effect_Sound_Or_Particle())
  lua_register(Lua_Main\State, "World_Effect_Sound", @Lua_Func_World_Effect_Sound())
  lua_register(Lua_Main\State, "World_Effect_Action", @Lua_Func_World_Effect_Action())
  lua_register(Lua_Main\State, "World_Physic_Queue_Add", @Lua_Func_World_Physic_Queue_Add())
EndProcedure

Procedure Lua_Init()
  Lua_Main\State = luaL_newstate()
  
  If Not Lua_Main\State
    Log_Add_Info("Lua not loaded")
    ProcedureReturn #Result_Fail
  EndIf
  
  ;luaopen_base(Lua_Main\State)
  ;luaopen_table(Lua_Main\State)
  
  ;luaopen_base          (Lua_Main\State)
  ;luaopen_coroutine     (Lua_Main\State)
  ;luaopen_table         (Lua_Main\State)
  ;luaopen_io            (Lua_Main\State)
  ;luaopen_os            (Lua_Main\State)
  ;luaopen_string        (Lua_Main\State)
  ;luaopen_bit32         (Lua_Main\State)
  ;luaopen_math          (Lua_Main\State)
  ;luaopen_debug         (Lua_Main\State)
  ;luaopen_package       (Lua_Main\State)
  
  ;luaL_openlibs(Lua_Main\State)
  
	lua_pushcclosure(Lua_Main\State, @luaL_openlibs(), 0)
  lua_call(Lua_Main\State, 0, 0)
  
	;luaopen_os(Lua_Main\State)
	;luaopen_string(Lua_Main\State)
	;luaopen_math(Lua_Main\State)
	;luaopen_debug(Lua_Main\State)
	;luaopen_package(Lua_Main\State)
	;lua_pushcclosure(Lua_Main\State, @luaopen_package(), 0)
  ;lua_call(Lua_Main\State, 0, 0)
  
  Lua_Register_All()
  
  Log_Add_Info("Lua loaded")
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Lua_SetVariable_String(Name.s, String.s)
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
	lua_pushstring(Lua_Main\State, String)
	lua_setglobal(Lua_Main\State, Name)
	
	ProcedureReturn #Result_Success
EndProcedure 

Procedure Lua_SetVariable_Integer(Name.s, Value)
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
	lua_pushinteger(Lua_Main\State, Value)
	lua_setglobal(Lua_Main\State, Name)
	
	ProcedureReturn #Result_Success
EndProcedure

Procedure.s Lua_GetVariable_String(Name.s)
  Protected Result.s = ""
  
  If Not Lua_Main\State
    ProcedureReturn ""
  EndIf
  
	lua_getglobal_fixed(Lua_Main\State, Name)
	lua_tostring(Result, Lua_Main\State, -1)
	lua_pop(Lua_Main\State, 1)
	
	ProcedureReturn Result
EndProcedure

Procedure Lua_GetVariable_Integer(Name.s)
  Protected Result
  
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
  lua_getglobal_fixed(Lua_Main\State, Name)
  Result = lua_tointeger(Lua_Main\State, -1)
  Lua_pop(Lua_Main\State, 1)
  
  ProcedureReturn Result
EndProcedure

Procedure Lua_Do_Function(Function.s, Arguments, Results)
  Protected Error_Message.s
  
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
  Result = lua_pcall(Lua_Main\State, Arguments, Results, 0)
  
  If Result
    lua_tostring(Error_Message, Lua_Main\State, -1)
    Select Result
      Case #LUA_ERRRUN : Log_Add_Warn("Runtimeerror in "+Function+" ("+Error_Message+")")
      Case #LUA_ERRMEM : Log_Add_Warn("Memoryallocationerror in "+Function+" ("+Error_Message+")")
      Case #LUA_ERRERR : Log_Add_Warn("Error in "+Function+" ("+Error_Message+")")
      Default          : Log_Add_Warn("Undefined Error in "+Function+" ("+Error_Message+")")
    EndSelect
    lua_pop(Lua_Main\State, 1)
    ProcedureReturn #Result_Fail
  EndIf
  
  ; #### The caller needs to pop the Results from the stack
  ProcedureReturn #Result_Success
EndProcedure

Procedure Lua_Do_String(String.s)
  Protected Error_Message.s
  
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
  luaL_loadstring(Lua_Main\State, String)
  ;Result = lua_pcall(Lua_Main\State, 0, #LUA_MULTRET, 0)
  Result = lua_pcall(Lua_Main\State, 0, 0, 0)
  
  If Result
    lua_tostring(Error_Message, Lua_Main\State, -1)
    Select Result
      Case #LUA_ERRRUN : Log_Add_Warn("Runtimeerror with '"+String+"' ("+Error_Message+")")
      Case #LUA_ERRMEM : Log_Add_Warn("Memoryallocationerror with '"+String+"' ("+Error_Message+")")
      Case #LUA_ERRERR : Log_Add_Warn("Error with '"+String+"' ("+Error_Message+")")
      Default          : Log_Add_Warn("Undefined Error with '"+String+"' ("+Error_Message+")")
    EndSelect
    lua_pop(Lua_Main\State, 1)
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Lua_Do_File(Filename.s)
  Protected Error_Message.s
  
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
  luaL_loadfile(Lua_Main\State, Filename)
  ;Result = lua_pcall(Lua_Main\State, 0, #LUA_MULTRET, 0)
  Result = lua_pcall(Lua_Main\State, 0, 0, 0)
  
  If Result
    lua_tostring(Error_Message, Lua_Main\State, -1)
    Select Result
      Case #LUA_ERRRUN : Log_Add_Warn("Runtimeerror in "+Filename+" ("+Error_Message+")")
      Case #LUA_ERRMEM : Log_Add_Warn("Memoryallocationerror in "+Filename+" ("+Error_Message+")")
      Case #LUA_ERRERR : Log_Add_Warn("Error in "+Filename+" ("+Error_Message+")")
      Default          : Log_Add_Warn("Undefined Error in "+Filename+" ("+Error_Message+")")
    EndSelect
    lua_pop(Lua_Main\State, 1)
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure
; IDE Options = PureBasic 4.60 RC 2 (Windows - x64)
; CursorPosition = 202
; FirstLine = 189
; Folding = ------------
; EnableXP