; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Block_Main
  File_Save.i
  File_Last_Date.i
EndStructure

; #################################################### Variables #################################################

Global Block_Main.Block_Main

Global Dim Block.Block(255)

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Block_Get(Type)
  If Type < 0 Or Type >= 256
    ; Add Error-Handler here
    Log_Add_Error("Type < 0 Or Type >= 256")
    ProcedureReturn #Null
  EndIf
  
  ProcedureReturn Block(Type)
EndProcedure

Procedure Block_Load(Filename.s)
  Protected i
  
  If OpenPreferences(Filename.s)
    
    For i = 0 To 255
      PreferenceGroup(Str(i))
      Block(i)\Name = ReadPreferenceString("Name", "")
      Block(i)\Name_Short = ReadPreferenceString("Name_Short", "")
      Block(i)\On_Client = ReadPreferenceLong("On_Client", 46)
      Block(i)\Physic_Type = ReadPreferenceLong("Physic_Type", 0)
      Block(i)\Physic_Event = ReadPreferenceString("Physic_Event", "")
      Block(i)\Physic_Time = ReadPreferenceLong("Physic_Time", 1000)
      Block(i)\Physic_Time_Random = ReadPreferenceLong("Physic_Time_Random", 100)
      Block(i)\Physic_Quantisation = ReadPreferenceLong("Physic_Quantisation", 0)
      Block(i)\Physic_Allowed_Trigger_Type = ReadPreferenceLong("Physic_Allowed_Trigger_Type", 20)
      Block(i)\Physic_Repeat = ReadPreferenceLong("Physic_Repeat", 0)
      Block(i)\Physic_On_Load = ReadPreferenceLong("Physic_On_Load", 0)
      Block(i)\Collision_Boundary = ReadPreferenceLong("Collision_Boundary", 1)
      Block(i)\Create_Event = ReadPreferenceString("Create_Event", "")
      Block(i)\Delete_Event = ReadPreferenceString("Delete_Event", "")
      Block(i)\Rightclick_Event = ReadPreferenceString("Rightclick_Event", "")
      Block(i)\Leftclick_Event = ReadPreferenceString("Leftclick_Event", "")
      Block(i)\Rank_Place = ReadPreferenceLong("Rank_Place", 32767)
      Block(i)\Rank_Delete = ReadPreferenceLong("Rank_Delete", 0)
      Block(i)\After_Delete = ReadPreferenceLong("After_Delete", 0)
      Block(i)\Corresponding_Item = ReadPreferenceLong("Corresponding_Item", i)
      Block(i)\Killer = ReadPreferenceLong("Killer", 0)
      Block(i)\Color = ReadPreferenceLong("Color", RGB(i,i,i))
      Block(i)\Light_Emit = ReadPreferenceLong("Light_Emit", 0)
      Block(i)\Light_Decrease = ReadPreferenceLong("Light_Decrease", 15)
    Next
    
    ClosePreferences()
    ;Block_Main\File_Save = 1
    Block_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure Block_Save(Filename.s)
  Protected i
  Protected File_ID
  
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "; Physic: 0   = Physic Off")
    WriteStringN(File_ID, ";         1   = 'Physic_Event'")
    WriteStringN(File_ID, ";         10  = Original Sand (Falling)")
    WriteStringN(File_ID, ";         11  = Original Sand (Instant move to lowest block)")
    WriteStringN(File_ID, ";         12  = New Sand (Max 45°)")
    WriteStringN(File_ID, ";         20  = Original Water")
    WriteStringN(File_ID, ";         21  = Finite Water")
    WriteStringN(File_ID, ";         22  = Infinite Fluid (I know, it's not a good idea with infinite worlds ;) )")
    WriteStringN(File_ID, ";         30  = Original Lava")
    WriteStringN(File_ID, ";         31  = Finite Lava")
    WriteStringN(File_ID, ";         100 = Selfdestruct")
    WriteStringN(File_ID, "")
    
    For i = 0 To 255
      WriteStringN(File_ID, "["+Str(i)+"]")
      If Block(i)\Name <> ""
        WriteStringN(File_ID, "Name = "+Block(i)\Name)
        WriteStringN(File_ID, "Name_Short = "+Block(i)\Name_Short)
        WriteStringN(File_ID, "On_Client = "+Str(Block(i)\On_Client))
        WriteStringN(File_ID, "Physic_Type = "+Str(Block(i)\Physic_Type))
        WriteStringN(File_ID, "Physic_Event = "+Block(i)\Physic_Event)
        WriteStringN(File_ID, "Physic_Time = "+Str(Block(i)\Physic_Time))
        WriteStringN(File_ID, "Physic_Time_Random = "+Str(Block(i)\Physic_Time_Random))
        WriteStringN(File_ID, "Physic_Quantisation = "+Str(Block(i)\Physic_Quantisation))
        WriteStringN(File_ID, "Physic_Allowed_Trigger_Type = "+Str(Block(i)\Physic_Allowed_Trigger_Type))
        WriteStringN(File_ID, "Physic_Repeat = "+Str(Block(i)\Physic_Repeat))
        WriteStringN(File_ID, "Physic_On_Load = "+Str(Block(i)\Physic_On_Load))
        WriteStringN(File_ID, "Collision_Boundary = "+Str(Block(i)\Collision_Boundary))
        WriteStringN(File_ID, "Create_Event = "+Block(i)\Create_Event)
        WriteStringN(File_ID, "Delete_Event = "+Block(i)\Delete_Event)
        WriteStringN(File_ID, "Rightclick_Event = "+Block(i)\Rightclick_Event)
        WriteStringN(File_ID, "Leftclick_Event = "+Block(i)\Leftclick_Event)
        WriteStringN(File_ID, "Rank_Place = "+Str(Block(i)\Rank_Place))
        WriteStringN(File_ID, "Rank_Delete = "+Str(Block(i)\Rank_Delete))
        WriteStringN(File_ID, "After_Delete = "+Str(Block(i)\After_Delete))
        WriteStringN(File_ID, "Corresponding_Item = "+Str(Block(i)\Corresponding_Item))
        WriteStringN(File_ID, "Killer = "+Str(Block(i)\Killer))
        WriteStringN(File_ID, "Color = "+Str(Block(i)\Color))
        WriteStringN(File_ID, "Light_Emit = "+Str(Block(i)\Light_Emit))
        WriteStringN(File_ID, "Light_Decrease = "+Str(Block(i)\Light_Decrease))
      EndIf
      WriteStringN(File_ID, "")
    Next
    
    CloseFile(File_ID)
    Block_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure Block_Main()
  Protected Filename.s
  Filename = Space(Files_File_Get("Block", 0))
  Files_File_Get("Block", @Filename)
  
  If Block_Main\File_Save
    Block_Main\File_Save = 0
    
    Block_Save(Filename)
  Else
    
    If Block_Main\File_Last_Date <> GetFileDate(Filename, #PB_Date_Modified)
      Block_Load(Filename)
    EndIf
  EndIf
  
EndProcedure
Timer_Register("Block", 0, 1000, @Block_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 71
; Folding = -
; EnableXP
; DisableDebugger