; #################################################### Initstuff #################################################

; #################################################### Macros ####################################################

; #################################################### Variables #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Procedures ################################################

Procedure World_Effect_Explosion(*World.World, X.d, Y.d, Z.d, R.f)
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Network_Client()
    If Network_Client()\Entity And Network_Client()\Entity\World = *World
      Network_Client_Packet_Send_Explosion(Network_Client(), X, Y, Z, R)
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Effect_Sound_Or_Particle(*World.World, Effect_ID, X, Y, Z, Data_)
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Network_Client()
    If Network_Client()\Entity And Network_Client()\Entity\World = *World
      Network_Client_Packet_Send_Sound_Or_Particle_Effect(Network_Client(), Effect_ID, X, Y, Z, Data_)
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Effect_Sound(*World.World, Sound_Name.s, X.d, Y.d, Z.d, Volume.f, Pitch.f)
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Network_Client()
    If Network_Client()\Entity And Network_Client()\Entity\World = *World
      Network_Client_Packet_Send_Sound_Effect(Network_Client(), Sound_Name, X, Y, Z, Volume, Pitch)
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Effect_Action(*World.World, X, Y, Z, Byte_1, Byte_2, Block_Type)
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Network_Client()
    If Network_Client()\Entity And Network_Client()\Entity\World = *World
      Network_Client_Packet_Send_Block_Action(Network_Client(), X, Y, Z, Byte_1, Byte_2, Block_Type)
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 77
; FirstLine = 34
; Folding = -
; EnableXP