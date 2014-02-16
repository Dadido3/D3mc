; #################################################### Initstuff #################################################

; #################################################### Macros ####################################################

Procedure World_Get_Column_X(X)
  If X < 0
    ProcedureReturn (X+1)/#World_Column_Size_X - 1
  Else
    ProcedureReturn X/#World_Column_Size_X
  EndIf
EndProcedure

Procedure World_Get_Column_Y(Y)
  If Y < 0
    ProcedureReturn (Y+1)/#World_Column_Size_Y - 1
  Else
    ProcedureReturn Y/#World_Column_Size_Y
  EndIf
EndProcedure

Procedure World_Get_Region_X(X)
  If X < 0
    ProcedureReturn (X+1)/#World_Region_Size_X - 1
  Else
    ProcedureReturn X/#World_Region_Size_X
  EndIf
EndProcedure

Procedure World_Get_Region_Y(Y)
  If Y < 0
    ProcedureReturn (Y+1)/#World_Region_Size_Y - 1
  Else
    ProcedureReturn Y/#World_Region_Size_Y
  EndIf
EndProcedure

; #################################################### Variables #################################################

Global NewList World.World()

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

XIncludeFile "Includes/World_Send.pbi"
XIncludeFile "Includes/World_Block.pbi"
XIncludeFile "Includes/World_Collision.pbi"
XIncludeFile "Includes/World_Light.pbi"
XIncludeFile "Includes/World_Physic.pbi"
XIncludeFile "Includes/World_Column.pbi"
XIncludeFile "Includes/World_Effect.pbi"

; #################################################### Structures ################################################

Structure World_Preferences
  File_Save.i
  File_Last_Date.i
EndStructure

; #################################################### Variables #################################################

Global World_Preferences.World_Preferences

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Procedures ################################################

Procedure World_Get_ID()
  Protected World_ID = 1
  Protected Found
  
  Repeat
    Found = 0
    ForEach World()
      If World_ID = World()\ID
        Found = 1
        Break
      EndIf
    Next
    If Found = 0
      ProcedureReturn World_ID
    Else
      World_ID + 1
    EndIf
  ForEver
  
  ProcedureReturn -1
EndProcedure

Procedure.s World_Get_Unique_ID()
  Protected ID.s = ""
  Protected i
  
  For i = 1 To 32
    Select CryptRandom(2)
      Case 0
        ID.s + Chr(48 + CryptRandom(9))
      Case 1
        ID.s + Chr(65 + CryptRandom(25))
      Case 2
        ID.s + Chr(97 + CryptRandom(25))
    EndSelect
  Next
  
  ProcedureReturn ID
EndProcedure

