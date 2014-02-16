; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Constants #################################################

; #################################################### Structures ################################################

Structure Item_Main
  File_Save.i
  File_Last_Date.i
EndStructure

; #################################################### Variables #################################################

Global Item_Main.Item_Main

Global Dim Item.Item(#Item_Amount_Max)

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Item_Get(Type)
  If Type < 0 Or Type >= #Item_Amount_Max
    ; Add Error-Handler here
    Log_Add_Error("Type < 0 Or Type >= #Item_Amount_Max")
    ProcedureReturn #Null
  EndIf
  
  ProcedureReturn Item(Type)
EndProcedure

Procedure Item_Load(Filename.s)
  Protected i
  
  If OpenPreferences(Filename.s)
    
    For i = 0 To #Item_Amount_Max
      PreferenceGroup(Str(i))
      Item(i)\Name = ReadPreferenceString("Name", "")
      Item(i)\Name_Short = ReadPreferenceString("Name_Short", "")
      Item(i)\Dig_Event = ReadPreferenceString("Dig_Event", "")
      Item(i)\Place_Event = ReadPreferenceString("Place_Event", "")
      Item(i)\Corresponding_Block = ReadPreferenceLong("Corresponding_Block", i)
      Item(i)\Stackable_Amount = ReadPreferenceLong("Stackable_Amount", 64)
      Item(i)\On_Client = ReadPreferenceLong("On_Client", 46)
    Next
    
    ClosePreferences()
    ;Item_Main\File_Save = 1
    Item_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure Item_Save(Filename.s)
  Protected i
  Protected File_ID
  
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "")
    
    For i = 0 To #Item_Amount_Max
      If Item(i)\Name
        WriteStringN(File_ID, "["+Str(i)+"]")
        WriteStringN(File_ID, "Name = "+Item(i)\Name)
        WriteStringN(File_ID, "Name_Short = "+Item(i)\Name_Short)
        WriteStringN(File_ID, "Dig_Event = "+Item(i)\Dig_Event)
        WriteStringN(File_ID, "Place_Event = "+Item(i)\Place_Event)
        WriteStringN(File_ID, "Corresponding_Block = "+Str(Item(i)\Corresponding_Block))
        WriteStringN(File_ID, "Stackable_Amount = "+Str(Item(i)\Stackable_Amount))
        WriteStringN(File_ID, "On_Client = "+Str(Item(i)\On_Client))
        WriteStringN(File_ID, "")
      EndIf
    Next
    
    Item_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Item_Main()
  Protected Filename.s
  Filename = Space(Files_File_Get("Item", 0))
  Files_File_Get("Item", @Filename)
  
  If Item_Main\File_Save
    Item_Main\File_Save = 0
    
    Item_Save(Filename)
  Else
    
    If Item_Main\File_Last_Date <> GetFileDate(Filename, #PB_Date_Modified)
      Item_Load(Filename)
    EndIf
  EndIf
  
EndProcedure
Timer_Register("Item", 0, 1000, @Item_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 54
; FirstLine = 37
; Folding = -
; EnableXP
; DisableDebugger