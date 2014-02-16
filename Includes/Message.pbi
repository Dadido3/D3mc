; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Message_Main
  
EndStructure

; #################################################### Variables #################################################

Global Message_Main.Message_Main

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Prototypes ################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Message_Send_2_Client(*Network_Client.Network_Client, Message.s)
  If Not *Network_Client
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Network_Client\Logged_In
    ProcedureReturn #Result_Fail
  EndIf
  
  Network_Client_Packet_Send_Chat_Message(*Network_Client, Message)
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Message_Send_2_World(*World.World, Message.s)
  If Not *World
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Network_Client()
    If Network_Client()\Entity
      If Network_Client()\Entity\World = *World
        Message_Send_2_Client(Network_Client(), Message.s)
      EndIf
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Message_Send_2_All(Message.s)
  ForEach Network_Client()
    Message_Send_2_Client(Network_Client(), Message.s)
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################


; IDE Options = PureBasic 4.60 Beta 1 (Windows - x64)
; CursorPosition = 59
; Folding = -
; EnableXP