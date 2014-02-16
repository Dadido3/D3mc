; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Entity_Send_Add(*Entity.Entity, *Network_Client.Network_Client)
  Protected *Entity_Type.Entity_Type
  
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Network_Client
    ; Add Error-Handler here
    Log_Add_Error("*Network_Client")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Entity_Type = Entity_Type_Get(*Entity\Type)
  If Not *Entity_Type
    ; Add Error-Handler here
    Log_Add_Error("Entity_Type_Get")
    ProcedureReturn #Result_Fail
  EndIf
  
  Select *Entity_Type\Category
    Case #Entity_Type_Player
      Network_Client_Packet_Send_Spawn_Named_Entity(*Network_Client, *Entity\ID, *Entity\Name, *Entity\X, *Entity\Y, *Entity\Z, *Entity\Yaw, *Entity\Pitch, 0)
      If *Entity\Inventory
        Network_Client_Packet_Send_Entity_Equipment(*Network_Client, *Entity\ID, 0, Entity_Inventory_Get_Type(*Entity, *Entity\Holding_Slot), Entity_Inventory_Get_Count(*Entity, *Entity\Holding_Slot), Entity_Inventory_Get_Uses(*Entity, *Entity\Holding_Slot))
        Network_Client_Packet_Send_Entity_Equipment(*Network_Client, *Entity\ID, 1, Entity_Inventory_Get_Type(*Entity, 8), Entity_Inventory_Get_Count(*Entity, 8), Entity_Inventory_Get_Uses(*Entity, 8))
        Network_Client_Packet_Send_Entity_Equipment(*Network_Client, *Entity\ID, 2, Entity_Inventory_Get_Type(*Entity, 7), Entity_Inventory_Get_Count(*Entity, 7), Entity_Inventory_Get_Uses(*Entity, 7))
        Network_Client_Packet_Send_Entity_Equipment(*Network_Client, *Entity\ID, 3, Entity_Inventory_Get_Type(*Entity, 6), Entity_Inventory_Get_Count(*Entity, 6), Entity_Inventory_Get_Uses(*Entity, 6))
        Network_Client_Packet_Send_Entity_Equipment(*Network_Client, *Entity\ID, 4, Entity_Inventory_Get_Type(*Entity, 5), Entity_Inventory_Get_Count(*Entity, 5), Entity_Inventory_Get_Uses(*Entity, 5))
      EndIf
    Case #Entity_Type_Item
      Network_Client_Packet_Send_Spawn_Pickup(*Network_Client, *Entity\ID, *Entity\Item_Type, *Entity\Item_Count, *Entity\Item_Uses, *Entity\X, *Entity\Y, *Entity\Z, *Entity\Yaw, *Entity\Pitch, *Entity\Roll)
    Case #Entity_Type_Mob
      Network_Client_Packet_Send_Spawn_Mob(*Network_Client, *Entity\ID, *Entity_Type\On_Client, *Entity\X, *Entity\Y, *Entity\Z, *Entity\Yaw, *Entity\Pitch, *Entity\Yaw)
    Case #Entity_Type_ObjectVehicle
      Network_Client_Packet_Send_Spawn_Object_Or_Vehicle(*Network_Client, *Entity\ID, *Entity_Type\On_Client, *Entity\X, *Entity\Y, *Entity\Z, 0, 0, 0, 0)
  EndSelect
EndProcedure

Procedure Entity_Send_Delete(*Entity.Entity, *Network_Client.Network_Client)
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Network_Client
    ; Add Error-Handler here
    Log_Add_Error("*Network_Client")
    ProcedureReturn #Result_Fail
  EndIf
  
  Network_Client_Packet_Send_Destroy_Entity(*Network_Client, *Entity\ID)
EndProcedure

Procedure Entity_Send_Main()
  ForEach Entity()
    ; #### New Entities
    If Entity()\World_Column And Entity()\Send_New
      Entity()\Send_New = #False
      
      ForEach Entity()\World_Column\Network_Client()
        If Entity()\World_Column\Network_Client()\Entity = Entity()
          Continue
        EndIf
        Entity_Send_Add(Entity(), Entity()\World_Column\Network_Client())
      Next
    EndIf
    
    ; #### Movement and stuff
    If Entity()\World_Column And Entity()\Send_Mask And Entity()\Send_Timer <= Timer_Milliseconds()
      Select Entity()\Type
        Case #Entity_Type_Item : Entity()\Send_Timer = Timer_Milliseconds() + 1000
        Default                : Entity()\Send_Timer = Timer_Milliseconds() + 100
      EndSelect
      
      ; #### Send Position
      If Entity()\Send_Mask & #Entity_Send_Position
        Entity()\Send_Mask & ~#Entity_Send_Position
        ForEach Entity()\World_Column\Network_Client()
          If Entity()\World_Column\Network_Client()\Entity = Entity()
            Continue
          EndIf
          Network_Client_Packet_Send_Entity_Teleport(Entity()\World_Column\Network_Client(), Entity()\ID, Entity()\X, Entity()\Y, Entity()\Z, Entity()\Yaw, Entity()\Pitch)
        Next
      EndIf
      
      ; #### Send Rotation
      If Entity()\Send_Mask & #Entity_Send_Rotation
        Entity()\Send_Mask & ~#Entity_Send_Rotation
        ForEach Entity()\World_Column\Network_Client()
          If Entity()\World_Column\Network_Client()\Entity = Entity()
            Continue
          EndIf
          Network_Client_Packet_Send_Entity_Look(Entity()\World_Column\Network_Client(), Entity()\ID, Entity()\Yaw, Entity()\Pitch)
          Network_Client_Packet_Send_Entity_Head_Look(Entity()\World_Column\Network_Client(), Entity()\ID, Entity()\Yaw)
        Next
      EndIf
      
      ; #### Send Velocity
      If Entity()\Send_Mask & #Entity_Send_Velocity
        Entity()\Send_Mask & ~#Entity_Send_Velocity
        ForEach Entity()\World_Column\Network_Client()
          If Entity()\World_Column\Network_Client()\Entity = Entity()
            Continue
          EndIf
          Network_Client_Packet_Send_Entity_Velocity(Entity()\World_Column\Network_Client(), Entity()\ID, Entity()\VX, Entity()\VY, Entity()\VZ)
        Next
      EndIf
    EndIf
  Next
EndProcedure
Timer_Register("Entity_Send", 0, 100, @Entity_Send_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 36
; FirstLine = 18
; Folding = -
; EnableXP