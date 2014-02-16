; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Prototypes ################################################

Prototype.i Timer_Function()

; #################################################### Structures ################################################

Structure Timer_Main
  PerformanceCounter.l
  Counts_Per_Second.q
EndStructure

Structure Timer
  ID.s
  
  Realtime.i
  
  Timer.i       ; Time, when the procedure gets triggered next
  Time.i        ; Time, between trigger events
  
  Max_Iterations.i
  
  Function.Timer_Function
EndStructure

; #################################################### Variables #################################################

Global Timer_Main.Timer_Main

Global NewList Timer.Timer()

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Initstuff #################################################

Timer_Main\PerformanceCounter = QueryPerformanceFrequency_(@Timer_Main\Counts_Per_Second)

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Timer_Milliseconds()
  Protected Temp_Timer.q
  If Timer_Main\PerformanceCounter
    QueryPerformanceCounter_(@Temp_Timer)
    Temp_Timer * 1000
    Temp_Timer / Timer_Main\Counts_Per_Second
    ProcedureReturn Temp_Timer
  Else
    ProcedureReturn ElapsedMilliseconds()
  EndIf
EndProcedure

Procedure Timer_Unregister(ID.s)
  ForEach Timer()
    If Timer()\ID = ID
      DeleteElement(Timer())
      ProcedureReturn #Result_Success
      Break
    EndIf
  Next
  
  ProcedureReturn #Result_Fail
EndProcedure

Procedure Timer_Register(ID.s, Realtime, Time, *Function, Max_Iterations=10)
  Timer_Unregister(ID)
  
  If Not AddElement(Timer())
    ProcedureReturn #Result_Fail
  EndIf
  
  Timer()\ID = ID
  Timer()\Realtime = Realtime
  Timer()\Time = Time
  Timer()\Timer = Timer_Milliseconds()
  Timer()\Function = *Function
  Timer()\Max_Iterations = Max_Iterations
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Timer_Main()
  Protected Remaining_Time, Iteration
  
  ForEach Timer()
    Remaining_Time = Timer()\Timer - Timer_Milliseconds()
    
    If Remaining_Time > Timer()\Time * 2
      Timer()\Timer = Timer_Milliseconds()
      Log_Add_Warn("Timer "+Timer()\ID+" (realtime-mode) is too busy!")
    EndIf
    
    Iteration = 0
    
    While Remaining_Time <= 0 And Iteration < Timer()\Max_Iterations
      If Timer()\Realtime
        Timer()\Timer + Timer()\Time
      Else
        Timer()\Timer = Timer_Milliseconds() + Timer()\Time
      EndIf
      
      Timer()\Function()
      
      If Timer()\Realtime
        Remaining_Time = Timer()\Timer - Timer_Milliseconds()
        Iteration + 1
      Else
        Break
      EndIf
    Wend
  Next
EndProcedure

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 97
; FirstLine = 75
; Folding = -
; EnableXP
; DisableDebugger