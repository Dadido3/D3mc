; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Entity_Type_Main
  File_Save.i
  File_Last_Date.i
EndStructure

; #################################################### Variables #################################################

Global Entity_Type_Main.Entity_Type_Main

Global NewList Entity_Type.Entity_Type()

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Entity_Type_Get(ID)
  If ListIndex(Entity_Type()) <> -1 And Entity_Type()\ID = ID
    ProcedureReturn Entity_Type()
  Else
    ForEach Entity_Type()
      If Entity_Type()\ID = ID
        ProcedureReturn Entity_Type()
      EndIf
    Next
  EndIf
  
  ProcedureReturn #Null
EndProcedure

Procedure Entity_Type_Load(Filename.s)
  Protected i
  
  If OpenPreferences(Filename.s)
    
    ClearList(Entity_Type())
    
    ExaminePreferenceGroups()
    While NextPreferenceGroup()
      AddElement(Entity_Type())
      Entity_Type()\ID = Val(PreferenceGroupName())
      Entity_Type()\Name = ReadPreferenceString("Name", "")
      Entity_Type()\Category = ReadPreferenceLong("Category", 0)
      Entity_Type()\On_Client = ReadPreferenceLong("On_Client", 0)
      Entity_Type()\Inventory_Type = ReadPreferenceLong("Inventory_Type", 0)
      Entity_Type()\Destroy_Time = ReadPreferenceLong("Destroy_Time", 0)
      Entity_Type()\Physic_Type = ReadPreferenceLong("Physic_Type", 0)
      Entity_Type()\Gravity = ReadPreferenceDouble("Gravity", #Gravity)
      Entity_Type()\Boundary_Center_X = ReadPreferenceDouble("Boundary_Center_X", 0)
      Entity_Type()\Boundary_Center_Y = ReadPreferenceDouble("Boundary_Center_Y", 0)
      Entity_Type()\Boundary_Center_Z = ReadPreferenceDouble("Boundary_Center_Z", 0)
      Entity_Type()\Boundary_Halfwidth_X = ReadPreferenceDouble("Boundary_Halfwidth_X", 0.1)
      Entity_Type()\Boundary_Halfwidth_Y = ReadPreferenceDouble("Boundary_Halfwidth_Y", 0.1)
      Entity_Type()\Boundary_Halfwidth_Z = ReadPreferenceDouble("Boundary_Halfwidth_Z", 0.1)
      Entity_Type()\Event = ReadPreferenceString("Event", "")
      Entity_Type()\Event_Time = ReadPreferenceLong("Event_Time", 0)
    Wend
    
    ClosePreferences()
    ;Entity_Type_Main\File_Save = 1
    Entity_Type_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure Entity_Type_Save(Filename.s)
  Protected i
  Protected File_ID
  
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    ForEach Entity_Type()
      WriteStringN(File_ID, "["+Str(Entity_Type()\ID)+"]")
      WriteStringN(File_ID, "Name = "+Entity_Type()\Name)
      WriteStringN(File_ID, "Category = "+Str(Entity_Type()\Category))
      WriteStringN(File_ID, "On_Client = "+Str(Entity_Type()\On_Client))
      WriteStringN(File_ID, "Inventory_Type = "+Str(Entity_Type()\Inventory_Type))
      WriteStringN(File_ID, "Destroy_Time = "+Str(Entity_Type()\Destroy_Time))
      WriteStringN(File_ID, "Physic_Type = "+Str(Entity_Type()\Physic_Type))
      WriteStringN(File_ID, "Gravity = "+StrD(Entity_Type()\Gravity))
      WriteStringN(File_ID, "Boundary_Center_X = "+StrD(Entity_Type()\Boundary_Center_X))
      WriteStringN(File_ID, "Boundary_Center_Y = "+StrD(Entity_Type()\Boundary_Center_Y))
      WriteStringN(File_ID, "Boundary_Center_Z = "+StrD(Entity_Type()\Boundary_Center_Z))
      WriteStringN(File_ID, "Boundary_Halfwidth_X = "+StrD(Entity_Type()\Boundary_Halfwidth_X))
      WriteStringN(File_ID, "Boundary_Halfwidth_Y = "+StrD(Entity_Type()\Boundary_Halfwidth_Y))
      WriteStringN(File_ID, "Boundary_Halfwidth_Z = "+StrD(Entity_Type()\Boundary_Halfwidth_Z))
      WriteStringN(File_ID, "Event = "+Entity_Type()\Event)
      WriteStringN(File_ID, "Event_Time = "+Str(Entity_Type()\Event_Time))
      WriteStringN(File_ID, "")
    Next
    
    CloseFile(File_ID)
    Entity_Type_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure Entity_Type_Main()
  Protected Filename.s
  Filename = Space(Files_File_Get("Entity_Type", 0))
  Files_File_Get("Entity_Type", @Filename)
  
  If Entity_Type_Main\File_Save
    Entity_Type_Main\File_Save = 0
    
    Entity_Type_Save(Filename)
  Else
    
    If Entity_Type_Main\File_Last_Date <> GetFileDate(Filename, #PB_Date_Modified)
      Entity_Type_Load(Filename)
    EndIf
  EndIf
  
EndProcedure
Timer_Register("Entity_Type", 0, 1000, @Entity_Type_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 70
; FirstLine = 41
; Folding = -
; EnableXP