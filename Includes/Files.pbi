; ########################################## Variablen ##########################################

Structure Files_Main
  Save_File.b                     ; Pfad-Datei soll gespeichert werden
  Mutex_ID.i                      ; Mutex, um doppelte Zugriffe zu verhindern.
EndStructure
Global Files_Main.Files_Main

Structure Files_File
  Name.s
  File.s
EndStructure
Global NewList Files_File.Files_File()

Structure Files_Folder
  Name.s
  Folder.s
EndStructure
Global NewList Files_Folder.Files_Folder()

; ########################################## Declares ############################################

Declare Files_Load(Filename.s)
Declare Files_Save(Filename.s)

Declare Files_File_Get(File.s, *Result)
Declare Files_Folder_Get(Name.s, *Result)

; ########################################## Ladekram ############################################

Files_Main\Mutex_ID = CreateMutex()

AddElement(Files_File())
Files_File()\Name = "Files"
Files_File()\File = "Files.txt"

Define Temp_String.s = Space(Files_File_Get("Files", 0))
Files_File_Get("Files", @Temp_String)
Files_Load(Temp_String)

; ########################################## Proceduren ##########################################

Procedure Files_Save(Filename.s)
  Protected File_ID
  
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    WriteStringN(File_ID, "; You have to restart if you change the file.")
    WriteStringN(File_ID, "; ")
    WriteStringN(File_ID, "; How it works:")
    WriteStringN(File_ID, ";   [Folder]")
    WriteStringN(File_ID, ";   Main = ../")
    WriteStringN(File_ID, ";   Data = Data/")
    WriteStringN(File_ID, ";   ")
    WriteStringN(File_ID, ";   [Files]")
    WriteStringN(File_ID, ";   Answer = [Main][Data]Answer.txt")
    WriteStringN(File_ID, "; ")
    WriteStringN(File_ID, "; Means that the File Answer is in '../Data/Answer.txt'.")
    WriteStringN(File_ID, "; You can create your own folders if you want:")
    WriteStringN(File_ID, ";   Example: [Folder]")
    WriteStringN(File_ID, ";            Log = Log/")
    WriteStringN(File_ID, ";            ")
    WriteStringN(File_ID, ";            [Files]")
    WriteStringN(File_ID, ";            Log = [Main][Log]Log_[i].txt")
    WriteStringN(File_ID, "; ")
    
    WriteStringN(File_ID, "")
    
    WriteStringN(File_ID, "[Folder]")
    ForEach Files_Folder()
      WriteStringN(File_ID, Files_Folder()\Name+" = "+Files_Folder()\Folder)
    Next
    
    WriteStringN(File_ID, "")
    
    WriteStringN(File_ID, "[Files]")
    ForEach Files_Folder()
      If Files_File()\Name <> "Files"
        WriteStringN(File_ID, Files_File()\Name+" = "+Files_File()\File)
      EndIf
    Next
    
    CloseFile(File_ID)
  EndIf
EndProcedure

Procedure Files_Load(Filename.s)
  Protected Opened
  
  Opened = OpenPreferences(Filename.s)
  
  ClearList(Files_Folder())
  
  PreferenceGroup("Folder")
  If ExaminePreferenceKeys()
    While NextPreferenceKey()
      AddElement(Files_Folder())
      Files_Folder()\Name = PreferenceKeyName()
      Files_Folder()\Folder = PreferenceKeyValue()
      ;CreateDirectory(Files_Folder()\Folder) Ist nicht ganz korrekt, es muss unterordner beachten ([Main][Test1][Test2])
    Wend
  EndIf
  
  ClearList(Files_File())
  
  PreferenceGroup("Files")
  If ExaminePreferenceKeys()
    While NextPreferenceKey()
      AddElement(Files_File())
      Files_File()\Name = PreferenceKeyName()
      Files_File()\File = PreferenceKeyValue()
    Wend
  EndIf
  
  ;Files_Main\Save_File = 1
  
  If Opened
    ClosePreferences()
  EndIf
EndProcedure

Procedure Files_File_Get(Name.s, *Result)
  Protected Result.s = ""
  Protected Found
  
  LockMutex(Files_Main\Mutex_ID)
  
  Found = 0
  
  ForEach Files_File()
    If Files_File()\Name = Name
      Result = Files_File()\File
      Found = 1
      Break
    EndIf
  Next
  
  If Found = 0
    ;Log_Add("Files", Lang_Get("", "Path to file not defined", Name), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    ProcedureReturn #Result_Fail
  Else
    ForEach Files_Folder()
      Result = ReplaceString(Result, "["+Files_Folder()\Name+"]", Files_Folder()\Folder)
    Next
  EndIf
  
  UnlockMutex(Files_Main\Mutex_ID)
  
  If *Result
    CopyMemory(@Result, *Result, StringByteLength(Result))
    ProcedureReturn #Result_Success
  Else
    ProcedureReturn Len(Result)
  EndIf
EndProcedure

Procedure Files_Folder_Get(Name.s, *Result)
  Protected Result.s = ""
  Protected Found
  
  LockMutex(Files_Main\Mutex_ID)
  
  Found = 0
  
  ForEach Files_Folder()
    If Files_Folder()\Name = Name
      Found = 1
      Result = Files_Folder()\Folder
      Break
    EndIf
  Next
  
  If Found = 0
    ;Log_Add("Files", Lang_Get("", "Path to folder not defined", Name), 10, #PB_Compiler_File, #PB_Compiler_Line, #PB_Compiler_Procedure)
    ProcedureReturn #Result_Fail
  EndIf
  
  UnlockMutex(Files_Main\Mutex_ID)
  
  If *Result
    CopyMemory(@Result, *Result, StringByteLength(Result))
    ProcedureReturn #Result_Success
  Else
    ProcedureReturn Len(Result)
  EndIf
EndProcedure
; IDE Options = PureBasic 4.60 Beta 1 (Windows - x64)
; CursorPosition = 184
; FirstLine = 138
; Folding = -
; EnableXP
; DisableDebugger
; EnableCompileCount = 0
; EnableBuildCount = 0