; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Constants #################################################

; #################################################### Structures ################################################

Structure World_Collision_Block
  Type.l
  Metadata_Mask.u   ; Each bit represents a possible Metadata-Combination (16 Combinations / 16 Bit)
  
  List Collision_Box.World_Collision_Box()
EndStructure

; #################################################### Variables #################################################

Global NewList World_Collision_Block.World_Collision_Block()

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure World_Collision_Check_Box(*Box_A.World_Collision_Box, *Delta.Vector_3D, *Box_B.World_Collision_Box)
  If (Abs(*Box_A\Center\X + *Delta\X - *Box_B\Center\X) >= (*Box_A\Halfwidth\X + *Box_B\Halfwidth\X)) : ProcedureReturn #False : EndIf
  If (Abs(*Box_A\Center\Y + *Delta\Y - *Box_B\Center\Y) >= (*Box_A\Halfwidth\Y + *Box_B\Halfwidth\Y)) : ProcedureReturn #False : EndIf
  If (Abs(*Box_A\Center\Z + *Delta\Z - *Box_B\Center\Z) >= (*Box_A\Halfwidth\Z + *Box_B\Halfwidth\Z)) : ProcedureReturn #False : EndIf
  
  ProcedureReturn #True
EndProcedure

Procedure World_Collision_Check_Moving_Box_X(*Box_A.World_Collision_Box, *Delta_A.Vector_3D, *Box_B.World_Collision_Box, Correction)
  If (Abs(*Box_A\Center\X + *Delta_A\X - *Box_B\Center\X) >= (*Box_A\Halfwidth\X + *Box_B\Halfwidth\X)) : ProcedureReturn #False : EndIf
  If (Abs(*Box_A\Center\Y              - *Box_B\Center\Y) >= (*Box_A\Halfwidth\Y + *Box_B\Halfwidth\Y)) : ProcedureReturn #False : EndIf
  If (Abs(*Box_A\Center\Z              - *Box_B\Center\Z) >= (*Box_A\Halfwidth\Z + *Box_B\Halfwidth\Z)) : ProcedureReturn #False : EndIf
  
  If *Delta_A\X > 0
    ; #### When it was outside on -X before any movement occured
    If (*Box_A\Center\X + *Box_A\Halfwidth\X) <= (*Box_B\Center\X - *Box_B\Halfwidth\X)
      ; #### If it goes throught the surface
      If (*Box_A\Center\X + *Delta_A\X + *Box_A\Halfwidth\X) > (*Box_B\Center\X - *Box_B\Halfwidth\X)
        If Correction
          *Delta_A\X = (*Box_B\Center\X - *Box_B\Halfwidth\X) - (*Box_A\Center\X + *Box_A\Halfwidth\X)
        EndIf
        ProcedureReturn #Direction_XP
      EndIf
    EndIf
  Else
    ; #### When it was outside on +X before any movement occured
    If (*Box_A\Center\X - *Box_A\Halfwidth\X) >= (*Box_B\Center\X + *Box_B\Halfwidth\X)
      ; #### If it goes throught the surface
      If (*Box_A\Center\X + *Delta_A\X - *Box_A\Halfwidth\X) < (*Box_B\Center\X + *Box_B\Halfwidth\X)
        If Correction
          *Delta_A\X = (*Box_B\Center\X + *Box_B\Halfwidth\X) - (*Box_A\Center\X - *Box_A\Halfwidth\X)
        EndIf
        ProcedureReturn #Direction_XN
      EndIf
    EndIf
  EndIf
  
  ProcedureReturn #False
EndProcedure

