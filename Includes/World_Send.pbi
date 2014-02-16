; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure World_Send_Queue_Add(*World.World, X, Y, Z, *World_Column.World_Column, Old_Type, Old_Metadata, No_Check)
  Protected Bitmask_Offset, *Bitmask.Ascii
  Protected *World_Send_Queue.World_Send_Queue
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If *World_Column\Send_Queue_Size > 300
    ProcedureReturn #Result_Success
  EndIf
  
  If ListSize(*World_Column\Network_Client()) = 0
    ProcedureReturn #Result_Success
  EndIf
  
  If Not *World_Column\Send_Queue_Mask
    *World_Column\Send_Queue_Mask = AllocateMemory(#World_Column_Bitmask_Size)
  EndIf
  If Not *World_Column\Send_Queue_Mask
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not No_Check
    Bitmask_Offset = World_Column_Get_Offset(X - *World_Column\X*#World_Column_Size_X, Y - *World_Column\Y*#World_Column_Size_Y, Z)
    If Bitmask_Offset < 0 Or Bitmask_Offset >= #World_Column_Bitmask_Size*8
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    *Bitmask = *World_Column\Send_Queue_Mask + Bitmask_Offset / 8
    If *Bitmask\a & (1 << (Bitmask_Offset & 7))
      ProcedureReturn #Result_Success
    EndIf
  EndIf
  
  LastElement(*World\Send_Queue())
  If Not AddElement(*World\Send_Queue())
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not No_Check
    *Bitmask\a | (1 << (Bitmask_Offset & 7))
  EndIf
  *World_Column\Send_Queue_Size + 1
  
  *World\Send_Queue()\X = X
  *World\Send_Queue()\Y = Y
  *World\Send_Queue()\Z = Z
  *World\Send_Queue()\World_Column = *World_Column
  *World\Send_Queue()\Old_Type = Old_Type
  *World\Send_Queue()\Old_Metadata = Old_Metadata
  *World\Send_Queue()\No_Check = No_Check
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Send_Queue_Delete(*World.World, *Send_Queue.World_Send_Queue)
  Protected Bitmask_Offset, *Bitmask.Ascii
  Protected *World_Column.World_Column
  
  If Not *World
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Send_Queue
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  *World_Column = *Send_Queue\World_Column
  
  If Not *World_Column
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column\Send_Queue_Mask
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Send_Queue\No_Check
    Bitmask_Offset = World_Column_Get_Offset(*Send_Queue\X - *World_Column\X*#World_Column_Size_X, *Send_Queue\Y - *World_Column\Y*#World_Column_Size_Y, *Send_Queue\Z)
    *Bitmask = *World_Column\Send_Queue_Mask + Bitmask_Offset / 8
    *Bitmask\a & ~(1 << (Bitmask_Offset & 7))
  EndIf
  
  *World_Column\Send_Queue_Size - 1
  
  If *World_Column\Send_Queue_Size = 0 And *World_Column\Send_Queue_Mask
    FreeMemory(*World_Column\Send_Queue_Mask)
    *World_Column\Send_Queue_Mask = 0
  EndIf
  
  ChangeCurrentElement(*World\Send_Queue(), *Send_Queue)
  
  DeleteElement(*World\Send_Queue())
  
  If Not *World_Column
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Send_Do()
  Protected Max_Counter = 100
  Protected X, Y, Z
  Protected Block_Type
  Protected *World_Column.World_Column
  Protected Column_X, Column_Y, Column_Pos_X, Column_Pos_Y, Column_Pos_Z
  Protected Old_Type, Old_Metadata, New_Type, New_Metadata, No_Check
  Protected *Records, Element, *Pointer.Ascii
  Protected Found, Chunk_Sendmask, i
  
  ;If Network_Server_Stats\Jammed_Output
  ;  ProcedureReturn #Result_Fail
  ;EndIf
  
  ForEach World()
    
    While FirstElement(World()\Send_Queue()) And Max_Counter > 0
      
      X = World()\Send_Queue()\X
      Y = World()\Send_Queue()\Y
      Z = World()\Send_Queue()\Z
      *World_Column = World()\Send_Queue()\World_Column
      Old_Type = World()\Send_Queue()\Old_Type
      Old_Metadata = World()\Send_Queue()\Old_Metadata
      No_Check = World()\Send_Queue()\No_Check
      
      If *World_Column
        
        Column_X = World_Get_Column_X(X)
        Column_Y = World_Get_Column_Y(Y)
        
        If *World_Column\Send_Queue_Size <= 2
          ; #### Send single blockchange
          Column_Pos_X = X - Column_X * #World_Column_Size_X
          Column_Pos_Y = Y - Column_Y * #World_Column_Size_Y
          Column_Pos_Z = Z
          World_Send_Queue_Delete(World(), World()\Send_Queue())
          If World_Column_Block_Get(World(), *World_Column, Column_Pos_X, Column_Pos_Y, Column_Pos_Z, @New_Type, @New_Metadata)
            If Old_Type <> New_Type Or Old_Metadata <> New_Metadata Or No_Check
              Found = 0
              
              New_Type = Block(New_Type)\On_Client
              
              ForEach *World_Column\Network_Client()
                Network_Client_Packet_Send_Block_Change(*World_Column\Network_Client(), X, Y, Z, New_Type, New_Metadata)
                Found = 1
              Next
              If Found
                Max_Counter - 1
              EndIf
            EndIf
          EndIf
          
        ElseIf *World_Column\Send_Queue_Size <= 300
          ; #### Send multi blockchange
          
          *Records = AllocateMemory(*World_Column\Send_Queue_Size*4)
          
          Element = 0
          
          ForEach World()\Send_Queue()
            If World()\Send_Queue()\World_Column = *World_Column
              X = World()\Send_Queue()\X
              Y = World()\Send_Queue()\Y
              Z = World()\Send_Queue()\Z
              Old_Type = World()\Send_Queue()\Old_Type
              Old_Metadata = World()\Send_Queue()\Old_Metadata
              World_Send_Queue_Delete(World(), World()\Send_Queue())
              Column_Pos_X = X - Column_X * #World_Column_Size_X
              Column_Pos_Y = Y - Column_Y * #World_Column_Size_Y
              Column_Pos_Z = Z
              If World_Column_Block_Get(World(), *World_Column, Column_Pos_X, Column_Pos_Y, Column_Pos_Z, @New_Type, @New_Metadata)
                
                If Old_Type <> New_Type Or Old_Metadata <> New_Metadata Or No_Check
                  New_Type = Block(New_Type)\On_Client
                  
                  *Pointer = *Records + Element*4
                  *Pointer\a = Column_Pos_X << 4
                  *Pointer\a | Column_Pos_Y
                  *Pointer + 1
                  *Pointer\a = Column_Pos_Z
                  *Pointer + 1
                  *Pointer\a = New_Type >> 4
                  *Pointer + 1
                  *Pointer\a = New_Metadata
                  *Pointer\a | New_Type << 4
                  
                  Element + 1
                EndIf
              EndIf
            EndIf
          Next
          
          ForEach *World_Column\Network_Client()
            Network_Client_Packet_Send_Multi_Block_Change(*World_Column\Network_Client(), Column_X, Column_Y, Element, *Records, Element*4)
          Next
          
          FreeMemory(*Records)
          
        Else
          ; #### Send complete Column
          
          ForEach World()\Send_Queue()
            If World()\Send_Queue()\World_Column = *World_Column
              World_Send_Queue_Delete(World(), World()\Send_Queue())
            EndIf
          Next
          *World_Column\Send_Queue_Size = 0
          Found = 0
          
          If World_Column_Compress_For_Sending(World(), *World_Column)
            Chunk_Sendmask = 0
            For i = 0 To #World_Column_Chunks-1
              If *World_Column\Empty[i] = #False
                Chunk_Sendmask | 1<<i
              EndIf
            Next
            ForEach *World_Column\Network_Client()
              Network_Client_Packet_Send_Chunk_Data(*World_Column\Network_Client(), *World_Column\X, *World_Column\Y, *World_Column\Send_Buffer, *World_Column\Send_Buffer_Size, Chunk_Sendmask, $0000, #True)
              ; #### To activate client side light calculation
              ;World_Column_Block_Get(World(), *World_Column, Column_Pos_X, Column_Pos_Y, Column_Pos_Z, @New_Type, @New_Metadata)
              ;Network_Client_Packet_Send_Block_Change(*World_Column\Network_Client(), X, Y, Z, New_Type, New_Metadata)
              Found = 1
            Next
          Else
            ; Add Error-Handler here
            Log_Add_Error("World_Column_Compress_For_Sending")
            ProcedureReturn #Result_Fail
          EndIf
          If Found
            Max_Counter - 50
          EndIf
          
        EndIf
        
      EndIf
      
    Wend
    
  Next
    
EndProcedure
Timer_Register("World_Send", 0, 50, @World_Send_Do())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################


; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 141
; FirstLine = 147
; Folding = -
; EnableXP