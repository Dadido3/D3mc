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

#Plugin_Name = "Midi"
#Plugin_Author = "David Vogel"

; ################################################### Structures ############################################

Structure Plugin_Main
  Date_ms.q
  Date_ms_Diff.q
  Second.d
  Minute.d
  Hour.d
EndStructure

Structure Note
  Channel.l
  Note.l
  Vel.l
EndStructure

; ################################################### Declares ##############################################

Declare   MIDICallBack(hMi.l, wMsg.l, dummy.l , Data1.l, Data2.l)

; ################################################### Prototypes ############################################

; ################################################### Procedures ############################################

ProcedureCDLL Init(*Plugin_Info.Plugin_Info, *Plugin_Function.Plugin_Function) ; Aufgerufen beim Laden der Library / Called with the loading of the library
  *Plugin_Info\Name = #Plugin_Name
  *Plugin_Info\Version = #Plugin_Version
  *Plugin_Info\Author = #Plugin_Author
  
  Define_Prototypes(*Plugin_Function)
  
  Global Plugin_Main.Plugin_Main
  
  Plugin_Main\Date_ms_Diff = ElapsedMilliseconds() - Date()*1000
  
  Global hMiP0.l = 0
  Global NewList Eventlist.Note()
  Global Mutex = CreateMutex()
  
  midiInOpen_(@hMiP0, 5, @MIDICallBack(), 0, #CALLBACK_FUNCTION)
  midiInStart_(hMiP0)
  
  ProcedureReturn #Result_Success
EndProcedure

ProcedureCDLL Deinit() ; Aufgerufen beim Entladen der Library / Called with the unloading of the library
  
  midiInReset_(hMiP0)
  midiInClose_(hMiP0)
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure MIDICallBack(hMi.l, wMsg.l, dummy.l , Data1.l, Data2.l)
  Select wMsg    ; process MIDI in events 
    Case #MM_MIM_DATA 
      Status = Data1 & 255 
      If Status >= 144 And Status < 160
          NT=(Data1 >> 8) & 255 
          Vel= (Data1 >> 16) & 255 
          If Vel 
            LockMutex(Mutex)
            
            LastElement(Eventlist())
            AddElement(Eventlist())
            Eventlist()\Note = NT
            Eventlist()\Vel = Vel
            Eventlist()\Channel = Status - 144
            
            UnlockMutex(Mutex)
          EndIf
          ;Debug " Note : "+MIDI_Note(NT)+" "+Str(NT)
          ;Debug "  Vel : " + Str(Vel)
     EndIf 
  EndSelect 
EndProcedure

ProcedureCDLL Main()
  Protected Note, Temp_Type
  Protected *World.World = World_Get_By_ID(2)
  
  LockMutex(Mutex)
  
  While FirstElement(Eventlist())
    Note = Eventlist()\Note - 54 - 24
    Vel = Eventlist()\Vel
    Channel = Eventlist()\Channel
    Pos_X = Channel
    DeleteElement(Eventlist())
    If Note >= 0 And Note <= 24
      Pos_Y = 0
      Tune.f = 31/63 + (Pow(2, Note/12)-1)/2
      Volume.f = Vel/127
      Sound.s = "note.pling"
      World_Block_Get(*World, Pos_X, Pos_Y, 11, @Temp_Type)
      World_Effect_Action(*World, Pos_X, Pos_Y, 10, 0, Note, 25)
      World_Block_Set(*World, Pos_X, Pos_Y, 10, 35, Note, -1, -1, -1, 1, 1, 1)
      If Temp_Type = 0
        World_Effect_Sound(*World, Sound, Pos_X, Pos_Y, 10, Volume, Tune)
      EndIf
    EndIf
    Note + 24
    If Note >= 0 And Note < 24
      Pos_Y = 0
      Tune.f = 31/63 + (Pow(2, Note/12)-1)/2
      Volume.f = Vel/127
      Sound.s = "note.pling"
      World_Block_Get(*World, Pos_X, Pos_Y, 11, @Temp_Type)
      World_Effect_Action(*World, Pos_X, Pos_Y, 10, 0, Note, 25)
      World_Block_Set(*World, Pos_X, Pos_Y, 10, 35, Note, -1, -1, -1, 1, 1, 1)
      If Temp_Type = 0
        World_Effect_Sound(*World, Sound, Pos_X, Pos_Y, 10, Volume, Tune)
      EndIf
    EndIf
    Note + 24
    If Note >= 0 And Note < 24
      Pos_Y = 5
      Tune.f = 31/63 + (Pow(2, Note/12)-1)/2
      Volume.f = Vel/127
      Sound.s = "note.bass"
      World_Block_Get(*World, Pos_X, Pos_Y, 11, @Temp_Type)
      World_Effect_Action(*World, Pos_X, Pos_Y, 10, 0, Note, 25)
      World_Block_Set(*World, Pos_X, Pos_Y, 10, 35, Note, -1, -1, -1, 1, 1, 1)
      If Temp_Type = 0
        World_Effect_Sound(*World, Sound, Pos_X, Pos_Y, 10, Volume, Tune)
      EndIf
    EndIf
    
    
    
    ;Log_Add_Debug("Note:"+Str(Note)+"   Vel:"+Str(Vel)+"   Tune_Raw:"+StrF(Tune*63)+"   Tune_Raw:"+Str(Tune*63)+"   Tune:"+StrF(Tune))
    
  Wend
  
  UnlockMutex(Mutex)
  
  ;For i = 1 To 20
  ;  World_Effect_Action(*World, 1, 1, 10, 0, 0, 25)
  ;Next
EndProcedure
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; ExecutableFormat = Shared Dll
; CursorPosition = 167
; FirstLine = 120
; Folding = -
; EnableUnicode
; EnableThread
; EnableXP
; EnableOnError
; Executable = Midi.x64.dll
; DisableDebugger