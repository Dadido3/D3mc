; ################################################### Documentation #########################################
; 
; Todo:
;  - 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; ################################################### Includes ##############################################

IncludePath "../../"
XIncludeFile "Plugins/SDK/Include.pbi"

; ################################################### Inits #################################################

; ################################################### Konstants #############################################

#Plugin_Name = "Lua"
#Plugin_Author = "David Vogel"

#Library_Path = "../../Libraries/"

Enumeration 0
  #Lua_Event_Timer
  
  #Lua_Event_Client_Add
  #Lua_Event_Client_Delete
  #Lua_Event_Client_Login
  #Lua_Event_Client_Logout
EndEnumeration

; ################################################### Structures ############################################

Structure Lua_Main
  State.i                     ; Lua-State von luaL_NewState()
EndStructure

Structure Lua_File
  Filename.s
  File_Date_Last.i            ; Datum letzter Änderung
EndStructure

Structure Lua_Event
  ID.s                ; Event-ID
  Type.a              ; Event Type
  Time.i              ; Time for the Timer event
  Timer.i             ; Timer
  Realtime.i          ; If the timer is realtime
  Max_Iterations.i    ; Max. Iterations
  
  Function.s          ; Function-Name
EndStructure

; ################################################### Variables #############################################

Procedure Declare_Variables()
  Global Lua_Main.Lua_Main
  Global NewList Lua_File.Lua_File()
  Global NewList Lua_Event.Lua_Event()
EndProcedure

; ################################################### Declares ##############################################

Declare   Timer()

Declare   Lua_Event_Delete(ID.s)
Declare   Lua_Event_Add(ID.s, Type, Time, Function.s)

; ################################################### Includes ##############################################

IncludePath ""
XIncludeFile "Lua.pbi"

; ################################################### Prototypes ############################################

; ################################################### Procedures ############################################

ProcedureCDLL Init(*Plugin_Info.Plugin_Info, *Plugin_Function.Plugin_Function) ; Aufgerufen beim Laden der Library / Called with the loading of the library
  *Plugin_Info\Name = #Plugin_Name
  *Plugin_Info\Version = #Plugin_Version
  *Plugin_Info\Author = #Plugin_Author
  
  Define_Prototypes(*Plugin_Function)
  
  Declare_Variables()
  
  If Not Timer_Register("Plugin:Lua", 0, 1000, @Timer())
    Log_Add_Error("Timer_Register")
    ProcedureReturn #Result_Fail
  EndIf
  
  OpenConsole()
  
  ProcedureReturn Lua_Init()
EndProcedure

ProcedureCDLL Deinit() ; Aufgerufen beim Entladen der Library / Called with the unloading of the library
  
  Timer_Unregister("Plugin:Lua")
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Lua_Event_Delete(ID.s)
  ForEach Lua_Event()
    If Lua_Event()\ID = ID
      DeleteElement(Lua_Event())
      ProcedureReturn #Result_Success
    EndIf
  Next
  
  ProcedureReturn #Result_Fail
EndProcedure

