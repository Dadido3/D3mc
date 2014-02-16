; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Entity_Inventory_Initialize(*Entity.Entity, Inventory_Type)
  Protected i
  
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Entity\Inventory = AllocateMemory(SizeOf(Entity_Inventory))
  If Not *Entity\Inventory
    ; Add Error-Handler here
    Log_Add_Error("*Entity\Inventory")
    ProcedureReturn #Result_Fail
  EndIf
  InitializeStructure(*Entity\Inventory, Entity_Inventory)
  
  *Entity\Inventory\Type = Inventory_Type
  Select *Entity\Inventory\Type
    Case #Entity_Inventory_Type_Player    : *Entity\Inventory\Slots = 45
    Case #Entity_Inventory_Type_Chest     : *Entity\Inventory\Slots = 54
    Case #Entity_Inventory_Type_Workbench : *Entity\Inventory\Slots = 10
    Case #Entity_Inventory_Type_Furnance  : *Entity\Inventory\Slots = 3
    Default
      ; Add Error-Handler here
      Log_Add_Error("*Entity\Inventory\Type")
      ClearStructure(*Entity\Inventory, Entity_Inventory)
      FreeMemory(*Entity\Inventory)
      *Entity\Inventory = 0
      ProcedureReturn #Result_Fail
  EndSelect
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Entity_Inventory_Slot_Get(*Entity.Entity, Slot)
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Null
  EndIf
  
  If Not *Entity\Inventory
    ; Add Error-Handler here
    Log_Add_Error("*Entity\Inventory")
    ProcedureReturn #Null
  EndIf
  
  If Slot < 0 Or Slot >= *Entity\Inventory\Slots
    ; Add Error-Handler here
    Log_Add_Error("Slot < 0 Or Slot >= *Entity\Inventory\Slots")
    ProcedureReturn #Null
  EndIf
  
  If ListIndex(*Entity\Inventory\Slot()) <> -1 And *Entity\Inventory\Slot()\Slot = Slot
    ProcedureReturn *Entity\Inventory\Slot()
  Else
    ForEach *Entity\Inventory\Slot()
      If *Entity\Inventory\Slot()\Slot = Slot
        ProcedureReturn *Entity\Inventory\Slot()
      EndIf
    Next
  EndIf
  
  ProcedureReturn #Null
EndProcedure

Procedure Entity_Inventory_Set(*Entity.Entity, Slot, Item_Type, Item_Count, Item_Uses)
  Protected Holding_Send = -1
  Protected Found
  Protected Send_Item_Type, Send_Item_Count, Send_Item_Uses
  
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Entity\Inventory
    ; Add Error-Handler here
    Log_Add_Error("*Entity\Inventory")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Slot < 0 Or Slot >= *Entity\Inventory\Slots
    ; Add Error-Handler here
    Log_Add_Error("Slot < 0 Or Slot >= *Entity\Inventory\Slots")
    ProcedureReturn #Result_Fail
  EndIf
  
  Found = #False
  ForEach *Entity\Inventory\Slot()
    If *Entity\Inventory\Slot()\Slot = Slot
      If Item_Type = -1 Or Item_Count <= 0
        DeleteElement(*Entity\Inventory\Slot())
      Else
        *Entity\Inventory\Slot()\Type = Item_Type
        *Entity\Inventory\Slot()\Count = Item_Count
        *Entity\Inventory\Slot()\Uses = Item_Uses
      EndIf
      Found = #True
      Break
    EndIf
  Next
  
  If Not Found
    AddElement(*Entity\Inventory\Slot())
    *Entity\Inventory\Slot()\Slot = Slot
    *Entity\Inventory\Slot()\Type = Item_Type
    *Entity\Inventory\Slot()\Count = Item_Count
    *Entity\Inventory\Slot()\Uses = Item_Uses
  EndIf
  
  If *Entity\Network_Client
    Network_Client_Packet_Send_Set_Slot(*Entity\Network_Client, 0, Slot, Entity_Inventory_Get_Type(*Entity, Slot), Entity_Inventory_Get_Count(*Entity, Slot), Entity_Inventory_Get_Uses(*Entity, Slot))
  EndIf
  
  ForEach *Entity\Inventory\Window()
    Network_Client_Packet_Send_Set_Slot(*Entity\Inventory\Window()\Network_Client, *Entity\Inventory\Window()\Window_ID, Slot, Entity_Inventory_Get_Type(*Entity, Slot), Entity_Inventory_Get_Count(*Entity, Slot), Entity_Inventory_Get_Uses(*Entity, Slot))
  Next
  
  If *Entity\Type = #Entity_Type_Player
    Select Slot
      Case *Entity\Holding_Slot : Holding_Send = 0
      Case 5 : Holding_Send = 4
      Case 6 : Holding_Send = 3
      Case 7 : Holding_Send = 2
      Case 8 : Holding_Send = 1
    EndSelect
    If Holding_Send <> -1
      ForEach *Entity\World_Column\Network_Client()
        Network_Client_Packet_Send_Entity_Equipment(*Entity\World_Column\Network_Client(), *Entity\ID, Holding_Send, Entity_Inventory_Get_Type(*Entity, Slot), Entity_Inventory_Get_Count(*Entity, Slot), Entity_Inventory_Get_Uses(*Entity, Slot))
      Next
    EndIf
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Entity_Inventory_Get_Type(*Entity.Entity, Slot)
  Protected *Entity_Inventory_Slot.Entity_Inventory_Slot
  
  *Entity_Inventory_Slot = Entity_Inventory_Slot_Get(*Entity, Slot)
  If Not *Entity_Inventory_Slot
    ProcedureReturn -1
  EndIf
  
  ProcedureReturn *Entity_Inventory_Slot\Type
