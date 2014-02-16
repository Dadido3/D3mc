; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Eight_Bytes
  A.a
  B.a
  C.a
  D.a
  E.a
  F.a
  G.a
  H.a
EndStructure

Structure Eight_Bytes_Ext
  StructureUnion
    Bytes.Eight_Bytes
    Ascii.a
    Byte.b
    
    Unicode.u
    Word.w
    
    Char.c
    
    Integer.i
    Long.l
    Quad.q
    
    Float.f
    Double.d
  EndStructureUnion
EndStructure

; #################################################### Variables #################################################

; #################################################### Constants #################################################

#Network_IN_Packet_Data_Size = 2048           ; Size of the IN_Packet buffer
#Network_OUT_Packet_Data_Size_Overhead = 32   ; Max Overhead of the OUT_Packet buffer. Smaller means less memory overhead, but it will be slower.

; #################################################### Declares ##################################################

; #################################################### Procedures ################################################

Procedure Network_Client_Packet_Add(*Network_Client.Network_Client, Disconnect_After=#False)
  ; #### Hint: Never insert a packet before a already encrypted one, it will mess up encryption (For the case, priorities will be added later...)
  LastElement(*Network_Client\OUT_Packet())
  If Not AddElement(*Network_Client\OUT_Packet())
    ; Add Error-Handler here
    Log_Add_Error("AddElement")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Network_Client\OUT_Packet()\Data = AllocateMemory(#Network_OUT_Packet_Data_Size_Overhead)
  *Network_Client\OUT_Packet()\Data_Size = #Network_OUT_Packet_Data_Size_Overhead
  *Network_Client\OUT_Packet()\Disconnect_After = Disconnect_After
  
  ; #### Prevent the packet from being encrypted
  If Not *Network_Client\AES\Encryption_Enabled
    *Network_Client\OUT_Packet()\Encrypted = -1
  EndIf
  
  If Not *Network_Client\OUT_Packet()\Data
    ; Add Error-Handler here
    Log_Add_Error("AllocateMemory")
    DeleteElement(*Network_Client\OUT_Packet())
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn *Network_Client\OUT_Packet()
EndProcedure

Procedure Network_Client_Packet_Delete(*Network_Client.Network_Client, *Packet.Network_Packet)
  If ChangeCurrentElement(*Network_Client\OUT_Packet(), *Packet)
    FreeMemory(*Packet\Data)
    DeleteElement(*Network_Client\OUT_Packet())
    ProcedureReturn #Result_Success
  EndIf
  
  ProcedureReturn #Result_Fail
EndProcedure

;-

Procedure Network_Client_Packet_Write_Byte(*Packet.Network_Packet, Value.b)
  Protected Write_Offset = *Packet\Write_Offset + 1
  Protected Data_Size = *Packet\Data_Size
  Protected *Temp_Data.Byte = *Packet\Data + *Packet\Write_Offset
  Protected *Reallocate_Result
  
  If Write_Offset > Data_Size
    *Reallocate_Result = ReAllocateMemory(*Packet\Data, Write_Offset + #Network_OUT_Packet_Data_Size_Overhead)
    If Not *Reallocate_Result
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    *Packet\Data = *Reallocate_Result
    *Packet\Data_Size = Write_Offset + #Network_OUT_Packet_Data_Size_Overhead
    *Temp_Data = *Packet\Data + *Packet\Write_Offset
  EndIf
  
  *Temp_Data\b = Value
  *Packet\Write_Offset + 1
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Packet_Write_Ascii(*Packet.Network_Packet, Value.a)
  Protected Write_Offset = *Packet\Write_Offset + 1
  Protected Data_Size = *Packet\Data_Size
  Protected *Temp_Data.Ascii = *Packet\Data + *Packet\Write_Offset
  Protected *Reallocate_Result
  
  If Write_Offset > Data_Size
    *Reallocate_Result = ReAllocateMemory(*Packet\Data, Write_Offset + #Network_OUT_Packet_Data_Size_Overhead)
    If Not *Reallocate_Result
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    *Packet\Data = *Reallocate_Result
    *Packet\Data_Size = Write_Offset + #Network_OUT_Packet_Data_Size_Overhead
    *Temp_Data = *Packet\Data + *Packet\Write_Offset
  EndIf
  
  *Temp_Data\a = Value
  *Packet\Write_Offset + 1
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Packet_Write_Word(*Packet.Network_Packet, Value.w)
  Protected Write_Offset = *Packet\Write_Offset + 2
  Protected Data_Size = *Packet\Data_Size
  Protected *Temp_Data.Eight_Bytes = *Packet\Data + *Packet\Write_Offset
  Protected *Reallocate_Result
  
  If Write_Offset > Data_Size
    *Reallocate_Result = ReAllocateMemory(*Packet\Data, Write_Offset + #Network_OUT_Packet_Data_Size_Overhead)
    If Not *Reallocate_Result
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    *Packet\Data = *Reallocate_Result
    *Packet\Data_Size = Write_Offset + #Network_OUT_Packet_Data_Size_Overhead
    *Temp_Data = *Packet\Data + *Packet\Write_Offset
  EndIf
  
  Protected *Value.Eight_Bytes = @Value
  
  *Temp_Data\A = *Value\B
  *Temp_Data\B = *Value\A
  *Packet\Write_Offset + 2
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Packet_Write_Unicode(*Packet.Network_Packet, Value.u)
  Protected Write_Offset = *Packet\Write_Offset + 2
  Protected Data_Size = *Packet\Data_Size
  Protected *Temp_Data.Eight_Bytes = *Packet\Data + *Packet\Write_Offset
  Protected *Reallocate_Result
  
  If Write_Offset > Data_Size
    *Reallocate_Result = ReAllocateMemory(*Packet\Data, Write_Offset + #Network_OUT_Packet_Data_Size_Overhead)
    If Not *Reallocate_Result
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    *Packet\Data = *Reallocate_Result
    *Packet\Data_Size = Write_Offset + #Network_OUT_Packet_Data_Size_Overhead
    *Temp_Data = *Packet\Data + *Packet\Write_Offset
  EndIf
  
  Protected *Value.Eight_Bytes = @Value
  
  *Temp_Data\A = *Value\B
  *Temp_Data\B = *Value\A
  *Packet\Write_Offset + 2
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Packet_Write_Long(*Packet.Network_Packet, Value.l)
  Protected Write_Offset = *Packet\Write_Offset + 4
  Protected Data_Size = *Packet\Data_Size
  Protected *Temp_Data.Eight_Bytes = *Packet\Data + *Packet\Write_Offset
  Protected *Reallocate_Result
  
  If Write_Offset > Data_Size
    *Reallocate_Result = ReAllocateMemory(*Packet\Data, Write_Offset + #Network_OUT_Packet_Data_Size_Overhead)
    If Not *Reallocate_Result
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    *Packet\Data = *Reallocate_Result
    *Packet\Data_Size = Write_Offset + #Network_OUT_Packet_Data_Size_Overhead
    *Temp_Data = *Packet\Data + *Packet\Write_Offset
  EndIf
  
  Protected *Value.Eight_Bytes = @Value
  
  *Temp_Data\A = *Value\D
  *Temp_Data\B = *Value\C
  *Temp_Data\C = *Value\B
  *Temp_Data\D = *Value\A
  *Packet\Write_Offset + 4
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Packet_Write_Float(*Packet.Network_Packet, Value.f)
  Protected Write_Offset = *Packet\Write_Offset + 4
  Protected Data_Size = *Packet\Data_Size
  Protected *Temp_Data.Eight_Bytes = *Packet\Data + *Packet\Write_Offset
  Protected *Reallocate_Result
  
  If Write_Offset > Data_Size
    *Reallocate_Result = ReAllocateMemory(*Packet\Data, Write_Offset + #Network_OUT_Packet_Data_Size_Overhead)
    If Not *Reallocate_Result
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    *Packet\Data = *Reallocate_Result
    *Packet\Data_Size = Write_Offset + #Network_OUT_Packet_Data_Size_Overhead
    *Temp_Data = *Packet\Data + *Packet\Write_Offset
  EndIf
  
  Protected *Value.Eight_Bytes = @Value
  
  *Temp_Data\A = *Value\D
  *Temp_Data\B = *Value\C
  *Temp_Data\C = *Value\B
  *Temp_Data\D = *Value\A
  *Packet\Write_Offset + 4
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Packet_Write_Quad(*Packet.Network_Packet, Value.q)
  Protected Write_Offset = *Packet\Write_Offset + 8
  Protected Data_Size = *Packet\Data_Size
  Protected *Temp_Data.Eight_Bytes = *Packet\Data + *Packet\Write_Offset
  Protected *Reallocate_Result
  
  If Write_Offset > Data_Size
    *Reallocate_Result = ReAllocateMemory(*Packet\Data, Write_Offset + #Network_OUT_Packet_Data_Size_Overhead)
    If Not *Reallocate_Result
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    *Packet\Data = *Reallocate_Result
    *Packet\Data_Size = Write_Offset + #Network_OUT_Packet_Data_Size_Overhead
    *Temp_Data = *Packet\Data + *Packet\Write_Offset
  EndIf
  
  Protected *Value.Eight_Bytes = @Value
  
  *Temp_Data\A = *Value\H
  *Temp_Data\B = *Value\G
  *Temp_Data\C = *Value\F
  *Temp_Data\D = *Value\E
  *Temp_Data\E = *Value\D
  *Temp_Data\F = *Value\C
  *Temp_Data\G = *Value\B
  *Temp_Data\H = *Value\A
  *Packet\Write_Offset + 8
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Packet_Write_Double(*Packet.Network_Packet, Value.d)
  Protected Write_Offset = *Packet\Write_Offset + 8
  Protected Data_Size = *Packet\Data_Size
  Protected *Temp_Data.Eight_Bytes = *Packet\Data + *Packet\Write_Offset
  Protected *Reallocate_Result
  
  If Write_Offset > Data_Size
    *Reallocate_Result = ReAllocateMemory(*Packet\Data, Write_Offset + #Network_OUT_Packet_Data_Size_Overhead)
    If Not *Reallocate_Result
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    *Packet\Data = *Reallocate_Result
    *Packet\Data_Size = Write_Offset + #Network_OUT_Packet_Data_Size_Overhead
    *Temp_Data = *Packet\Data + *Packet\Write_Offset
  EndIf
  
  Protected *Value.Eight_Bytes = @Value
  
  *Temp_Data\A = *Value\H
  *Temp_Data\B = *Value\G
  *Temp_Data\C = *Value\F
  *Temp_Data\D = *Value\E
  *Temp_Data\E = *Value\D
  *Temp_Data\F = *Value\C
  *Temp_Data\G = *Value\B
  *Temp_Data\H = *Value\A
  *Packet\Write_Offset + 8
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Packet_Write_String(*Packet.Network_Packet, String.s, Format=#PB_UTF16)
  Protected Write_Offset = *Packet\Write_Offset + 2
  Protected Data_Size = *Packet\Data_Size
  Protected *Temp_Data.Eight_Bytes = *Packet\Data + *Packet\Write_Offset
  Protected *Reallocate_Result
  Protected *Temp_Char_Dest.Eight_Bytes_Ext, *Temp_Char_Source.Eight_Bytes_Ext, i
  
  If Write_Offset > Data_Size
    *Reallocate_Result = ReAllocateMemory(*Packet\Data, Write_Offset + #Network_OUT_Packet_Data_Size_Overhead)
    If Not *Reallocate_Result
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    *Packet\Data = *Reallocate_Result
    *Packet\Data_Size = Write_Offset + #Network_OUT_Packet_Data_Size_Overhead
    Data_Size = *Packet\Data_Size
    *Temp_Data = *Packet\Data + *Packet\Write_Offset
  EndIf
  
  Protected Length = Len(String)
  Protected ByteLength = StringByteLength(String, Format)
  Protected *Length.Eight_Bytes = @Length;@ByteLength
  
  *Temp_Data\A = *Length\B
  *Temp_Data\B = *Length\A
  
  *Packet\Write_Offset + 2
  *Temp_Data + 2
  Write_Offset + ByteLength
  
  Protected *Temp_String_Buffer
  *Temp_String_Buffer = AllocateMemory(ByteLength+2)
  If Not *Temp_String_Buffer
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  Select Format
    Case #PB_UTF16
      *Temp_Char_Source = @String
      *Temp_Char_Dest = *Temp_String_Buffer
      For i = 1 To ByteLength Step 2
        *Temp_Char_Dest\Bytes\B = *Temp_Char_Source\Bytes\A
        *Temp_Char_Dest\Bytes\A = *Temp_Char_Source\Bytes\B
        *Temp_Char_Dest + 2
        *Temp_Char_Source + 2
      Next
    Case #PB_UTF8, #PB_Ascii
      PokeS(*Temp_String_Buffer, String, Length, Format)
  EndSelect
  
  If Write_Offset > Data_Size
    *Reallocate_Result = ReAllocateMemory(*Packet\Data, Write_Offset + #Network_OUT_Packet_Data_Size_Overhead)
    If Not *Reallocate_Result
      ; Add Error-Handler here
      FreeMemory(*Temp_String_Buffer)
      ProcedureReturn #Result_Fail
    EndIf
    *Packet\Data = *Reallocate_Result
    *Packet\Data_Size = Write_Offset + #Network_OUT_Packet_Data_Size_Overhead
    *Temp_Data = *Packet\Data + *Packet\Write_Offset
  EndIf
  
  MoveMemory(*Temp_String_Buffer, *Temp_Data, ByteLength)
  FreeMemory(*Temp_String_Buffer)
  
  *Packet\Write_Offset + ByteLength
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Client_Packet_Write_Memory(*Packet.Network_Packet, *Source, Size)
  Protected Write_Offset = *Packet\Write_Offset + Size
  Protected Data_Size = *Packet\Data_Size
  Protected *Temp_Data.Byte = *Packet\Data + *Packet\Write_Offset
  Protected *Reallocate_Result
  
  If Write_Offset > Data_Size
    *Reallocate_Result = ReAllocateMemory(*Packet\Data, Write_Offset + #Network_OUT_Packet_Data_Size_Overhead)
    If Not *Reallocate_Result
      ; Add Error-Handler here
      ProcedureReturn #Result_Fail
    EndIf
    *Packet\Data = *Reallocate_Result
    *Packet\Data_Size = Write_Offset + #Network_OUT_Packet_Data_Size_Overhead
    *Temp_Data = *Packet\Data + *Packet\Write_Offset
  EndIf
  
  If *Source
    CopyMemory(*Source, *Temp_Data, Size)
  ElseIf Size > 0
    ZeroMemory_(*Temp_Data, Size)
  EndIf
  
  *Packet\Write_Offset + Size
  
  ProcedureReturn #Result_Success
EndProcedure

;-

Procedure.b Network_Client_Packet_Read_Byte(*Network_Client.Network_Client)
  Protected Read_Offset = *Network_Client\IN_Packet\Read_Offset + 1
  Protected Write_Offset = *Network_Client\IN_Packet\Write_Offset
  Protected *Temp_Data.Byte = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Read_Offset
  
  If Read_Offset > Write_Offset
    ; Add Error-Handler here
    ProcedureReturn 0
  EndIf
  
  *Network_Client\IN_Packet\Read_Offset + 1
  ProcedureReturn *Temp_Data\b
EndProcedure

Procedure.a Network_Client_Packet_Read_Ascii(*Network_Client.Network_Client)
  Protected Read_Offset = *Network_Client\IN_Packet\Read_Offset + 1
  Protected Write_Offset = *Network_Client\IN_Packet\Write_Offset
  Protected *Temp_Data.Ascii = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Read_Offset
  
  If Read_Offset > Write_Offset
    ; Add Error-Handler here
    ProcedureReturn 0
  EndIf
  
  *Network_Client\IN_Packet\Read_Offset + 1
  ProcedureReturn *Temp_Data\a
EndProcedure

Procedure.w Network_Client_Packet_Read_Word(*Network_Client.Network_Client)
  Protected Read_Offset = *Network_Client\IN_Packet\Read_Offset + 2
  Protected Write_Offset = *Network_Client\IN_Packet\Write_Offset
  Protected *Temp_Data.Eight_Bytes = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Read_Offset
  
  If Read_Offset > Write_Offset
    ; Add Error-Handler here
    ProcedureReturn 0
  EndIf
  
  Protected Result.w
  Protected *Result.Eight_Bytes = @Result
  
  *Result\B = *Temp_Data\A
  *Result\A = *Temp_Data\B
  
  *Network_Client\IN_Packet\Read_Offset + 2
  ProcedureReturn Result
EndProcedure

Procedure.u Network_Client_Packet_Read_Unicode(*Network_Client.Network_Client)
  Protected Read_Offset = *Network_Client\IN_Packet\Read_Offset + 2
  Protected Write_Offset = *Network_Client\IN_Packet\Write_Offset
  Protected *Temp_Data.Eight_Bytes = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Read_Offset
  
  If Read_Offset > Write_Offset
    ; Add Error-Handler here
    ProcedureReturn 0
  EndIf
  
  Protected Result.u
  Protected *Result.Eight_Bytes = @Result
  
  *Result\B = *Temp_Data\A
  *Result\A = *Temp_Data\B
  
  *Network_Client\IN_Packet\Read_Offset + 2
  ProcedureReturn Result
EndProcedure

Procedure.l Network_Client_Packet_Read_Long(*Network_Client.Network_Client)
  Protected Read_Offset = *Network_Client\IN_Packet\Read_Offset + 4
  Protected Write_Offset = *Network_Client\IN_Packet\Write_Offset
  Protected *Temp_Data.Eight_Bytes = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Read_Offset
  
  If Read_Offset > Write_Offset
    ; Add Error-Handler here
    ProcedureReturn 0
  EndIf
  
  Protected Result.l
  Protected *Result.Eight_Bytes = @Result
  
  *Result\D = *Temp_Data\A
  *Result\C = *Temp_Data\B
  *Result\B = *Temp_Data\C
  *Result\A = *Temp_Data\D
  
  *Network_Client\IN_Packet\Read_Offset + 4
  ProcedureReturn Result
EndProcedure

Procedure.f Network_Client_Packet_Read_Float(*Network_Client.Network_Client)
  Protected Read_Offset = *Network_Client\IN_Packet\Read_Offset + 4
  Protected Write_Offset = *Network_Client\IN_Packet\Write_Offset
  Protected *Temp_Data.Eight_Bytes = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Read_Offset
  
  If Read_Offset > Write_Offset
    ; Add Error-Handler here
    ProcedureReturn 0
  EndIf
  
  Protected Result.f
  Protected *Result.Eight_Bytes = @Result
  
  *Result\D = *Temp_Data\A
  *Result\C = *Temp_Data\B
  *Result\B = *Temp_Data\C
  *Result\A = *Temp_Data\D
  
  *Network_Client\IN_Packet\Read_Offset + 4
  ProcedureReturn Result
EndProcedure

Procedure.q Network_Client_Packet_Read_Quad(*Network_Client.Network_Client)
  Protected Read_Offset = *Network_Client\IN_Packet\Read_Offset + 8
  Protected Write_Offset = *Network_Client\IN_Packet\Write_Offset
  Protected *Temp_Data.Eight_Bytes = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Read_Offset
  
  If Read_Offset > Write_Offset
    ; Add Error-Handler here
    ProcedureReturn 0
  EndIf
  
  Protected Result.q
  Protected *Result.Eight_Bytes = @Result
  
  *Result\H = *Temp_Data\A
  *Result\G = *Temp_Data\B
  *Result\F = *Temp_Data\C
  *Result\E = *Temp_Data\D
  *Result\D = *Temp_Data\E
  *Result\C = *Temp_Data\F
  *Result\B = *Temp_Data\G
  *Result\A = *Temp_Data\H
  
  *Network_Client\IN_Packet\Read_Offset + 8
  ProcedureReturn Result
EndProcedure

Procedure.d Network_Client_Packet_Read_Double(*Network_Client.Network_Client)
  Protected Read_Offset = *Network_Client\IN_Packet\Read_Offset + 8
  Protected Write_Offset = *Network_Client\IN_Packet\Write_Offset
  Protected *Temp_Data.Eight_Bytes = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Read_Offset
  
  If Read_Offset > Write_Offset
    ; Add Error-Handler here
    ProcedureReturn 0
  EndIf
  
  Protected Result.d
  Protected *Result.Eight_Bytes = @Result
  
  *Result\H = *Temp_Data\A
  *Result\G = *Temp_Data\B
  *Result\F = *Temp_Data\C
  *Result\E = *Temp_Data\D
  *Result\D = *Temp_Data\E
  *Result\C = *Temp_Data\F
  *Result\B = *Temp_Data\G
  *Result\A = *Temp_Data\H
  
  *Network_Client\IN_Packet\Read_Offset + 8
  ProcedureReturn Result
EndProcedure

Procedure.s Network_Client_Packet_Read_String(*Network_Client.Network_Client, Format=#PB_UTF16)
  Protected Read_Offset = *Network_Client\IN_Packet\Read_Offset + 2
  Protected Write_Offset = *Network_Client\IN_Packet\Write_Offset
  Protected *Temp_Data.Eight_Bytes = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Read_Offset
  Protected Temp_Char.Eight_Bytes_Ext, i
  
  If Read_Offset > Write_Offset
    ; Add Error-Handler here
    ProcedureReturn ""
  EndIf
  
  Protected Length.u
  Protected *Length.Eight_Bytes = @Length
  
  *Length\B = *Temp_Data\A
  *Length\A = *Temp_Data\B
  
  Protected ByteLength
  Select Format
    Case #PB_UTF16              : ByteLength = Length * 2
    Case #PB_UTF8               : ByteLength = Length
    Case #PB_Ascii              : ByteLength = Length
  EndSelect
  
  *Network_Client\IN_Packet\Read_Offset + 2
  *Temp_Data + 2
  Read_Offset + ByteLength
  
  If Read_Offset > Write_Offset
    ; Add Error-Handler here
    ProcedureReturn ""
  EndIf
  
  Protected Result.s
  
  Select Format
    Case #PB_UTF16
      For i = 1 To Length
        Temp_Char\Bytes\B = *Temp_Data\A
        Temp_Char\Bytes\A = *Temp_Data\B
        Result + PeekS(Temp_Char, 2, Format)
        *Temp_Data + 2
      Next
    Case #PB_UTF8
      Result = PeekS(*Temp_Data, Length, Format)
  EndSelect
  
  *Network_Client\IN_Packet\Read_Offset + ByteLength
  
  ProcedureReturn Result
EndProcedure

Procedure Network_Client_Packet_Read_Memory(*Network_Client.Network_Client, *Destination, Size)
  Protected Read_Offset = *Network_Client\IN_Packet\Read_Offset + Size
  Protected Write_Offset = *Network_Client\IN_Packet\Write_Offset
  Protected *Temp_Data = *Network_Client\IN_Packet\Data + *Network_Client\IN_Packet\Read_Offset
  
  If Read_Offset > Write_Offset
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  MoveMemory(*Temp_Data, *Destination, Size)
  
  *Network_Client\IN_Packet\Read_Offset + Size
  
  ProcedureReturn #Result_Success
EndProcedure

;-

Procedure Network_Client_Packet_Send_Keep_Alive(*Network_Client.Network_Client, ID)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $00)
  
  Network_Client_Packet_Write_Long(*Packet, ID)
EndProcedure

Procedure Network_Client_Packet_Send_Login_Response(*Network_Client.Network_Client, Entity_ID, Level_Type.s, Server_Mode, Dimension, Difficulty, Max_Players)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $01)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_String (*Packet, Level_Type)
  Network_Client_Packet_Write_Byte   (*Packet, Server_Mode)
  Network_Client_Packet_Write_Byte   (*Packet, Dimension)
  Network_Client_Packet_Write_Byte   (*Packet, Difficulty)
  Network_Client_Packet_Write_Ascii  (*Packet, 0)
  Network_Client_Packet_Write_Ascii  (*Packet, Max_Players)
EndProcedure

;Procedure Network_Client_Packet_Send_Handshake(*Network_Client.Network_Client, Hash.s)
;  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
;  Network_Client_Packet_Write_Ascii(*Packet, $02)
;  
;  Network_Client_Packet_Write_String (*Packet, Hash)
;EndProcedure

Procedure Network_Client_Packet_Send_Chat_Message(*Network_Client.Network_Client, Message.s)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $03)
  
  Network_Client_Packet_Write_String (*Packet, Message)
EndProcedure

Procedure Network_Client_Packet_Send_Time_Update(*Network_Client.Network_Client, Time)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $04)
  
  Network_Client_Packet_Write_Quad   (*Packet, Time)
  Network_Client_Packet_Write_Quad   (*Packet, Time)
EndProcedure

Procedure Network_Client_Packet_Send_Entity_Equipment(*Network_Client.Network_Client, Entity_ID, Slot, Item_Type, Item_Count, Item_Damage)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $05)
  
  If Item_Type >= 0 And Item_Type <= #Item_Amount_Max
    Item_Type = Item(Item_Type)\On_Client
  EndIf
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Unicode(*Packet, Slot)
  Network_Client_Packet_Write_Word   (*Packet, Item_Type)
  If Item_Type <> -1
    Network_Client_Packet_Write_Ascii  (*Packet, Item_Count)
    Network_Client_Packet_Write_Word   (*Packet, Item_Damage)
    Network_Client_Packet_Write_Word   (*Packet, -1)
  EndIf
EndProcedure

Procedure Network_Client_Packet_Send_Spawn_Position(*Network_Client.Network_Client, X.d, Y.d, Z.d)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $06)
  
  Network_Client_Packet_Write_Long   (*Packet, X)
  Network_Client_Packet_Write_Long   (*Packet, Z)
  Network_Client_Packet_Write_Long   (*Packet, Y)
EndProcedure

Procedure Network_Client_Packet_Send_Update_Health(*Network_Client.Network_Client, Health, Food, Food_Saturation)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $08)
  
  Network_Client_Packet_Write_Unicode(*Packet, Health)
  Network_Client_Packet_Write_Unicode(*Packet, Food)
  Network_Client_Packet_Write_Float  (*Packet, Food_Saturation)
EndProcedure

Procedure Network_Client_Packet_Send_Respawn(*Network_Client.Network_Client, Dimension, Difficulty, Game_Mode, World_Height, Level_Type.s)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $09)
  
  Network_Client_Packet_Write_Long   (*Packet, Dimension)
  Network_Client_Packet_Write_Ascii  (*Packet, Difficulty)
  Network_Client_Packet_Write_Ascii  (*Packet, Game_Mode)
  Network_Client_Packet_Write_Unicode(*Packet, World_Height)
  Network_Client_Packet_Write_String (*Packet, Level_Type)
EndProcedure

Procedure Network_Client_Packet_Send_Player_Position(*Network_Client.Network_Client, X.d, Y.d, Z.d, Stance.d, On_Ground)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $0B)
  
  Network_Client_Packet_Write_Double (*Packet, X)
  Network_Client_Packet_Write_Double (*Packet, Stance)
  Network_Client_Packet_Write_Double (*Packet, Z)
  Network_Client_Packet_Write_Double (*Packet, Y)
  Network_Client_Packet_Write_Ascii  (*Packet, On_Ground)
EndProcedure

Procedure Network_Client_Packet_Send_Player_Position_And_Look(*Network_Client.Network_Client, X.d, Y.d, Z.d, Stance.d, Yaw.f, Pitch.f, On_Ground)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $0D)
  
  Network_Client_Packet_Write_Double (*Packet, X)
  Network_Client_Packet_Write_Double (*Packet, Stance)
  Network_Client_Packet_Write_Double (*Packet, Z)
  Network_Client_Packet_Write_Double (*Packet, Y)
  Network_Client_Packet_Write_Float  (*Packet, Yaw)
  Network_Client_Packet_Write_Float  (*Packet, Pitch)
  Network_Client_Packet_Write_Ascii  (*Packet, On_Ground)
EndProcedure

;Procedure Network_Client_Packet_Send_Player_Digging(*Network_Client.Network_Client, Status, X, Y, Z, Face)
;  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
;  Network_Client_Packet_Write_Ascii(*Packet, $0E)
;  
;  Network_Client_Packet_Write_Ascii  (*Packet, Status)
;  Network_Client_Packet_Write_Long   (*Packet, X)
;  Network_Client_Packet_Write_Ascii  (*Packet, Z)
;  Network_Client_Packet_Write_Long   (*Packet, Y)
;  Network_Client_Packet_Write_Ascii  (*Packet, Face)
;EndProcedure

;Procedure Network_Client_Packet_Send_Player_Block_Placement(*Network_Client.Network_Client, X, Y, Z, Direction, Item, Item_Count, Item_Damage)
;  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
;  Network_Client_Packet_Write_Ascii(*Packet, $0F)
;  
;  Network_Client_Packet_Write_Long   (*Packet, X)
;  Network_Client_Packet_Write_Ascii  (*Packet, Z)
;  Network_Client_Packet_Write_Long   (*Packet, Y)
;  Network_Client_Packet_Write_Ascii  (*Packet, Direction)
;  Network_Client_Packet_Write_Word   (*Packet, Item)
;  If Held_Item <> -1
;    Network_Client_Packet_Write_Ascii  (*Packet, Item_Count)
;    Network_Client_Packet_Write_Ascii  (*Packet, Item_Damage)
;  EndIf
;EndProcedure

;Procedure Network_Client_Packet_Send_Held(*Network_Client.Network_Client, X, Y, Z, Direction, Item, Item_Count, Item_Damage)
;  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
;  Network_Client_Packet_Write_Ascii(*Packet, $0F)
;  
;  Network_Client_Packet_Write_Long   (*Packet, X)
;  Network_Client_Packet_Write_Ascii  (*Packet, Z)
;  Network_Client_Packet_Write_Long   (*Packet, Y)
;  Network_Client_Packet_Write_Ascii  (*Packet, Direction)
;  Network_Client_Packet_Write_Word   (*Packet, Item)
;  If Held_Item <> -1
;    Network_Client_Packet_Write_Ascii  (*Packet, Item_Count)
;    Network_Client_Packet_Write_Ascii  (*Packet, Item_Damage)
;  EndIf
;EndProcedure

Procedure Network_Client_Packet_Send_Use_Bed(*Network_Client.Network_Client, Entity_ID, X, Y, Z)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $11)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Byte   (*Packet, 0)
  Network_Client_Packet_Write_Long   (*Packet, X)
  Network_Client_Packet_Write_Ascii  (*Packet, Z)
  Network_Client_Packet_Write_Long   (*Packet, Y)
EndProcedure

Procedure Network_Client_Packet_Send_Animation(*Network_Client.Network_Client, Entity_ID, Animation)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $12)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Byte   (*Packet, Animation)
EndProcedure

Procedure Network_Client_Packet_Send_Spawn_Named_Entity(*Network_Client.Network_Client, Entity_ID, Name.s, X.d, Y.d, Z.d, Yaw.f, Pitch.f, Current_Item_Type)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $14)
  
  If Current_Item_Type >= 0 And Current_Item_Type <= #Item_Amount_Max
    Current_Item_Type = Item(Current_Item_Type)\On_Client
  EndIf
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_String (*Packet, Name)
  Network_Client_Packet_Write_Long   (*Packet, X*32)
  Network_Client_Packet_Write_Long   (*Packet, Z*32)
  Network_Client_Packet_Write_Long   (*Packet, Y*32)
  Network_Client_Packet_Write_Ascii  (*Packet, Yaw*255/360)
  Network_Client_Packet_Write_Ascii  (*Packet, Pitch*255/360)
  Network_Client_Packet_Write_Unicode(*Packet, 1)
  Network_Client_Packet_Write_Ascii  (*Packet, 0) ; #### Metadata should be completed later
  Network_Client_Packet_Write_Ascii  (*Packet, 0) ; #### Metadata should be completed later
  Network_Client_Packet_Write_Ascii  (*Packet, 127) ; #### Metadata should be completed later
EndProcedure

Procedure Network_Client_Packet_Send_Spawn_Pickup(*Network_Client.Network_Client, Entity_ID, Item_Type, Item_Count, Item_Damage, X.d, Y.d, Z.d, Yaw.f, Pitch.f, Roll.f)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $15)
  
  If Item_Type >= 0 And Item_Type <= #Item_Amount_Max
    Item_Type = Item(Item_Type)\On_Client
  EndIf
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Unicode(*Packet, Item_Type)
  Network_Client_Packet_Write_Ascii  (*Packet, Item_Count)
  Network_Client_Packet_Write_Unicode(*Packet, Item_Damage)
  Network_Client_Packet_Write_Long   (*Packet, X*32)
  Network_Client_Packet_Write_Long   (*Packet, Z*32)
  Network_Client_Packet_Write_Long   (*Packet, Y*32)
  Network_Client_Packet_Write_Ascii  (*Packet, Yaw*255/360)
  Network_Client_Packet_Write_Ascii  (*Packet, Pitch*255/360)
  Network_Client_Packet_Write_Ascii  (*Packet, Roll*255/360)
EndProcedure

Procedure Network_Client_Packet_Send_Collect_Item(*Network_Client.Network_Client, Collected_Entity_ID, Collector_Entity_ID)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $16)
  
  Network_Client_Packet_Write_Long   (*Packet, Collected_Entity_ID)
  Network_Client_Packet_Write_Long   (*Packet, Collector_Entity_ID)