Procedure World_Collision_Check_Moving_Box_Y(*Box_A.World_Collision_Box, *Delta_A.Vector_3D, *Box_B.World_Collision_Box, Correction)
  If (Abs(*Box_A\Center\X              - *Box_B\Center\X) >= (*Box_A\Halfwidth\X + *Box_B\Halfwidth\X)) : ProcedureReturn #False : EndIf
  If (Abs(*Box_A\Center\Y + *Delta_A\Y - *Box_B\Center\Y) >= (*Box_A\Halfwidth\Y + *Box_B\Halfwidth\Y)) : ProcedureReturn #False : EndIf
  If (Abs(*Box_A\Center\Z              - *Box_B\Center\Z) >= (*Box_A\Halfwidth\Z + *Box_B\Halfwidth\Z)) : ProcedureReturn #False : EndIf
  
  
  If *Delta_A\Y > 0
    ; #### When it was outside on -Y before any movement occured
    If (*Box_A\Center\Y + *Box_A\Halfwidth\Y) <= (*Box_B\Center\Y - *Box_B\Halfwidth\Y)
      ; #### If it goes throught the surface
      If (*Box_A\Center\Y + *Delta_A\Y + *Box_A\Halfwidth\Y) > (*Box_B\Center\Y - *Box_B\Halfwidth\Y)
        If Correction
          *Delta_A\Y = (*Box_B\Center\Y - *Box_B\Halfwidth\Y) - (*Box_A\Center\Y + *Box_A\Halfwidth\Y)
        EndIf
        ProcedureReturn #Direction_YP
      EndIf
    EndIf
  Else
    ; #### When it was outside on +Y before any movement occured
    If (*Box_A\Center\Y - *Box_A\Halfwidth\Y) >= (*Box_B\Center\Y + *Box_B\Halfwidth\Y)
      ; #### If it goes throught the surface
      If (*Box_A\Center\Y + *Delta_A\Y - *Box_A\Halfwidth\Y) < (*Box_B\Center\Y + *Box_B\Halfwidth\Y)
        If Correction
          *Delta_A\Y = (*Box_B\Center\Y + *Box_B\Halfwidth\Y) - (*Box_A\Center\Y - *Box_A\Halfwidth\Y)
        EndIf
        ProcedureReturn #Direction_YN
      EndIf
    EndIf
  EndIf
  
  ProcedureReturn #False
EndProcedure

Procedure World_Collision_Check_Moving_Box_Z(*Box_A.World_Collision_Box, *Delta_A.Vector_3D, *Box_B.World_Collision_Box, Correction)
  If (Abs(*Box_A\Center\X              - *Box_B\Center\X) >= (*Box_A\Halfwidth\X + *Box_B\Halfwidth\X)) : ProcedureReturn #False : EndIf
  If (Abs(*Box_A\Center\Y              - *Box_B\Center\Y) >= (*Box_A\Halfwidth\Y + *Box_B\Halfwidth\Y)) : ProcedureReturn #False : EndIf
  If (Abs(*Box_A\Center\Z + *Delta_A\Z - *Box_B\Center\Z) >= (*Box_A\Halfwidth\Z + *Box_B\Halfwidth\Z)) : ProcedureReturn #False : EndIf
  
  If *Delta_A\Z > 0
    ; #### When it was outside on -Z before any movement occured
    If (*Box_A\Center\Z + *Box_A\Halfwidth\Z) <= (*Box_B\Center\Z - *Box_B\Halfwidth\Z)
      ; #### If it goes throught the surface
      If (*Box_A\Center\Z + *Delta_A\Z + *Box_A\Halfwidth\Z) > (*Box_B\Center\Z - *Box_B\Halfwidth\Z)
        If Correction
          *Delta_A\Z = (*Box_B\Center\Z - *Box_B\Halfwidth\Z) - (*Box_A\Center\Z + *Box_A\Halfwidth\Z)
        EndIf
        ProcedureReturn #Direction_ZP
      EndIf
    EndIf
  Else
    ; #### When it was outside on +Z before any movement occured
    If (*Box_A\Center\Z - *Box_A\Halfwidth\Z) >= (*Box_B\Center\Z + *Box_B\Halfwidth\Z)
      ; #### If it goes throught the surface
      If (*Box_A\Center\Z + *Delta_A\Z - *Box_A\Halfwidth\Z) < (*Box_B\Center\Z + *Box_B\Halfwidth\Z)
        If Correction
          *Delta_A\Z = (*Box_B\Center\Z + *Box_B\Halfwidth\Z) - (*Box_A\Center\Z - *Box_A\Halfwidth\Z)
        EndIf
        ProcedureReturn #Direction_ZN
      EndIf
    EndIf
  EndIf
  
  ProcedureReturn #False
