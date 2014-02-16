; ################################################### Documentation #########################################
; 
; Todo:
;  - 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; 
; ################################################### Inits #################################################

; ################################################### Konstants #############################################

#Plugin_Define_Prototypes = #True

#Plugin_Version = 1000

; ################################################### Variables/Structures ##################################

; ################################################### Includes ##############################################

XIncludeFile "S_Includes/Constants.pbi"
XIncludeFile "S_Includes/Structures.pbi"
XIncludeFile "S_Includes/Functions.pbi"

; ################################################### Declares ##############################################

; ################################################### Macros ################################################

;Macro List_Store(Pointer, Listname)
;  If ListIndex(Listname) <> -1
;    Pointer = Listname
;  Else
;    Pointer = 0
;  EndIf
;EndMacro

;Macro List_Restore(Pointer, Listname)
;  If Pointer
;    ChangeCurrentElement(Listname, Pointer)
;  EndIf
;EndMacro

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

; ################################################### Procedures ############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 26
; Folding = -
; EnableXP