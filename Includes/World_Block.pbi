; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure World_Block_Destroy(*World.World, X, Y, Z, Current_Trigger_Time=0, Spawn_Pickup=#False)
  Protected *World_Column.World_Column
  Protected *Entity.Entity
  Protected Column_X, Column_Y, Column_Pos_X, Column_Pos_Y, Column_Pos_Z
  Protected Old_Type, Old_Metadata
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Column_X = World_Get_Column_X(X)
  Column_Y = World_Get_Column_Y(Y)
  Column_Pos_X = X - Column_X * #World_Column_Size_X
  Column_Pos_Y = Y - Column_Y * #World_Column_Size_Y
  Column_Pos_Z = Z
  
  *World_Column = World_Column_Get(*World, Column_X, Column_Y)
  If Not *World_Column
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  World_Column_Block_Get(*World, *World_Column, Column_Pos_X, Column_Pos_Y, Column_Pos_Z, @Old_Type, @Old_Metadata)
  If Old_Type < 0 Or Old_Type > 255
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not World_Column_Block_Set(*World, *World_Column, Column_Pos_X, Column_Pos_Y, Column_Pos_Z, Block(Old_Type)\After_Delete, 0, -1, -1, -1, 2)
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Spawn_Pickup
    *Entity = Entity_Add(*World, X+0.5, Y+0.5, Z+0.5, 1, "")
    If *Entity
      *Entity\Item_Type = Block(Old_Type)\Corresponding_Item
      *Entity\Item_Count = 1
      *Entity\Item_Uses = Old_Metadata
    EndIf
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Block_Swap(*World.World, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Current_Trigger_Time=0)
  Protected *World_Column_0.World_Column
  Protected *World_Column_1.World_Column
  Protected Column_X_0, Column_Y_0, Column_Pos_X_0, Column_Pos_Y_0, Column_Pos_Z_0
  Protected Column_X_1, Column_Y_1, Column_Pos_X_1, Column_Pos_Y_1, Column_Pos_Z_1
  Protected Temp_Type_0, Temp_Metadata_0
  Protected Temp_Type_1, Temp_Metadata_1
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Column_X_0 = World_Get_Column_X(X_0)
  Column_Y_0 = World_Get_Column_Y(Y_0)
  Column_Pos_X_0 = X_0 - Column_X_0 * #World_Column_Size_X
  Column_Pos_Y_0 = Y_0 - Column_Y_0 * #World_Column_Size_Y
  Column_Pos_Z_0 = Z_0
  Column_X_1 = World_Get_Column_X(X_1)
  Column_Y_1 = World_Get_Column_Y(Y_1)
  Column_Pos_X_1 = X_1 - Column_X_1 * #World_Column_Size_X
  Column_Pos_Y_1 = Y_1 - Column_Y_1 * #World_Column_Size_Y
  Column_Pos_Z_1 = Z_1
  
  *World_Column_0 = World_Column_Get(*World, Column_X_0, Column_Y_0)
  If Not *World_Column_0
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  *World_Column_1 = World_Column_Get(*World, Column_X_1, Column_Y_1)
  If Not *World_Column_1
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  World_Column_Block_Get(*World, *World_Column_0, Column_Pos_X_0, Column_Pos_Y_0, Column_Pos_Z_0, @Temp_Type_0, @Temp_Metadata_0)
  World_Column_Block_Get(*World, *World_Column_1, Column_Pos_X_1, Column_Pos_Y_1, Column_Pos_Z_1, @Temp_Type_1, @Temp_Metadata_1)
  
  If Not World_Column_Block_Set(*World, *World_Column_0, Column_Pos_X_0, Column_Pos_Y_0, Column_Pos_Z_0, Temp_Type_1, Temp_Metadata_1)
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not World_Column_Block_Set(*World, *World_Column_1, Column_Pos_X_1, Column_Pos_Y_1, Column_Pos_Z_1, Temp_Type_0, Temp_Metadata_0)
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Block_Copy(*World.World, X_0, Y_0, Z_0, X_1, Y_1, Z_1, Current_Trigger_Time=0)
  Protected *World_Column_0.World_Column
  Protected *World_Column_1.World_Column
  Protected Column_X_0, Column_Y_0, Column_Pos_X_0, Column_Pos_Y_0, Column_Pos_Z_0
  Protected Column_X_1, Column_Y_1, Column_Pos_X_1, Column_Pos_Y_1, Column_Pos_Z_1
  Protected Temp_Type_0, Temp_Metadata_0
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Column_X_0 = World_Get_Column_X(X_0)
  Column_Y_0 = World_Get_Column_Y(Y_0)
  Column_Pos_X_0 = X_0 - Column_X_0 * #World_Column_Size_X
  Column_Pos_Y_0 = Y_0 - Column_Y_0 * #World_Column_Size_Y
  Column_Pos_Z_0 = Z_0
  Column_X_1 = World_Get_Column_X(X_1)
  Column_Y_1 = World_Get_Column_Y(Y_1)
  Column_Pos_X_1 = X_1 - Column_X_1 * #World_Column_Size_X
  Column_Pos_Y_1 = Y_1 - Column_Y_1 * #World_Column_Size_Y
  Column_Pos_Z_1 = Z_1
  
  *World_Column_0 = World_Column_Get(*World, Column_X_0, Column_Y_0)
  If Not *World_Column_0
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  *World_Column_1 = World_Column_Get(*World, Column_X_1, Column_Y_1)
  If Not *World_Column_1
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  World_Column_Block_Get(*World, *World_Column_0, Column_Pos_X_0, Column_Pos_Y_0, Column_Pos_Z_0, @Temp_Type_0, @Temp_Metadata_0)
  
  If Not World_Column_Block_Set(*World, *World_Column_1, Column_Pos_X_1, Column_Pos_Y_1, Column_Pos_Z_1, Temp_Type_0, Temp_Metadata_0)
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Block_Set(*World.World, X, Y, Z, Type=-1, Metadata=-1, BlockLight=-1, SkyLight=-1, Playerdata=-1, Send=1, Light=1, Physic=1, Current_Trigger_Time=0)
  Protected *World_Column.World_Column
  Protected Column_X, Column_Y, Column_Pos_X, Column_Pos_Y, Column_Pos_Z
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Column_X = World_Get_Column_X(X)
  Column_Y = World_Get_Column_Y(Y)
  Column_Pos_X = X - Column_X * #World_Column_Size_X
  Column_Pos_Y = Y - Column_Y * #World_Column_Size_Y
  Column_Pos_Z = Z
  
  *World_Column = World_Column_Get(*World, Column_X, Column_Y)
  If Not *World_Column
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn World_Column_Block_Set(*World, *World_Column, Column_Pos_X, Column_Pos_Y, Column_Pos_Z, Type, Metadata, BlockLight, SkyLight, Playerdata, Send, Light, Physic, Current_Trigger_Time)
EndProcedure

Procedure World_Block_Get(*World.World, X, Y, Z, *Type.Ascii=0, *Metadata.Ascii=0, *BlockLight.Ascii=0, *SkyLight.Ascii=0, *Playerdata.Ascii=0)
  Protected *World_Column.World_Column
  Protected Column_X, Column_Y, Column_Pos_X, Column_Pos_Y, Column_Pos_Z
  Protected Result
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Column_X = World_Get_Column_X(X)
  Column_Y = World_Get_Column_Y(Y)
  Column_Pos_X = X - Column_X * #World_Column_Size_X
  Column_Pos_Y = Y - Column_Y * #World_Column_Size_Y
  Column_Pos_Z = Z
  
  *World_Column = World_Column_Get(*World, Column_X, Column_Y)
  If Not *World_Column
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn World_Column_Block_Get(*World, *World_Column, Column_Pos_X, Column_Pos_Y, Column_Pos_Z, *Type, *Metadata, *BlockLight, *SkyLight, *Playerdata)
EndProcedure

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################


; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 206
; FirstLine = 164
; Folding = -
; EnableXP
; DisableDebugger