EndProcedure

Procedure Network_Client_Packet_Send_Spawn_Object_Or_Vehicle(*Network_Client.Network_Client, Entity_ID, Type, X.d, Y.d, Z.d, Throwers_Entity_ID, Vel_X.d, Vel_Y.d, Vel_Z.d)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $17)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Byte   (*Packet, Type)
  Network_Client_Packet_Write_Long   (*Packet, X*32)
  Network_Client_Packet_Write_Long   (*Packet, Z*32)
  Network_Client_Packet_Write_Long   (*Packet, Y*32)
  Network_Client_Packet_Write_Long   (*Packet, Throwers_Entity_ID)
  If Throwers_Entity_ID <> 0
    Network_Client_Packet_Write_Word   (*Packet, Vel_X)
    Network_Client_Packet_Write_Word   (*Packet, Vel_Z)
    Network_Client_Packet_Write_Word   (*Packet, Vel_Y)
  EndIf
EndProcedure

Procedure Network_Client_Packet_Send_Spawn_Mob(*Network_Client.Network_Client, Entity_ID, Type, X.d, Y.d, Z.d, Yaw.f, Pitch.f, Head_Yaw.f)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $18)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Byte   (*Packet, Type)
  Network_Client_Packet_Write_Long   (*Packet, X*32)
  Network_Client_Packet_Write_Long   (*Packet, Z*32)
  Network_Client_Packet_Write_Long   (*Packet, Y*32)
  Network_Client_Packet_Write_Ascii  (*Packet, Yaw*255/360)
  Network_Client_Packet_Write_Ascii  (*Packet, Pitch*255/360)
  Network_Client_Packet_Write_Ascii  (*Packet, Head_Yaw*255/360)
  Network_Client_Packet_Write_Word   (*Packet, 0)
  Network_Client_Packet_Write_Word   (*Packet, 0)
  Network_Client_Packet_Write_Word   (*Packet, 0)
  Network_Client_Packet_Write_Ascii  (*Packet, 0) ; #### Metadata should be completed later
  Network_Client_Packet_Write_Ascii  (*Packet, 0) ; #### Metadata should be completed later
  Network_Client_Packet_Write_Ascii  (*Packet, 127) ; #### Metadata should be completed later