EndProcedure

Procedure World_Collision_Check_Moving_Box(*Box_A.World_Collision_Box, *Delta_A.Vector_3D, *Box_B.World_Collision_Box, Correction_Mask)
  Protected Result
  
  If (Abs(*Box_A\Center\X + *Delta_A\X - *Box_B\Center\X) >= (*Box_A\Halfwidth\X + *Box_B\Halfwidth\X)) : ProcedureReturn #False : EndIf
  If (Abs(*Box_A\Center\Y + *Delta_A\Y - *Box_B\Center\Y) >= (*Box_A\Halfwidth\Y + *Box_B\Halfwidth\Y)) : ProcedureReturn #False : EndIf
  If (Abs(*Box_A\Center\Z + *Delta_A\Z - *Box_B\Center\Z) >= (*Box_A\Halfwidth\Z + *Box_B\Halfwidth\Z)) : ProcedureReturn #False : EndIf
  
  If Correction_Mask & #Direction_XP
    ; #### When it was outside on -X before any movement occured
    If (*Box_A\Center\X + *Box_A\Halfwidth\X) <= (*Box_B\Center\X - *Box_B\Halfwidth\X)
      ; #### If it goes throught the surface
      If (*Box_A\Center\X + *Delta_A\X + *Box_A\Halfwidth\X) > (*Box_B\Center\X - *Box_B\Halfwidth\X)
        *Delta_A\X = (*Box_B\Center\X - *Box_B\Halfwidth\X) - (*Box_A\Center\X + *Box_A\Halfwidth\X); - 0.0001
        Result | #Direction_XP
      EndIf
    EndIf
  EndIf
  If Correction_Mask & #Direction_XN
    ; #### When it was outside on +X before any movement occured
    If (*Box_A\Center\X - *Box_A\Halfwidth\X) >= (*Box_B\Center\X + *Box_B\Halfwidth\X)
      ; #### If it goes throught the surface
      If (*Box_A\Center\X + *Delta_A\X - *Box_A\Halfwidth\X) < (*Box_B\Center\X + *Box_B\Halfwidth\X)
        *Delta_A\X = (*Box_B\Center\X + *Box_B\Halfwidth\X) - (*Box_A\Center\X - *Box_A\Halfwidth\X); + 0.0001
        Result | #Direction_XN
      EndIf
    EndIf
  EndIf
  If Correction_Mask & #Direction_YP
    ; #### When it was outside on -Y before any movement occured
    If (*Box_A\Center\Y + *Box_A\Halfwidth\Y) <= (*Box_B\Center\Y - *Box_B\Halfwidth\Y)
      ; #### If it goes throught the surface
      If (*Box_A\Center\Y + *Delta_A\Y + *Box_A\Halfwidth\Y) > (*Box_B\Center\Y - *Box_B\Halfwidth\Y)
        *Delta_A\Y = (*Box_B\Center\Y - *Box_B\Halfwidth\Y) - (*Box_A\Center\Y + *Box_A\Halfwidth\Y); - 0.0001
        Result | #Direction_YP
      EndIf
    EndIf
  EndIf
  If Correction_Mask & #Direction_YN
    ; #### When it was outside on +Y before any movement occured
    If (*Box_A\Center\Y - *Box_A\Halfwidth\Y) >= (*Box_B\Center\Y + *Box_B\Halfwidth\Y)
      ; #### If it goes throught the surface
      If (*Box_A\Center\Y + *Delta_A\Y - *Box_A\Halfwidth\Y) < (*Box_B\Center\Y + *Box_B\Halfwidth\Y)
        *Delta_A\Y = (*Box_B\Center\Y + *Box_B\Halfwidth\Y) - (*Box_A\Center\Y - *Box_A\Halfwidth\Y); + 0.0001
        Result | #Direction_YN
      EndIf
    EndIf
  EndIf
  If Correction_Mask & #Direction_ZP
    ; #### When it was outside on -Z before any movement occured
    If (*Box_A\Center\Z + *Box_A\Halfwidth\Z) <= (*Box_B\Center\Z - *Box_B\Halfwidth\Z)
      ; #### If it goes throught the surface
      If (*Box_A\Center\Z + *Delta_A\Z + *Box_A\Halfwidth\Z) > (*Box_B\Center\Z - *Box_B\Halfwidth\Z)
        *Delta_A\Z = (*Box_B\Center\Z - *Box_B\Halfwidth\Z) - (*Box_A\Center\Z + *Box_A\Halfwidth\Z); - 0.0001
        Result | #Direction_ZP
      EndIf
    EndIf
  EndIf
  If Correction_Mask & #Direction_ZN
    ; #### When it was outside on +Z before any movement occured
    If (*Box_A\Center\Z - *Box_A\Halfwidth\Z) >= (*Box_B\Center\Z + *Box_B\Halfwidth\Z)
      ; #### If it goes throught the surface
      If (*Box_A\Center\Z + *Delta_A\Z - *Box_A\Halfwidth\Z) < (*Box_B\Center\Z + *Box_B\Halfwidth\Z)
        *Delta_A\Z = (*Box_B\Center\Z + *Box_B\Halfwidth\Z) - (*Box_A\Center\Z - *Box_A\Halfwidth\Z); + 0.0001
        Result | #Direction_ZN
      EndIf
    EndIf
  EndIf
  
  ProcedureReturn Result
