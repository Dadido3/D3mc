; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Log_Main
  Filename.s
  File_ID.i
EndStructure

; #################################################### Variables #################################################

Global Log_Main.Log_Main

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

Declare   Log_Add(Type.s, Message.s, _Include.s, _Procedure.s, _Line, _Thread)

; #################################################### Macros ####################################################

Macro Log_Add_Info(Message)
  Log_Add(#Log_Type_Information, Message, GetFilePart(#PB_Compiler_File), #PB_Compiler_Procedure, #PB_Compiler_Line, #PB_Compiler_Thread)
EndMacro

Macro Log_Add_Warn(Message)
  Log_Add(#Log_Type_Warning, Message, GetFilePart(#PB_Compiler_File), #PB_Compiler_Procedure, #PB_Compiler_Line, #PB_Compiler_Thread)
EndMacro

Macro Log_Add_Error(Message)
  Log_Add(#Log_Type_Error, Message, GetFilePart(#PB_Compiler_File), #PB_Compiler_Procedure, #PB_Compiler_Line, #PB_Compiler_Thread)
EndMacro

Macro Log_Add_Chat(Message)
  Log_Add(#Log_Type_Chat, Message, GetFilePart(#PB_Compiler_File), #PB_Compiler_Procedure, #PB_Compiler_Line, #PB_Compiler_Thread)
EndMacro

Macro Log_Add_Debug(Message)
  Log_Add(#Log_Type_Debug, Message, GetFilePart(#PB_Compiler_File), #PB_Compiler_Procedure, #PB_Compiler_Line, #PB_Compiler_Thread)
EndMacro

; #################################################### Procedures ################################################

Procedure Log_Add(Type.s, Message.s, _Include.s, _Procedure.s, _Line, _Thread)
  Select Type
    Case #Log_Type_Information
      PrintN(Type+"| "+Message)
    Case #Log_Type_Warning
      PrintN(Type+"| "+LSet(_Procedure, 30, " ")+"| "+LSet(Str(_Line), 5, " ")+"| "+Message)
    Case #Log_Type_Error
      PrintN(Type+"| "+LSet(_Procedure, 30, " ")+"| "+LSet(Str(_Line), 5, " ")+"| "+Message)
    Case #Log_Type_Chat
      PrintN(Type+"| "+Message)
    Case #Log_Type_Debug
      PrintN(Type+"| "+LSet(_Procedure, 30, " ")+"| "+LSet(Str(_Line), 5, " ")+"| "+Message)
  EndSelect
  
  If Not Log_Main\File_ID
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  WriteStringN(Log_Main\File_ID, Message)
  
  ProcedureReturn #Result_Success
EndProcedure

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 58
; FirstLine = 25
; Folding = --
; EnableXP
; DisableDebugger