Procedure World_Create(Name.s, Directory.s)
  Protected File_ID
  
  ; Correct the path
  ReplaceString(Directory, "\", "/")
  If Not Right(Directory, 1) = "/"
    Directory + "/"
  EndIf
  
  If Not AddElement(World())
    ; Add Error-Handler here
    Log_Add_Error("AddElement")
    ProcedureReturn #Result_Fail
  EndIf
  
  World()\ID = World_Get_ID()
  World()\UID = World_Get_Unique_ID()
  World()\Name = Name
  World()\Directory = Directory
  World()\Column_Finder = D3HT_Create(SizeOf(Long)*2, SizeOf(Integer), 8192)
  
  World()\Spawn\X = 7.5
  World()\Spawn\Y = 7.5
  World()\Spawn\Z = 127
  
  World()\Limit_Radius = -1
  
  World()\Generator = "Lua:Mapfill_standart"
  World()\Seed = Random(2147483647)
  
  World()\Version = #Version_World_File
  
  If Not World()\Column_Finder
    ; Add Error-Handler here
    DeleteElement(World())
    Log_Add_Error("D3HT_Create")
    ProcedureReturn #Result_Fail
  EndIf
  
  CreateDirectory(World()\Directory)
  
  File_ID = CreateFile(#PB_Any, World()\Directory+#World_Filename_Config)
  If Not File_ID
    ; Add Error-Handler here
    D3HT_Destroy(World()\Column_Finder)
    DeleteElement(World())
    Log_Add_Error("CreateFile")
    ProcedureReturn #Result_Fail
  EndIf
  
  CloseFile(File_ID)
  
  ProcedureReturn World()
EndProcedure

Procedure World_Load(Directory.s)
  If Not AddElement(World())
    ; Add Error-Handler here
    Log_Add_Error("AddElement")
    ProcedureReturn #Result_Fail
  EndIf
  
  ; Correct the path
  ReplaceString(Directory, "\", "/")
  If Not Right(Directory, 1) = "/"
    Directory + "/"
  EndIf
  
  World()\ID = World_Get_ID()
  World()\Directory = Directory
  World()\Column_Finder = D3HT_Create(SizeOf(Long)*2, SizeOf(Integer), 4096)
  
  If Not World()\Column_Finder
    ; Add Error-Handler here
    DeleteElement(World())
    Log_Add_Error("D3HT_Create")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not OpenPreferences(World()\Directory+#World_Filename_Config)
    ; Add Error-Handler here
    D3HT_Destroy(World()\Column_Finder)
    DeleteElement(World())
    Log_Add_Error("OpenPreferences")
    ProcedureReturn #Result_Fail
  EndIf
  
  PreferenceGroup("General")
  World()\Version = ReadPreferenceLong("Version", World()\Version)
  World()\UID = ReadPreferenceString("UID", World()\UID)
  World()\Name = ReadPreferenceString("Name", World()\Name)
  
  PreferenceGroup("Spawn")
  World()\Spawn\X     = ReadPreferenceDouble("X", 8)
  World()\Spawn\Y     = ReadPreferenceDouble("Y", 8)
  World()\Spawn\Z     = ReadPreferenceDouble("Z", 256)
  World()\Spawn\Yaw   = ReadPreferenceFloat("Yaw", 0)
  World()\Spawn\Pitch = ReadPreferenceFloat("Pitch", 0)
  World()\Spawn\Roll  = ReadPreferenceFloat("Roll", 0)
  
  PreferenceGroup("World")
  World()\Time_Mode = ReadPreferenceLong("Time_Mode", 0)
  World()\Time_Factor = ReadPreferenceFloat("Time_Factor", 1)
  World()\Time = ReadPreferenceFloat("Time", 0)
  World()\Limit_Radius = ReadPreferenceLong("Limit_Radius", -1)
  World()\Generator = ReadPreferenceString("Generator", "Lua:Mapfill_standart")
  World()\Seed = ReadPreferenceLong("Seed", Random(2147483647))
  
  ClosePreferences()
  
  ProcedureReturn World()
EndProcedure

Procedure World_Save(*World.World, Save_Chunks=#False)
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not CreatePreferences(*World\Directory+#World_Filename_Config)
    ; Add Error-Handler here
    Log_Add_Error("CreatePreferences")
    ProcedureReturn #Result_Fail
  EndIf
  
  PreferenceGroup("General")
  WritePreferenceLong("Version", *World\Version)
  WritePreferenceString("UID", *World\UID)
  WritePreferenceString("Name", *World\Name)
  
  PreferenceGroup("Spawn")
  WritePreferenceDouble("X", *World\Spawn\X)
  WritePreferenceDouble("Y", *World\Spawn\Y)
  WritePreferenceDouble("Z", *World\Spawn\Z)
  WritePreferenceFloat("Yaw", *World\Spawn\Yaw)
  WritePreferenceFloat("Pitch", *World\Spawn\Pitch)
  WritePreferenceFloat("Roll", *World\Spawn\Roll)
  
  PreferenceGroup("World")
  WritePreferenceLong("Time_Mode", *World\Time_Mode)
  WritePreferenceFloat("Time_Factor", *World\Time_Factor)
  WritePreferenceFloat("Time", *World\Time)
  WritePreferenceLong("Limit_Radius", *World\Limit_Radius)
  WritePreferenceString("Generator", *World\Generator)
  WritePreferenceLong("Seed", *World\Seed)
  
  ClosePreferences()
  
  ; #### Manually HDD saving
  If Save_Chunks
    ForEach *World\Column()
      If And *World\Column()\HDD_Save_Date
        World_Column_File_Write(*World, *World\Column())
        *World\Column()\HDD_Save_Date = 0
      EndIf
    Next
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Get_By_UID(World_UID.s)
  If ListIndex(World()) <> -1 And World()\UID = World_UID
    ProcedureReturn World()
  Else
    ForEach World()
      If World()\UID = World_UID
        ProcedureReturn World()
      EndIf
    Next
  EndIf
  
  ProcedureReturn #Null
EndProcedure

Procedure World_Get_By_ID(World_ID)
  If ListIndex(World()) <> -1 And World()\ID = World_ID
    ProcedureReturn World()
  Else
    ForEach World()
      If World()\ID = World_ID
        ProcedureReturn World()
      EndIf
    Next
  EndIf
  
  ProcedureReturn #Null
EndProcedure

Procedure World_Get_By_Spawn_Priority()
  Protected *World.World, Spawn_Priority = -1
  
  *World = #Null
  ForEach World()
    If Spawn_Priority < World()\Spawn_Priority
      *World = World()
      Spawn_Priority = World()\Spawn_Priority
    EndIf
  Next
  
  ProcedureReturn *World
EndProcedure

Procedure World_Main_Column_Gen()
  Protected Counter
  
  ForEach World()
    ForEach World()\Column()
      If World()\Column()\Generation_State
        If World()\Column()\Generation_State < 100 Or World()\Column()\Neighbour_Columns = 8
          
          World()\Column()\Generation_State = Plugin_Do_Event_World_Column_Fill(World()\Generator, World(), World()\Column(), World()\Seed, World()\Column()\Generation_State)
          
          Counter + 1
          If Counter > 2
            Break 2
          EndIf
        EndIf
      EndIf
    Next
  Next
EndProcedure
Timer_Register("World_Column_Gen", 0, 50, @World_Main_Column_Gen())

Procedure World_Main_Light()
  ForEach World()
    
    ; #### Compute Lighting
    World_Light_Do(World())
    
  Next
EndProcedure
Timer_Register("World_Light", 0, 100, @World_Main_Light())

Procedure World_Preferences_Load(Filename.s)
  Protected World_ID
  Protected *World.World
  Protected Spawn_Priority, Directory.s, Name.s, Create, Delete
  
  OpenPreferences(Filename)
  
  If ExaminePreferenceGroups()
    While NextPreferenceGroup()
      World_ID = ReadPreferenceLong("ID", 0)
      
      *World = World_Get_By_ID(World_ID)
      Spawn_Priority = ReadPreferenceLong("Spawn_Priority", 0)
      Directory = ReadPreferenceString("Directory", "")
      Name = ReadPreferenceString("Name", "Standart")
      Create = ReadPreferenceLong("Create", 0)
      Delete = ReadPreferenceLong("Delete", 0)
      
      If Not *World
        If Create
          *World = World_Create(Name, Directory)
        Else
          ClosePreferences() ; #### Because of the stupid one file restriction of Preference-Files :/
          *World = World_Load(Directory)
          OpenPreferences(Filename)
          ExaminePreferenceGroups()
        EndIf
      Else
        If Delete
          ; #### Todo
          *World = #Null
        EndIf
      EndIf
      ; #### Don't do any more preference functions after that line! Just reinitialised examining...
      
      If *World
        *World\Spawn_Priority = Spawn_Priority
      EndIf
      
    Wend
  EndIf
  
  ClosePreferences()
  ;World_Preferences\File_Save = 1
  World_Preferences\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Preferences_Save(Filename.s)
  Protected World_ID
  Protected Found
  
  If Not CreatePreferences(Filename)
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach World()
    PreferenceGroup(Str(World()\ID))
    WritePreferenceLong("ID", World()\ID)
    WritePreferenceLong("Create", 0)
    WritePreferenceLong("Delete", 0)
    WritePreferenceString("Name", World()\Name)
    
    WritePreferenceString("Directory", World()\Directory)
    WritePreferenceLong("Spawn_Priority", World()\Spawn_Priority)
  Next
  
  ClosePreferences()
  World_Preferences\File_Save = 0
  World_Preferences\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Main()
  Protected i, Save_Counter, Time_Offset
  Protected Filename.s
  
  ; #### Check, load or save World_Preferences
  Filename = Space(Files_File_Get("Worlds", 0))
  Files_File_Get("Worlds", @Filename)
  If World_Preferences\File_Save
    World_Preferences\File_Save = 0
    World_Preferences_Save(Filename)
  Else
    If World_Preferences\File_Last_Date <> GetFileDate(Filename, #PB_Date_Modified)
      World_Preferences_Load(Filename)
    EndIf
  EndIf
  
  ; #### Do some world computation and other stuff
  ForEach World()
    
    ; #### World Time
    Select World()\Time_Mode
      Case 0
        World()\Time + World()\Time_Factor
      Case 1
        World()\Time = Date() * World()\Time_Factor
    EndSelect
    Time_Offset = World()\Time
    Time_Offset = Time_Offset/86400*86400
    World()\Time - Time_Offset
    ; #### World Time sending
    If World()\Time_Send_Date <= Date()
      ForEach Network_Client()
        If Network_Client()\Logged_In And Network_Client()\Entity And Network_Client()\Entity\World = World()
          Network_Client_Packet_Send_Time_Update(Network_Client(), 18000+World()\Time*24000/86400)
        EndIf
      Next
      World()\Time_Send_Date = Date() + #World_Time_Send_Time
    EndIf
    
    ; #### World Saving
    If World()\Save_Date <= Date()
      World_Save(World())
      World()\Save_Date = Date() + #World_Save_Time
    EndIf
    
    ; #### Compute Lighting
    World_Light_Do(World())
    
    ForEach World()\Column()
      ; #### Delete Sending buffer after some time
      If World()\Column()\Send_Buffer_Time And World()\Column()\Send_Buffer_Time <= Date()
        World()\Column()\Send_Buffer_Time = 0
        If World()\Column()\Send_Buffer
          FreeMemory(World()\Column()\Send_Buffer)
          World()\Column()\Send_Buffer = 0
          World()\Column()\Send_Buffer_Size = 0
        EndIf
      EndIf
      
      ; #### HDD saving after some time
      If Save_Counter < #World_Column_HDD_Save_Max And World()\Column()\HDD_Save_Date And World()\Column()\HDD_Save_Date <= Date()
        World_Column_File_Write(World(), World()\Column())
        World()\Column()\HDD_Save_Date = 0
        Save_Counter + 1
      EndIf
      
      For i = 0 To #World_Column_Chunks-1
        ; #### Raw --> ZLib --> HDD after some time
        If World()\Column()\Format_Change_Date[i] And World()\Column()\Format_Change_Date[i] <= Date()
          World()\Column()\Format_Change_Date[i] = 0
          Select World()\Column()\Format[i]
            Case #World_Column_Format_Raw : World_Column_Change_Format(World(), World()\Column(), 1<<i, #World_Column_Format_ZLib)
            ;Case #World_Column_Format_ZLib : World_Column_Change_Format(World(), World()\Column(), $FFFF, #World_Column_Format_HDD)
          EndSelect
        EndIf
      Next
    Next
  Next
EndProcedure
Timer_Register("World", 0, 1000, @World_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 452
; FirstLine = 417
; Folding = ---
; EnableXP
; DisableDebugger