EndProcedure

Procedure World_Collision_Check_Movement(*World.World, *Boundary.World_Collision_Box, *Delta.Vector_3D)
  Protected ix, iy, iz
  Protected ix0, iy0, iz0, ix1, iy1, iz1
  Protected Temp_Type, Temp_Metadata
  Protected Collision_Boundary
  Protected NewList Collision_Box.World_Collision_Box()
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If *Boundary\Halfwidth\X <= 0 Or *Boundary\Halfwidth\Y <= 0 Or *Boundary\Halfwidth\Z <= 0
    ProcedureReturn #Result_Fail
  EndIf
  
  ix0 = Round(*Boundary\Center\X+*Delta\X-*Boundary\Halfwidth\X, 0)
  iy0 = Round(*Boundary\Center\Y+*Delta\Y-*Boundary\Halfwidth\Y, 0)
  iz0 = Round(*Boundary\Center\Z+*Delta\Z-*Boundary\Halfwidth\Y-1, 0)
  ix1 = Round(*Boundary\Center\X+*Delta\X+*Boundary\Halfwidth\X, 0)
  iy1 = Round(*Boundary\Center\Y+*Delta\Y+*Boundary\Halfwidth\Y, 0)
  iz1 = Round(*Boundary\Center\Z+*Delta\Z+*Boundary\Halfwidth\Z, 0)
  
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
  
  ForEach Collision_Box()
    World_Collision_Check_Moving_Box(*Boundary, *Delta, Collision_Box(), #True)
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Collision_Init()
  Protected i
  
  ; #### Full Block
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 1
  World_Collision_Block()\Metadata_Mask = $FFFF
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/2
  World_Collision_Block()\Collision_Box()\Center\Y = 1/2
  World_Collision_Block()\Collision_Box()\Center\Z = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/2
  
  ; #### Stair: X+ goes upwards, normal
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 2
  World_Collision_Block()\Metadata_Mask = 1 << 0
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 3/4
  World_Collision_Block()\Collision_Box()\Center\Y = 2/4
  World_Collision_Block()\Collision_Box()\Center\Z = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 2/4
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/4
  World_Collision_Block()\Collision_Box()\Center\Y = 2/4
  World_Collision_Block()\Collision_Box()\Center\Z = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/4
  
  ; #### Stair: X- goes upwards, normal
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 2
  World_Collision_Block()\Metadata_Mask = 1 << 1
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/4
  World_Collision_Block()\Collision_Box()\Center\Y = 2/4
  World_Collision_Block()\Collision_Box()\Center\Z = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 2/4
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 3/4
  World_Collision_Block()\Collision_Box()\Center\Y = 2/4
  World_Collision_Block()\Collision_Box()\Center\Z = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/4
  
  ; #### Stair: Y+ goes upwards, normal
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 2
  World_Collision_Block()\Metadata_Mask = 1 << 2
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 2/4
  World_Collision_Block()\Collision_Box()\Center\Y = 3/4
  World_Collision_Block()\Collision_Box()\Center\Z = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 2/4
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 2/4
  World_Collision_Block()\Collision_Box()\Center\Y = 1/4
  World_Collision_Block()\Collision_Box()\Center\Z = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/4
  
  ; #### Stair: Y- goes upwards, normal
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 2
  World_Collision_Block()\Metadata_Mask = 1 << 3
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 2/4
  World_Collision_Block()\Collision_Box()\Center\Y = 1/4
  World_Collision_Block()\Collision_Box()\Center\Z = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 2/4
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 2/4
  World_Collision_Block()\Collision_Box()\Center\Y = 3/4
  World_Collision_Block()\Collision_Box()\Center\Z = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/4
  
  ; #### Stair: X+ goes upwards, upside-down
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 2
  World_Collision_Block()\Metadata_Mask = 1 << 4
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 3/4
  World_Collision_Block()\Collision_Box()\Center\Y = 2/4
  World_Collision_Block()\Collision_Box()\Center\Z = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 2/4
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/4
  World_Collision_Block()\Collision_Box()\Center\Y = 2/4
  World_Collision_Block()\Collision_Box()\Center\Z = 3/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/4
  
  ; #### Stair: X- goes upwards, upside-down
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 2
  World_Collision_Block()\Metadata_Mask = 1 << 5
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/4
  World_Collision_Block()\Collision_Box()\Center\Y = 2/4
  World_Collision_Block()\Collision_Box()\Center\Z = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 2/4
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 3/4
  World_Collision_Block()\Collision_Box()\Center\Y = 2/4
  World_Collision_Block()\Collision_Box()\Center\Z = 3/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/4
  
  ; #### Stair: Y+ goes upwards, upside-down
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 2
  World_Collision_Block()\Metadata_Mask = 1 << 6
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 2/4
  World_Collision_Block()\Collision_Box()\Center\Y = 3/4
  World_Collision_Block()\Collision_Box()\Center\Z = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 2/4
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 2/4
  World_Collision_Block()\Collision_Box()\Center\Y = 1/4
  World_Collision_Block()\Collision_Box()\Center\Z = 3/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/4
  
  ; #### Stair: Y- goes upwards, upside-down
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 2
  World_Collision_Block()\Metadata_Mask = 1 << 7
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 2/4
  World_Collision_Block()\Collision_Box()\Center\Y = 1/4
  World_Collision_Block()\Collision_Box()\Center\Z = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 2/4
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 2/4
  World_Collision_Block()\Collision_Box()\Center\Y = 3/4
  World_Collision_Block()\Collision_Box()\Center\Z = 3/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/4
  
  ; #### Slab:
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 3
  World_Collision_Block()\Metadata_Mask = %1111111111111111
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 2/4
  World_Collision_Block()\Collision_Box()\Center\Y = 2/4
  World_Collision_Block()\Collision_Box()\Center\Z = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/4
  
  ; #### Door:
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 4
  World_Collision_Block()\Metadata_Mask = %1111111111111111
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 2/4
  World_Collision_Block()\Collision_Box()\Center\Y = 2/4
  World_Collision_Block()\Collision_Box()\Center\Z = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/4
  
  ; #### Ladder:
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 5
  World_Collision_Block()\Metadata_Mask = %1111111111111111
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 2/4
  World_Collision_Block()\Collision_Box()\Center\Y = 2/4
  World_Collision_Block()\Collision_Box()\Center\Z = 1/4
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 2/4
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/4
  
  ; #### Snow:
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 6
  World_Collision_Block()\Metadata_Mask = %1111111111111111
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/2
  World_Collision_Block()\Collision_Box()\Center\Y = 1/2
  World_Collision_Block()\Collision_Box()\Center\Z = 1/32
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/32
  
  ; #### Cactus:
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 7
  World_Collision_Block()\Metadata_Mask = %1111111111111111
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/2
  World_Collision_Block()\Collision_Box()\Center\Y = 1/2
  World_Collision_Block()\Collision_Box()\Center\Z = 15/32
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 14/32
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 14/32
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 15/32
  
  ; #### Fence:
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 8
  World_Collision_Block()\Metadata_Mask = %1111111111111111
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/2
  World_Collision_Block()\Collision_Box()\Center\Y = 1/2
  World_Collision_Block()\Collision_Box()\Center\Z = 24/32
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 24/32
  
  ; #### Cake:
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 9
  World_Collision_Block()\Metadata_Mask = %1111111111111111
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/2
  World_Collision_Block()\Collision_Box()\Center\Y = 1/2
  World_Collision_Block()\Collision_Box()\Center\Z = 7/32
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 14/32
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 14/32
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 7/32
  
  ; #### Trapdoor:
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 10
  World_Collision_Block()\Metadata_Mask = %1111111111111111
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/2
  World_Collision_Block()\Collision_Box()\Center\Y = 1/2
  World_Collision_Block()\Collision_Box()\Center\Z = 3/32
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 3/32
  
  ; #### Fence-Gate:
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 11
  World_Collision_Block()\Metadata_Mask = %1111111111111111
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/2
  World_Collision_Block()\Collision_Box()\Center\Y = 1/2
  World_Collision_Block()\Collision_Box()\Center\Z = 24/32
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 24/32
  
  ; #### Brewing-Stand:
  AddElement(World_Collision_Block())
  World_Collision_Block()\Type = 12
  World_Collision_Block()\Metadata_Mask = %1111111111111111
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/2
  World_Collision_Block()\Collision_Box()\Center\Y = 1/2
  World_Collision_Block()\Collision_Box()\Center\Z = 1/32
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/2
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 1/32
  AddElement(World_Collision_Block()\Collision_Box())
  World_Collision_Block()\Collision_Box()\Center\X = 1/2
  World_Collision_Block()\Collision_Box()\Center\Y = 1/2
  World_Collision_Block()\Collision_Box()\Center\Z = 14/32
  World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/16
  World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/16
  World_Collision_Block()\Collision_Box()\Halfwidth\Z = 14/32
  
  ; #### Heights from 1 to 15
  For i = 1 To 15
    AddElement(World_Collision_Block())
    World_Collision_Block()\Type = 100+i
    World_Collision_Block()\Metadata_Mask = $FFFF
    AddElement(World_Collision_Block()\Collision_Box())
    World_Collision_Block()\Collision_Box()\Center\X = 1/2
    World_Collision_Block()\Collision_Box()\Center\Y = 1/2
    World_Collision_Block()\Collision_Box()\Center\Z = i/32
    World_Collision_Block()\Collision_Box()\Halfwidth\X = 1/2
    World_Collision_Block()\Collision_Box()\Halfwidth\Y = 1/2
    World_Collision_Block()\Collision_Box()\Halfwidth\Z = i/32
  Next
EndProcedure

; #################################################### Initstuff #################################################

World_Collision_Init()

; #################################################### Datasections ##############################################


; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 551
; FirstLine = 515
; Folding = --
; EnableXP