; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Network_Encryption_Main
  rsa.rsa_context
  entropy.entropy_context
  ctr_drbg.ctr_drbg_context
  *Public_Key_PEM
  Public_Key_PEM_Size.i
EndStructure

Structure AES_CFB_IV
  IV.a[64+1]
EndStructure

; #################################################### Variables #################################################

Global Network_Encryption_Main.Network_Encryption_Main

; #################################################### Includes ##################################################

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Procedures ################################################

Procedure StartAESCipher_CFB(*Ctx.AES_CFB, *Key, Bits, *IV, Mode)
  If Not *Ctx
    ProcedureReturn #False
  EndIf
  
  If Not Bits = 128 ; Only 128 bit yet!
    ProcedureReturn #False
  EndIf
  
  *Ctx\AESCipher_ID = StartAESCipher(#PB_Any, *Key, Bits, *IV, #PB_Cipher_Encode | #PB_Cipher_ECB)
  If Not *Ctx\AESCipher_ID
    ProcedureReturn #False
  EndIf
  
  *Ctx\Mode = Mode
  *Ctx\Bits = Bits
  CopyMemory(*IV, @*Ctx\IV[0], Bits/8)
  
  ProcedureReturn #True
EndProcedure

Procedure AddCipherBuffer_CFB(*Ctx.AES_CFB, *Input, *Output, Size)
  Protected IV_Position.i, Temp.a
  
  If Not *Ctx
    ProcedureReturn #False
  EndIf
  
  If Not *Ctx\AESCipher_ID
    ProcedureReturn #False
  EndIf
  
  IV_Position = *Ctx\IV_Position
  
  If *Ctx\Mode = #PB_Cipher_Decode
    While Size : Size - 1
      If IV_Position = 0
        AddCipherBuffer(*Ctx\AESCipher_ID, @*Ctx\IV[0], @*Ctx\IV[0], 16)
      EndIf
      
      Temp = PeekA(*Input) : *Input + 1
      PokeA(*Output, Temp ! *Ctx\IV[IV_Position]) : *Output + 1
      *Ctx\IV[IV_Position] = Temp
      
      IV_Position = (IV_Position + 1) & $0F
    Wend
  Else
    While Size : Size - 1
      If IV_Position = 0
        AddCipherBuffer(*Ctx\AESCipher_ID, @*Ctx\IV[0], @*Ctx\IV[0], 16)
      EndIf
      
      Temp = (*Ctx\IV[IV_Position] ! PeekA(*Input)) : *Input + 1
      PokeA(*Output, Temp) : *Output + 1
      *Ctx\IV[IV_Position] = Temp
      
      IV_Position = (IV_Position + 1) & $0F
    Wend
  EndIf
  
  *Ctx\IV_Position = IV_Position
  
  ProcedureReturn #True
EndProcedure

Procedure AddCipherBuffer_CFB8(*Ctx.AES_CFB, *Input, *Output, Size)
  Protected Temp.a, Temp_IV.AES_CFB_IV
  
  If Not *Ctx
    ProcedureReturn #False
  EndIf
  
  If Not *Ctx\AESCipher_ID
    ProcedureReturn #False
  EndIf
  
  If *Ctx\Mode = #PB_Cipher_Decode
    While Size : Size - 1
      CopyMemory(@*Ctx\IV[0], @Temp_IV\IV[0], 16)
      
      AddCipherBuffer(*Ctx\AESCipher_ID, @*Ctx\IV[0], @*Ctx\IV[0], 16)
      
      Temp = PeekA(*Input) : *Input + 1
      PokeA(*Output, Temp ! *Ctx\IV[0]) : *Output + 1
      Temp_IV\IV[16] = Temp
      
      CopyMemory(@Temp_IV\IV[1], @*Ctx\IV[0], 16)
    Wend
  Else
    While Size : Size - 1
      CopyMemory(@*Ctx\IV[0], @Temp_IV\IV[0], 16)
      
      AddCipherBuffer(*Ctx\AESCipher_ID, @*Ctx\IV[0], @*Ctx\IV[0], 16)
      
      Temp = (PeekA(*Input) ! *Ctx\IV[0]) : *Input + 1
      PokeA(*Output, Temp) : *Output + 1
      Temp_IV\IV[16] = Temp
      
      CopyMemory(@Temp_IV\IV[1], @*Ctx\IV[0], 16)
    Wend
  EndIf
  
  ProcedureReturn #True
EndProcedure

Procedure FinishCipher_CFB(*Ctx.AES_CFB)
  
  If *Ctx\AESCipher_ID
    FinishCipher(*Ctx\AESCipher_ID)
  EndIf
  
  *Ctx\AESCipher_ID = 0
  
  ProcedureReturn #True
EndProcedure

Procedure Network_Encryption_Deinit()
  rsa_free(Network_Encryption_Main\rsa)
  
  If Network_Encryption_Main\Public_Key_PEM
    FreeMemory(Network_Encryption_Main\Public_Key_PEM)
    Network_Encryption_Main\Public_Key_PEM = #Null
    Network_Encryption_Main\Public_Key_PEM_Size = 0
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Network_Encryption_Init(Key_Size=1024, Custom_String.s="SSdtIGdheSBhbmQgeWVhaCwgbm93IHlvdSBrbm93IGl0IDsp")
  Protected Temp_Result
  Protected *Temp_N, Temp_N_Length
  Protected *Temp_E, Temp_E_Length
  Protected *Temp_Pointer
  
  Network_Encryption_Deinit()
  
  entropy_init(Network_Encryption_Main\entropy)
  Temp_Result = ctr_drbg_init(Network_Encryption_Main\ctr_drbg, @entropy_func(), Network_Encryption_Main\entropy, @Custom_String, StringByteLength(Custom_String))
  
  If Temp_Result
    ; Add Error-Handler here
    Log_Add_Error("ctr_drbg_init returned "+Str(Temp_Result))
    ProcedureReturn #Result_Fail
  EndIf
  
  rsa_init(Network_Encryption_Main\rsa, #RSA_PKCS_V15, 0)
  Temp_Result = rsa_gen_key(Network_Encryption_Main\rsa, @ctr_drbg_random(), Network_Encryption_Main\ctr_drbg, Key_Size, 65537)
  If Temp_Result
    ; Add Error-Handler here
    Log_Add_Error("rsa_gen_key returned "+Str(Temp_Result))
    ProcedureReturn #Result_Fail
  EndIf
  
  ; #### Create the public-key. ASN.1 (Basic Encoding Rules)
  
  Temp_N_Length = mpi_size(Network_Encryption_Main\rsa\N) + 1
  *Temp_N = AllocateMemory(Temp_N_Length)
  If Not *Temp_N
    ; Add Error-Handler here
    Log_Add_Error("AllocateMemory(Temp_N_Length)")
    ProcedureReturn #Result_Fail
  EndIf
  Temp_E_Length = mpi_size(Network_Encryption_Main\rsa\E)
  *Temp_E = AllocateMemory(Temp_E_Length)
  If Not *Temp_E
    ; Add Error-Handler here
    FreeMemory(*Temp_N)
    Log_Add_Error("AllocateMemory(Temp_E_Length)")
    ProcedureReturn #Result_Fail
  EndIf
  mpi_write_binary(Network_Encryption_Main\rsa\N, *Temp_N, Temp_N_Length)
  mpi_write_binary(Network_Encryption_Main\rsa\E, *Temp_E, Temp_E_Length)
  
  Network_Encryption_Main\Public_Key_PEM_Size = ?Public_Key_BER_B_End-?Public_Key_BER_A + Temp_N_Length + Temp_E_Length + 2
  Network_Encryption_Main\Public_Key_PEM = AllocateMemory(Network_Encryption_Main\Public_Key_PEM_Size)
  If Not Network_Encryption_Main\Public_Key_PEM
    ; Add Error-Handler here
    FreeMemory(*Temp_N)
    FreeMemory(*Temp_E)
    Log_Add_Error("AllocateMemory(Network_Encryption_Main\Public_Key_PEM_Size)")
    ProcedureReturn #Result_Fail
  EndIf
  
  ; #### DON'T ask how that code works, it just does!
  *Temp_Pointer = Network_Encryption_Main\Public_Key_PEM
  CopyMemory(?Public_Key_BER_A, *Temp_Pointer, ?Public_Key_BER_A_End-?Public_Key_BER_A) : *Temp_Pointer + ?Public_Key_BER_A_End-?Public_Key_BER_A
  PokeA(*Temp_Pointer, Temp_N_Length) : *Temp_Pointer + 1
  CopyMemory(*Temp_N, *Temp_Pointer, Temp_N_Length) : *Temp_Pointer + Temp_N_Length
  CopyMemory(?Public_Key_BER_B, *Temp_Pointer, ?Public_Key_BER_B_End-?Public_Key_BER_B) : *Temp_Pointer + ?Public_Key_BER_B_End-?Public_Key_BER_B
  PokeA(*Temp_Pointer, Temp_E_Length) : *Temp_Pointer + 1
  CopyMemory(*Temp_E, *Temp_Pointer, Temp_E_Length) : *Temp_Pointer + Temp_E_Length
  
  *Temp_Pointer = Network_Encryption_Main\Public_Key_PEM + 2
  PokeA(*Temp_Pointer, Network_Encryption_Main\Public_Key_PEM_Size - 3)
  *Temp_Pointer = Network_Encryption_Main\Public_Key_PEM + 20
  PokeA(*Temp_Pointer, Network_Encryption_Main\Public_Key_PEM_Size - 21)
  *Temp_Pointer = Network_Encryption_Main\Public_Key_PEM + 24
  PokeA(*Temp_Pointer, Network_Encryption_Main\Public_Key_PEM_Size - 25)
  
  ;Protected i, Temp_String.s
  ;For i = 0 To Network_Encryption_Main\Public_Key_PEM_Size-1
  ;  If i % 16 = 0
  ;    Debug Temp_String
  ;    Temp_String = ""
  ;  EndIf
  ;  Temp_String.s + RSet(Hex(PeekA(Network_Encryption_Main\Public_Key_PEM+i)), 2, "0") + " "
  ;Next
  ;Debug Temp_String
  
  FreeMemory(*Temp_N)
  FreeMemory(*Temp_E)
  
  ProcedureReturn #Result_Success
EndProcedure

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################

DataSection
  Public_Key_BER_A:
  Data.a $30,$81,$9F,$30,$0D,$06,$09,$2A,$86,$48,$86,$F7,$0D,$01,$01,$01,$05,$00,$03,$81,$8D,$00,$30,$81,$89,$02,$81
  Public_Key_BER_A_End:
  
  Public_Key_BER_B:
  Data.a $02
  Public_Key_BER_B_End:
EndDataSection
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 18
; Folding = --
; EnableXP