; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Constants #################################################

#Entity_Physic_Max_Step = 0.9 ; m

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Entity_Physic_Item(*Entity.Entity, Timestep.d)
  Protected X.d = *Entity\X, Y.d = *Entity\Y, Z.d = *Entity\Z
  Protected DX.d, DY.d, DZ.d
  Protected *World.World = *Entity\World
  Protected Max_Vel.d = #Entity_Physic_Max_Step / Timestep
  Protected Temp_Type
  Protected Temp_Result, Entity_Delete
  
  If Z < 0.5
    
    Entity_Delete = 1
    
  Else
    
    Temp_Result = World_Block_Get(*World, Round(*Entity\X, 0), Round(*Entity\Y, 0), Round(*Entity\Z-0.125, 0), @Temp_Type) 
    
    If Not Temp_Result
      ; #### In an invalid block
      Entity_Delete = 1
    ElseIf Temp_Type = 0
      ; #### In air
      *Entity\VZ + #Gravity * Timestep
      If *Entity\VZ >  Max_Vel : *Entity\VZ =  Max_Vel : EndIf
      If *Entity\VZ < -Max_Vel : *Entity\VZ = -Max_Vel : EndIf
      DX = *Entity\VX * Timestep
      DY = *Entity\VY * Timestep
      DZ = *Entity\VZ * Timestep
      If World_Block_Get(*World, Round(X+DX, 0), Round(Y   , 0), Round(Z   -0.125, 0), @Temp_Type) And Temp_Type <> 0 : *Entity\VX = 0 : EndIf
      If World_Block_Get(*World, Round(X   , 0), Round(Y+DY, 0), Round(Z   -0.125, 0), @Temp_Type) And Temp_Type <> 0 : *Entity\VY = 0 : EndIf
      If World_Block_Get(*World, Round(X   , 0), Round(Y   , 0), Round(Z+DZ-0.125, 0), @Temp_Type) And Temp_Type <> 0 : *Entity\VZ = 0 : *Entity\VX * 0.8 : *Entity\VY * 0.8 : EndIf
    Else
      ; #### In a block
      If     World_Block_Get(*World, Round(X, 0)-1, Round(Y, 0)  , Round(Z-0.125, 0)  , @Temp_Type) And Temp_Type = 0 : *Entity\VX - 10 * Timestep
      ElseIf World_Block_Get(*World, Round(X, 0)+1, Round(Y, 0)  , Round(Z-0.125, 0)  , @Temp_Type) And Temp_Type = 0 : *Entity\VX + 10 * Timestep
      ElseIf World_Block_Get(*World, Round(X, 0)  , Round(Y, 0)-1, Round(Z-0.125, 0)  , @Temp_Type) And Temp_Type = 0 : *Entity\VY - 10 * Timestep
      ElseIf World_Block_Get(*World, Round(X, 0)  , Round(Y, 0)+1, Round(Z-0.125, 0)  , @Temp_Type) And Temp_Type = 0 : *Entity\VY + 10 * Timestep
      ElseIf World_Block_Get(*World, Round(X, 0)  , Round(Y, 0)  , Round(Z-0.125, 0)+1, @Temp_Type) And Temp_Type = 0 : *Entity\VZ + 10 * Timestep
      ElseIf World_Block_Get(*World, Round(X, 0)  , Round(Y, 0)  , Round(Z-0.125, 0)-1, @Temp_Type) And Temp_Type = 0 : *Entity\VZ - 10 * Timestep
      EndIf
    EndIf
    
    If *Entity\VX >  Max_Vel : *Entity\VX =  Max_Vel : EndIf
    If *Entity\VX < -Max_Vel : *Entity\VX = -Max_Vel : EndIf
    If *Entity\VY >  Max_Vel : *Entity\VY =  Max_Vel : EndIf
    If *Entity\VY < -Max_Vel : *Entity\VY = -Max_Vel : EndIf
    If *Entity\VZ >  Max_Vel : *Entity\VZ =  Max_Vel : EndIf
    If *Entity\VZ < -Max_Vel : *Entity\VZ = -Max_Vel : EndIf
    
    DX = *Entity\VX * Timestep
    DY = *Entity\VY * Timestep
    DZ = *Entity\VZ * Timestep
    
    X + DX
    Y + DY
    Z + DZ
    
  EndIf
  
  If Entity_Delete
    Entity_Delete(*Entity)
  Else
    Entity_Set_Position(*Entity, X, Y, Z, 0)
  EndIf