EndProcedure

Procedure Network_Client_Packet_Send_Spawn_Painting(*Network_Client.Network_Client, Entity_ID, Title.s, X, Y, Z, Direction)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $19)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_String (*Packet, Title)
  Network_Client_Packet_Write_Long   (*Packet, X)
  Network_Client_Packet_Write_Long   (*Packet, Z)
  Network_Client_Packet_Write_Long   (*Packet, Y)
  Network_Client_Packet_Write_Long   (*Packet, Direction)
EndProcedure

Procedure Network_Client_Packet_Send_Spawn_Experience_Orb(*Network_Client.Network_Client, Entity_ID, X.d, Y.d, Z.d, Count)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $1A)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Long   (*Packet, X*32)
  Network_Client_Packet_Write_Long   (*Packet, Z*32)
  Network_Client_Packet_Write_Long   (*Packet, Y*32)
  Network_Client_Packet_Write_Word   (*Packet, Count)
EndProcedure

Procedure Network_Client_Packet_Send_Entity_Velocity(*Network_Client.Network_Client, Entity_ID, Vel_X.d, Vel_Y.d, Vel_Z.d)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $1C)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Word   (*Packet, Vel_X*800.0)
  Network_Client_Packet_Write_Word   (*Packet, Vel_Z*800.0)
  Network_Client_Packet_Write_Word   (*Packet, Vel_Y*800.0)
