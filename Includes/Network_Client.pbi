; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

Declare   Network_Client_World_Column_Preregister(*Network_Client.Network_Client, *World.World, X, Y)
Declare   Network_Client_World_Column_Register(*Network_Client.Network_Client, *World.World, *Network_Client_World_Column.Network_Client_World_Column)
Declare   Network_Client_World_Column_Unregister(*Network_Client.Network_Client, *Network_Client_World_Column.Network_Client_World_Column)

; #################################################### Procedures ################################################

Procedure Network_Client_Add(Client_ID)
  If Not AddElement(Network_Client())
    ; Add Error-Handler here
    Log_Add_Error("AddElement")
    ProcedureReturn #Result_Fail
  EndIf
  
  Network_Client()\ID = Client_ID
  Network_Client()\IP = GetClientIP(Client_ID)
  Network_Client()\IN_Packet\Data = AllocateMemory(#Network_IN_Packet_Data_Size)
  Network_Client()\IN_Packet\Data_Size = #Network_IN_Packet_Data_Size
  
  Network_Client()\Inventory_Slot_Mouse\Type = -1
  
  Network_Client()\Build_Mode\Mode = "Creative"
  
  Log_Add_Info("Client added")
  
  Plugin_Do_Event_Client_Add(Network_Client())
  
  ProcedureReturn Network_Client()
EndProcedure

Procedure Network_Client_Delete(*Network_Client.Network_Client)
  Protected *Entity.Entity, Player_Name.s
  
  If Not *Network_Client
    ; Add Error-Handler here
    Log_Add_Error("*Network_Client")
    ProcedureReturn #Result_Fail
  EndIf
  
  If *Network_Client\Logged_In And *Network_Client\Player
    Plugin_Do_Event_Client_Logout(*Network_Client, *Network_Client\Player\Name)
  EndIf
  
  Plugin_Do_Event_Client_Delete(*Network_Client)
  
  ForEach *Network_Client\World_Column()
    Network_Client_World_Column_Unregister(*Network_Client, *Network_Client\World_Column())
  Next
  
  FreeMemory(*Network_Client\IN_Packet\Data)
  *Network_Client\IN_Packet\Data = 0
  
  While FirstElement(*Network_Client\OUT_Packet())
    FreeMemory(*Network_Client\OUT_Packet()\Data)
    *Network_Client\OUT_Packet()\Data = 0
    DeleteElement(*Network_Client\OUT_Packet())
  Wend
  
  ForEach *Network_Client\Inventory_Window()
    *Entity = *Network_Client\Inventory_Window()\Entity
    ForEach *Entity\Inventory\Window()
      If *Entity\Inventory\Window()\Network_Client = *Network_Client
        DeleteElement(*Entity\Inventory\Window())
      EndIf
    Next
  Next
  
  If *Network_Client\Entity
    Player_Name = *Network_Client\Entity\Name_Prefix+*Network_Client\Entity\Name+*Network_Client\Entity\Name_Suffix
    Entity_Delete(*Network_Client\Entity)
  EndIf
  
  ChangeCurrentElement(Network_Client(), *Network_Client)
  DeleteElement(Network_Client())
  
  ForEach Network_Client()
    Network_Client_Packet_Send_Player_List(Network_Client(), Player_Name, #False, 0)
  Next
  
  Log_Add_Info("Client deleted")
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Kick(*Network_Client.Network_Client)
  If Not *Network_Client
    ; Add Error-Handler here
    Log_Add_Error("*Network_Client")
    ProcedureReturn #Result_Fail
  EndIf
  
  Log_Add_Info("Client kicked")
  
  Network_Client_Packet_Send_Kick(*Network_Client, "Kick, bla bla!")
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Enable_Encryption(*Network_Client.Network_Client, *IV)
  Protected Temp_Result
  If Not *Network_Client
    ; Add Error-Handler here
    Log_Add_Error("*Network_Client")
    ProcedureReturn #Result_Fail
  EndIf
  
  Protected i, Temp_String.s
  For i = 0 To 15
    Temp_String.s + RSet(Hex(PeekA(*IV+i)), 2, "0") + " "
  Next
  ;Debug Temp_String
  
  Log_Add_Debug("Encryption-Activated: "+Temp_String)
  
  Temp_Result = StartAESCipher_CFB(*Network_Client\AES\Encryption, *IV, 128, *IV, #PB_Cipher_Encode)
  If Not Temp_Result
    Log_Add_Error("StartAESCipher_CFB() failed.")
  EndIf
  *Network_Client\AES\Encryption_Enabled = #True
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Enable_Decryption(*Network_Client.Network_Client, *IV)
  Protected Temp_Result
  If Not *Network_Client
    ; Add Error-Handler here
    Log_Add_Error("*Network_Client")
    ProcedureReturn #Result_Fail
  EndIf
  
  Protected i, Temp_String.s
  For i = 0 To 15
    Temp_String.s + RSet(Hex(PeekA(*IV+i)), 2, "0") + " "
  Next
  ;Debug Temp_String
  
  Log_Add_Debug("Decryption-Activated: "+Temp_String)
  
  Temp_Result = StartAESCipher_CFB(*Network_Client\AES\Decryption, *IV, 128, *IV, #PB_Cipher_Decode)
  If Not Temp_Result
    Log_Add_Error("StartAESCipher_CFB() failed.")
  EndIf
  *Network_Client\AES\Decryption_Enabled = #True
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Get(Client_ID)
  If ListIndex(Network_Client()) <> -1 And Network_Client()\ID = Client_ID
    ProcedureReturn Network_Client()
  Else
    ForEach Network_Client()
      If Network_Client()\ID = Client_ID
        ProcedureReturn Network_Client()
      EndIf
    Next
  EndIf
  
  ProcedureReturn #Result_Fail
EndProcedure

Procedure Network_Client_Input_Handler(*Network_Client.Network_Client)  
  Protected Received_Bytes, Remaining_Bytes, *Temp_Adress
  
  If *Network_Client\IN_Packet\Write_Offset = 0
    Received_Bytes = ReceiveNetworkData(*Network_Client\ID, *Network_Client\IN_Packet\Data, 1)
    If Received_Bytes > 0
      *Network_Client\IN_Packet\Write_Offset + Received_Bytes
    ElseIf Received_Bytes = 0
      ; There is just not enough data received (yet)
      ; Theoretically this should never happen
      ProcedureReturn #Result_Fail
    Else
      ; Error occured, add kicking here later....
      ; Add Error-Handler here
      ; (Returned, even when there is just no data)
      ProcedureReturn #Result_Fail
    EndIf
    
    ; #### Packet Decryption
    If *Network_Client\AES\Decryption_Enabled
      AddCipherBuffer_CFB8(*Network_Client\AES\Decryption, *Network_Client\IN_Packet\Data, *Network_Client\IN_Packet\Data, 1)
    EndIf
    
    Select PeekA(*Network_Client\IN_Packet\Data)
      Case $00 ; #### Keep Alive
        *Network_Client\IN_Packet\Max_Write_Offset + 5
      Case $01 ; #### Login Request
        *Network_Client\IN_Packet\Max_Write_Offset + 1
      Case $02 ; #### Handshake
        *Network_Client\IN_Packet\Max_Write_Offset + 4   : *Network_Client\IN_Packet\Split_Counter + 1
      Case $03 ; #### Chat Message
        *Network_Client\IN_Packet\Max_Write_Offset + 3   : *Network_Client\IN_Packet\Split_Counter + 1
      Case $07 ; #### Use Entity
        *Network_Client\IN_Packet\Max_Write_Offset + 10
      Case $09 ; #### Respawn
        *Network_Client\IN_Packet\Max_Write_Offset + 1
      Case $0A ; #### Player
        *Network_Client\IN_Packet\Max_Write_Offset + 2
      Case $0B ; #### Player Position
        *Network_Client\IN_Packet\Max_Write_Offset + 34
      Case $0C ; #### Player Look
        *Network_Client\IN_Packet\Max_Write_Offset + 10
      Case $0D ; #### Player Position & Look
        *Network_Client\IN_Packet\Max_Write_Offset + 42
      Case $0E ; #### Player Digging
        *Network_Client\IN_Packet\Max_Write_Offset + 12
      Case $0F ; #### Player Block Placement
        *Network_Client\IN_Packet\Max_Write_Offset + 13  : *Network_Client\IN_Packet\Split_Counter + 1
      Case $10 ; #### Holding Change
        *Network_Client\IN_Packet\Max_Write_Offset + 3
      Case $12 ; #### Animation
        *Network_Client\IN_Packet\Max_Write_Offset + 6
      Case $13 ; #### Entity Action
        *Network_Client\IN_Packet\Max_Write_Offset + 6
      Case $65 ; #### Close Window
        *Network_Client\IN_Packet\Max_Write_Offset + 2
      Case $66 ; #### Window Click
        *Network_Client\IN_Packet\Max_Write_Offset + 10  : *Network_Client\IN_Packet\Split_Counter + 1
      Case $6A ; #### Confirm Transaction
        *Network_Client\IN_Packet\Max_Write_Offset + 5
      Case $6B ; #### Creative Inventory Action
        *Network_Client\IN_Packet\Max_Write_Offset + 5   : *Network_Client\IN_Packet\Split_Counter + 1
      Case $6C ; #### Enchant Item
        *Network_Client\IN_Packet\Max_Write_Offset + 3
      Case $82 ; #### Update Sign
        *Network_Client\IN_Packet\Max_Write_Offset + 13  : *Network_Client\IN_Packet\Split_Counter + 1
      Case $CA ; #### Player Abilities
        *Network_Client\IN_Packet\Max_Write_Offset + 4
      Case $CB ; #### Tab-complete
        *Network_Client\IN_Packet\Max_Write_Offset + 3   : *Network_Client\IN_Packet\Split_Counter + 1
      Case $CC ; #### Locale and View Distance
        *Network_Client\IN_Packet\Max_Write_Offset + 3   : *Network_Client\IN_Packet\Split_Counter + 1
      Case $CD ; #### Client Statuses
        *Network_Client\IN_Packet\Max_Write_Offset + 2
      Case $FA ; #### Plugin Message
        *Network_Client\IN_Packet\Max_Write_Offset + 3   : *Network_Client\IN_Packet\Split_Counter + 1
      Case $FC ; #### Encryption Key Response
        *Network_Client\IN_Packet\Max_Write_Offset + 3   : *Network_Client\IN_Packet\Split_Counter + 1
      Case $FE ; #### Server List Ping
        *Network_Client\IN_Packet\Max_Write_Offset + 1
      Case $FF ; #### Disconnect
        *Network_Client\IN_Packet\Max_Write_Offset + 3   : *Network_Client\IN_Packet\Split_Counter + 1
      Default
        *Network_Client\IN_Packet\Max_Write_Offset + 1
        ProcedureReturn #Result_Fail
    EndSelect
  EndIf
  
  If *Network_Client\IN_Packet\Write_Offset > 0
    Remaining_Bytes = *Network_Client\IN_Packet\Max_Write_Offset - *Network_Client\IN_Packet\Write_Offset
    
    While Remaining_Bytes > 0
      
      ; #### Check if the buffer is large enough
      If *Network_Client\IN_Packet\Data_Size < *Network_Client\IN_Packet\Write_Offset + Remaining_Bytes
        ; Error occured, add real kicking here later....
        ; Add Error-Handler here
        Network_Client_Packet_Send_Kick(*Network_Client, "Network Error... :\")
        *Network_Client\IN_Packet\Max_Write_Offset = 0
        *Network_Client\IN_Packet\Split_Counter = 0
        *Network_Client\IN_Packet\Write_Offset = 0
        *Network_Client\IN_Packet\Read_Offset = 0
        Log_Add_Error("Buffer is not large enough "+Str(*Network_Client\IN_Packet\Write_Offset + Remaining_Bytes))
        ProcedureReturn #Result_Fail
      EndIf
      
      Received_Bytes = ReceiveNetworkData(*Network_Client\ID, *Network_Client\IN_Packet\Data+*Network_Client\IN_Packet\Write_Offset, Remaining_Bytes)
      If Received_Bytes > 0
        *Network_Client\IN_Packet\Write_Offset + Received_Bytes
      ElseIf Received_Bytes = 0
        ; There is just not enough data received (yet)
        ProcedureReturn #Result_Fail
      Else
        ; Error occured, add kicking here later....
        ; Add Error-Handler here
        ; (Returned, even when there is just no data)
        ProcedureReturn #Result_Fail
      EndIf
      
      ; #### Packet Decryption
      If *Network_Client\AES\Decryption_Enabled
        AddCipherBuffer_CFB8(*Network_Client\AES\Decryption, *Network_Client\IN_Packet\Data+*Network_Client\IN_Packet\Write_Offset-Received_Bytes, *Network_Client\IN_Packet\Data+*Network_Client\IN_Packet\Write_Offset-Received_Bytes, Received_Bytes)
      EndIf
      
      Remaining_Bytes = *Network_Client\IN_Packet\Max_Write_Offset - *Network_Client\IN_Packet\Write_Offset
      
      If Remaining_Bytes = 0
        Select PeekA(*Network_Client\IN_Packet\Data)
          Case $02 ; #### Handshake
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2+2 : *Network_Client\IN_Packet\Split_Counter + 1
              Case 2 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2+4 : *Network_Client\IN_Packet\Split_Counter + 1
            EndSelect
          Case $03 ; #### Chat Message
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2 : *Network_Client\IN_Packet\Split_Counter + 1
            EndSelect
          Case $09 ; #### Respawn
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2 : *Network_Client\IN_Packet\Split_Counter + 1
            EndSelect
          Case $0F ; #### Player Block Placement
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : If (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1)) <> 65535 : *Network_Client\IN_Packet\Max_Write_Offset + 5 : *Network_Client\IN_Packet\Split_Counter + 1
                       Else : *Network_Client\IN_Packet\Max_Write_Offset + 3 : *Network_Client\IN_Packet\Split_Counter + 2 : EndIf
              Case 2 : If (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1)) <> 65535 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1)) + 3 : *Network_Client\IN_Packet\Split_Counter + 1
                       Else : *Network_Client\IN_Packet\Max_Write_Offset + 3 : *Network_Client\IN_Packet\Split_Counter + 1 : EndIf
            EndSelect
          Case $66 ; #### Window Click
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : If (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1)) <> 65535 : *Network_Client\IN_Packet\Max_Write_Offset + 3 : *Network_Client\IN_Packet\Split_Counter + 1 : EndIf
            EndSelect
          Case $6B ; #### Creative Inventory Action
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : If (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1)) <> 65535 : *Network_Client\IN_Packet\Max_Write_Offset + 5 : *Network_Client\IN_Packet\Split_Counter + 1 : EndIf
            EndSelect
          Case $82 ; #### Update Sign
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2 + 2 : *Network_Client\IN_Packet\Split_Counter + 1
              Case 2 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2 + 2 : *Network_Client\IN_Packet\Split_Counter + 1
              Case 3 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2 + 2 : *Network_Client\IN_Packet\Split_Counter + 1
              Case 4 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2 : *Network_Client\IN_Packet\Split_Counter + 1
            EndSelect
          Case $CB ; #### Tab-complete
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2 : *Network_Client\IN_Packet\Split_Counter + 1
            EndSelect
          Case $CC ; #### Locale and View Distance
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2 + 3 : *Network_Client\IN_Packet\Split_Counter + 1
            EndSelect
          Case $FA ; #### Plugin Message
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2 + 2 : *Network_Client\IN_Packet\Split_Counter + 1
              Case 2 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2 : *Network_Client\IN_Packet\Split_Counter + 1
            EndSelect
          Case $FC ; #### Encryption Key Response
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1)) + 2 : *Network_Client\IN_Packet\Split_Counter + 1
              Case 2 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1)) : *Network_Client\IN_Packet\Split_Counter + 1
            EndSelect
          Case $FF ; #### Disconnect
            *Temp_Adress = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Write_Offset-2
            Select *Network_Client\IN_Packet\Split_Counter
              Case 1 : *Network_Client\IN_Packet\Max_Write_Offset + (PeekA(*Temp_Adress)<<8|PeekA(*Temp_Adress+1))*2 : *Network_Client\IN_Packet\Split_Counter + 1
            EndSelect
        EndSelect
        Remaining_Bytes = *Network_Client\IN_Packet\Max_Write_Offset - *Network_Client\IN_Packet\Write_Offset
      EndIf
    Wend
    
  EndIf
  
  If Remaining_Bytes = 0
    
    Network_Client_Packet_Handler(*Network_Client)
    
    *Network_Client\IN_Packet\Max_Write_Offset = 0
    *Network_Client\IN_Packet\Split_Counter = 0
    *Network_Client\IN_Packet\Write_Offset = 0
    *Network_Client\IN_Packet\Read_Offset = 0
    ProcedureReturn #Result_Success
  EndIf
