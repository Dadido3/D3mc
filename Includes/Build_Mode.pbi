; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Build_Mode_Main
  File_Save.i
  File_Last_Date.i
EndStructure

; #################################################### Variables #################################################

Global Build_Mode_Main.Build_Mode_Main

Global NewList Build_Mode.Build_Mode()

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Prototypes ################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Build_Mode_Creative_Place(*Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z)
  Protected Temp_Type, Temp_Metadata
  Protected Item_Type, Item_Metadata, Slot
  Protected Block_Type
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Network_Client\Entity
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Network_Client\Entity\Inventory
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ; Do Rightclick-Action of the Block if there is one
  If World_Block_Get(*World, X, Y, Z, @Temp_Type, @Temp_Metadata)
    If Block(Temp_Type)\Rightclick_Event
      Plugin_Do_Event_Block_Rightclick(Block(Temp_Type)\Rightclick_Event, *Network_Client, *World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Temp_Type, Temp_Metadata)
      ProcedureReturn #Result_Success
    EndIf
  EndIf
  
  Slot = *Network_Client\Entity\Holding_Slot
  
  If Slot < 0 Or Slot >= *Network_Client\Entity\Inventory\Slots
    ; Add Error-Handler here
    Log_Add_Error("Slot < 0 Or Slot >= *Entity\Inventory\Slots")
    ProcedureReturn #Result_Fail
  EndIf
  
  Item_Type = Entity_Inventory_Get_Type(*Network_Client\Entity, Slot)
  If Item_Type < 0 Or Item_Type >= #Item_Amount_Max
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Item_Metadata = Entity_Inventory_Get_Uses(*Network_Client\Entity, Slot)
  If Item_Metadata < 0
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ; Do Place-Action of the Item if there is one
  If Item(Item_Type)\Place_Event
    Plugin_Do_Event_Item_Place(Item(Item_Type)\Place_Event, *Network_Client, *World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Item_Type, Item_Metadata)
    ProcedureReturn #Result_Success
  EndIf
  
  Select Direction
    Case 0 : Z - 1 : Case 1 : Z + 1 : Case 2 : Y - 1 : Case 3 : Y + 1 : Case 4 : X - 1 : Case 5 : X + 1 : Default : ProcedureReturn #Result_Fail
  EndSelect
  
  Block_Type = Item(Item_Type)\Corresponding_Block
  If Block_Type < 0 Or Block_Type > 255
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not World_Block_Set(*World, X, Y, Z, Block_Type, Item_Metadata, -1, -1, -1, 2)
    ProcedureReturn #Result_Fail
  EndIf
  
  ;Entity_Inventory_Set(*Network_Client\Entity, Slot, Entity_Inventory_Get_Type(*Network_Client\Entity, Slot), Entity_Inventory_Get_Count(*Network_Client\Entity, Slot)-1, Entity_Inventory_Get_Uses(*Network_Client\Entity, Slot))
  ProcedureReturn #Result_Success
EndProcedure