EndProcedure

Procedure Network_Client_Packet_Send_Destroy_Entity(*Network_Client.Network_Client, Entity_ID)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $1D)
  
  Network_Client_Packet_Write_Ascii  (*Packet, 1)
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID) ; #### Should be changed to an array later!
EndProcedure

Procedure Network_Client_Packet_Send_Entity(*Network_Client.Network_Client, Entity_ID)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $1E)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
EndProcedure

Procedure Network_Client_Packet_Send_Entity_Relative_Move(*Network_Client.Network_Client, Entity_ID, X.d, Y.d, Z.d)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $1F)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Byte   (*Packet, X*32)
  Network_Client_Packet_Write_Byte   (*Packet, Z*32)
  Network_Client_Packet_Write_Byte   (*Packet, Y*32)
EndProcedure

Procedure Network_Client_Packet_Send_Entity_Look(*Network_Client.Network_Client, Entity_ID, Yaw.f, Pitch.f)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $20)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Ascii  (*Packet, Yaw*255/360)
  Network_Client_Packet_Write_Ascii  (*Packet, Pitch*255/360)
EndProcedure

Procedure Network_Client_Packet_Send_Entity_Look_And_Relative_Move(*Network_Client.Network_Client, Entity_ID, X.d, Y.d, Z.d, Yaw.f, Pitch.f)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $21)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Byte   (*Packet, X*32)
  Network_Client_Packet_Write_Byte   (*Packet, Z*32)
  Network_Client_Packet_Write_Byte   (*Packet, Y*32)
  Network_Client_Packet_Write_Ascii  (*Packet, Yaw*255/360)
  Network_Client_Packet_Write_Ascii  (*Packet, Pitch*255/360)
EndProcedure

Procedure Network_Client_Packet_Send_Entity_Teleport(*Network_Client.Network_Client, Entity_ID, X.d, Y.d, Z.d, Yaw.f, Pitch.f)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $22)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Long   (*Packet, X*32)
  Network_Client_Packet_Write_Long   (*Packet, Z*32)
  Network_Client_Packet_Write_Long   (*Packet, Y*32)
  Network_Client_Packet_Write_Ascii  (*Packet, Yaw*255/360)
  Network_Client_Packet_Write_Ascii  (*Packet, Pitch*255/360)
EndProcedure

Procedure Network_Client_Packet_Send_Entity_Head_Look(*Network_Client.Network_Client, Entity_ID, Head_Yaw.f)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $23)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Ascii  (*Packet, Head_Yaw*255/360)
EndProcedure

Procedure Network_Client_Packet_Send_Entity_Status(*Network_Client.Network_Client, Entity_ID, Status)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $26)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Byte   (*Packet, Status)
EndProcedure

Procedure Network_Client_Packet_Send_Attach_Entity(*Network_Client.Network_Client, Entity_ID, Attached_To_Entity_ID)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $27)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Long   (*Packet, Attached_To_Entity_ID)
EndProcedure

;Procedure Network_Client_Packet_Send_Entity_Metadata(*Network_Client.Network_Client, Entity_ID)
;  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
;  Network_Client_Packet_Write_Ascii(*Packet, $28)
;  
;  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
;  ; #### Metadata Here
;EndProcedure

Procedure Network_Client_Packet_Send_Entity_Effect(*Network_Client.Network_Client, Entity_ID, Effect_ID, Amplifier, Duration)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $29)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Ascii  (*Packet, Effect_ID)
  Network_Client_Packet_Write_Ascii  (*Packet, Amplifier)
  Network_Client_Packet_Write_Word   (*Packet, Duration)
