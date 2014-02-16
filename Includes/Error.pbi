; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Error_Handler()
  PrintN("")
  PrintN("")
  PrintN("Message: "+ErrorMessage())
  PrintN("Code: "+Str(ErrorCode()))
  PrintN("Address: "+Str(ErrorAddress()))
  If ErrorCode() = #PB_OnError_InvalidMemory   
    PrintN("Target Address: "+Str(ErrorTargetAddress()))
  EndIf
  PrintN("Line: "+Str(ErrorLine()))
  PrintN("File: "+GetFilePart(ErrorFile()))
  PrintN("")
  PrintN("")
  PrintN("##############################")
  PrintN("#  !!!! Server crashed !!!!  #")
  PrintN("#                            #")
  PrintN("# You can find more          #")
  PrintN("# information about the      #")
  PrintN("# the crash in               #")
  PrintN("# HTML/Error_*.html          #")
  PrintN("#                            #")
  PrintN("# Please send the html       #")
  PrintN("# file to the developer      #")
  PrintN("# ( Dadido3@aol.com )        #")
  PrintN("#                            #")
  PrintN("# Sorry for the crash.       #")
  PrintN("#                            #")
  PrintN("##############################")
  
  ;Delay(30000)
  Input()
  
EndProcedure

; #################################################### Initstuff #################################################

OnErrorCall(@Error_Handler())

; #################################################### Datasections ##############################################


; IDE Options = PureBasic 4.51 (Windows - x64)
; CursorPosition = 39
; FirstLine = 8
; Folding = -
; EnableXP