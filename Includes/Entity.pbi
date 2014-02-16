; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Entity_Main
  Entity_ID_Counter.l
EndStructure

; #################################################### Variables #################################################

Global Entity_Main.Entity_Main
Entity_Main\Entity_ID_Counter = 1 ; 0 is invalid, 1 is reserved for the client's entity_id on each client, so Entity_Get_Free_ID() returns 2 on first call

Global NewList Entity.Entity()

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Entity_Get_Free_ID()
  Entity_Main\Entity_ID_Counter + 1
  ProcedureReturn Entity_Main\Entity_ID_Counter
EndProcedure

Procedure Entity_Get_By_ID(Entity_ID)
  If ListIndex(Entity()) <> -1 And Entity()\ID = Entity_ID
    ProcedureReturn Entity()
  Else
    ForEach Entity()
      If Entity()\ID = Entity_ID
        ProcedureReturn Entity()
      EndIf
    Next
  EndIf
  
  ProcedureReturn #Result_Fail
EndProcedure

Procedure Entity_Add(*World.World, X.d, Y.d, Z.d, Type, Name.s)
  Protected *Entity_Type.Entity_Type
  
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not AddElement(Entity())
    ; Add Error-Handler here
    Log_Add_Error("AddElement")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Entity_Type = Entity_Type_Get(Type)
  If Not *Entity_Type
    ; Add Error-Handler here
    Log_Add_Error("Entity_Type_Get")
    ProcedureReturn #Result_Fail
  EndIf
  
  Entity()\Column_X = World_Get_Column_X(Round(X,0))
  Entity()\Column_Y = World_Get_Column_Y(Round(Y,0))
  Entity()\World_Column = World_Column_Get(*World, Entity()\Column_X, Entity()\Column_Y, #True, #True)
  If Not Entity()\World_Column
    ; Add Error-Handler here
    Log_Add_Error("World_Column_Get")
    DeleteElement(Entity())
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not AddElement(Entity()\World_Column\Entity())
    ; Add Error-Handler here
    Log_Add_Error("AddElement")
    DeleteElement(Entity())
    ProcedureReturn #Result_Fail
  EndIf
  Entity()\World_Column\Entity() = Entity()
  
  Entity()\ID = Entity_Get_Free_ID()
  Entity()\Type = Type
  Entity()\Name = Name
  
  Entity()\World = *World
  Entity()\X = X
  Entity()\Y = Y
  Entity()\Z = Z
  
  Entity()\Send_New = #True
  
  Entity()\Holding_Slot = 36
  
  If *Entity_Type\Destroy_Time
    Entity()\Destroy_Timer = Date() + *Entity_Type\Destroy_Time
  EndIf
  
  If *Entity_Type\Event_Time
    Entity()\Event_Timer = Timer_Milliseconds() + *Entity_Type\Event_Time
  EndIf
  
  If *Entity_Type\Inventory_Type
    Entity_Inventory_Initialize(Entity(), *Entity_Type\Inventory_Type)
  EndIf
  
  ProcedureReturn Entity()
EndProcedure

Procedure Entity_Delete(*Entity.Entity)
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  If *Entity\World_Column
    ForEach *Entity\World_Column\Entity()
      If *Entity\World_Column\Entity() = *Entity
        DeleteElement(*Entity\World_Column\Entity())
        Break
      EndIf
    Next
  EndIf
  
  If *Entity\World_Column
    ForEach *Entity\World_Column\Network_Client()
      If *Entity\World_Column\Network_Client()\Entity = *Entity
        Continue
      EndIf
      Entity_Send_Delete(*Entity, *Entity\World_Column\Network_Client())
    Next
  EndIf
  
  If *Entity\Network_Client
    *Entity\Network_Client\Entity = 0
  EndIf
  
  If *Entity\Inventory
    ForEach *Entity\Inventory\Window()
      Network_Client_Inventory_Window_Close(*Entity\Inventory\Window()\Network_Client, *Entity\Inventory\Window()\Window_ID)
    Next
    ClearStructure(*Entity\Inventory, Entity_Inventory)
    FreeMemory(*Entity\Inventory)
  EndIf
  
  ChangeCurrentElement(Entity(), *Entity)
  DeleteElement(Entity())
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Entity_Set_Position(*Entity.Entity, X.d, Y.d, Z.d, To_Client)
  Protected *Old_World_Column.World_Column
  Protected DX.d, DY.d, DZ.d
  Protected Found
  
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  DX = *Entity\X - X
  DY = *Entity\Y - Y
  DZ = *Entity\Z - Z
  *Entity\X = X
  *Entity\Y = Y
  *Entity\Z = Z
  
  If *Entity\Column_X <> World_Get_Column_X(Round(X,0)) Or *Entity\Column_Y <> World_Get_Column_Y(Round(Y,0))
    
    ; Remove the old entity-Pointer from the Column
    If *Entity\World_Column
      ForEach *Entity\World_Column\Entity()
        If *Entity\World_Column\Entity() = *Entity
          DeleteElement(*Entity\World_Column\Entity())
          Break
        EndIf
      Next
    EndIf
    
    ; Select the new Column
    *Entity\Column_X = World_Get_Column_X(Round(X,0))
    *Entity\Column_Y = World_Get_Column_Y(Round(Y,0))
    *Old_World_Column = *Entity\World_Column
    *Entity\World_Column = World_Column_Get(*Entity\World, *Entity\Column_X, *Entity\Column_Y, #True, #True)
    If Not *Entity\World_Column
      ; Add Error-Handler here
      Log_Add_Error("World_Column_Get")
      ;Entity_Delete(*Entity)
      ProcedureReturn #Result_Fail
    EndIf
    
    ; Add the entity-pointer to the new Column
    If Not AddElement(*Entity\World_Column\Entity())
      ; Add Error-Handler here
      Log_Add_Error("AddElement")
      ;Entity_Delete(*Entity)
      ProcedureReturn #Result_Fail
    EndIf
    *Entity\World_Column\Entity() = *Entity
    
    ; send Destroy / Add Entity to clients
    If *Old_World_Column And *Old_World_Column <> *Entity\World_Column
      ; #### Destroy
      ForEach *Old_World_Column\Network_Client()
        If *Old_World_Column\Network_Client()\Entity = *Entity
          Continue
        EndIf
        Found = 0
        ForEach *Entity\World_Column\Network_Client()
          If *Old_World_Column\Network_Client() = *Entity\World_Column\Network_Client()
            Found = 1
            Break
          EndIf
        Next
        If Found = 0
          Entity_Send_Delete(*Entity, *Old_World_Column\Network_Client())
        EndIf
      Next
      ; #### Create
      ForEach *Entity\World_Column\Network_Client()
        If *Entity\World_Column\Network_Client()\Entity = *Entity
          Continue
        EndIf
        Found = 0
        ForEach *Old_World_Column\Network_Client()
          If *Old_World_Column\Network_Client() = *Entity\World_Column\Network_Client()
            Found = 1
            Break
          EndIf
        Next
        If Found = 0
          Entity_Send_Add(*Entity, *Entity\World_Column\Network_Client())
        EndIf
      Next
    EndIf
  EndIf
  
  If Abs(DX) >= #Entity_Movement_Send_Trigger Or Abs(DY) >= #Entity_Movement_Send_Trigger Or Abs(DZ) >= #Entity_Movement_Send_Trigger
    *Entity\Send_Mask | #Entity_Send_Position
  EndIf
  
  If To_Client
    If *Entity\Network_Client
      Network_Client_Packet_Send_Player_Position(*Entity\Network_Client, X, Y, Z, Z+1.6, 0)
    EndIf
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Entity_Set_Velocity(*Entity.Entity, VX.d, VY.d, VZ.d, Send, To_Client)
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Entity\VX = VX
  *Entity\VY = VY
  *Entity\VZ = VZ
  
  If Send
    *Entity\Send_Mask | #Entity_Send_Velocity
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Entity_Set_Rotation(*Entity.Entity, Yaw.f, Pitch.f, Roll.f, Send, To_Client)
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Entity\Yaw = Yaw
  *Entity\Pitch = Pitch
  *Entity\Roll = Roll
  
  If Send
    *Entity\Send_Mask | #Entity_Send_Rotation
  EndIf
  
  If To_Client
    If *Entity\Network_Client
      Network_Client_Packet_Send_Player_Position_And_Look(*Entity\Network_Client, *Entity\X, *Entity\Y, *Entity\Z, *Entity\Z+1.6, Yaw, Pitch, 0)
    EndIf
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Entity_Set_World(*Entity.Entity, *World.World)
  Protected *Old_World.World
  
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
             
  ; #### Send Destroy
  If *Entity\World_Column
    ForEach *Entity\World_Column\Network_Client()
      If *Entity\World_Column\Network_Client()\Entity = *Entity
        Continue
      EndIf
      Entity_Send_Delete(*Entity, *Entity\World_Column\Network_Client())
    Next
  EndIf
  
  ; #### Remove the old entity-Pointer from the Column
  If *Entity\World_Column
    ForEach *Entity\World_Column\Entity()
      If *Entity\World_Column\Entity() = *Entity
        DeleteElement(*Entity\World_Column\Entity())
        Break
      EndIf
    Next
  EndIf
  
  *Old_World = *Entity\World
  
  ; #### Move Entity to spawn
  *Entity\World = *World
  *Entity\X = *World\Spawn\X
  *Entity\Y = *World\Spawn\Y
  *Entity\Z = *World\Spawn\Z
  *Entity\Yaw = *World\Spawn\Yaw
  *Entity\Pitch = *World\Spawn\Pitch
  *Entity\Roll = *World\Spawn\Roll
  
  ; #### Select the new Column
  *Entity\Column_X = World_Get_Column_X(Round(*Entity\X,0))
  *Entity\Column_Y = World_Get_Column_Y(Round(*Entity\Y,0))
  *Entity\World_Column = World_Column_Get(*Entity\World, *Entity\Column_X, *Entity\Column_Y, #True, #True)
  If Not *Entity\World_Column
    ; Add Error-Handler here
    Log_Add_Error("World_Column_Get")
    ;Entity_Delete(*Entity)
    ProcedureReturn #Result_Fail
  EndIf
  
  ; #### Add the entity-pointer to the new Column
  If Not AddElement(*Entity\World_Column\Entity())
    ; Add Error-Handler here
    Log_Add_Error("AddElement")
    ProcedureReturn #Result_Fail
  EndIf
  *Entity\World_Column\Entity() = *Entity
  
  ; #### Send Entity
  *Entity\Send_New = #True
  
  ; #### Send to own client
  If *Entity\Network_Client
    Network_Client_Packet_Send_Player_Position_And_Look(*Entity\Network_Client, *Entity\X, *Entity\Y, *Entity\Z, *Entity\Z+1.6, *Entity\Yaw, *Entity\Pitch, 0)
  EndIf
  
  ; #### Messages
  If *World <> *Old_World
    Message_Send_2_All("§e"+*Entity\Name+" joined '"+*World\name+"'")
    ;If *Old_World
    ;  Message_Send_2_World(*Old_World, "§c"+*Entity\Name+" joined '"+*Old_World\name+"'")
    ;EndIf
    ;If *World
    ;  Message_Send_2_World(*World, "§c"+*Entity\Name+" joined '"+*World\name+"'")
    ;EndIf
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Entity_Main()
  ;Protected *Entity_Type.Entity_Type
  
  ForEach Entity()
    ;*Entity_Type = Entity_Type_Get(Entity()\Type)
    
    If Entity()\Destroy_Timer And Entity()\Destroy_Timer <= Date()
      Entity_Delete(Entity())
    EndIf
  Next
EndProcedure
Timer_Register("Entity", 0, 1000, @Entity_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 270
; FirstLine = 258
; Folding = --
; EnableXP
; DisableDebugger