EndProcedure

Procedure Network_Client_Packet_Send_Remove_Entity_Effect(*Network_Client.Network_Client, Entity_ID, Effect_ID)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $2A)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Ascii  (*Packet, Effect_ID)
EndProcedure

Procedure Network_Client_Packet_Send_Set_Experience(*Network_Client.Network_Client, Exp_Bar, Level, Total_Exp)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $2B)
  
  Network_Client_Packet_Write_Float  (*Packet, Exp_Bar)
  Network_Client_Packet_Write_Word   (*Packet, Level)
  Network_Client_Packet_Write_Word   (*Packet, Total_Exp)
EndProcedure

Procedure Network_Client_Packet_Send_Chunk_Data(*Network_Client.Network_Client, Column_X, Column_Y, *Data_, Data_Size, Primary_Bitmap, Add_Bitmap, Continuous)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $33)
  
  Network_Client_Packet_Write_Long   (*Packet, Column_X)
  Network_Client_Packet_Write_Long   (*Packet, Column_Y)
  Network_Client_Packet_Write_Ascii  (*Packet, Continuous)
  Network_Client_Packet_Write_Unicode(*Packet, Primary_Bitmap)
  Network_Client_Packet_Write_Unicode(*Packet, Add_Bitmap)
  Network_Client_Packet_Write_Long   (*Packet, Data_Size)
  Network_Client_Packet_Write_Memory (*Packet, *Data_, Data_Size)
EndProcedure

Procedure Network_Client_Packet_Send_Multi_Block_Change(*Network_Client.Network_Client, Column_X, Column_Y, Blocks, *Data_, Data_Length)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $34)
  
  Network_Client_Packet_Write_Long   (*Packet, Column_X)
  Network_Client_Packet_Write_Long   (*Packet, Column_Y)
  Network_Client_Packet_Write_Unicode(*Packet, Blocks)
  Network_Client_Packet_Write_Long   (*Packet, Data_Length)
  Network_Client_Packet_Write_Memory (*Packet, *Data_, Data_Length)
EndProcedure

Procedure Network_Client_Packet_Send_Block_Change(*Network_Client.Network_Client, X, Y, Z, Block_Type, Metadata)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $35)
  
  If Block_Type >= 0 And Block_Type <= 255
    Block_Type = Block(Block_Type)\On_Client
  EndIf
  
  Network_Client_Packet_Write_Long   (*Packet, X)
  Network_Client_Packet_Write_Ascii  (*Packet, Z)
  Network_Client_Packet_Write_Long   (*Packet, Y)
  Network_Client_Packet_Write_Word   (*Packet, Block_Type)
  Network_Client_Packet_Write_Ascii  (*Packet, Metadata)
EndProcedure

Procedure Network_Client_Packet_Send_Block_Action(*Network_Client.Network_Client, X, Y, Z, Byte_1, Byte_2, Block_Type)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $36)
  
  Network_Client_Packet_Write_Long   (*Packet, X)
  Network_Client_Packet_Write_Unicode(*Packet, Z)
  Network_Client_Packet_Write_Long   (*Packet, Y)
  Network_Client_Packet_Write_Ascii  (*Packet, Byte_1)
  Network_Client_Packet_Write_Ascii  (*Packet, Byte_2)
  Network_Client_Packet_Write_Unicode(*Packet, Block_Type)
EndProcedure

Procedure Network_Client_Packet_Send_Block_Break_Animation(*Network_Client.Network_Client, Entity_ID, X, Y, Z, Byte)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $37)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Long   (*Packet, X)
  Network_Client_Packet_Write_Long   (*Packet, Z)
  Network_Client_Packet_Write_Long   (*Packet, Y)
  Network_Client_Packet_Write_Ascii  (*Packet, Byte)
EndProcedure

Procedure Network_Client_Packet_Send_Map_Chunk_Bulk(*Network_Client.Network_Client, *Data_, Data_Size, Column_X, Column_Y, Primary_Bitmap, Add_Bitmap)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $38)
  
  Network_Client_Packet_Write_Word   (*Packet, 1)
  Network_Client_Packet_Write_Long   (*Packet, Data_Size)
  Network_Client_Packet_Write_Memory (*Packet, *Data_, Data_Size)
  Network_Client_Packet_Write_Long   (*Packet, Column_X)
  Network_Client_Packet_Write_Long   (*Packet, Column_Y)
  Network_Client_Packet_Write_Unicode(*Packet, Primary_Bitmap)
  Network_Client_Packet_Write_Unicode(*Packet, Add_Bitmap)
EndProcedure

Procedure Network_Client_Packet_Send_Explosion(*Network_Client.Network_Client, X.d, Y.d, Z.d, R.f)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $3C)
  
  Network_Client_Packet_Write_Double (*Packet, X)
  Network_Client_Packet_Write_Double (*Packet, Z)
  Network_Client_Packet_Write_Double (*Packet, Y)
  Network_Client_Packet_Write_Float  (*Packet, R)
  Network_Client_Packet_Write_Long   (*Packet, 0) ; Causes no blockchanges
  Network_Client_Packet_Write_Float  (*Packet, 0)
  Network_Client_Packet_Write_Float  (*Packet, 0)
  Network_Client_Packet_Write_Float  (*Packet, 0)
EndProcedure

Procedure Network_Client_Packet_Send_Sound_Or_Particle_Effect(*Network_Client.Network_Client, Effect_ID, X, Y, Z, Data_)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $3D)
  
  Network_Client_Packet_Write_Long   (*Packet, Effect_ID)
  Network_Client_Packet_Write_Long   (*Packet, X)
  Network_Client_Packet_Write_Ascii  (*Packet, Z)
  Network_Client_Packet_Write_Long   (*Packet, Y)
  Network_Client_Packet_Write_long   (*Packet, Data_)
EndProcedure

Procedure Network_Client_Packet_Send_Sound_Effect(*Network_Client.Network_Client, Sound_Name.s, X.d, Y.d, Z.d, Volume.f, Pitch.f)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $3E)
  
  Network_Client_Packet_Write_String (*Packet, Sound_Name)
  Network_Client_Packet_Write_Long   (*Packet, X*8)
  Network_Client_Packet_Write_Long   (*Packet, Z*8)
  Network_Client_Packet_Write_Long   (*Packet, Y*8)
  Network_Client_Packet_Write_Float  (*Packet, Volume)
  Network_Client_Packet_Write_Ascii  (*Packet, Pitch*63)
EndProcedure

Procedure Network_Client_Packet_Send_Change_Game_State(*Network_Client.Network_Client, Reason, Game_Mode)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $46)
  
  Network_Client_Packet_Write_Ascii  (*Packet, Reason)
  Network_Client_Packet_Write_Ascii  (*Packet, Game_Mode)
EndProcedure

Procedure Network_Client_Packet_Send_Thunderbolt(*Network_Client.Network_Client, Entity_ID, X, Y, Z)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $47)
  
  Network_Client_Packet_Write_Long   (*Packet, Entity_ID)
  Network_Client_Packet_Write_Byte   (*Packet, 1)
  Network_Client_Packet_Write_Long   (*Packet, X)
  Network_Client_Packet_Write_Long   (*Packet, Z)
  Network_Client_Packet_Write_Long   (*Packet, Y)
EndProcedure

Procedure Network_Client_Packet_Send_Open_Window(*Network_Client.Network_Client, Window_ID, Window_Type, Window_Title.s, Slots)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $64)
  
  Network_Client_Packet_Write_Ascii  (*Packet, Window_ID)
  Network_Client_Packet_Write_Ascii  (*Packet, Window_Type)
  Network_Client_Packet_Write_String (*Packet, Window_Title)
  Network_Client_Packet_Write_Ascii  (*Packet, Slots)
EndProcedure

Procedure Network_Client_Packet_Send_Close_Window(*Network_Client.Network_Client, Window_ID)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $65)
  
  Network_Client_Packet_Write_Ascii  (*Packet, Window_ID)
EndProcedure

Procedure Network_Client_Packet_Send_Set_Slot(*Network_Client.Network_Client, Window_ID, Slot, Item_Type, Item_Count, Item_Damage)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $67)
  
  If Item_Type >= 0 And Item_Type <= #Item_Amount_Max
    Item_Type = Item(Item_Type)\On_Client
  EndIf
  
  Network_Client_Packet_Write_Ascii  (*Packet, Window_ID)
  Network_Client_Packet_Write_Word   (*Packet, Slot)
  Network_Client_Packet_Write_Word   (*Packet, Item_Type)
  If Item_Type <> -1
    Network_Client_Packet_Write_Ascii  (*Packet, Item_Count)
    Network_Client_Packet_Write_Word   (*Packet, Item_Damage)
    Network_Client_Packet_Write_Word   (*Packet, -1)
  EndIf
EndProcedure

Procedure Network_Client_Packet_Send_Window_Items(*Network_Client.Network_Client, Window_ID, *Inventory.Entity_Inventory)
  If Not *Inventory
    ProcedureReturn #Result_Fail
  EndIf
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Protected i, Item_Type, Item_Count, Item_Uses
  Network_Client_Packet_Write_Ascii(*Packet, $68)
  
  Network_Client_Packet_Write_Ascii  (*Packet, Window_ID)
  Network_Client_Packet_Write_Word   (*Packet, *Inventory\Slots)
  For i = 0 To *Inventory\Slots-1
    Item_Type = -1
    Item_Count = 0
    Item_Uses = 0
    ForEach *Inventory\Slot()
      If *Inventory\Slot()\Slot = i
        Item_Type = *Inventory\Slot()\Type
        Item_Count = *Inventory\Slot()\Count
        Item_Uses = *Inventory\Slot()\Uses
        Break
      EndIf
    Next
    If Item_Type >= 0 And Item_Type <= #Item_Amount_Max
      Item_Type = Item(Item_Type)\On_Client
    EndIf
    Network_Client_Packet_Write_Word   (*Packet, Item_Type)
    If Item_Type <> -1
      Network_Client_Packet_Write_Ascii  (*Packet, Item_Count)
      Network_Client_Packet_Write_Word   (*Packet, Item_Uses)
      Network_Client_Packet_Write_Word   (*Packet, -1)
    EndIf
  Next
