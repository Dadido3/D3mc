; #################################################### Initstuff #################################################

InitNetwork()

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Network_Server
  Server_ID.i
  Thread_ID.i
EndStructure

Structure Network_Server_Stats
  Jammed_Output.l   ; If #True the output buffer of all clients is full
EndStructure

; #################################################### Variables #################################################

Global Network_Server.Network_Server
Global Network_Server_Stats.Network_Server_Stats

Global NewList Network_Client.Network_Client()

; #################################################### Includes ##################################################

XIncludeFile "Includes/Network_Encryption.pbi"
XIncludeFile "Includes/Network_Client_Packets.pbi"
XIncludeFile "Includes/Network_Client.pbi"

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Procedures ################################################

Procedure Network_Server_Stop()
  
  ; #### Todo: Client's have to be deleted here!
  
  CloseNetworkServer(Network_Server\Server_ID)
  Network_Server\Server_ID = 0
  
  Log_Add_Info("Server Stopped.")
EndProcedure

Procedure Network_Server_Start(Port)
  Protected Flag
  
  If Network_Server\Server_ID
    Network_Server_Stop()
  EndIf
  
  Network_Server\Server_ID = CreateNetworkServer(#PB_Any, Port)
  
  If Network_Server\Server_ID
    Log_Add_Info("Server Started. Port:"+Str(Port))
    Flag = #True
    Log_Add_Debug("TCP_NODELAY: "+Str(setsockopt_(ServerID(Network_Server\Server_ID), #IPPROTO_TCP, #TCP_NODELAY, @Flag, SizeOf(Long))))
    Log_Add_Debug("WSAGetLastError_: "+Str(WSAGetLastError_()))
  EndIf
EndProcedure

Procedure Network_Server_Main()
  Protected Event, Client_ID
  Protected Remaining_Bytes, Sent_Bytes
  Protected *Network_Client.Network_Client
  
  ; #### Receive
  Event = NetworkServerEvent()
  While Event
    Client_ID = EventClient()
    *Network_Client = Network_Client_Get(Client_ID)
    
    Select Event
      Case #PB_NetworkEvent_Connect
        Network_Client_Add(Client_ID)
        
      Case #PB_NetworkEvent_Disconnect
        Network_Client_Delete(*Network_Client)
        
      Case #PB_NetworkEvent_Data
        Network_Client_Input_Handler(*Network_Client)
        
    EndSelect
    Event = NetworkServerEvent()
  Wend
  
  ; #### Send
  ForEach Network_Client()
    Network_Client()\Jammed_Output = #False
    While FirstElement(Network_Client()\OUT_Packet())
      
      ; #### Encryption
      If Network_Client()\AES\Encryption_Enabled And Network_Client()\OUT_Packet()\Encrypted = #False
        AddCipherBuffer_CFB8(Network_Client()\AES\Encryption, Network_Client()\OUT_Packet()\Data, Network_Client()\OUT_Packet()\Data, Network_Client()\OUT_Packet()\Write_Offset)
        Network_Client()\OUT_Packet()\Encrypted = #True
      EndIf
      
      Remaining_Bytes = Network_Client()\OUT_Packet()\Write_Offset - Network_Client()\OUT_Packet()\Read_Offset
      Sent_Bytes = SendNetworkData(Network_Client()\ID, Network_Client()\OUT_Packet()\Data + Network_Client()\OUT_Packet()\Read_Offset, Remaining_Bytes)
      If Sent_Bytes > 0
        ; OK
        Network_Client()\OUT_Packet()\Read_Offset + Sent_Bytes
        If Network_Client()\OUT_Packet()\Write_Offset = Network_Client()\OUT_Packet()\Read_Offset
          ; Kick_After_Send
          If Network_Client()\OUT_Packet()\Disconnect_After
            CloseNetworkConnection(Network_Client()\ID)
            Network_Client_Delete(Network_Client())
            Break
          Else
            Network_Client_Packet_Delete(Network_Client(), Network_Client()\OUT_Packet())
          EndIf
        EndIf
      ElseIf Sent_Bytes = 0
        ; Error occured, add kicking here later....
        ; Add Error-Handler here
        Log_Add_Error("Send-Error")
        Break
      ElseIf Sent_Bytes = -1
        ; buffer is full...
        ;Log_Add_Warn("Jammed-Output")
        Network_Client()\Jammed_Output = #True
        Break
      EndIf
    Wend
  Next
EndProcedure
Timer_Register("Network_Server", 0, 0, @Network_Server_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 97
; FirstLine = 83
; Folding = -
; EnableXP
; DisableDebugger