EndProcedure

Procedure Entity_Inventory_Get_Count(*Entity.Entity, Slot)
  Protected *Entity_Inventory_Slot.Entity_Inventory_Slot
  
  *Entity_Inventory_Slot = Entity_Inventory_Slot_Get(*Entity, Slot)
  If Not *Entity_Inventory_Slot
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn *Entity_Inventory_Slot\Count
EndProcedure

Procedure Entity_Inventory_Get_Uses(*Entity.Entity, Slot)
  Protected *Entity_Inventory_Slot.Entity_Inventory_Slot
  
  *Entity_Inventory_Slot = Entity_Inventory_Slot_Get(*Entity, Slot)
  If Not *Entity_Inventory_Slot
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn *Entity_Inventory_Slot\Uses
EndProcedure

Procedure Entity_Inventory_Holding_Slot_Set(*Entity.Entity, Slot)
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Entity\Inventory
    ; Add Error-Handler here
    Log_Add_Error("*Entity\Inventory")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Slot < 0 Or Slot >= *Entity\Inventory\Slots
    ; Add Error-Handler here
    Log_Add_Error("Slot < 0 Or Slot >= *Entity\Inventory\Slots")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Entity\Holding_Slot = Slot
  
  If *Entity\World_Column
    ForEach *Entity\World_Column\Network_Client()
      Network_Client_Packet_Send_Entity_Equipment(*Entity\World_Column\Network_Client(), *Entity\ID, 0, Entity_Inventory_Get_Type(*Entity, Slot), Entity_Inventory_Get_Count(*Entity, Slot), Entity_Inventory_Get_Uses(*Entity, Slot))
    Next
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Entity_Inventory_Get_Free_Slot(*Entity.Entity, Item_Type, Item_Metadata)
  Protected i, Slot
  
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn -1 ; Invalid Slot
  EndIf
  
  If Not *Entity\Inventory
    ; Add Error-Handler here
    Log_Add_Error("*Entity\Inventory")
    ProcedureReturn -1 ; Invalid Slot
  EndIf
  
  If Item_Type < 0 Or Item_Type >= #Item_Amount_Max
    ; Add Error-Handler here
    Log_Add_Error("Item_Type < 0 Or Item_Type >= #Item_Amount_Max")
    ProcedureReturn -1 ; Invalid Slot
  EndIf
  
  ForEach *Entity\Inventory\Slot()
    If *Entity\Inventory\Slot()\Type = Item_Type And *Entity\Inventory\Slot()\Uses = Item_Metadata And *Entity\Inventory\Slot()\Count < Item(Item_Type)\Stackable_Amount
      ProcedureReturn *Entity\Inventory\Slot()\Slot
    EndIf
  Next
  
  For i = 0 To *Entity\Inventory\Slots-1
    Select *Entity\Inventory\Type
      Case #Entity_Inventory_Type_Player
        Select i
          Case 0 To 8 : Slot = i + 36
          Case 36 To 44 : Slot = -1
          Default : Slot = i
        EndSelect
      Default : Slot = i
    EndSelect
    
    If Slot >= 0
      If Entity_Inventory_Get_Type(*Entity, Slot) = -1
        ProcedureReturn Slot
      EndIf
    EndIf
  Next
  
  ProcedureReturn -1 ; Invalid Slot