EndProcedure

Procedure Network_Client_Packet_Send_Update_Window_Property(*Network_Client.Network_Client, Window_ID, Property, Value)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $69)
  
  Network_Client_Packet_Write_Ascii  (*Packet, Window_ID)
  Network_Client_Packet_Write_Word   (*Packet, Property)
  Network_Client_Packet_Write_Word   (*Packet, Value)
EndProcedure

Procedure Network_Client_Packet_Send_Confirm_Transaction(*Network_Client.Network_Client, Window_ID, Action_ID, Accepted)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $6A)
  
  Network_Client_Packet_Write_Ascii  (*Packet, Window_ID)
  Network_Client_Packet_Write_Word   (*Packet, Action_ID)
  Network_Client_Packet_Write_Ascii  (*Packet, Accepted)
EndProcedure

Procedure Network_Client_Packet_Send_Creative_Inventory_Action(*Network_Client.Network_Client, Slot, Item_Type, Item_Count, Item_Damage)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $6B)
  
  If Item_Type >= 0 And Item_Type <= #Item_Amount_Max
    Item_Type = Item(Item_Type)\On_Client
  EndIf
  
  Network_Client_Packet_Write_Word   (*Packet, Slot)
  Network_Client_Packet_Write_Word   (*Packet, Item_Type)
  If Item_Type <> -1
    Network_Client_Packet_Write_Ascii  (*Packet, Item_Count)
    Network_Client_Packet_Write_Word   (*Packet, Item_Damage)
    Network_Client_Packet_Write_Word   (*Packet, -1)
  EndIf
EndProcedure

Procedure Network_Client_Packet_Send_Update_Sign(*Network_Client.Network_Client, X, Y, Z, Line_1.s, Line_2.s, Line_3.s, Line_4.s)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $82)
  
  Network_Client_Packet_Write_Long   (*Packet, X)
  Network_Client_Packet_Write_Unicode(*Packet, Z)
  Network_Client_Packet_Write_Long   (*Packet, Y)
  Network_Client_Packet_Write_String (*Packet, Line_1)
  Network_Client_Packet_Write_String (*Packet, Line_2)
  Network_Client_Packet_Write_String (*Packet, Line_3)
  Network_Client_Packet_Write_String (*Packet, Line_4)
EndProcedure

Procedure Network_Client_Packet_Send_Item_Data(*Network_Client.Network_Client, Item_Type, Item_ID, *Data_, Data_Length)
  If Data_Length > 255
    ProcedureReturn #Result_Fail
  EndIf
  
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $83)
  
  Network_Client_Packet_Write_Unicode(*Packet, Item_Type)
  Network_Client_Packet_Write_Unicode(*Packet, Item_ID)
  Network_Client_Packet_Write_Ascii  (*Packet, Data_Length)
  Network_Client_Packet_Write_Memory (*Packet, *Data_, Data_Length)
EndProcedure

Procedure Network_Client_Packet_Send_Update_Tile_Entity(*Network_Client.Network_Client, X, Y, Z, Action, Custom_1, Custom_2, Custom_3)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $84)
  
  Network_Client_Packet_Write_Long   (*Packet, X)
  Network_Client_Packet_Write_Unicode(*Packet, Z)
  Network_Client_Packet_Write_Long   (*Packet, Y)
  Network_Client_Packet_Write_Byte   (*Packet, Action)
  Network_Client_Packet_Write_Long   (*Packet, Custom_1)
  Network_Client_Packet_Write_Long   (*Packet, Custom_2)
  Network_Client_Packet_Write_Long   (*Packet, Custom_3)
EndProcedure

Procedure Network_Client_Packet_Send_Increment_Statistic(*Network_Client.Network_Client, Statistic_ID, Amount)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $C8)
  
  Network_Client_Packet_Write_Long   (*Packet, Statistic_ID)
  Network_Client_Packet_Write_Byte   (*Packet, Amount)
EndProcedure

Procedure Network_Client_Packet_Send_Player_List(*Network_Client.Network_Client, Player_Name.s, Online, Ping)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $C9)
  
  Network_Client_Packet_Write_String (*Packet, Player_Name)
  Network_Client_Packet_Write_Ascii  (*Packet, Online)
  Network_Client_Packet_Write_Unicode(*Packet, Ping)
EndProcedure

Procedure Network_Client_Packet_Send_Player_Abilities(*Network_Client.Network_Client, Flags, Flying_Speed, Walking_Speed)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $CA)
  
  Network_Client_Packet_Write_Ascii  (*Packet, Flags)
  Network_Client_Packet_Write_Ascii  (*Packet, Flying_Speed)
  Network_Client_Packet_Write_Ascii  (*Packet, Walking_Speed)
EndProcedure

Procedure Network_Client_Packet_Send_Tab_Complete(*Network_Client.Network_Client, Text.s)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $CB)
  
  Network_Client_Packet_Write_String (*Packet, Text)
EndProcedure

Procedure Network_Client_Packet_Send_Plugin_Message(*Network_Client.Network_Client, Channel.s, *Data_, Data_Length)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $FA)
  
  Network_Client_Packet_Write_String (*Packet, Channel)
  Network_Client_Packet_Write_Unicode(*Packet, Data_Length)
  Network_Client_Packet_Write_Memory (*Packet, *Data_, Data_Length)
EndProcedure

Procedure Network_Client_Packet_Send_Encryption_Key_Response(*Network_Client.Network_Client, *Shared_Secret, Shared_Secret_Length, *Verify_Token, Verify_Token_Length)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $FC)
  
  Network_Client_Packet_Write_Unicode(*Packet, Shared_Secret_Length)
  Network_Client_Packet_Write_Memory (*Packet, *Shared_Secret, Shared_Secret_Length)
  Network_Client_Packet_Write_Unicode(*Packet, Verify_Token_Length)
  Network_Client_Packet_Write_Memory (*Packet, *Verify_Token, Verify_Token_Length)
EndProcedure

Procedure Network_Client_Packet_Send_Encryption_Key_Request(*Network_Client.Network_Client, Server_ID.s, *Public_Key, Public_Key_Length, *Verify_Token, Verify_Token_Length)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client)
  Network_Client_Packet_Write_Ascii(*Packet, $FD)
  
  Network_Client_Packet_Write_String (*Packet, Server_ID)
  Network_Client_Packet_Write_Unicode(*Packet, Public_Key_Length)
  Network_Client_Packet_Write_Memory (*Packet, *Public_Key, Public_Key_Length)
  Network_Client_Packet_Write_Unicode(*Packet, Verify_Token_Length)
  Network_Client_Packet_Write_Memory (*Packet, *Verify_Token, Verify_Token_Length)
EndProcedure