EndProcedure

Procedure Network_Client_Inventory_Window_Open(*Network_Client.Network_Client, *Entity.Entity)
  Protected Window_ID
  
  If Not *Entity
    ; Add Error-Handler here
    Log_Add_Error("*Entity")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Network_Client
    ; Add Error-Handler here
    Log_Add_Error("*Network_Client")
    ProcedureReturn #Result_Fail
  EndIf
  
  Network_Client_Inventory_Window_Close(*Network_Client.Network_Client, *Entity.Entity)
  
  If Not AddElement(*Network_Client\Inventory_Window())
    ; Add Error-Handler here
    Log_Add_Error("AddElement")
    ProcedureReturn #Result_Fail
  EndIf
  
  Window_ID = 1
  ForEach *Network_Client\Inventory_Window()
    If Window_ID <= *Network_Client\Inventory_Window()\Window_ID
      Window_ID = *Network_Client\Inventory_Window()\Window_ID + 1
    EndIf
  Next
  
  If Not AddElement(*Entity\Inventory\Window())
    ; Add Error-Handler here
    Log_Add_Error("AddElement")
    DeleteElement(*Network_Client\Inventory_Window())
    ProcedureReturn #Result_Fail
  EndIf
  
  *Entity\Inventory\Window() = *Network_Client\Inventory_Window()
  
  *Network_Client\Inventory_Window()\Window_ID = Window_ID
  *Network_Client\Inventory_Window()\Entity = *Entity
  *Network_Client\Inventory_Window()\Network_Client = *Network_Client
  
  Network_Client_Packet_Send_Open_Window(*Network_Client, Window_ID, *Entity\Inventory\Type, "Entity_Inventory", *Entity\Inventory\Slots)
  Network_Client_Packet_Send_Window_Items(*Network_Client, Window_ID, *Entity\Inventory)
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Inventory_Window_Close(*Network_Client.Network_Client, Window_ID)
  Protected *Entity.Entity
  
  If Not *Network_Client
    ; Add Error-Handler here
    Log_Add_Error("*Network_Client")
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach *Network_Client\Inventory_Window()
    If *Network_Client\Inventory_Window()\Window_ID = Window_ID
      *Entity = *Network_Client\Inventory_Window()\Entity
      
      ForEach *Entity\Inventory\Window()
        If *Entity\Inventory\Window()\Network_Client = *Network_Client And *Entity\Inventory\Window()\Window_ID = Window_ID
          DeleteElement(*Entity\Inventory\Window())
          Break
        EndIf
      Next
      
      Network_Client_Packet_Send_Close_Window(*Network_Client, *Network_Client\Inventory_Window()\Window_ID)
      DeleteElement(*Network_Client\Inventory_Window())
      Break
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_World_Column_Preregister(*Network_Client.Network_Client, *World.World, X, Y)
  If Not AddElement(*Network_Client\World_Column())
    ; Add Error-Handler here
    Log_Add_Error("AddElement(*Network_Client\World_Column())")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Network_Client\World_Column()\X = X
  *Network_Client\World_Column()\Y = Y
  *Network_Client\World_Column()\World_Column = World_Column_Get(*World, X, Y, #True, #True)
  
  If Not *Network_Client\World_Column()\World_Column
    ; Add Error-Handler here
    Log_Add_Error("*Network_Client\World_Column()\World_Column")
    DeleteElement(*Network_Client\World_Column())
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn *Network_Client\World_Column()
EndProcedure

Procedure Network_Client_World_Column_Register(*Network_Client.Network_Client, *World.World, *Network_Client_World_Column.Network_Client_World_Column)
  ;Protected *Stored_Element
  Protected *Entity.Entity
  Protected *World_Column.World_Column
  Protected Column_X, Column_Y
  Protected Chunk_Sendmask, i
  
  If Not *Network_Client_World_Column
    ; Add Error-Handler here
    Log_Add_Error("*Network_Client_World_Column")
    ProcedureReturn #Result_Fail
  EndIf
  
  *World_Column = *Network_Client_World_Column\World_Column
  
  If Not *World_Column
    ; Add Error-Handler here
    Log_Add_Error("*World_Column")
    ProcedureReturn #Result_Fail
  EndIf
  
  If *World_Column\Generation_State
    ; Column isn't generated yet
    ProcedureReturn #Result_Fail
  EndIf
  
  Column_X = *Network_Client_World_Column\X
  Column_Y = *Network_Client_World_Column\Y
  
  If World_Column_Compress_For_Sending(*World, *World_Column)
    Chunk_Sendmask = 0
    For i = 0 To #World_Column_Chunks-1
      If *World_Column\Empty[i] = #False
        Chunk_Sendmask | 1<<i
      EndIf
    Next
    Network_Client_Packet_Send_Map_Chunk_Bulk(*Network_Client, *World_Column\Send_Buffer, *World_Column\Send_Buffer_Size, Column_X, Column_Y, Chunk_Sendmask, $0000)
  Else
    ; Add Error-Handler here
    Log_Add_Error("World_Column_Compress_For_Sending(*World, *World_Column)")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Network_Client_World_Column\Sent = #True
  
  If Not AddElement(*World_Column\Network_Client())
    ; Add Error-Handler here
    Log_Add_Error("AddElement(*World_Column\Network_Client())")
    DeleteElement(*Network_Client\World_Column())
    ProcedureReturn #Result_Fail
  EndIf
  *World_Column\Network_Client() = *Network_Client
  
  ForEach *World_Column\Entity()
    *Entity = *World_Column\Entity()
    If *Network_Client\Entity = *Entity
      Continue
    EndIf
    Entity_Send_Add(*Entity, *Network_Client)
  Next
  
  ProcedureReturn *Network_Client_World_Column
EndProcedure

Procedure Network_Client_World_Column_Unregister(*Network_Client.Network_Client, *Network_Client_World_Column.Network_Client_World_Column)
  Protected *World_Column.World_Column
  
  *World_Column = *Network_Client_World_Column\World_Column
  
  If *Network_Client_World_Column\Sent
    ForEach *Network_Client_World_Column\World_Column\Entity()
      If *Network_Client\Entity = *Network_Client_World_Column\World_Column\Entity()
        Continue
      EndIf
      Entity_Send_Delete(*Network_Client_World_Column\World_Column\Entity(), *Network_Client)
    Next
    
    Network_Client_Packet_Send_Chunk_Data(*Network_Client, *World_Column\X, *World_Column\Y, ?Network_Client_World_Column_Empty, 12,$0000, $0000, #True)
    
    ForEach *Network_Client_World_Column\World_Column\Network_Client()
      If *Network_Client_World_Column\World_Column\Network_Client() = *Network_Client
        DeleteElement(*Network_Client_World_Column\World_Column\Network_Client())
        Break
      EndIf
    Next
  EndIf
  
  *World_Column = *Network_Client_World_Column\World_Column
  *Network_Client_World_Column\Sent = #False
  
  ; Should be selected already, but it's not safe! (Always check it, or replace it later...)
  DeleteElement(*Network_Client\World_Column())
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_World_Column_Sender()
  Protected i, ix, iy, Column_X, Column_Y, *Temp, Temp_Size, Send_Radius
  Protected *Network_Client_World_Column.Network_Client_World_Column
  Protected *World_Column.World_Column
  Protected Dim Column_Array(#World_Send_Max_Distance*2, #World_Send_Max_Distance*2)
  
  ForEach Network_Client()
    If Network_Client()\Logged_In And Network_Client()\Entity
      
      For ix = -#World_Send_Max_Distance To #World_Send_Max_Distance
        For iy = -#World_Send_Max_Distance To #World_Send_Max_Distance
          Column_Array(ix+#World_Send_Max_Distance, iy+#World_Send_Max_Distance) = 0
        Next
      Next
      
      ForEach Network_Client()\World_Column()
        *Network_Client_World_Column = Network_Client()\World_Column()
        *World_Column = *Network_Client_World_Column\World_Column
        
        ix = *Network_Client_World_Column\X - Network_Client()\Entity\Column_X
        iy = *Network_Client_World_Column\Y - Network_Client()\Entity\Column_Y
        If *World_Column\World = Network_Client()\Entity\World And ix >= -#World_Send_Max_Distance And ix <= #World_Send_Max_Distance And iy >= -#World_Send_Max_Distance And iy <= #World_Send_Max_Distance
          ; #### Column is inside of the clients sight.
          If *Network_Client_World_Column\Sent
            Column_Array(ix+#World_Send_Max_Distance, iy+#World_Send_Max_Distance) = 3
          Else
            If *Network_Client_World_Column\World_Column\Generation_State >= 100
              Column_Array(ix+#World_Send_Max_Distance, iy+#World_Send_Max_Distance) = 2
            Else
              Column_Array(ix+#World_Send_Max_Distance, iy+#World_Send_Max_Distance) = 1
            EndIf
            If Network_Client()\Entity\World\Limit_Radius = -1 Or ( *Network_Client_World_Column\X >= -Network_Client()\Entity\World\Limit_Radius And *Network_Client_World_Column\X <= Network_Client()\Entity\World\Limit_Radius And *Network_Client_World_Column\Y >= -Network_Client()\Entity\World\Limit_Radius And *Network_Client_World_Column\Y <= Network_Client()\Entity\World\Limit_Radius)
              Network_Client_World_Column_Register(Network_Client(), Network_Client()\Entity\World, *Network_Client_World_Column)
            EndIf
          EndIf
        Else
          ; #### Column is outside of the clients sight
          Network_Client_World_Column_Unregister(Network_Client(), *Network_Client_World_Column)
        EndIf
      Next
      
      Send_Radius = 0
      For i = 0 To #World_Send_Max_Distance
        If Column_Array(i+#World_Send_Max_Distance, i+#World_Send_Max_Distance) > 1 And Column_Array(-i+#World_Send_Max_Distance, i+#World_Send_Max_Distance) > 1 And Column_Array(i+#World_Send_Max_Distance, -i+#World_Send_Max_Distance) > 1 And Column_Array(-i+#World_Send_Max_Distance, -i+#World_Send_Max_Distance) > 1
          Send_Radius = i + 1
        Else
          Break
        EndIf
      Next
      
      If Send_Radius > #World_Send_Max_Distance
        Send_Radius = #World_Send_Max_Distance
      EndIf
      
      ; #### If sending-buffer is full, reduce sending radius to 0
      If Network_Client()\Jammed_Output
        Send_Radius = 0
      EndIf
      
      For ix = -Send_Radius To Send_Radius
        For iy = -Send_Radius To Send_Radius
          If Not Column_Array(ix+#World_Send_Max_Distance, iy+#World_Send_Max_Distance)
            Column_X = ix + Network_Client()\Entity\Column_X
            Column_Y = iy + Network_Client()\Entity\Column_Y
            *Network_Client_World_Column = Network_Client_World_Column_Preregister(Network_Client(), Network_Client()\Entity\World, Column_X, Column_Y)
            ;Log_Add_Debug(Str(Column_X) + "   " + Str(Column_Y)+"   --> "+Str(*Network_Client_World_Column))
          Else
            Column_Array(ix+#World_Send_Max_Distance, iy+#World_Send_Max_Distance) = 0
          EndIf
        Next
      Next
      
    EndIf
  Next
EndProcedure
Timer_Register("Network_Client_World_Column_Sender", 0, 100, @Network_Client_World_Column_Sender())

Procedure Network_Client_Send_List()
  Protected *Network_Client.Network_Client
  
  ; #### Playerlist
  ForEach Network_Client()
    *Network_Client = Network_Client()
    If *Network_Client\Logged_In And *Network_Client\Entity
      PushListPosition(Network_Client())
      
      ForEach Network_Client()
        If Network_Client()\Logged_In And Network_Client()\Entity
          Network_Client_Packet_Send_Player_List(*Network_Client, Network_Client()\Entity\Name_Prefix+Network_Client()\Entity\Name+Network_Client()\Entity\Name_Suffix, #True, Network_Client()\Ping)
        EndIf
      Next
      
      PopListPosition(Network_Client())
    EndIf
  Next
EndProcedure
Timer_Register("Network_Client_Send_List", 0, 5000, @Network_Client_Send_List())

Procedure Network_Client_Main()
  
  ; #### Ping
  ForEach Network_Client()
    If Network_Client()\Logged_In
      If Network_Client()\Ping_Time < Timer_Milliseconds() - 5000
        If Network_Client()\Ping_ID
          Network_Client()\Ping = -1
          Network_Client()\Ping_ID = 0
        EndIf
        Network_Client()\Ping_ID = Random(2147483647)
        Network_Client()\Ping_Time = Timer_Milliseconds()
        Network_Client_Packet_Send_Keep_Alive(Network_Client(), Network_Client()\Ping_ID)
      EndIf
    EndIf
  Next
EndProcedure
Timer_Register("Network_Client", 0, 1000, @Network_Client_Main())


; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################

DataSection
  Network_Client_World_Column_Empty:
  Data.a $78, $9C, $63, $64, $1C, $D9, $00, $00, $81, $80, $01, $01
EndDataSection
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 151
; FirstLine = 121
; Folding = ---
; EnableXP
; DisableDebugger