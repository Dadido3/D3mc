; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure World_Physic_Queue_Add(*World.World, X, Y, Z, *World_Column.World_Column, Trigger_Time, Trigger_Type)
  Protected Bitmask_Offset, *Bitmask.Ascii
  Protected Block_Type
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  World_Block_Get(*World, X, Y, Z, @Block_Type)
  If Block_Type >= 0 And Block_Type <= 255 And Block(Block_Type)\Physic_Type = 0
    ProcedureReturn #Result_Fail
  EndIf
  
  If Block(Block_Type)\Physic_Allowed_Trigger_Type < Trigger_Type
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not Trigger_Time
    Trigger_Time = Timer_Milliseconds()
  EndIf
  
  If Block(Block_Type)\Physic_Quantisation
    Trigger_Time / Block(Block_Type)\Physic_Quantisation
    Trigger_Time * Block(Block_Type)\Physic_Quantisation
  EndIf
  Trigger_Time + Block(Block_Type)\Physic_Time
  If Block(Block_Type)\Physic_Time_Random
    Trigger_Time + Random(Block(Block_Type)\Physic_Time_Random)
  EndIf
  
  If Not *World_Column\Physic_Queue_Mask
    *World_Column\Physic_Queue_Mask = AllocateMemory(#World_Column_Bitmask_Size)
  EndIf
  If Not *World_Column\Physic_Queue_Mask
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Bitmask_Offset = World_Column_Get_Offset(X - *World_Column\X*#World_Column_Size_X, Y - *World_Column\Y*#World_Column_Size_Y, Z)
  If Bitmask_Offset < 0 Or Bitmask_Offset >= #World_Column_Bitmask_Size*8
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  *Bitmask = *World_Column\Physic_Queue_Mask + Bitmask_Offset / 8
  If *Bitmask\a & (1 << (Bitmask_Offset & 7))
    ProcedureReturn #Result_Success
  EndIf
  
  ; Find the correct Queue-Branch to store Elements in
  If ListSize(*World\Physic_Queue()) = 0
    AddElement(*World\Physic_Queue())
    *World\Physic_Queue()\Trigger_Time = Trigger_Time
  ElseIf LastElement(*World\Physic_Queue()) And *World\Physic_Queue()\Trigger_Time < Trigger_Time
    AddElement(*World\Physic_Queue())
    *World\Physic_Queue()\Trigger_Time = Trigger_Time
  Else
    ForEach *World\Physic_Queue()
      If *World\Physic_Queue()\Trigger_Time = Trigger_Time
        Break
      ElseIf *World\Physic_Queue()\Trigger_Time > Trigger_Time
        InsertElement(*World\Physic_Queue())
        *World\Physic_Queue()\Trigger_Time = Trigger_Time
        Break
      EndIf
    Next
  EndIf
  
  ; Add a Element to the branch
  LastElement(*World\Physic_Queue()\Element())
  If Not AddElement(*World\Physic_Queue()\Element())
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  *Bitmask\a | (1 << (Bitmask_Offset & 7))
  *World_Column\Physic_Queue_Size + 1
  
  *World\Physic_Queue()\Element()\X = X
  *World\Physic_Queue()\Element()\Y = Y
  *World\Physic_Queue()\Element()\Z = Z
  *World\Physic_Queue()\Element()\World_Column = *World_Column
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Physic_Queue_Delete(*World.World, *Physic_Queue_Element.World_Physic_Queue_Element)
  Protected Bitmask_Offset, *Bitmask.Ascii
  Protected *World_Column.World_Column
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Physic_Queue_Element
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  *World_Column = *Physic_Queue_Element\World_Column
  
  If Not *World_Column
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column\Physic_Queue_Mask
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Bitmask_Offset = World_Column_Get_Offset(*Physic_Queue_Element\X - *World_Column\X*#World_Column_Size_X, *Physic_Queue_Element\Y - *World_Column\Y*#World_Column_Size_Y, *Physic_Queue_Element\Z)
  *Bitmask = *World_Column\Physic_Queue_Mask + Bitmask_Offset / 8
  *Bitmask\a & ~(1 << (Bitmask_Offset & 7))
  
  *World_Column\Physic_Queue_Size - 1
  
  If *World_Column\Physic_Queue_Size = 0 And *World_Column\Physic_Queue_Mask
    FreeMemory(*World_Column\Physic_Queue_Mask)
    *World_Column\Physic_Queue_Mask = 0
  EndIf
  
  If ListIndex(*World\Physic_Queue()) <> -1 And ListIndex(*World\Physic_Queue()\Element()) <> -1 And *World\Physic_Queue()\Element() = *Physic_Queue_Element
    DeleteElement(*World\Physic_Queue()\Element())
    If ListSize(*World\Physic_Queue()\Element()) = 0
      DeleteElement(*World\Physic_Queue())
    EndIf
  Else
    ForEach *World\Physic_Queue()
      ForEach *World\Physic_Queue()\Element()
        If *World\Physic_Queue()\Element() = *Physic_Queue_Element
          DeleteElement(*World\Physic_Queue()\Element())
          If ListSize(*World\Physic_Queue()\Element()) = 0
            DeleteElement(*World\Physic_Queue())
          EndIf
          Break 2
        EndIf
      Next
    Next
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Physic_Type_10(*World.World, X, Y, Z, Current_Trigger_Time)
  Protected Block_Type
  
  World_Block_Get(*World, X, Y, Z-1, @Block_Type)
  If Block_Type = 0
    World_Block_Swap(*World, X, Y, Z, X, Y, Z-1)
  EndIf
EndProcedure

Procedure World_Physic_Type_12(*World.World, X, Y, Z, Current_Trigger_Time)
  Protected Block_Type
  
  If World_Block_Get(*World, X, Y, Z-1, @Block_Type) And Block_Type = 0
    World_Block_Swap(*World, X, Y, Z, X, Y, Z-1)
  ElseIf World_Block_Get(*World, X+1, Y, Z-1, @Block_Type) And Block_Type = 0
    World_Block_Swap(*World, X, Y, Z, X+1, Y, Z-1)
  ElseIf World_Block_Get(*World, X, Y+1, Z-1, @Block_Type) And Block_Type = 0
    World_Block_Swap(*World, X, Y, Z, X, Y+1, Z-1)
  ElseIf World_Block_Get(*World, X-1, Y, Z-1, @Block_Type) And Block_Type = 0
    World_Block_Swap(*World, X, Y, Z, X-1, Y, Z-1)
  ElseIf World_Block_Get(*World, X, Y-1, Z-1, @Block_Type) And Block_Type = 0
    World_Block_Swap(*World, X, Y, Z, X, Y-1, Z-1)
  EndIf
EndProcedure

Procedure World_Physic_Type_20(*World.World, X, Y, Z, Current_Trigger_Time)
  Protected Temp_Type, Temp_Metadata
  Protected Block_Type, Block_Metadata
  Protected Temp_Height, Height
  
  World_Block_Get(*World, X, Y, Z, @Block_Type, @Block_Metadata)
  
  Select Block_Metadata & $7
    Case 0
      If Block_Metadata & $8
        ; #### Block is spreading
        If World_Block_Get(*World, X, Y, Z+1, @Temp_Type) And Temp_Type = Block_Type
          ; #### There is water above, so it can spread
          If World_Block_Get(*World, X, Y, Z-1, @Temp_Type) And Temp_Type = 0
            ; #### Just falling...
            World_Block_Set(*World, X, Y, Z-1, Block_Type, $8)
          ElseIf World_Block_Get(*World, X, Y, Z-1, @Temp_Type, @Temp_Metadata) And (Temp_Type = Block_Type And Temp_Metadata = 0) Or (Temp_Type <> 0 And Temp_Type <> Block_Type)
            ; #### Spreading sideways
            If World_Block_Get(*World, X+1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X+1, Y  , Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X-1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X-1, Y  , Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X  , Y+1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y+1, Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X  , Y-1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y-1, Z, Block_Type, 7) : EndIf
          EndIf
        Else
          ; #### No water above, so no spreading
          World_Block_Set(*World, X, Y, Z, 0, 0)
        EndIf
      Else
        ; #### Block is a source, so fall or spread sideways
        If World_Block_Get(*World, X, Y, Z-1, @Temp_Type) And Temp_Type = 0
            ; #### Just falling...
            World_Block_Set(*World, X, Y, Z-1, Block_Type, $8)
          ElseIf World_Block_Get(*World, X, Y, Z-1, @Temp_Type, @Temp_Metadata) And (Temp_Type = Block_Type And Temp_Metadata = 0) Or (Temp_Type <> 0 And Temp_Type <> Block_Type)
            ; #### Spreading sideways
            If World_Block_Get(*World, X+1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X+1, Y  , Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X-1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X-1, Y  , Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X  , Y+1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y+1, Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X  , Y-1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y-1, Z, Block_Type, 7) : EndIf
          EndIf
      EndIf
      
    Case 1 To 7
      Temp_Height = 7
      
      If World_Block_Get(*World, X+1, Y  , Z, @Temp_Type) And Temp_Type = Block_Type
        World_Block_Get(*World, X+1, Y  , Z, 0, @Height) : Height & $7
        If Temp_Height > Height : Temp_Height = Height : EndIf
      EndIf
      If World_Block_Get(*World, X-1, Y  , Z, @Temp_Type) And Temp_Type = Block_Type
        World_Block_Get(*World, X-1, Y  , Z, 0, @Height) : Height & $7
        If Temp_Height > Height : Temp_Height = Height : EndIf
      EndIf
      If World_Block_Get(*World, X  , Y+1, Z, @Temp_Type) And Temp_Type = Block_Type
        World_Block_Get(*World, X  , Y+1, Z, 0, @Height) : Height & $7
        If Temp_Height > Height : Temp_Height = Height : EndIf
      EndIf
      If World_Block_Get(*World, X  , Y-1, Z, @Temp_Type) And Temp_Type = Block_Type
        World_Block_Get(*World, X  , Y-1, Z, 0, @Height) : Height & $7
        If Temp_Height > Height : Temp_Height = Height : EndIf
      EndIf
      
      Temp_Height + 1
      If Temp_Height <= 7
        If Block_Metadata & $7 <> Temp_Height
          World_Block_Set(*World, X, Y, Z, Block_Type, Temp_Height)
        EndIf
      Else
        World_Block_Set(*World, X, Y, Z, 0, 0)
      EndIf
      
      If World_Block_Get(*World, X, Y, Z-1, @Temp_Type) And Temp_Type = 0
        ; #### Just falling...
        World_Block_Set(*World, X, Y, Z-1, Block_Type, $8)
      EndIf
      
      Temp_Height + 1
      If Temp_Height <= 7
        ; #### fall Or spread sideways
        If World_Block_Get(*World, X, Y, Z-1, @Temp_Type, @Temp_Metadata) And (Temp_Type = Block_Type And Temp_Metadata = 0) Or (Temp_Type <> 0 And Temp_Type <> Block_Type)
          ; #### Spreading sideways
          If World_Block_Get(*World, X+1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X+1, Y  , Z, Block_Type, Temp_Height) : EndIf
          If World_Block_Get(*World, X-1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X-1, Y  , Z, Block_Type, Temp_Height) : EndIf
          If World_Block_Get(*World, X  , Y+1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y+1, Z, Block_Type, Temp_Height) : EndIf
          If World_Block_Get(*World, X  , Y-1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y-1, Z, Block_Type, Temp_Height) : EndIf
        EndIf
      EndIf
      
  EndSelect
EndProcedure

Procedure World_Physic_Type_22(*World.World, X, Y, Z, Current_Trigger_Time)
  Protected Block_Type
  
  If World_Block_Get(*World, X, Y, Z-1, @Block_Type) And Block_Type = 0
    World_Block_Copy(*World, X, Y, Z, X, Y, Z-1)
  ElseIf World_Block_Get(*World, X+1, Y, Z, @Block_Type) And Block_Type = 0
    World_Block_Copy(*World, X, Y, Z, X+1, Y, Z)
  ElseIf World_Block_Get(*World, X, Y+1, Z, @Block_Type) And Block_Type = 0
    World_Block_Copy(*World, X, Y, Z, X, Y+1, Z)
  ElseIf World_Block_Get(*World, X-1, Y, Z, @Block_Type) And Block_Type = 0
    World_Block_Copy(*World, X, Y, Z, X-1, Y, Z)
  ElseIf World_Block_Get(*World, X, Y-1, Z, @Block_Type) And Block_Type = 0
    World_Block_Copy(*World, X, Y, Z, X, Y-1, Z)
  EndIf
EndProcedure

Procedure World_Physic_Type_30(*World.World, X, Y, Z, Current_Trigger_Time)
  Protected Temp_Type, Temp_Metadata
  Protected Block_Type, Block_Metadata
  Protected Temp_Height, Height
  
  World_Block_Get(*World, X, Y, Z, @Block_Type, @Block_Metadata)
  
  Select Block_Metadata & $7
    Case 0
      If Block_Metadata & $8
        ; #### Block is spreading
        If World_Block_Get(*World, X, Y, Z+1, @Temp_Type) And Temp_Type = Block_Type
          ; #### There is water above, so it can spread
          If World_Block_Get(*World, X, Y, Z-1, @Temp_Type) And Temp_Type = 0
            ; #### Just falling...
            World_Block_Set(*World, X, Y, Z-1, Block_Type, $8)
          ElseIf World_Block_Get(*World, X, Y, Z-1, @Temp_Type, @Temp_Metadata) And (Temp_Type = Block_Type And Temp_Metadata = 0) Or (Temp_Type <> 0 And Temp_Type <> Block_Type)
            ; #### Spreading sideways
            If World_Block_Get(*World, X+1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X+1, Y  , Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X-1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X-1, Y  , Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X  , Y+1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y+1, Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X  , Y-1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y-1, Z, Block_Type, 7) : EndIf
          EndIf
        Else
          ; #### No water above, so no spreading
          World_Block_Set(*World, X, Y, Z, 0, 0)
        EndIf
      Else
        ; #### Block is a source, so fall or spread sideways
        If World_Block_Get(*World, X, Y, Z-1, @Temp_Type) And Temp_Type = 0
            ; #### Just falling...
            World_Block_Set(*World, X, Y, Z-1, Block_Type, $8)
          ElseIf World_Block_Get(*World, X, Y, Z-1, @Temp_Type, @Temp_Metadata) And (Temp_Type = Block_Type And Temp_Metadata = 0) Or (Temp_Type <> 0 And Temp_Type <> Block_Type)
            ; #### Spreading sideways
            If World_Block_Get(*World, X+1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X+1, Y  , Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X-1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X-1, Y  , Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X  , Y+1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y+1, Z, Block_Type, 7) : EndIf
            If World_Block_Get(*World, X  , Y-1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y-1, Z, Block_Type, 7) : EndIf
          EndIf
      EndIf
      
    Case 1 To 7
      Temp_Height = 7
      
      If World_Block_Get(*World, X+1, Y  , Z, @Temp_Type) And Temp_Type = Block_Type
        World_Block_Get(*World, X+1, Y  , Z, 0, @Height) : Height & $7
        If Temp_Height > Height : Temp_Height = Height : EndIf
      EndIf
      If World_Block_Get(*World, X-1, Y  , Z, @Temp_Type) And Temp_Type = Block_Type
        World_Block_Get(*World, X-1, Y  , Z, 0, @Height) : Height & $7
        If Temp_Height > Height : Temp_Height = Height : EndIf
      EndIf
      If World_Block_Get(*World, X  , Y+1, Z, @Temp_Type) And Temp_Type = Block_Type
        World_Block_Get(*World, X  , Y+1, Z, 0, @Height) : Height & $7
        If Temp_Height > Height : Temp_Height = Height : EndIf
      EndIf
      If World_Block_Get(*World, X  , Y-1, Z, @Temp_Type) And Temp_Type = Block_Type
        World_Block_Get(*World, X  , Y-1, Z, 0, @Height) : Height & $7
        If Temp_Height > Height : Temp_Height = Height : EndIf
      EndIf
      
      Temp_Height + 1
      If Temp_Height <= 7
        If Block_Metadata & $7 <> Temp_Height
          World_Block_Set(*World, X, Y, Z, Block_Type, Temp_Height)
        EndIf
      Else
        World_Block_Set(*World, X, Y, Z, 0, 0)
      EndIf
      
      If World_Block_Get(*World, X, Y, Z-1, @Temp_Type) And Temp_Type = 0
        ; #### Just falling...
        World_Block_Set(*World, X, Y, Z-1, Block_Type, $8)
      EndIf
      
      Temp_Height + 1
      If Temp_Height <= 7
        ; #### fall Or spread sideways
        If World_Block_Get(*World, X, Y, Z-1, @Temp_Type, @Temp_Metadata) And (Temp_Type = Block_Type And Temp_Metadata = 0) Or (Temp_Type <> 0 And Temp_Type <> Block_Type)
          ; #### Spreading sideways
          If World_Block_Get(*World, X+1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X+1, Y  , Z, Block_Type, Temp_Height) : EndIf
          If World_Block_Get(*World, X-1, Y  , Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X-1, Y  , Z, Block_Type, Temp_Height) : EndIf
          If World_Block_Get(*World, X  , Y+1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y+1, Z, Block_Type, Temp_Height) : EndIf
          If World_Block_Get(*World, X  , Y-1, Z, @Temp_Type) And Temp_Type = 0 : World_Block_Set(*World, X  , Y-1, Z, Block_Type, Temp_Height) : EndIf
        EndIf
      EndIf
      
  EndSelect
EndProcedure

Procedure World_Physic_Type_100(*World.World, X, Y, Z, Current_Trigger_Time)
  Protected Block_Type, Temp_Type
  Protected ix, iy, iz
  
  World_Block_Get(*World, X, Y, Z, @Block_Type)
  
  For ix = -1 To 1
    For iy = -1 To 1
      For iz = -1 To 1
        If World_Block_Get(*World, X+ix, Y+iy, Z+iz, @Temp_Type) And Temp_Type = Block_Type : World_Block_Set(*World, X+ix, Y+iy, Z+iz, 0, 0) : EndIf
      Next
    Next
  Next
  
EndProcedure

Procedure World_Physic_Do()
  Protected Max_Time
  Protected X, Y, Z, *World_Column.World_Column, Current_Trigger_Time
  Protected Block_Type, Metadata
  Protected Current_Time.q
  
  ForEach World()
    
    Current_Time = Timer_Milliseconds()
    
    Max_Time = Timer_Milliseconds() + 50
    While FirstElement(World()\Physic_Queue()) And World()\Physic_Queue()\Trigger_Time <= Current_Time And FirstElement(World()\Physic_Queue()\Element()) And Max_Time > Timer_Milliseconds()
      
      X = World()\Physic_Queue()\Element()\X
      Y = World()\Physic_Queue()\Element()\Y
      Z = World()\Physic_Queue()\Element()\Z
      *World_Column = World()\Physic_Queue()\Element()\World_Column
      Current_Trigger_Time = World()\Physic_Queue()\Trigger_Time
      World_Physic_Queue_Delete(World(), World()\Physic_Queue()\Element())
      
      World_Block_Get(World(), X, Y, Z, @Block_Type, @Metadata)
      If Block_Type >= 0 And Block_Type <= 255
        If Block(Block_Type)\Physic_Repeat
          World_Physic_Queue_Add(World(), X, Y, Z, *World_Column, Current_Trigger_Time, 0)
        EndIf
        Select Block(Block_Type)\Physic_Type
          Case 1   : Plugin_Do_Event_World_Physic(Block(Block_Type)\Physic_Event, World(), X, Y, Z, Block_Type, Metadata, Current_Trigger_Time)
          Case 10  : World_Physic_Type_10(World(), X, Y, Z, Current_Trigger_Time)
          Case 12  : World_Physic_Type_12(World(), X, Y, Z, Current_Trigger_Time)
          Case 20  : World_Physic_Type_20(World(), X, Y, Z, Current_Trigger_Time)
          Case 22  : World_Physic_Type_22(World(), X, Y, Z, Current_Trigger_Time)
          Case 30  : World_Physic_Type_30(World(), X, Y, Z, Current_Trigger_Time)
          Case 100 : World_Physic_Type_100(World(), X, Y, Z, Current_Trigger_Time)
        EndSelect
      EndIf
      
    Wend
    
  Next
  
EndProcedure
Timer_Register("World_Physic", 0, 10, @World_Physic_Do())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################


; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 413
; FirstLine = 402
; Folding = --
; EnableXP