EndProcedure

Procedure Entity_Inventory_Insert(*Entity.Entity, *Entity_Item.Entity)
  Protected Add, Slot, Item_Type
  Protected *Entity_Type.Entity_Type
  
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Entity_Item
    ; Add Error-Handler here
    Log_Add_Error("*Entity_Item")
    ProcedureReturn #Result_Fail
  EndIf
  
  If *Entity_Item\Type <> #Entity_Type_Item
    ; Add Error-Handler here
    Log_Add_Error("*Entity_Item\Type <> #Entity_Type_Item")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Entity\Inventory
    ; Add Error-Handler here
    Log_Add_Error("*Entity\Inventory")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Entity_Type = Entity_Type_Get(*Entity_Item\Type)
  If Not *Entity_Type
    ; Add Error-Handler here
    Log_Add_Error("Entity_Type_Get")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Entity_Type\Category = #Entity_Type_Item
    ; Add Error-Handler here
    Log_Add_Error("*Entity_Type\Category != #Entity_Type_Item")
    ProcedureReturn #Result_Fail
  EndIf
  
  While *Entity_Item\Item_Count > 0
    Slot = Entity_Inventory_Get_Free_Slot(*Entity, *Entity_Item\Item_Type, *Entity_Item\Item_Uses)
    If Slot = -1
      ProcedureReturn #Result_Fail
    EndIf
    Item_Type = Entity_Inventory_Get_Type(*Entity, Slot)
    If Item_Type = -1
      Entity_Inventory_Set(*Entity, Slot, *Entity_Item\Item_Type, *Entity_Item\Item_Count, *Entity_Item\Item_Uses)
      *Entity_Item\Item_Count = 0
    ElseIf Item_Type >= 0 And Item_Type < #Item_Amount_Max
      Add = Item(Item_Type)\Stackable_Amount - Entity_Inventory_Get_Count(*Entity, Slot)
      If Add > *Entity_Item\Item_Count : Add = *Entity_Item\Item_Count : EndIf
      Entity_Inventory_Set(*Entity, Slot, *Entity_Item\Item_Type, Entity_Inventory_Get_Count(*Entity, Slot)+Add, *Entity_Item\Item_Uses)
      *Entity_Item\Item_Count - Add
      If Add = 0
        Log_Add_Warn("Add = 0. Should NEVER happen!")
        ProcedureReturn #Result_Fail
      EndIf
    EndIf
  Wend
  
  If *Entity_Item\Item_Count = 0
    ForEach *Entity\World_Column\Network_Client()
      Network_Client_Packet_Send_Collect_Item(*Entity\World_Column\Network_Client(), *Entity_Item\ID, *Entity\ID)
    Next
    
    Entity_Delete(*Entity_Item)
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Entity_Inventory_Mouse_Swap(*Entity.Entity, Slot, Rightclick, *Network_Client.Network_Client)
  Protected Temp_Inv_Type, Temp_Inv_Count, Temp_Inv_Uses
  Protected Temp_Mouse_Type, Temp_Mouse_Count, Temp_Mouse_Uses
  Protected Inv_Difference
  
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Entity\Inventory
    ; Add Error-Handler here
    Log_Add_Error("*Entity\Inventory")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Slot < 0 Or Slot >= *Entity\Inventory\Slots
    ; Add Error-Handler here
    Log_Add_Error("Slot < 0 Or Slot >= *Entity\Inventory\Slots")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Network_Client
    ; Add Error-Handler here
    Log_Add_Error("*Network_Client")
    ProcedureReturn #Result_Fail
  EndIf
  
  Temp_Inv_Type  = Entity_Inventory_Get_Type(*Entity, Slot)
  Temp_Inv_Count = Entity_Inventory_Get_Count(*Entity, Slot)
  Temp_Inv_Uses  = Entity_Inventory_Get_Uses(*Entity, Slot)
  Temp_Mouse_Type  = *Network_Client\Inventory_Slot_Mouse\Type
  Temp_Mouse_Count = *Network_Client\Inventory_Slot_Mouse\Count
  Temp_Mouse_Uses  = *Network_Client\Inventory_Slot_Mouse\Uses
  
  If Temp_Mouse_Type <> -1
    If Rightclick
      Inv_Difference = 1
    Else
      Inv_Difference = Temp_Mouse_Count
    EndIf
  Else
    If Rightclick
      Inv_Difference = -Temp_Inv_Count/2
    Else
      Inv_Difference = -Temp_Inv_Count
    EndIf
  EndIf
  
  If Inv_Difference > Temp_Mouse_Count       : Inv_Difference = Temp_Mouse_Count       : EndIf
  If Inv_Difference < -Temp_Inv_Count        : Inv_Difference = -Temp_Inv_Count        : EndIf
  
  If Inv_Difference > 64-Temp_Inv_Count      : Inv_Difference = 64-Temp_Inv_Count      : EndIf
  If Inv_Difference < -(64-Temp_Mouse_Count) : Inv_Difference = -(64-Temp_Mouse_Count) : EndIf
  
  If Temp_Inv_Type <> Temp_Mouse_Type And Temp_Inv_Type <> -1 And Temp_Mouse_Type <> -1
    Entity_Inventory_Set(*Entity, Slot, Temp_Mouse_Type, Temp_Mouse_Count, Temp_Mouse_Uses)
    *Network_Client\Inventory_Slot_Mouse\Type  = Temp_Inv_Type
    *Network_Client\Inventory_Slot_Mouse\Count = Temp_Inv_Count
    *Network_Client\Inventory_Slot_Mouse\Uses  = Temp_Inv_Uses
  ElseIf Inv_Difference > 0
    Entity_Inventory_Set(*Entity, Slot, Temp_Mouse_Type, Temp_Inv_Count+Inv_Difference, Temp_Mouse_Uses)
    *Network_Client\Inventory_Slot_Mouse\Count - Inv_Difference
  ElseIf Inv_Difference < 0
    Entity_Inventory_Set(*Entity, Slot, Temp_Inv_Type, Temp_Inv_Count+Inv_Difference, Temp_Inv_Uses)
    *Network_Client\Inventory_Slot_Mouse\Type  =  Temp_Inv_Type
    *Network_Client\Inventory_Slot_Mouse\Count = -Inv_Difference
    *Network_Client\Inventory_Slot_Mouse\Uses  =  Temp_Inv_Uses
  Else
    Entity_Inventory_Set(*Entity, Slot, Temp_Inv_Type, Temp_Inv_Count, Temp_Inv_Uses)
  EndIf
  If *Network_Client\Inventory_Slot_Mouse\Type = -1 Or *Network_Client\Inventory_Slot_Mouse\Count <= 0
    *Network_Client\Inventory_Slot_Mouse\Type  = -1
    *Network_Client\Inventory_Slot_Mouse\Count = 0
    *Network_Client\Inventory_Slot_Mouse\Uses  = 0
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Entity_Inventory_Main()
  Protected *List_Temp
  Protected *Entity.Entity
  Protected Dist.d
  
  ForEach Entity()
    *Entity = Entity()
    If *Entity\Type = #Entity_Type_Player
      PushListPosition(Entity())
      
      If *Entity\World_Column
        ForEach *Entity\World_Column\Entity()
          If *Entity\World_Column\Entity()\Type = #Entity_Type_Item
            Dist.d = Sqr(Pow(*Entity\World_Column\Entity()\X-*Entity\X,2) + Pow(*Entity\World_Column\Entity()\Y-*Entity\Y,2) + Pow(*Entity\World_Column\Entity()\Z-*Entity\Z,2))
            If Dist <= 2
              Entity_Inventory_Insert(*Entity, *Entity\World_Column\Entity())
            EndIf
          EndIf
        Next
      EndIf
      
      PopListPosition(Entity())
    EndIf
  Next
EndProcedure
Timer_Register("Entity_Inventory", 0, 100, @Entity_Inventory_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 RC 2 (Windows - x64)
; CursorPosition = 429
; FirstLine = 412
; Folding = --
; EnableXP
; DisableDebugger