Procedure Lua_Event_Add(ID.s, Type, Time, Function.s)
  Lua_Event_Delete(ID)
  
  If Not AddElement(Lua_Event())
    ProcedureReturn #Result_Fail
  EndIf
  
  Lua_Event()\ID = ID
  Lua_Event()\Type = Type
  Lua_Event()\Time = Time
  Lua_Event()\Function = Function
  Lua_Event()\Max_Iterations = 20
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Check_New_Files(Directory.s)
  
  If Right(Directory, 1) = "/" Or Right(Directory, 1) = "\"
    Directory = Left(Directory, Len(Directory)-1)
  EndIf
  
  Directory_ID = ExamineDirectory(#PB_Any, Directory, "*.*")
  If Directory_ID
    While NextDirectoryEntry(Directory_ID)
      Entry_Name.s = DirectoryEntryName(Directory_ID)
      Filename.s = Directory + "/" + Entry_Name
      
      If Entry_Name <> "." And Entry_Name <> ".."
        
        If DirectoryEntryType(Directory_ID) = #PB_DirectoryEntry_File
          If LCase(Right(Entry_Name, 4)) = ".lua"
            Found = 0
            ForEach Lua_File()
              If Lua_File()\Filename = Filename
                Found = 1
                Break
              EndIf
            Next
            If Found = 0
              AddElement(Lua_File())
              Lua_File()\Filename = Filename
            EndIf
          EndIf
        Else
          Check_New_Files(Filename)
        EndIf
        
      EndIf
      
    Wend
    FinishDirectory(Directory_ID)
  EndIf
  
EndProcedure

Procedure Timer()
  Protected Filename.s
  Filename = Space(Files_Folder_Get("Lua", 0))
  Files_Folder_Get("Lua", @Filename)
  
  If Not Lua_Main\State
    ProcedureReturn #Result_Fail
  EndIf
  
  Check_New_Files(Filename)
  
  ForEach Lua_File()
    File_Date = GetFileDate(Lua_File()\Filename, #PB_Date_Modified)
    If Lua_File()\File_Date_Last <> File_Date
      Lua_File()\File_Date_Last = File_Date
      Lua_Do_File(Lua_File()\Filename)
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

ProcedureCDLL Event_Client_Add(*Network_Client.Network_Client)
  If Not *Network_Client
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Lua_Event()
    If Lua_Event()\Type = #Lua_Event_Client_Add
      Lua_Do_Func_Event_Client_Add(Lua_Event()\Function, *Network_Client\ID)
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

ProcedureCDLL Event_Client_Delete(*Network_Client.Network_Client)
  If Not *Network_Client
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Lua_Event()
    If Lua_Event()\Type = #Lua_Event_Client_Delete
      Lua_Do_Func_Event_Client_Delete(Lua_Event()\Function, *Network_Client\ID)
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

ProcedureCDLL Event_Client_Login(*Network_Client.Network_Client, Name.s)
  If Not *Network_Client
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Lua_Event()
    If Lua_Event()\Type = #Lua_Event_Client_Login
      Lua_Do_Func_Event_Client_Login(Lua_Event()\Function, *Network_Client\ID, Name)
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

ProcedureCDLL Event_Client_Logout(*Network_Client.Network_Client, Name.s)
  If Not *Network_Client
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Lua_Event()
    If Lua_Event()\Type = #Lua_Event_Client_Logout
      Lua_Do_Func_Event_Client_Logout(Lua_Event()\Function, *Network_Client\ID, Name)
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

ProcedureCDLL Event_World_Column_Fill(Function.s, *World.World, *World_Column.World_Column, Seed, Generation_State)
  If Not *World
    ProcedureReturn 0
  EndIf
  
  If Not *World_Column
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn Lua_Do_Func_Event_Column_Fill(Function, *World\ID, *World_Column\X, *World_Column\Y, Seed, Generation_State)
EndProcedure

ProcedureCDLL Event_World_Physic(Function.s, *World.World, X, Y, Z, Type, Metadata, Current_Trigger_Time)
  If Not *World
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn Lua_Do_Func_Event_Physic(Function, *World\ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
EndProcedure

ProcedureCDLL Event_Block_Rightclick(Function.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
  If Not *Network_Client
    ProcedureReturn 0
  EndIf
  
  If Not *World
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn Lua_Do_Func_Event_Block_Rightclick(Function, *Network_Client\ID, *World\ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
EndProcedure

ProcedureCDLL Event_Block_Leftclick(Function.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Face, State, Type, Metadata)
  If Not *Network_Client
    ProcedureReturn 0
  EndIf
  
  If Not *World
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn Lua_Do_Func_Event_Block_Leftclick(Function, *Network_Client\ID, *World\ID, X, Y, Z, Face, State, Type, Metadata)
EndProcedure

ProcedureCDLL Event_Entity(Function.s, *Entity.Entity)
  If Not *Entity
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn Lua_Do_Func_Event_Entity(Function, *Entity\ID)
EndProcedure

ProcedureCDLL Event_Item_Place(Function.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
  If Not *Network_Client
    ProcedureReturn 0
  EndIf
  
  If Not *World
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn Lua_Do_Func_Event_Item_Place(Function, *Network_Client\ID, *World\ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
EndProcedure

ProcedureCDLL Event_Item_Dig(Function.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Face, State, Type, Metadata)
  If Not *Network_Client
    ProcedureReturn 0
  EndIf
  
  If Not *World
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn Lua_Do_Func_Event_Item_Dig(Function, *Network_Client\ID, *World\ID, X, Y, Z, Face, State, Type, Metadata)
EndProcedure

ProcedureCDLL Main()
  Protected Remaining_Time, Iteration
  
  ForEach Lua_Event()
    If Lua_Event()\Type = #Lua_Event_Timer
      Remaining_Time = Lua_Event()\Timer - ElapsedMilliseconds()
      
      If Remaining_Time > Lua_Event()\Time * 2
        Lua_Event()\Timer = ElapsedMilliseconds()
      EndIf
      
      Iteration = 0
      
      While Remaining_Time <= 0 And Iteration < Lua_Event()\Max_Iterations
        If Lua_Event()\Realtime
          Lua_Event()\Timer + Lua_Event()\Time
        Else
          Lua_Event()\Timer = ElapsedMilliseconds() + Lua_Event()\Time
        EndIf
        
        Lua_Do_Func_Event_Timer(Lua_Event()\Function)
        
        If Lua_Event()\Realtime
          Remaining_Time = Lua_Event()\Timer - ElapsedMilliseconds()
          Iteration + 1
        Else
          Break
        EndIf
      Wend
    EndIf
  Next
EndProcedure
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; ExecutableFormat = Shared Dll
; CursorPosition = 32
; Folding = ----
; EnableXP
; Executable = Lua.x64.dll