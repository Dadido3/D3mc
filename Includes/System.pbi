; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure System
  Server_Name.s
  Ping_Message.s
  MOTD.s
  Max_Players.l
  
  File_Save.i
  File_Last_Date.i
EndStructure

; #################################################### Variables #################################################

Global System.System

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure System_Load(Filename.s)
  Protected i
  
  If OpenPreferences(Filename.s)
    
    PreferenceGroup("Server")
    System\Server_Name = ReadPreferenceString("Name", "Default")
    System\Ping_Message = ReadPreferenceString("Ping_Message", "Default")
    System\MOTD = ReadPreferenceString("MOTD", "Default")
    System\Max_Players = ReadPreferenceLong("Max_Players", 32)
    
    ClosePreferences()
    ;System\File_Save = 1
    System\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure System_Save(Filename.s)
  Protected i
  Protected File_ID
  
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "[Server]")
    WriteStringN(File_ID, "Name = "+System\Server_Name)
    WriteStringN(File_ID, "Ping_Message = "+System\Ping_Message)
    WriteStringN(File_ID, "MOTD = "+System\MOTD)
    WriteStringN(File_ID, "Max_Players = "+Str(System\Max_Players))
    
    CloseFile(File_ID)
    System\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure System_Main()
  Protected Filename.s
  Filename = Space(Files_File_Get("System", 0))
  Files_File_Get("System", @Filename)
  
  If System\File_Save
    System\File_Save = 0
    
    System_Save(Filename)
  Else
    
    If System\File_Last_Date <> GetFileDate(Filename, #PB_Date_Modified)
      System_Load(Filename)
    EndIf
  EndIf
  
EndProcedure
Timer_Register("System", 0, 1000, @System_Main())
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 10
; Folding = -
; EnableXP