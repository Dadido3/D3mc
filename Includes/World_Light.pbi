; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure World_Light_Queue_Add(*World.World, X, Y, Z, *World_Column.World_Column)
  Protected Bitmask_Offset, *Bitmask.Ascii
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column\Light_Queue_Mask
    *World_Column\Light_Queue_Mask = AllocateMemory(#World_Column_Bitmask_Size)
  EndIf
  If Not *World_Column\Light_Queue_Mask
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Bitmask_Offset = World_Column_Get_Offset(X - *World_Column\X*#World_Column_Size_X, Y - *World_Column\Y*#World_Column_Size_Y, Z)
  If Bitmask_Offset < 0 Or Bitmask_Offset >= #World_Column_Bitmask_Size*8
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  *Bitmask = *World_Column\Light_Queue_Mask + Bitmask_Offset / 8
  If *Bitmask\a & (1 << (Bitmask_Offset & 7))
    ProcedureReturn #Result_Success
  EndIf
  
  LastElement(*World\Light_Queue())
  If Not AddElement(*World\Light_Queue())
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  *Bitmask\a | (1 << (Bitmask_Offset & 7))
  *World_Column\Light_Queue_Size + 1
  
  *World\Light_Queue()\X = X
  *World\Light_Queue()\Y = Y
  *World\Light_Queue()\Z = Z
  *World\Light_Queue()\World_Column = *World_Column
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Light_Queue_Delete(*World.World, *Light_Queue.Coordinate)
  Protected Bitmask_Offset, *Bitmask.Ascii
  Protected *World_Column.World_Column
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Light_Queue
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  *World_Column = *Light_Queue\World_Column
  
  If Not *World_Column
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column\Light_Queue_Mask
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Bitmask_Offset = World_Column_Get_Offset(*Light_Queue\X - *World_Column\X*#World_Column_Size_X, *Light_Queue\Y - *World_Column\Y*#World_Column_Size_Y, *Light_Queue\Z)
  *Bitmask = *World_Column\Light_Queue_Mask + Bitmask_Offset / 8
  *Bitmask\a & ~(1 << (Bitmask_Offset & 7))
  
  *World_Column\Light_Queue_Size - 1
  
  If *World_Column\Light_Queue_Size = 0 And *World_Column\Light_Queue_Mask
    FreeMemory(*World_Column\Light_Queue_Mask)
    *World_Column\Light_Queue_Mask = 0
  EndIf
  
  ChangeCurrentElement(*World\Light_Queue(), *Light_Queue)
  
  DeleteElement(*World\Light_Queue())
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Light_Do(*World.World)
  Protected Max_Time
  Protected X, Y, Z
  Protected Block_Type
  Protected Temp_BlockLight, Block_BlockLight, Old_BlockLight
  Protected Temp_SkyLight, Block_SkyLight, Old_SkyLight
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Max_Time = Timer_Milliseconds() + 50
  
  While FirstElement(*World\Light_Queue()) And Max_Time > Timer_Milliseconds()
    
    X = *World\Light_Queue()\X
    Y = *World\Light_Queue()\Y
    Z = *World\Light_Queue()\Z
    World_Light_Queue_Delete(*World, *World\Light_Queue())
    
    World_Block_Get(*World, X, Y, Z, @Block_Type, 0, @Old_BlockLight, @Old_SkyLight)
    If Block_Type >= 0
      
      If Block(Block_Type)\Light_Decrease < 15
        ; #### Start value
        Block_BlockLight = 0
        ; #### X+ Block
        World_Block_Get(*World, X+1, Y  , Z  , 0, 0, @Temp_BlockLight)
        If Block_BlockLight < Temp_BlockLight : Block_BlockLight = Temp_BlockLight : EndIf
        ; #### X- Block
        World_Block_Get(*World, X-1, Y  , Z  , 0, 0, @Temp_BlockLight)
        If Block_BlockLight < Temp_BlockLight : Block_BlockLight = Temp_BlockLight : EndIf
        ; #### Y+ Block
        World_Block_Get(*World, X  , Y+1, Z  , 0, 0, @Temp_BlockLight)
        If Block_BlockLight < Temp_BlockLight : Block_BlockLight = Temp_BlockLight : EndIf
        ; #### Y- Block
        World_Block_Get(*World, X  , Y-1, Z  , 0, 0, @Temp_BlockLight)
        If Block_BlockLight < Temp_BlockLight : Block_BlockLight = Temp_BlockLight : EndIf
        ; #### Z+ Block
        World_Block_Get(*World, X  , Y  , Z+1, 0, 0, @Temp_BlockLight)
        If Block_BlockLight < Temp_BlockLight : Block_BlockLight = Temp_BlockLight : EndIf
        ; #### Z- Block
        World_Block_Get(*World, X  , Y  , Z-1, 0, 0, @Temp_BlockLight)
        If Block_BlockLight < Temp_BlockLight : Block_BlockLight = Temp_BlockLight : EndIf
        ; #### Decrease
        Block_BlockLight - Block(Block_Type)\Light_Decrease
        ; #### Emitting
        If Block_BlockLight < Block(Block_Type)\Light_Emit : Block_BlockLight = Block(Block_Type)\Light_Emit : EndIf
        
        World_Block_Get(*World, X  , Y  , Z+1, 0, 0, 0, @Temp_SkyLight)
        If Temp_SkyLight = 15 Or Temp_SkyLight = -1
          ; #### Sunlight from Top
          Block_SkyLight = 15 - Block(Block_Type)\Light_Decrease + 1
        Else
          ; #### Start value
          Block_SkyLight = 0
          ; #### X+ Block
          World_Block_Get(*World, X+1, Y  , Z  , 0, 0, 0, @Temp_SkyLight)
          If Block_SkyLight < Temp_SkyLight : Block_SkyLight = Temp_SkyLight : EndIf
          ; #### X- Block
          World_Block_Get(*World, X-1, Y  , Z  , 0, 0, 0, @Temp_SkyLight)
          If Block_SkyLight < Temp_SkyLight : Block_SkyLight = Temp_SkyLight : EndIf
          ; #### Y+ Block
          World_Block_Get(*World, X  , Y+1, Z  , 0, 0, 0, @Temp_SkyLight)
          If Block_SkyLight < Temp_SkyLight : Block_SkyLight = Temp_SkyLight : EndIf
          ; #### Y- Block
          World_Block_Get(*World, X  , Y-1, Z  , 0, 0, 0, @Temp_SkyLight)
          If Block_SkyLight < Temp_SkyLight : Block_SkyLight = Temp_SkyLight : EndIf
          ; #### Z+ Block
          World_Block_Get(*World, X  , Y  , Z+1, 0, 0, 0, @Temp_SkyLight)
          If Block_SkyLight < Temp_SkyLight : Block_SkyLight = Temp_SkyLight : EndIf
          ; #### Z- Block
          World_Block_Get(*World, X  , Y  , Z-1, 0, 0, 0, @Temp_SkyLight)
          If Block_SkyLight < Temp_SkyLight : Block_SkyLight = Temp_SkyLight : EndIf
          ; #### Decrease
          Block_SkyLight - Block(Block_Type)\Light_Decrease
        EndIf
        
      Else
        Block_BlockLight = Block(Block_Type)\Light_Emit
        Block_SkyLight = 0
      EndIf
      
      If Block_BlockLight < 0 : Block_BlockLight = 0 : EndIf
      If Block_SkyLight < 0 : Block_SkyLight = 0 : EndIf
      
      If Block_BlockLight <> Old_BlockLight Or Block_SkyLight <> Old_SkyLight
        If World_Block_Set(*World, X, Y, Z, -1, -1, Block_BlockLight, Block_SkyLight)
          World_Light_Queue_Add(*World, X  , Y  , Z+1, World_Column_Get(*World, World_Get_Column_X(X  ), World_Get_Column_Y(Y  )))
          World_Light_Queue_Add(*World, X  , Y  , Z-1, World_Column_Get(*World, World_Get_Column_X(X  ), World_Get_Column_Y(Y  )))
          World_Light_Queue_Add(*World, X  , Y+1, Z  , World_Column_Get(*World, World_Get_Column_X(X  ), World_Get_Column_Y(Y+1)))
          World_Light_Queue_Add(*World, X  , Y-1, Z  , World_Column_Get(*World, World_Get_Column_X(X  ), World_Get_Column_Y(Y-1)))
          World_Light_Queue_Add(*World, X+1, Y  , Z  , World_Column_Get(*World, World_Get_Column_X(X+1), World_Get_Column_Y(Y  )))
          World_Light_Queue_Add(*World, X-1, Y  , Z  , World_Column_Get(*World, World_Get_Column_X(X-1), World_Get_Column_Y(Y  )))
        EndIf
      EndIf
      
    EndIf
    
  Wend
EndProcedure

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################


; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 122
; FirstLine = 120
; Folding = -
; EnableXP