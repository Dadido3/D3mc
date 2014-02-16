; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Rank_Main
  File_Save.i
  File_Last_Date.i
EndStructure

; #################################################### Variables #################################################

Global Rank_Main.Rank_Main

Global NewList Rank.Rank()

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Rank_Get(Rank)
  ForEach Rank()
    If Rank()\Rank = Rank
      ProcedureReturn Rank()
    EndIf
  Next
  
  ProcedureReturn #Null
EndProcedure

Procedure Rank_Get_Nearest(Rank)
  Protected *Result.Rank
  
  ForEach Rank()
    If Rank()\Rank <= Rank
      *Result = Rank()
    Else
      Break
    EndIf
  Next
  
  ProcedureReturn *Result
EndProcedure

Procedure Rank_Load(Filename.s)
  Protected i
  
  If OpenPreferences(Filename.s)
    
    ClearList(Rank())
    
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        AddElement(Rank())
        
        Rank()\Rank = Val(PreferenceGroupName())
        Rank()\Name = ReadPreferenceString("Name", "")
        Rank()\Prefix = ReadPreferenceString("Prefix", "["+Str(Rank()\Rank)+"]")
        Rank()\Suffix = ReadPreferenceString("Suffix", "")
        
      Wend
    EndIf
    
    SortStructuredList(Rank(), #PB_Sort_Ascending, OffsetOf(Rank\Rank), #PB_Long)
    
    ClosePreferences()
    ;Rank_Main\File_Save = 1
    Rank_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure Rank_Save(Filename.s)
  Protected i
  Protected File_ID
  
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    ForEach Rank()
      WriteStringN(File_ID, "["+Str(Rank()\Rank)+"]")
      WriteStringN(File_ID, "Name = "+Rank()\Name)
      WriteStringN(File_ID, "Prefix = "+Rank()\Prefix)
      WriteStringN(File_ID, "Suffix = "+Rank()\Suffix)
      WriteStringN(File_ID, "")
    Next
    
    CloseFile(File_ID)
    Rank_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure Rank_Main()
  Protected Filename.s
  Filename = Space(Files_File_Get("Rank", 0))
  Files_File_Get("Rank", @Filename)
  
  If Rank_Main\File_Save
    Rank_Main\File_Save = 0
    
    Rank_Save(Filename)
  Else
    
    If Rank_Main\File_Last_Date <> GetFileDate(Filename, #PB_Date_Modified)
      Rank_Load(Filename)
    EndIf
  EndIf
  
EndProcedure
Timer_Register("Rank", 0, 1000, @Rank_Main())
; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 70
; FirstLine = 51
; Folding = -
; EnableXP