EndProcedure

Procedure Entity_Physic_Standard(*Entity.Entity, *Entity_Type.Entity_Type, Timestep.d)
  Protected X.d = *Entity\X, Y.d = *Entity\Y, Z.d = *Entity\Z
  Protected *World.World = *Entity\World
  Protected Boundary.World_Collision_Box
  Protected Delta.Vector_3D, Temp_Delta.Vector_3D
  Protected ix, iy, iz
  Protected ix0, iy0, iz0, ix1, iy1, iz1
  Protected Temp_Type, Temp_Metadata, Temp_Result
  Protected Direction_Mask, Direction_Mask_2
  Protected Collision_Boundary
  Protected On_Ground, Temp_Delta_Z.d, Collision_Found
  Protected *Collision_Box.World_Collision_Box
  Protected NewList Collision_Box.World_Collision_Box()
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Boundary\Center\X = X + *Entity_Type\Boundary_Center_X
  Boundary\Center\Y = Y + *Entity_Type\Boundary_Center_Y
  Boundary\Center\Z = Z + *Entity_Type\Boundary_Center_Z
  Boundary\Halfwidth\X = *Entity_Type\Boundary_Halfwidth_X
  Boundary\Halfwidth\Y = *Entity_Type\Boundary_Halfwidth_Y
  Boundary\Halfwidth\Z = *Entity_Type\Boundary_Halfwidth_Z
  
  *Entity\VZ + *Entity_Type\Gravity * Timestep
  
  Delta\X = *Entity\VX * Timestep
  Delta\Y = *Entity\VY * Timestep
  Delta\Z = *Entity\VZ * Timestep
  
  ix0 = Round(Boundary\Center\X+Delta\X-Boundary\Halfwidth\X, 0)-1
  iy0 = Round(Boundary\Center\Y+Delta\Y-Boundary\Halfwidth\Y, 0)-1
  iz0 = Round(Boundary\Center\Z+Delta\Z-Boundary\Halfwidth\Z, 0)-1
  ix1 = Round(Boundary\Center\X+Delta\X+Boundary\Halfwidth\X, 0)+1
  iy1 = Round(Boundary\Center\Y+Delta\Y+Boundary\Halfwidth\Y, 0)+1
  iz1 = Round(Boundary\Center\Z+Delta\Z+Boundary\Halfwidth\Z, 0);+1
  
  For ix = ix0 To ix1
    For iy = iy0 To iy1
      For iz = iz0 To iz1
        
        If World_Block_Get(*World, ix, iy, iz, @Temp_Type, @Temp_Metadata)
          Collision_Boundary = Block(Temp_Type)\Collision_Boundary
          
          If Collision_Boundary
            ForEach World_Collision_Block()
              If World_Collision_Block()\Type = Collision_Boundary And World_Collision_Block()\Metadata_Mask & (1 << Temp_Metadata)
                ForEach World_Collision_Block()\Collision_Box()
                  AddElement(Collision_Box())
                  CopyStructure(World_Collision_Block()\Collision_Box(), Collision_Box(), World_Collision_Box)
                  Collision_Box()\Center\X + ix
                  Collision_Box()\Center\Y + iy
                  Collision_Box()\Center\Z + iz
                Next
                Break
              EndIf
            Next
          EndIf
          
        EndIf
        
      Next
    Next
  Next
  
  ; #### Check movement in Z direction
  ForEach Collision_Box()
    Temp_Result = World_Collision_Check_Moving_Box_Z(Boundary, Delta, Collision_Box(), #True)
    If Temp_Result
      *Entity\VZ = 0
      If Temp_Result = #Direction_ZN
        On_Ground = #True
      EndIf
    EndIf
  Next
  
  Z + Delta\Z
  Boundary\Center\Z + Delta\Z
  
  ; #### Check movement in X direction
  Temp_Delta_Z = 0
  ForEach Collision_Box()
    Temp_Result = World_Collision_Check_Moving_Box_X(Boundary, Delta, Collision_Box(), #True)
    If Temp_Result
      If Temp_Delta_Z < (Collision_Box()\Center\Z + Collision_Box()\Halfwidth\Z) - (Boundary\Center\Z - Boundary\Halfwidth\Z)
        Temp_Delta_Z = (Collision_Box()\Center\Z + Collision_Box()\Halfwidth\Z) - (Boundary\Center\Z - Boundary\Halfwidth\Z)
      EndIf
    EndIf
  Next
  ; #### If there is an obstacle in X and if its not higher than 0.5 check if it's possible to go up there
  If On_Ground And Temp_Delta_Z > 0 And Temp_Delta_Z <= 0.5
    Temp_Delta\X = *Entity\VX * Timestep
    Temp_Delta\Z = Temp_Delta_Z
    Collision_Found = #False
    ForEach Collision_Box()
      Temp_Result = World_Collision_Check_Moving_Box_Z(Boundary, Temp_Delta, Collision_Box(), #False)
      If Temp_Result
        Collision_Found = #True
        Break
      EndIf
    Next
    If Not Collision_Found
      Z + Temp_Delta\Z
      Boundary\Center\Z + Temp_Delta\Z
      ForEach Collision_Box()
        Temp_Result = World_Collision_Check_Moving_Box_X(Boundary, Temp_Delta, Collision_Box(), #False)
        If Temp_Result
          Z - Temp_Delta\Z
          Boundary\Center\Z - Temp_Delta\Z
          Collision_Found = #True
          Break
        EndIf
      Next
    EndIf
    If Not Collision_Found
      Delta\X = Temp_Delta\X
      Delta\Z = Temp_Delta\Z
    EndIf
  EndIf
  
  X + Delta\X
  Boundary\Center\X + Delta\X
  
  ; #### Check movement in Y direction
  Temp_Delta_Z = 0
  ForEach Collision_Box()
    Temp_Result = World_Collision_Check_Moving_Box_Y(Boundary, Delta, Collision_Box(), #True)
    If Temp_Result
      If Temp_Delta_Z < (Collision_Box()\Center\Z + Collision_Box()\Halfwidth\Z) - (Boundary\Center\Z - Boundary\Halfwidth\Z)
        Temp_Delta_Z = (Collision_Box()\Center\Z + Collision_Box()\Halfwidth\Z) - (Boundary\Center\Z - Boundary\Halfwidth\Z)
      EndIf
    EndIf
  Next
  ; #### If there is an obstacle in Y and if its not higher than 0.5 check if it's possible to go up there
  If On_Ground And Temp_Delta_Z > 0 And Temp_Delta_Z <= 0.5
    Temp_Delta\Y = *Entity\VY * Timestep
    Temp_Delta\Z = Temp_Delta_Z
    Collision_Found = #False
    ForEach Collision_Box()
      Temp_Result = World_Collision_Check_Moving_Box_Z(Boundary, Temp_Delta, Collision_Box(), #False)
      If Temp_Result
        Collision_Found = #True
        Break
      EndIf
    Next
    If Not Collision_Found
      Z + Temp_Delta\Z
      Boundary\Center\Z + Temp_Delta\Z
      ForEach Collision_Box()
        Temp_Result = World_Collision_Check_Moving_Box_Y(Boundary, Temp_Delta, Collision_Box(), #False)
        If Temp_Result
          Z - Temp_Delta\Z
          Boundary\Center\Z - Temp_Delta\Z
          Collision_Found = #True
          Break
        EndIf
      Next
    EndIf
    If Not Collision_Found
      Delta\Y = Temp_Delta\Y
      Delta\Z = Temp_Delta\Z
    EndIf
  EndIf
  
  Y + Delta\Y
  ;Boundary\Center\Y + Delta\Y
  
  If On_Ground
    *Entity\VX * 0.9
    *Entity\VY * 0.9
  EndIf
  
  If (Not *Entity\Network_Client) And Z < -10
    Entity_Delete(*Entity)
  Else
    Entity_Set_Position(*Entity, X, Y, Z, #True)
  EndIf
EndProcedure

Procedure Entity_Physic_Main()
  Protected *Entity_Type.Entity_Type
  
  ForEach Entity()
    *Entity_Type = Entity_Type_Get(Entity()\Type)
    If *Entity_Type
      Select *Entity_Type\Physic_Type
        Case #Entity_Physic_Standard
          Entity_Physic_Standard(Entity(), *Entity_Type, 0.1)
      EndSelect
    EndIf
  Next
  
EndProcedure
Timer_Register("Entity_Physic", #True, 100, @Entity_Physic_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 256
; FirstLine = 221
; Folding = -
; EnableXP
; DisableDebugger