; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Entity_Event_Main
  
EndStructure

; #################################################### Variables #################################################

Global Entity_Event_Main.Entity_Event_Main

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Entity_Event_Main()
  Protected *Entity_Type.Entity_Type
  
  ForEach Entity()
    *Entity_Type = Entity_Type_Get(Entity()\Type)
    
    If *Entity_Type
      If *Entity_Type\Event_Time And Entity()\Event_Timer <= Timer_Milliseconds()
        Entity()\Event_Timer = Timer_Milliseconds() + *Entity_Type\Event_Time
        
        Plugin_Do_Event_Entity(*Entity_Type\Event, Entity())
      EndIf
    EndIf
  Next
  
EndProcedure
Timer_Register("Entity_Event", 0, 100, @Entity_Event_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 23
; Folding = -
; EnableXP