Procedure Build_Mode_Creative_Dig(*Network_Client.Network_Client, *World.World, X, Y, Z, Face, State)
  Protected Temp_Type, Temp_Metadata
  Protected Item_Type, Item_Metadata, Slot
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Network_Client\Entity
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Network_Client\Entity\Inventory
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ; Do Leftclick-Action if there is one
  If World_Block_Get(*World, X, Y, Z, @Temp_Type, @Temp_Metadata)
    If Block(Temp_Type)\Leftclick_Event
      Plugin_Do_Event_Block_Leftclick(Block(Temp_Type)\Leftclick_Event, *Network_Client, *World, X, Y, Z, Face, State, Temp_Type, Temp_Metadata)
      ProcedureReturn #Result_Success
    EndIf
  EndIf
  
  Slot = *Network_Client\Entity\Holding_Slot
  
  If Slot < 0 Or Slot >= *Network_Client\Entity\Inventory\Slots
    ; Add Error-Handler here
    Log_Add_Error("Slot < 0 Or Slot >= *Entity\Inventory\Slots")
    ProcedureReturn #Result_Fail
  EndIf
  
  ; Do Dig-Action of the Item if there is one
  Item_Type = Entity_Inventory_Get_Type(*Network_Client\Entity, Slot)
  Item_Metadata = Entity_Inventory_Get_Uses(*Network_Client\Entity, Slot)
  If Item_Type >= 0 And Item_Type < #Item_Amount_Max
    If Item(Item_Type)\Dig_Event
      Plugin_Do_Event_Item_Dig(Item(Item_Type)\Dig_Event, *Network_Client, *World, X, Y, Z, Face, State, Item_Type, Item_Metadata)
      ProcedureReturn #Result_Success
    EndIf
  EndIf
  
  ;If State = 4
  ;  ProcedureReturn #Result_Fail
  ;EndIf
  
  ProcedureReturn World_Block_Destroy(*World, X, Y, Z, 0, #False)
EndProcedure

Procedure Build_Mode_Box_Place(*Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z)
  Protected Item_Type, Slot, Replace_Type, Temp_Type, Block_Type, Metadata
  Protected ix, iy, iz
  Protected X_0, Y_0, Z_0, X_1, Y_1, Z_1
  Protected Surface
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Select Direction
    Case 0 : Z - 1 : Case 1 : Z + 1 : Case 2 : Y - 1 : Case 3 : Y + 1 : Case 4 : X - 1 : Case 5 : X + 1 : Default : ProcedureReturn #Result_Fail
  EndSelect
  
  If *Network_Client\Entity
    
    If Not *Network_Client\Entity\Inventory
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    
    Slot = *Network_Client\Entity\Holding_Slot
    
    If Slot < 0 Or Slot >= *Network_Client\Entity\Inventory\Slots
      ; Add Error-Handler here
      Log_Add_Error("Slot < 0 Or Slot >= *Entity\Inventory\Slots")
      ProcedureReturn #Result_Fail
    EndIf
    
    Item_Type = Entity_Inventory_Get_Type(*Network_Client\Entity, Slot)
    Metadata = Entity_Inventory_Get_Uses(*Network_Client\Entity, Slot)
    
    Block_Type = Item(Item_Type)\Corresponding_Block
    If Block_Type < 0 Or Block_Type > 255
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    
    If Z >= 0 And Z < #World_Column_Size_Z
      Select *Network_Client\Build_Mode\State
        Case 0
          *Network_Client\Build_Mode\State + 1
          *Network_Client\Build_Mode\Coordinate[0]\X = X
          *Network_Client\Build_Mode\Coordinate[0]\Y = Y
          *Network_Client\Build_Mode\Coordinate[0]\Z = Z
          
        Case 1
          *Network_Client\Build_Mode\State + 1
          X_0 = *Network_Client\Build_Mode\Coordinate[0]\X
          Y_0 = *Network_Client\Build_Mode\Coordinate[0]\Y
          Z_0 = *Network_Client\Build_Mode\Coordinate[0]\Z
          X_1 = X
          Y_1 = Y
          Z_1 = Z
          If X_0 > X_1
            Swap X_0, X_1
          EndIf
          If Y_0 > Y_1
            Swap Y_0, Y_1
          EndIf
          If Z_0 > Z_1
            Swap Z_0, Z_1
          EndIf
          Replace_Type = Build_Mode_Integer_Get(*Network_Client, 0)
          For ix = X_0 To X_1
            For iy = Y_0 To Y_1
              For iz = Z_0 To Z_1
                If Replace_Type = -1 Or (World_Block_Get(*World, ix, iy, iz, @Temp_Type) And Temp_Type = Replace_Type)
                  If ix = X_0 Or ix = X_1 Or iy = Y_0 Or iy = Y_1 Or iz = Z_0 Or iz = Z_1
                    World_Block_Set(*World, ix, iy, iz, Block_Type, Metadata, -1, -1, -1, 1, 1, 1)
                  Else
                    World_Block_Set(*World, ix, iy, iz, Block_Type, Metadata, -1, -1, -1, 1, 1, 0)
                  EndIf
                EndIf
              Next
            Next
          Next
          Build_Mode_Set(*Network_Client, "")
          
      EndSelect
    EndIf
    
  EndIf
EndProcedure

Procedure Build_Mode_Box_Dig(*Network_Client.Network_Client, *World.World, X, Y, Z, Face, State)
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If State = 4
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn World_Block_Destroy(*World, X, Y, Z, 0, #False)
EndProcedure

;---------------------------------------------------------------

Procedure Build_Mode_Do_Place(*Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z)
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Build_Mode()
    If Build_Mode()\ID = *Network_Client\Build_Mode\Mode
      
      If Build_Mode()\Place_Function
        CallFunctionFast(Build_Mode()\Place_Function, *Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z)
      EndIf
      
      Break
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Build_Mode_Do_Dig(*Network_Client.Network_Client, *World.World, X, Y, Z, Face, State)
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Build_Mode()
    If Build_Mode()\ID = *Network_Client\Build_Mode\Mode
      
      If Build_Mode()\Dig_Function
        CallFunctionFast(Build_Mode()\Dig_Function, *Network_Client, *World.World, X, Y, Z, Face, State)
      EndIf
      
      Break
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Build_Mode_Set(*Network_Client.Network_Client, Mode.s)
  Protected i
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  *Network_Client\Build_Mode\State = 0
  For i = 0 To #Network_Client_Build_Mode_Variables-1
    *Network_Client\Build_Mode\Integer[i] = 0
  Next
  
  ForEach Build_Mode()
    If Build_Mode()\ID = Mode
      
      *Network_Client\Build_Mode\Mode = Mode
      
      ProcedureReturn #Result_Success
    EndIf
  Next
  
  *Network_Client\Build_Mode\Mode = "Creative"
  
  ProcedureReturn #Result_Fail
EndProcedure

Procedure Build_Mode_Integer_Set(*Network_Client.Network_Client, Number, Value.q)
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Number < 0 Or Number >= #Network_Client_Build_Mode_Variables
    ProcedureReturn #Result_Fail
  EndIf
  
  *Network_Client\Build_Mode\Integer[Number] = Value
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Build_Mode_Integer_Get(*Network_Client.Network_Client, Number)
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn 0
  EndIf
  
  If Number < 0 Or Number >= #Network_Client_Build_Mode_Variables
    ProcedureReturn 0
  EndIf
  
  ProcedureReturn *Network_Client\Build_Mode\Integer[Number]
EndProcedure

Procedure Build_Mode_Init_Internal()
  ForEach Build_Mode()
    Select Build_Mode()\ID
      Case "Creative" : Build_Mode()\Dig_Function = @Build_Mode_Creative_Dig() : Build_Mode()\Place_Function = @Build_Mode_Creative_Place()
      Case "Box" : Build_Mode()\Dig_Function = @Build_Mode_Box_Dig() : Build_Mode()\Place_Function = @Build_Mode_Box_Place()
    EndSelect
  Next
EndProcedure

Procedure Build_Mode_Load(Filename.s)
  Protected i
  
  If OpenPreferences(Filename.s)
    
    ClearList(Build_Mode())
    
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        AddElement(Build_Mode())
        
        Build_Mode()\ID = PreferenceGroupName()
        Build_Mode()\Name = ReadPreferenceString("Name", "")
        
      Wend
    EndIf
    
    Build_Mode_Init_Internal()
    
    ClosePreferences()
    ;Build_Mode_Main\File_Save = 1
    Build_Mode_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure Build_Mode_Save(Filename.s)
  Protected i
  Protected File_ID
  
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    ForEach Build_Mode()
      WriteStringN(File_ID, "["+Build_Mode()\ID+"]")
      WriteStringN(File_ID, "Name = "+Build_Mode()\Name)
      WriteStringN(File_ID, "")
    Next
    
    CloseFile(File_ID)
    Build_Mode_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure Build_Mode_Main()
  Protected Filename.s
  Filename = Space(Files_File_Get("Build_Mode", 0))
  Files_File_Get("Build_Mode", @Filename)
  
  If Build_Mode_Main\File_Save
    Build_Mode_Main\File_Save = 0
    
    Build_Mode_Save(Filename)
  Else
    
    If Build_Mode_Main\File_Last_Date <> GetFileDate(Filename, #PB_Date_Modified)
      Build_Mode_Load(Filename)
    EndIf
  EndIf
  
EndProcedure
Timer_Register("Build_Mode", 0, 1000, @Build_Mode_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################


; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 398
; FirstLine = 360
; Folding = ---
; EnableXP