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
; ################################################### Includes ##############################################

IncludePath "../../"
XIncludeFile "Plugins/SDK/Include.pbi"

; ################################################### Inits #################################################

; ################################################### Konstants #############################################

#Plugin_Name = "Example"
#Plugin_Author = "David Vogel"

; ################################################### Structures ############################################

Structure Plugin_Main
  Date_ms.q
  Date_ms_Diff.q
  Second.d
  Minute.d
  Hour.d
EndStructure

; ################################################### Declares ##############################################

; ################################################### Prototypes ############################################

; ################################################### Procedures ############################################

ProcedureCDLL Init(*Plugin_Info.Plugin_Info, *Plugin_Function.Plugin_Function) ; Aufgerufen beim Laden der Library / Called with the loading of the library
  *Plugin_Info\Name = #Plugin_Name
  *Plugin_Info\Version = #Plugin_Version
  *Plugin_Info\Author = #Plugin_Author
  
  Define_Prototypes(*Plugin_Function)
  
  Global Plugin_Main.Plugin_Main
  
  Plugin_Main\Date_ms_Diff = ElapsedMilliseconds() - Date()*1000
  
  ProcedureReturn #Result_Success
EndProcedure

ProcedureCDLL Deinit() ; Aufgerufen beim Entladen der Library / Called with the unloading of the library
  
  ProcedureReturn #Result_Success
EndProcedure

#X_ = 2.0
#Y_ = 416.0
#Z_ = 77

ProcedureCDLL Main()
  Protected i
  Global TempTimer
  
  If TempTimer < ElapsedMilliseconds()
    TempTimer = ElapsedMilliseconds() + 50
    
    For i = 0 To 10*2
      World_Block_Set(World_Get_By_ID(1), #X_+Cos(Radian(Plugin_Main\Hour*30))*i, #Y_+Sin(Radian(Plugin_Main\Hour*30))*i, #Z_, 1, 0)
    Next
    
    For i = 0 To 12*2
      World_Block_Set(World_Get_By_ID(1), #X_+Cos(Radian(Plugin_Main\Minute*6))*i, #Y_+Sin(Radian(Plugin_Main\Minute*6))*i, #Z_, 1, 0)
    Next
    
    For i = 0 To 14*2
      World_Block_Set(World_Get_By_ID(1), #X_+Cos(Radian(Plugin_Main\Second*6))*i, #Y_+Sin(Radian(Plugin_Main\Second*6))*i, #Z_, 1, 0)
    Next
    
    For i = 0 To 5*2
      World_Block_Set(World_Get_By_ID(1), #X_+Cos(Radian(Plugin_Main\Second*360))*i, #Y_+Sin(Radian(Plugin_Main\Second*360))*i, #Z_, 1, 0)
    Next
    
    Plugin_Main\Date_ms = (ElapsedMilliseconds() - Plugin_Main\Date_ms_Diff)
    
    Plugin_Main\Second = Plugin_Main\Date_ms /    1000
    Plugin_Main\Minute = Plugin_Main\Date_ms /   60000
    Plugin_Main\Hour   = Plugin_Main\Date_ms / 3600000
    
    For i = 0 To 10*2
      World_Block_Set(World_Get_By_ID(1), #X_+Cos(Radian(Plugin_Main\Hour*30))*i, #Y_+Sin(Radian(Plugin_Main\Hour*30))*i, #Z_, 35, 3)
    Next
    
    For i = 0 To 12*2
      World_Block_Set(World_Get_By_ID(1), #X_+Cos(Radian(Plugin_Main\Minute*6))*i, #Y_+Sin(Radian(Plugin_Main\Minute*6))*i, #Z_, 35, 5)
    Next
    
    For i = 0 To 14*2
      World_Block_Set(World_Get_By_ID(1), #X_+Cos(Radian(Plugin_Main\Second*6))*i, #Y_+Sin(Radian(Plugin_Main\Second*6))*i, #Z_, 35, 14)
    Next
    
    For i = 0 To 5*2
      World_Block_Set(World_Get_By_ID(1), #X_+Cos(Radian(Plugin_Main\Second*360))*i, #Y_+Sin(Radian(Plugin_Main\Second*360))*i, #Z_, 35, 15)
    Next
    
  EndIf
EndProcedure
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; ExecutableFormat = Shared Dll
; CursorPosition = 65
; FirstLine = 62
; Folding = -
; EnableThread
; EnableXP
; EnableOnError
; Executable = Example.x64.dll
; DisableDebugger