Procedure Network_Client_Packet_Send_Kick(*Network_Client.Network_Client, Reason.s)
  Protected *Packet.Network_Packet = Network_Client_Packet_Add(*Network_Client.Network_Client, #True)
  Network_Client_Packet_Write_Ascii(*Packet, $FF)
  
  Network_Client_Packet_Write_String (*Packet, Reason)
EndProcedure

;-

Procedure Network_Client_Packet_Handler(*Network_Client.Network_Client)
  Protected Packet_Type = Network_Client_Packet_Read_Ascii(*Network_Client)
  Select Packet_Type
    Case $00 ; #### Keep Alive
      Protected Ping_ID = Network_Client_Packet_Read_Long(*Network_Client)
      If *Network_Client\Ping_ID = Ping_ID
        *Network_Client\Ping_ID = 0
        *Network_Client\Ping = Timer_Milliseconds() - *Network_Client\Ping_Time
      EndIf
      
    Case $01 ; #### Login Request
      ;Protected Client_Version = Network_Client_Packet_Read_Long(*Network_Client)
      ;Protected Client_Name.s = Network_Client_Packet_Read_String(*Network_Client)
      ;Protected Client_Seed = Network_Client_Packet_Read_Quad(*Network_Client)
      ;Protected Client_Dimension = Network_Client_Packet_Read_Byte(*Network_Client)
      
    Case $02 ; #### Handshake
      Protected Client_Version = Network_Client_Packet_Read_Byte(*Network_Client)
      Protected Client_Name.s = Network_Client_Packet_Read_String(*Network_Client)
      Protected Server_Host.s = Network_Client_Packet_Read_String(*Network_Client)
      Protected Server_Port = Network_Client_Packet_Read_Long(*Network_Client)
      Log_Add_Info("Handshake : Ver.:"+Str(Client_Version)+" Name:"+Client_Name+" Host:"+Server_Host+" Port:"+Str(Server_Port))
      
      *Network_Client\Login_Name = Client_Name
      
      Protected Verify_Token.l = 123456789; in big-endian --> 365779719
      
      Network_Client_Packet_Send_Encryption_Key_Request(*Network_Client, System\Server_Name, Network_Encryption_Main\Public_Key_PEM, Network_Encryption_Main\Public_Key_PEM_Size, @Verify_Token, 4)
      
    Case $03 ; #### Chat Message
      Protected Message.s = Network_Client_Packet_Read_String(*Network_Client)
      Protected Amount, Type
      
      If Left(Message, 1) = "/"
        Command_Do(*Network_Client, Mid(Message, 2))
      Else
        If *Network_Client\Entity And *Network_Client\Player
          Log_Add_Chat(*Network_Client\Player\Name+": "+Message)
          ForEach Network_Client()
            Network_Client_Packet_Send_Chat_Message(Network_Client(), *Network_Client\Entity\Name_Prefix+*Network_Client\Entity\Name+*Network_Client\Entity\Name_Suffix+"§r: "+Message)
          Next
        EndIf
      EndIf
      
    Case $07 ; #### Use Entity
      Protected User_Entity_ID = Network_Client_Packet_Read_Long(*Network_Client)
      Protected Target_Entity_ID = Network_Client_Packet_Read_Long(*Network_Client)
      Protected Leftclick = Network_Client_Packet_Read_Ascii(*Network_Client)
      Log_Add_Info("Use Entity: EID.:"+Str(Target_Entity_ID)+" Leftclick:"+Str(Leftclick))
      
    Case $09 ; #### Respawn
      Log_Add_Info("Respawn:")
      
    Case $0A ; #### Player
      Protected On_Ground = Network_Client_Packet_Read_Ascii(*Network_Client)
      Log_Add_Info("Player: Onground:"+Str(On_Ground))
      
    Case $0B ; #### Player Position
      Protected X.d, Y.d, Z.d, Stance.d, Yaw.f, Pitch.f
      X.d = Network_Client_Packet_Read_Double(*Network_Client)
      Z.d = Network_Client_Packet_Read_Double(*Network_Client)
      Stance.d = Network_Client_Packet_Read_Double(*Network_Client)
      Y.d = Network_Client_Packet_Read_Double(*Network_Client)
      If *Network_Client\Entity
        Entity_Set_Position(*Network_Client\Entity, X, Y, Z, 0)
      EndIf
      
    Case $0C ; #### Player Look
      Yaw.f = Network_Client_Packet_Read_Float(*Network_Client)
      Pitch.f = Network_Client_Packet_Read_Float(*Network_Client)
      If *Network_Client\Entity
        Entity_Set_Rotation(*Network_Client\Entity, Yaw, Pitch, 0, 1, 0)
      EndIf
      
    Case $0D ; #### Player Position & Look
      X.d = Network_Client_Packet_Read_Double(*Network_Client)
      Z.d = Network_Client_Packet_Read_Double(*Network_Client)
      Stance.d = Network_Client_Packet_Read_Double(*Network_Client)
      Y.d = Network_Client_Packet_Read_Double(*Network_Client)
      Yaw.f = Network_Client_Packet_Read_Float(*Network_Client)
      Pitch.f = Network_Client_Packet_Read_Float(*Network_Client)
      If *Network_Client\Entity
        Entity_Set_Rotation(*Network_Client\Entity, Yaw, Pitch, 0, 1, 0)
        Entity_Set_Position(*Network_Client\Entity, X, Y, Z, 0)
      EndIf
      
    Case $0E ; #### Player Digging
      Protected iStatus, iX, iY, iZ, Face
      
      iStatus = Network_Client_Packet_Read_Byte(*Network_Client)
      iX = Network_Client_Packet_Read_Long(*Network_Client)
      iZ = Network_Client_Packet_Read_Ascii(*Network_Client)
      iY = Network_Client_Packet_Read_Long(*Network_Client)
      Face = Network_Client_Packet_Read_Ascii(*Network_Client)
      
      If *Network_Client\Entity
        Build_Mode_Do_Dig(*Network_Client, *Network_Client\Entity\World, iX, iY, iZ, Face, iStatus)
      EndIf
      
      ;World_Block_Destroy(*Network_Client\Entity\World, iX, iY, iZ)
      
      Protected iix, iiy, iiz
      ;For iix = -15 To 15
      ;  For iiy = -15 To 15
      ;    For iiz = 0 To 10
      ;      ;World_Block_Change(*Network_Client\Entity\World, iX+iix, iY+iiy, iZ+iiz, 0)
      ;      If World_Block_Get_Type(*Network_Client\Entity\World, iX+iix, iY+iiy, iZ+iiz)
      ;        World_Block_Destroy(*Network_Client\Entity\World, iX+iix, iY+iiy, iZ+iiz)
      ;      EndIf
      ;    Next
      ;  Next
      ;Next
      
    Case $0F ; #### Player Block Placement
      Protected Dir, Block, Cursor_X, Cursor_Y, Cursor_Z
      Protected Temp_Buffer_Size, *Temp_Buffer
      iX = Network_Client_Packet_Read_Long(*Network_Client)
      iZ = Network_Client_Packet_Read_Ascii(*Network_Client)
      iY = Network_Client_Packet_Read_Long(*Network_Client)
      Dir = Network_Client_Packet_Read_Ascii(*Network_Client)
      Block = Network_Client_Packet_Read_Word(*Network_Client)
      If Block <> -1
        Network_Client_Packet_Read_Ascii(*Network_Client)
        Network_Client_Packet_Read_Word(*Network_Client)
        Temp_Buffer_Size = Network_Client_Packet_Read_Word(*Network_Client)
        If Temp_Buffer_Size > 0
          *Temp_Buffer = AllocateMemory(Temp_Buffer_Size)
          If *Temp_Buffer
            Network_Client_Packet_Read_Memory(*Network_Client, *Temp_Buffer, Temp_Buffer_Size)
            FreeMemory(*Temp_Buffer)
          EndIf
        EndIf
      EndIf
      Cursor_X = Network_Client_Packet_Read_Ascii(*Network_Client)
      Cursor_Z = Network_Client_Packet_Read_Ascii(*Network_Client)
      Cursor_Y = Network_Client_Packet_Read_Ascii(*Network_Client)
      
      If *Network_Client\Entity
        Build_Mode_Do_Place(*Network_Client, *Network_Client\Entity\World, iX, iY, iZ, Dir, Cursor_X, Cursor_Y, Cursor_Z)
      EndIf
      
      ;Select Dir
      ;  Case 0 : iZ - 1 : Case 1 : iZ + 1 : Case 2 : iY - 1 : Case 3 : iY + 1 : Case 4 : iX - 1 : Case 5 : iX + 1
      ;EndSelect
      ;If *Network_Client\Entity
      ;  World_Block_Build_Entity(*Network_Client\Entity, *Network_Client\Entity\World, iX, iY, iZ, *Network_Client\Entity\Holding_Slot)
      ;EndIf
      
      ;Log_Add_Info("Block placing ID:"+Str(Block))
      
    Case $10 ; #### Holding Change
      Protected Slot
      Slot = Network_Client_Packet_Read_Word(*Network_Client)
      If *Network_Client\Entity
        Entity_Inventory_Holding_Slot_Set(*Network_Client\Entity, 36+Slot)
      EndIf
      ;Log_Add_Info("Holding change   Slot:"+Str(Slot))
      
    Case $12 ; #### Arm Animation
      ;Log_Add_Info("Arm Animation")
      
    Case $13 ; #### Entity Action
      Protected Action = Network_Client_Packet_Read_Ascii(*Network_Client)
      ;Log_Add_Info("Entity Action: "+Str(Action))
      
    Case $65 ; #### Close Window
      Network_Client_Inventory_Window_Close(*Network_Client, Network_Client_Packet_Read_Ascii(*Network_Client))
      Log_Add_Info("Close Window")
      
    Case $66 ; #### Window Click
      Protected Window_ID = Network_Client_Packet_Read_Ascii(*Network_Client)
                Slot = Network_Client_Packet_Read_Word(*Network_Client)
      Protected Right = Network_Client_Packet_Read_Ascii(*Network_Client)
      Protected Action_ID = Network_Client_Packet_Read_Unicode(*Network_Client)
      Protected Shift = Network_Client_Packet_Read_Ascii(*Network_Client)
      
      Log_Add_Info("Window Click :"+Str(Window_ID)+" "+Str(Slot)+" "+Str(Right)+" "+Str(Action_ID))
      ;Network_Client_Packet_Send_Transaction(*Network_Client, Window_ID, Action_ID, 1)
      If *Network_Client\Entity
        If Window_ID = 0
          Entity_Inventory_Mouse_Swap(*Network_Client\Entity, Slot, Right, *Network_Client)
        Else
          
        EndIf
      EndIf
      
    Case $6A ; #### Transaction
      Window_ID = Network_Client_Packet_Read_Ascii(*Network_Client)
      Action_ID = Network_Client_Packet_Read_Unicode(*Network_Client)
      ;Network_Client_Packet_Send_Transaction(*Network_Client, Window_ID, Action_ID, 0)
      Log_Add_Info("Transaction")
      
    Case $6B ; #### Creative Inventory Action
                Slot = Network_Client_Packet_Read_Word(*Network_Client)
      Protected Item_Type = Network_Client_Packet_Read_Word(*Network_Client)
      
      If Item_Type <> -1
        Protected Item_Count = Network_Client_Packet_Read_Ascii(*Network_Client)
        Protected Item_Metadata = Network_Client_Packet_Read_Word(*Network_Client)
      EndIf
      
      If *Network_Client\Entity
        Entity_Inventory_Set(*Network_Client\Entity, Slot, Item_Type, Item_Count, Item_Metadata)
      EndIf
      
      ;Log_Add_Info("Creative Inventory Action")
      
    Case $82 ; #### Update Sign
      Protected Text_1.s, Text_2.s, Text_3.s, Text_4.s
      iX = Network_Client_Packet_Read_Long(*Network_Client)
      iZ = Network_Client_Packet_Read_Unicode(*Network_Client)
      iY = Network_Client_Packet_Read_Long(*Network_Client)
      Text_1 = Network_Client_Packet_Read_String(*Network_Client)
      Text_2 = Network_Client_Packet_Read_String(*Network_Client)
      Text_3 = Network_Client_Packet_Read_String(*Network_Client)
      Text_4 = Network_Client_Packet_Read_String(*Network_Client)
      Log_Add_Debug("Update Sign: ("+Str(iX)+","+Str(iY)+","+Str(iZ)+") "+Text_1+"|"+Text_2+"|"+Text_3+"|"+Text_4)
      
    Case $CA ; #### Player Abilities
      Network_Client_Packet_Read_Byte(*Network_Client)
      ;Log_Add_Info("Player Abilities: Flying_Speed:"+Str(Network_Client_Packet_Read_Byte(*Network_Client)))
      Network_Client_Packet_Read_Byte(*Network_Client)
      
    Case $CC ; #### Locale and View Distance
      ;Log_Add_Info("Locale and View Distance:")
      ;Log_Add_Info("  Locale: "+Network_Client_Packet_Read_String(*Network_Client))
      ;Log_Add_Info("  View_Distance: "+Str(Network_Client_Packet_Read_Byte(*Network_Client)))
      ;Log_Add_Info("  Chat_Flags: "+Str(Network_Client_Packet_Read_Byte(*Network_Client)))
      ;Log_Add_Info("  Difficulty: "+Str(Network_Client_Packet_Read_Byte(*Network_Client)))
      
    Case $CD ; #### Client Statuses
      Protected Status = Network_Client_Packet_Read_Byte(*Network_Client)
      ;Log_Add_Debug("Client Statuses: "+Str(Status))
      
      If Status = 0 And *Network_Client\Logged_In = #False
        Protected *World.World = World_Get_By_Spawn_Priority()
        If Not *World
          ; Add Error-Handler here
          Log_Add_Error("World_Get_By_Spawn_Priority")
          ProcedureReturn #Result_Fail
        EndIf
        
        Protected *Player.Player = Player_Get_By_Name(*Network_Client\Login_Name, #True)
        If Not *Player
          ; Add Error-Handler here
          Log_Add_Error("Player_Get_By_Name")
          ProcedureReturn #Result_Fail
        EndIf
        
        Protected *Rank.Rank = Rank_Get_Nearest(*Player\Rank)
        If Not *Rank
          ; Add Error-Handler here
          Log_Add_Error("Rank_Get_Nearest")
          ProcedureReturn #Result_Fail
        EndIf
        
        *Network_Client\Player = *Player
        *Player\Counter_Login + 1
        *Player\IP = IPString(*Network_Client\IP)
        *Player\Write_To_Database = #True
        If Not *Player\Custom_Name
          *Player\Name_Prefix = *Rank\Prefix
          *Player\Name_Suffix = *Rank\Suffix
        EndIf
        
        Protected *Entity.Entity = Entity_Add(*World, *World\Spawn\X, *World\Spawn\Y, *World\Spawn\Z, 0, *Player\Name)
        If Not *Entity
          ; Add Error-Handler here
          Log_Add_Error("Entity_Add")
          ProcedureReturn #Result_Fail
        EndIf
        
        *Entity\Name_Prefix = *Player\Name_Prefix
        *Entity\Name_Suffix = *Player\Name_Suffix
        
        *Network_Client\Entity = *Entity
        *Entity\Network_Client = *Network_Client
        
        ;Network_Client_Packet_Send_Encryption_Key_Request(*Network_Client, "Test", @"Test", 8, @"as", 4)
        
        Network_Client_Packet_Send_Login_Response(*Network_Client, *Entity\ID, "SUPERFLAT", 1, 0, 0, 32)
        
        Network_Client_Packet_Send_Spawn_Position(*Network_Client, *World\Spawn\X, *World\Spawn\Y, *World\Spawn\Z)
        Network_Client_Packet_Send_Player_Position_And_Look(*Network_Client, *World\Spawn\X, *World\Spawn\Y, *World\Spawn\Z, *World\Spawn\Z+1.62, *World\Spawn\Yaw, *World\Spawn\Pitch, 0)
        
        *Network_Client\Logged_In = #True
        ;*Network_Client\Login_Name = Client_Name
        
        If *Entity\Inventory
          Network_Client_Packet_Send_Window_Items(*Network_Client, 0, *Entity\Inventory)
        EndIf
        
        ;Log_Add_Info("Login:")
        ;Log_Add_Info("  Version  : "+Str(Client_Version))
        ;Log_Add_Info("  Name     : "+Client_Name)
        ;Log_Add_Info("  Seed     : "+Str(Client_Seed))
        ;Log_Add_Info("  Dimension: "+Str(Client_Dimension))
        
        Plugin_Do_Event_Client_Login(*Network_Client, *Player\Name)
      EndIf
      
    Case $FE ; #### Server List Ping
      Protected Players
      PushListPosition(Network_Client())
      ForEach Network_Client()
        If Network_Client()\Logged_In
          Players + 1
        EndIf
      Next
      PopListPosition(Network_Client())
      Network_Client_Packet_Send_Kick(*Network_Client, System\Ping_Message+"§"+Str(Players)+"§"+Str(system\Max_Players))
      
    Case $FC ; #### Encryption Key Response
      Protected Shared_Secret_Length = Network_Client_Packet_Read_Unicode(*Network_Client)
      Protected *Shared_Secret = AllocateMemory(Shared_Secret_Length)
      If Not *Shared_Secret
        ; Add Error-Handler here
        Log_Add_Error("AllocateMemory(Shared_Secret_Length)")
        ProcedureReturn #Result_Fail
      EndIf
      Network_Client_Packet_Read_Memory(*Network_Client, *Shared_Secret, Shared_Secret_Length)
      Protected Verify_Token_Length = Network_Client_Packet_Read_Unicode(*Network_Client)
      Protected *Verify_Token = AllocateMemory(Verify_Token_Length)
      If Not *Verify_Token
        ; Add Error-Handler here
        Log_Add_Error("AllocateMemory(Verify_Token_Length)")
        FreeMemory(*Shared_Secret)
        ProcedureReturn #Result_Fail
      EndIf
      Network_Client_Packet_Read_Memory(*Network_Client, *Verify_Token, Verify_Token_Length)
      
      Protected *Shared_Secret_Dec = AllocateMemory(Shared_Secret_Length)
      If Not *Shared_Secret_Dec
        ; Add Error-Handler here
        Log_Add_Error("AllocateMemory(Shared_Secret_Length)")
        FreeMemory(*Shared_Secret)
        FreeMemory(*Verify_Token)
        ProcedureReturn #Result_Fail
      EndIf
      Protected *Verify_Token_Dec = AllocateMemory(Verify_Token_Length)
      If Not *Verify_Token_Dec
        ; Add Error-Handler here
        Log_Add_Error("AllocateMemory(Shared_Secret_Length)")
        FreeMemory(*Shared_Secret)
        FreeMemory(*Verify_Token)
        FreeMemory(*Shared_Secret_Dec)
        ProcedureReturn #Result_Fail
      EndIf
      Protected *Shared_Secret_Dec_E = AllocateMemory(Shared_Secret_Length)
      If Not *Shared_Secret_Dec_E
        ; Add Error-Handler here
        Log_Add_Error("AllocateMemory(Shared_Secret_Length)")
        FreeMemory(*Shared_Secret)
        FreeMemory(*Verify_Token)
        FreeMemory(*Shared_Secret_Dec)
        FreeMemory(*Verify_Token_Dec)
        ProcedureReturn #Result_Fail
      EndIf
      Protected *Verify_Token_Dec_E.long = AllocateMemory(Verify_Token_Length)
      If Not *Verify_Token_Dec_E
        ; Add Error-Handler here
        Log_Add_Error("AllocateMemory(Shared_Secret_Length)")
        FreeMemory(*Shared_Secret)
        FreeMemory(*Verify_Token)
        FreeMemory(*Shared_Secret_Dec)
        FreeMemory(*Verify_Token_Dec)
        FreeMemory(*Shared_Secret_Dec_E)
        ProcedureReturn #Result_Fail
      EndIf
      
      Log_Add_Info("Encryption Key Response: SS_Length="+Str(Shared_Secret_Length)+" VT_Length="+Str(Verify_Token_Length))
      
      rsa_private(Network_Encryption_Main\rsa, *Shared_Secret, *Shared_Secret_Dec)
      rsa_private(Network_Encryption_Main\rsa, *Verify_Token, *Verify_Token_Dec)
      
      ; #### Endian(m)ess...
      Protected i
      For i = 0 To Shared_Secret_Length - 1
        ;PokeA(*Shared_Secret_Dec_E + i, PeekA(*Shared_Secret_Dec + Shared_Secret_Length - i - 1))
        ;PokeA(*Verify_Token_Dec_E + i, PeekA(*Verify_Token_Dec + Verify_Token_Length - i - 1))
        
        PokeA(*Shared_Secret_Dec_E + i, PeekA(*Shared_Secret_Dec + i))
        PokeA(*Verify_Token_Dec_E + i, PeekA(*Verify_Token_Dec + i))
      Next
      
      ;Protected Temp_String.s
      ;For i = 0 To Shared_Secret_Length-1
      ;  If i % 16 = 0
      ;    Debug Temp_String
      ;    Temp_String = ""
      ;  EndIf
      ;  Temp_String.s + RSet(Hex(PeekA(*Shared_Secret_Dec_E+i)), 2, "0") + " "
      ;Next
      ;Debug Temp_String
      
      ;Temp_String = ""
      ;For i = 0 To Verify_Token_Length-1
      ;  If i % 16 = 0
      ;    Debug Temp_String
      ;    Temp_String = ""
      ;  EndIf
      ;  Temp_String.s + RSet(Hex(PeekA(*Verify_Token_Dec_E+i)), 2, "0") + " "
      ;Next
      ;Debug Temp_String
      
      If Not PeekL(*Verify_Token_Dec_E + Verify_Token_Length - 4) = 123456789
        Log_Add_Error("Verify-Token is wrong. ("+Str(*Verify_Token_Dec_E\l)+")")
        Network_Client_Packet_Send_Kick(*Network_Client, "§cVerify Token is wrong!")
        FreeMemory(*Shared_Secret)
        FreeMemory(*Verify_Token)
        FreeMemory(*Shared_Secret_Dec)
        FreeMemory(*Verify_Token_Dec)
        FreeMemory(*Shared_Secret_Dec_E)
        FreeMemory(*Verify_Token_Dec_E)
        ProcedureReturn #Result_Fail
      EndIf
      
      ; #### Add player authenticity check here!
      
      Network_Client_Packet_Send_Encryption_Key_Response(*Network_Client, #Null, 0, #Null, 0)
      
      Network_Client_Enable_Decryption(*Network_Client, *Shared_Secret_Dec_E + Shared_Secret_Length - 16) ; Client has already encryption activated!
      Network_Client_Enable_Encryption(*Network_Client, *Shared_Secret_Dec_E + Shared_Secret_Length - 16)
      
      FreeMemory(*Shared_Secret)
      FreeMemory(*Verify_Token)
      FreeMemory(*Shared_Secret_Dec)
      FreeMemory(*Verify_Token_Dec)
      FreeMemory(*Shared_Secret_Dec_E)
      FreeMemory(*Verify_Token_Dec_E)
      
      ;Network_Client_Delete(*Network_Client)
      
      ProcedureReturn #Result_Fail
      
    Case $FF ; #### Disconnect
      Network_Client_Packet_Send_Kick(*Network_Client, "cya")
      
    Default  ; #### Unknown
      Network_Client_Packet_Send_Kick(*Network_Client, "§cNetwork Error... :\ §e("+Str(Packet_Type)+") §dSorryz!")
      Log_Add_Error("Unknown Packet: "+Str(Packet_Type))
      
      
  EndSelect
EndProcedure

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 1695
; FirstLine = 1656
; Folding = ---------------
; EnableXP
; DisableDebugger