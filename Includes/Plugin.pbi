; #################################################### Initstuff #################################################

; #################################################### Prototypes ################################################

PrototypeC   Plugin_Inside_Main()

PrototypeC   Plugin_Inside_Event_Client_Add(*Network_Client.Network_Client)
PrototypeC   Plugin_Inside_Event_Client_Delete(*Network_Client.Network_Client)
PrototypeC   Plugin_Inside_Event_Client_Login(*Network_Client.Network_Client, Name.s)
PrototypeC   Plugin_Inside_Event_Client_Logout(*Network_Client.Network_Client, Name.s)

PrototypeC   Plugin_Inside_Event_World_Column_Fill(Function.s, *World.World, *World_Column.World_Column, Seed, Generation_State)
PrototypeC   Plugin_Inside_Event_World_Physic(Function.s, *World.World, X, Y, Z, Type, Metadata, Current_Trigger_Time)
PrototypeC   Plugin_Inside_Event_Block_Rightclick(Function.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
PrototypeC   Plugin_Inside_Event_Block_Leftclick(Function.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Face, State, Type, Metadata)
PrototypeC   Plugin_Inside_Event_Entity(Function.s, *Entity.Entity)
PrototypeC   Plugin_Inside_Event_Item_Place(Function.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
PrototypeC   Plugin_Inside_Event_Item_Dig(Function.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Face, State, Type, Metadata)

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

#Plugin_Define_Prototypes = #False ; Disable Define_Prototypes()
XIncludeFile "S_Includes/Functions.pbi"

; #################################################### Structures ################################################

Structure Plugin_Main
  Timer_File_Check.l          ; Timer für das überprüfen der Dateigröße
EndStructure

Structure Plugin_Inside_Functions
  Main.Plugin_Inside_Main
  
  Event_Client_Add.Plugin_Inside_Event_Client_Add
  Event_Client_Delete.Plugin_Inside_Event_Client_Delete
  Event_Client_Login.Plugin_Inside_Event_Client_Login
  Event_Client_Logout.Plugin_Inside_Event_Client_Logout
  
  Event_World_Column_Fill.Plugin_Inside_Event_World_Column_Fill
  Event_World_Physic.Plugin_Inside_Event_World_Physic
  Event_Block_Rightclick.Plugin_Inside_Event_Block_Rightclick
  Event_Block_Leftclick.Plugin_Inside_Event_Block_Leftclick
  Event_Entity.Plugin_Inside_Event_Entity
  Event_Item_Place.Plugin_Inside_Event_Item_Place
  Event_Item_Dig.Plugin_Inside_Event_Item_Dig
EndStructure
Structure Plugin
  Plugin_Info.Plugin_Info
  Functions.Plugin_Inside_Functions
  Filename.s
  Library_ID.i                ; Rückgabe von Openlibrary (0: Ungültig)
  File_Date_Last.l            ; Datum letzter Änderung
EndStructure

; #################################################### Variables #################################################

Global Plugin_Main.Plugin_Main

Global NewList Plugin.Plugin()

; #################################################### Constants #################################################

#Plugin_Version = 1000

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
    #Plugin_Suffix = ".x86.dll"
  CompilerElse
    #Plugin_Suffix = ".x64.dll"
  CompilerEndIf
CompilerElse
  CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
    #Plugin_Suffix = ".x86.so"
  CompilerElse
    #Plugin_Suffix = ".x64.so"
  CompilerEndIf
CompilerEndIf

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

; #################################################### Main functions

Procedure Plugin_Initialize(*Plugin.Plugin) ; Initialisiert Plugin und übergibt Funktionspointer...
  If Not *Plugin
    ; Add Error-Handler here
    Log_Add_Error("*Plugin")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not CallCFunction(*Plugin\Library_ID, "Init", @*Plugin\Plugin_Info, @Plugin_Function)
    Log_Add_Warn("Plugin not loaded: Initialisation failed ("+*Plugin\Filename+", "+*Plugin\Plugin_Info\Name+", "+*Plugin\Plugin_Info\Author+")")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Plugin\Plugin_Info\Version = #Plugin_Version
    Log_Add_Warn("Plugin not loaded: Incompatible ("+*Plugin\Filename+", "+Str(*Plugin\Plugin_Info\Version)+")")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Plugin\Functions\Main = GetFunction(*Plugin\Library_ID, "Main")
  
  *Plugin\Functions\Event_Client_Add = GetFunction(*Plugin\Library_ID, "Event_Client_Add")
  *Plugin\Functions\Event_Client_Delete = GetFunction(*Plugin\Library_ID, "Event_Client_Delete")
  *Plugin\Functions\Event_Client_Login = GetFunction(*Plugin\Library_ID, "Event_Client_Login")
  *Plugin\Functions\Event_Client_Logout = GetFunction(*Plugin\Library_ID, "Event_Client_Logout")
  
  *Plugin\Functions\Event_World_Column_Fill = GetFunction(*Plugin\Library_ID, "Event_World_Column_Fill")
  *Plugin\Functions\Event_World_Physic = GetFunction(*Plugin\Library_ID, "Event_World_Physic")
  *Plugin\Functions\Event_Block_Rightclick = GetFunction(*Plugin\Library_ID, "Event_Block_Rightclick")
  *Plugin\Functions\Event_Block_Leftclick = GetFunction(*Plugin\Library_ID, "Event_Block_Leftclick")
  *Plugin\Functions\Event_Entity = GetFunction(*Plugin\Library_ID, "Event_Entity")
  *Plugin\Functions\Event_Item_Place = GetFunction(*Plugin\Library_ID, "Event_Item_Place")
  *Plugin\Functions\Event_Item_Dig = GetFunction(*Plugin\Library_ID, "Event_Item_Dig")
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Plugin_Deinitialize(*Plugin.Plugin) ; Deinitialisiert Plugin...
  If Not *Plugin
    ; Add Error-Handler here
    Log_Add_Error("*Plugin")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not CallCFunction(*Plugin\Library_ID, "Deinit")
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Plugin_Unload(*Plugin.Plugin) ; Entlädt die Lib, löscht sie aber nicht aus der Liste
  If Not *Plugin
    ; Add Error-Handler here
    Log_Add_Error("*Plugin")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Plugin\Library_ID
    ProcedureReturn #Result_Success
  EndIf
  
  Plugin_Deinitialize(*Plugin)
  
  CloseLibrary(*Plugin\Library_ID)
  *Plugin\Library_ID = 0
  
  Log_Add_Info("Plugin unloaded: "+*Plugin\Filename+" ("+*Plugin\Plugin_Info\Name+", "+*Plugin\Plugin_Info\Author+")")
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Plugin_Load(*Plugin.Plugin) ; Lädt die Lib (Wenn in der Liste vorhanden)
  If Not *Plugin
    ; Add Error-Handler here
    Log_Add_Error("*Plugin")
    ProcedureReturn #Result_Fail
  EndIf
  
  Plugin_Unload(*Plugin)
  *Plugin\Library_ID = OpenLibrary(#PB_Any, *Plugin\Filename)
      
  If Not *Plugin\Library_ID
    Log_Add_Warn("Plugin not loaded: Can't open "+*Plugin\Filename)
    Plugin_Unload(*Plugin)
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not Plugin_Initialize(*Plugin)
    Plugin_Unload(*Plugin)
    ProcedureReturn #Result_Fail
  EndIf
  
  Log_Add_Info("Plugin loaded: "+*Plugin\Filename+" ("+*Plugin\Plugin_Info\Name+", "+*Plugin\Plugin_Info\Author+")")
  ProcedureReturn #Result_Success
EndProcedure

Procedure Plugin_Check_Files(Directory.s)
  Protected Directory_ID, Filename.s, Entry_Name.s, Found
  
  If Right(Directory, 1) = "/" Or Right(Directory, 1) = "\"
    Directory = Left(Directory, Len(Directory)-1)
  EndIf
  
  Directory_ID = ExamineDirectory(#PB_Any, Directory, "*.*")
  If Directory_ID
    While NextDirectoryEntry(Directory_ID)
      Entry_Name = DirectoryEntryName(Directory_ID)
      Filename = Directory + "/" + Entry_Name
      
      If Entry_Name <> "." And Entry_Name <> ".."
        
        If DirectoryEntryType(Directory_ID) = #PB_DirectoryEntry_File
          If LCase(Right(Entry_Name, Len(#Plugin_Suffix))) = #Plugin_Suffix
            Found = 0
            ForEach Plugin()
              If Plugin()\Filename = Filename
                Found = 1
                Break
              EndIf
            Next
            If Found = 0
              AddElement(Plugin())
              Plugin()\Filename = Filename
              Plugin()\Plugin_Info\Name = Left(GetFilePart(Filename), Len(GetFilePart(Filename))-Len(#Plugin_Suffix))
            EndIf
          EndIf
        Else
          Plugin_Check_Files(Filename)
        EndIf
        
      EndIf
      
    Wend
    FinishDirectory(Directory_ID)
  EndIf
  
EndProcedure

Procedure Plugin_Main()
  Protected File_Date
  Protected Filename.s
  Filename = Space(Files_Folder_Get("Plugins", 0))
  Files_Folder_Get("Plugins", @Filename)
  
  ; ##################### gelöschte Plugins entladen + von Liste entfernen
  
  ForEach Plugin()
    If FileSize(Plugin()\Filename) = -1
      If Plugin_Unload(Plugin()) = #True
        DeleteElement(Plugin())
      EndIf
    EndIf
  Next
  
  ; ##################### neue Plugins zur Liste hinzufügen
  
  Plugin_Check_Files(Filename)
  
  ; ################### Plugins laden
  
  ForEach Plugin()
    File_Date = GetFileDate(Plugin()\Filename, #PB_Date_Modified)
    If Plugin()\File_Date_Last <> File_Date
      Plugin()\File_Date_Last = File_Date
      Plugin_Load(Plugin())
    EndIf
  Next
  
EndProcedure
Timer_Register("Plugin_Main", 0, 1000, @Plugin_Main())

; #################################################### Callable Plugin Functions (Broadcast) #####################

Procedure Plugin_Do_Main()
  ; ########## Execute "Main()" of each plugin
  
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Main
        Plugin()\Functions\Main()
      EndIf
    EndIf
  Next
EndProcedure
Timer_Register("Plugin_Do_Main", 0, 0, @Plugin_Do_Main())

Procedure Plugin_Do_Event_Client_Add(*Network_Client.Network_Client)
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Client_Add
        Plugin()\Functions\Event_Client_Add(*Network_Client)
      EndIf
    EndIf
  Next
EndProcedure

Procedure Plugin_Do_Event_Client_Delete(*Network_Client.Network_Client)
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Client_Delete
        Plugin()\Functions\Event_Client_Delete(*Network_Client)
      EndIf
    EndIf
  Next
EndProcedure

Procedure Plugin_Do_Event_Client_Login(*Network_Client.Network_Client, Name.s)
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Client_Login
        Plugin()\Functions\Event_Client_Login(*Network_Client, Name)
      EndIf
    EndIf
  Next
EndProcedure

Procedure Plugin_Do_Event_Client_Logout(*Network_Client.Network_Client, Name.s)
  ForEach Plugin()
    If Plugin()\Library_ID
      If Plugin()\Functions\Event_Client_Logout
        Plugin()\Functions\Event_Client_Logout(*Network_Client, Name)
      EndIf
    EndIf
  Next
EndProcedure

; #################################################### Callable Plugin Functions (Destination) ###################

Procedure Plugin_Do_Event_World_Column_Fill(Destination.s, *World.World, *World_Column.World_Column, Seed, Generation_State)
  Protected Destination_Plugin.s = StringField(Destination, 1, ":")
  Protected Destination_Function.s = StringField(Destination, 2, ":")
  Protected Result
  
  ForEach Plugin()
    If Destination_Plugin = "*" Or Plugin()\Plugin_Info\Name = Destination_Plugin
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_World_Column_Fill
          Result = Plugin()\Functions\Event_World_Column_Fill(Destination_Function, *World, *World_Column, Seed, Generation_State)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Do_Event_World_Physic(Destination.s, *World.World, X, Y, Z, Type, Metadata, Current_Trigger_Time)
  Protected Destination_Plugin.s = StringField(Destination, 1, ":")
  Protected Destination_Function.s = StringField(Destination, 2, ":")
  Protected Result
  
  ForEach Plugin()
    If Destination_Plugin = "*" Or Plugin()\Plugin_Info\Name = Destination_Plugin
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_World_Physic
          Result = Plugin()\Functions\Event_World_Physic(Destination_Function, *World, X, Y, Z, Type, Metadata, Current_Trigger_Time)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Do_Event_Block_Rightclick(Destination.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
  Protected Destination_Plugin.s = StringField(Destination, 1, ":")
  Protected Destination_Function.s = StringField(Destination, 2, ":")
  Protected Result
  
  ForEach Plugin()
    If Destination_Plugin = "*" Or Plugin()\Plugin_Info\Name = Destination_Plugin
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_Block_Rightclick
          Result = Plugin()\Functions\Event_Block_Rightclick(Destination_Function, *Network_Client, *World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Do_Event_Block_Leftclick(Destination.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Face, State, Type, Metadata)
  Protected Destination_Plugin.s = StringField(Destination, 1, ":")
  Protected Destination_Function.s = StringField(Destination, 2, ":")
  Protected Result
  
  ForEach Plugin()
    If Destination_Plugin = "*" Or Plugin()\Plugin_Info\Name = Destination_Plugin
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_Block_Leftclick
          Result = Plugin()\Functions\Event_Block_Leftclick(Destination_Function, *Network_Client, *World, X, Y, Z, Face, State, Type, Metadata)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Do_Event_Entity(Destination.s, *Entity.Entity)
  Protected Destination_Plugin.s = StringField(Destination, 1, ":")
  Protected Destination_Function.s = StringField(Destination, 2, ":")
  Protected Result
  
  ForEach Plugin()
    If Destination_Plugin = "*" Or Plugin()\Plugin_Info\Name = Destination_Plugin
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_Entity
          Result = Plugin()\Functions\Event_Entity(Destination_Function, *Entity)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Do_Event_Item_Place(Destination.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
  Protected Destination_Plugin.s = StringField(Destination, 1, ":")
  Protected Destination_Function.s = StringField(Destination, 2, ":")
  Protected Result
  
  ForEach Plugin()
    If Destination_Plugin = "*" Or Plugin()\Plugin_Info\Name = Destination_Plugin
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_Item_Place
          Result = Plugin()\Functions\Event_Item_Place(Destination_Function, *Network_Client, *World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

Procedure Plugin_Do_Event_Item_Dig(Destination.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Face, State, Type, Metadata)
  Protected Destination_Plugin.s = StringField(Destination, 1, ":")
  Protected Destination_Function.s = StringField(Destination, 2, ":")
  Protected Result
  
  ForEach Plugin()
    If Destination_Plugin = "*" Or Plugin()\Plugin_Info\Name = Destination_Plugin
      If Plugin()\Library_ID
        If Plugin()\Functions\Event_Item_Dig
          Result = Plugin()\Functions\Event_Item_Dig(Destination_Function, *Network_Client, *World, X, Y, Z, Face, State, Type, Metadata)
        EndIf
      EndIf
    EndIf
  Next
  
  ProcedureReturn Result
EndProcedure

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 106
; FirstLine = 365
; Folding = ----
; EnableXP