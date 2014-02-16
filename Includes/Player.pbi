; #################################################### Initstuff #################################################

UseSQLiteDatabase()

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Player_Database
  ID.i
EndStructure

; #################################################### Variables #################################################

Global Player_Database.Player_Database

Global NewList Player.Player()

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Player_Get_By_ID(ID)
  Protected *Result.Player = #Null
  Protected Found
  
  ForEach Player()
    If Player()\ID = ID
      ProcedureReturn Player()
    EndIf
  Next
  
  If Player_Database\ID And DatabaseQuery(Player_Database\ID, "SELECT ID,Name_Prefix,Name,Name_Suffix,Custom_Name,Rank,Counter_Login,Counter_Kick,Counter_Ban,Ontime,IP,Stopped_Date,Banned_Date,Muted_Date,Message_Stop,Message_Ban,Message_Kick,Message_Mute,Message_Rank FROM Player_List WHERE ID = '"+Str(ID)+"'")
    If NextDatabaseRow(Player_Database\ID)
      AddElement(Player())
      Player()\ID             = GetDatabaseLong(Player_Database\ID, 0)
      Player()\Name_Prefix    = GetDatabaseString(Player_Database\ID, 1)
      Player()\Name           = GetDatabaseString(Player_Database\ID, 2)
      Player()\Name_Suffix    = GetDatabaseString(Player_Database\ID, 3)
      Player()\Custom_Name    = GetDatabaseLong(Player_Database\ID, 4)
      Player()\Rank           = GetDatabaseLong(Player_Database\ID, 5)
      Player()\Counter_Login  = GetDatabaseLong(Player_Database\ID, 6)
      Player()\Counter_Kick   = GetDatabaseLong(Player_Database\ID, 7)
      Player()\Counter_Ban    = GetDatabaseLong(Player_Database\ID, 8)
      Player()\Ontime         = GetDatabaseQuad(Player_Database\ID, 9)
      Player()\IP             = GetDatabaseString(Player_Database\ID, 10)
      Player()\Stopped_Date   = GetDatabaseQuad(Player_Database\ID, 11)
      Player()\Banned_Date    = GetDatabaseQuad(Player_Database\ID, 12)
      Player()\Muted_Date     = GetDatabaseQuad(Player_Database\ID, 13)
      Player()\Message_Stop   = GetDatabaseString(Player_Database\ID, 14)
      Player()\Message_Ban    = GetDatabaseString(Player_Database\ID, 15)
      Player()\Message_Kick   = GetDatabaseString(Player_Database\ID, 16)
      Player()\Message_Mute   = GetDatabaseString(Player_Database\ID, 17)
      Player()\Message_Rank   = GetDatabaseString(Player_Database\ID, 18)
      
      Found = #True
      
      *Result = Player()
    EndIf
    FinishDatabaseQuery(Player_Database\ID)
  EndIf
  
  ProcedureReturn *Result
EndProcedure

Procedure Player_Get_By_Name(Name.s, Create_If_Nonexistent=0)
  Protected *Result.Player = #Null
  Protected Found
  
  ForEach Player()
    If LCase(Player()\Name) = LCase(Name)
      ProcedureReturn Player()
    EndIf
  Next
  
  If DatabaseQuery(Player_Database\ID, "SELECT ID,Name_Prefix,Name,Name_Suffix,Custom_Name,Rank,Counter_Login,Counter_Kick,Counter_Ban,Ontime,IP,Stopped_Date,Banned_Date,Muted_Date,Message_Stop,Message_Ban,Message_Kick,Message_Mute,Message_Rank FROM Player_List WHERE lower(Name) = '"+LCase(Name)+"'")
    If NextDatabaseRow(Player_Database\ID)
      AddElement(Player())
      Player()\ID             = GetDatabaseLong(Player_Database\ID, 0)
      Player()\Name_Prefix    = GetDatabaseString(Player_Database\ID, 1)
      Player()\Name           = GetDatabaseString(Player_Database\ID, 2)
      Player()\Name_Suffix    = GetDatabaseString(Player_Database\ID, 3)
      Player()\Custom_Name    = GetDatabaseLong(Player_Database\ID, 4)
      Player()\Rank           = GetDatabaseLong(Player_Database\ID, 5)
      Player()\Counter_Login  = GetDatabaseLong(Player_Database\ID, 6)
      Player()\Counter_Kick   = GetDatabaseLong(Player_Database\ID, 7)
      Player()\Counter_Ban    = GetDatabaseLong(Player_Database\ID, 8)
      Player()\Ontime         = GetDatabaseQuad(Player_Database\ID, 9)
      Player()\IP             = GetDatabaseString(Player_Database\ID, 10)
      Player()\Stopped_Date   = GetDatabaseQuad(Player_Database\ID, 11)
      Player()\Banned_Date    = GetDatabaseQuad(Player_Database\ID, 12)
      Player()\Muted_Date     = GetDatabaseQuad(Player_Database\ID, 13)
      Player()\Message_Stop   = GetDatabaseString(Player_Database\ID, 14)
      Player()\Message_Ban    = GetDatabaseString(Player_Database\ID, 15)
      Player()\Message_Kick   = GetDatabaseString(Player_Database\ID, 16)
      Player()\Message_Mute   = GetDatabaseString(Player_Database\ID, 17)
      Player()\Message_Rank   = GetDatabaseString(Player_Database\ID, 18)
      
      Found = #True
      
      *Result = Player()
    EndIf
    FinishDatabaseQuery(Player_Database\ID)
  EndIf
  
  If (Not Found) And Create_If_Nonexistent
    *Result = Player_Add(Name)
  EndIf
  
  ProcedureReturn *Result
EndProcedure

Procedure Player_Write(*Player.Player)
  If Not *Player
    ; Add Error-Handler here
    Log_Add_Error("*Player")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not DatabaseUpdate(Player_Database\ID, "REPLACE INTO Player_List (ID,Name_Prefix,Name,Name_Suffix,Custom_Name,Rank,Counter_Login,Counter_Kick,Counter_Ban,Ontime,IP,Stopped_Date,Banned_Date,Muted_Date,Message_Stop,Message_Ban,Message_Kick,Message_Mute,Message_Rank) VALUES ("+Str(*Player\ID)+", '"+*Player\Name_Prefix+"', '"+*Player\Name+"', '"+*Player\Name_Suffix+"', "+Str(*Player\Custom_Name)+", "+Str(*Player\Rank)+", "+Str(*Player\Counter_Login)+", "+Str(*Player\Counter_Kick)+", "+Str(*Player\Counter_Ban)+", "+Str(*Player\Ontime)+", '"+*Player\IP+"', "+Str(*Player\Stopped_Date)+", "+Str(*Player\Banned_Date)+", "+Str(*Player\Muted_Date)+", "+Chr(34)+ReplaceString(*Player\Message_Stop, Chr(34), "'")+Chr(34)+", "+Chr(34)+ReplaceString(*Player\Message_Ban, Chr(34), "'")+Chr(34)+", "+Chr(34)+ReplaceString(*Player\Message_Kick, Chr(34), "'")+Chr(34)+", "+Chr(34)+ReplaceString(*Player\Message_Mute, Chr(34), "'")+Chr(34)+", "+Chr(34)+ReplaceString(*Player\Message_Rank, Chr(34), "'")+Chr(34)+")")
    Log_Add_Info("Player-Database: Can't write. ("+DatabaseError()+")")
    ProcedureReturn #Result_Fail
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Player_Add(Name.s)
  Protected *Player.Player
  
  If Player_Get_By_Name(Name, #False)
    ; Already existant
    Log_Add_Info("Player-Database: Player '"+Name+"' already existant.")
    ProcedureReturn #Null
  EndIf
  
  If Not DatabaseUpdate(Player_Database\ID, "REPLACE INTO Player_List (Name) VALUES ('"+Name+"')")
    Log_Add_Info("Player-Database: Can't write. ("+DatabaseError()+")")
    ProcedureReturn #Null
  EndIf
  
  *Player = Player_Get_By_Name(Name)
  If Not *Player
    Log_Add_Info("Player-Database: Wasn't able to create '"+Name+"'.")
    ProcedureReturn #Null
  EndIf
  
  ProcedureReturn *Player
EndProcedure

Procedure Player_Delete(*Player.Player)
  If Not *Player
    ; Add Error-Handler here
    Log_Add_Error("*Player")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not DatabaseUpdate(Player_Database\ID, "DELETE FROM Player_List WHERE ID = "+Str(*Player\ID)+";")
    Log_Add_Info("Player-Database: Can't write. ("+DatabaseError()+")")
    ProcedureReturn #Result_Fail
  EndIf
  
  PushListPosition(Network_Client())
  ForEach Network_Client()
    If Network_Client()\Player = *Player
      Network_Client()\Player = #Null
    EndIf
  Next
  PopListPosition(Network_Client())
  
  If ChangeCurrentElement(Player(), *Player)
    DeleteElement(Player())
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Player_Unload(*Player.Player)
  If Not *Player
    ; Add Error-Handler here
    Log_Add_Error("*Player")
    ProcedureReturn #Result_Fail
  EndIf
  
  If *Player\Write_To_Database
    *Player\Write_To_Database = #False
    Player_Write(*Player.Player)
  EndIf
  
  PushListPosition(Network_Client())
  ForEach Network_Client()
    If Network_Client()\Player = *Player
      Network_Client()\Player = #Null
    EndIf
  Next
  PopListPosition(Network_Client())
  
  If ChangeCurrentElement(Player(), *Player)
    DeleteElement(Player())
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Player_Database_Create(Filename.s)
  Protected File_ID
  
  File_ID = CreateFile(#PB_Any, Filename.s)
  If IsFile(File_ID)
    CloseFile(File_ID)
    Log_Add_Info("Player-Database: created '"+Filename+"'.")
  Else
    Log_Add_Info("Player-Database: failed to create '"+Filename+"'.")
  EndIf
EndProcedure

Procedure Player_Database_Open(Filename.s)
  Player_Database_Close()
  
  If FileSize(Filename) = -1
    Player_Database_Create(Filename)
  EndIf
  
  Player_Database\ID = OpenDatabase(#PB_Any, Filename.s, "", "", #PB_Database_SQLite)
  If Not Player_Database\ID
    Log_Add_Info("Player-Database: failed to open '"+Filename+"'.")
    ProcedureReturn #Result_Fail
  EndIf
  
  ; #### Initialise Database, and add columns (if not done yet)
  DatabaseUpdate(Player_Database\ID, "CREATE TABLE IF NOT EXISTS Player_List (ID INTEGER PRIMARY KEY, Name_Prefix TEXT, Name TEXT UNIQUE, Name_Suffix TEXT);")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Custom_Name INTEGER;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Rank INTEGER;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Counter_Login INTEGER;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Counter_Kick INTEGER;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Counter_Ban INTEGER;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Ontime INTEGER;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN IP TEXT;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Stopped_Date INTEGER;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Banned_Date INTEGER;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Muted_Date INTEGER;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Message_Stop TEXT;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Message_Ban TEXT;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Message_Kick TEXT;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Message_Mute TEXT;")
  DatabaseUpdate(Player_Database\ID, "ALTER TABLE Player_List ADD COLUMN Message_Rank TEXT;")
  
  Log_Add_Info("Player-Database: opened '"+Filename+"'.")
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Player_Database_Close()
  If Player_Database\ID
    CloseDatabase(Player_Database\ID)
    Player_Database\ID = 0
    Log_Add_Info("Player-Database: closed.")
  EndIf
EndProcedure

Procedure Player_Ontime()
  ForEach Player()
    Player()\Ontime + 120
    Player()\Write_To_Database = #True
  Next
EndProcedure
Timer_Register("Player_Ontime", #True, 120000, @Player_Ontime())

Procedure Player_Main()
  Protected Found
  
  ForEach Player()
    If Player()\Write_To_Database
      Player()\Write_To_Database = #False
      Player_Write(Player())
    EndIf
  Next
  
  ; #### Delete not used Player() elements
  ForEach Player()
    Found = #False
    ForEach Network_Client()
      If Network_Client()\Player = Player()
        Found = #True
        Break
      EndIf
    Next
    If Not Found
      Player_Unload(Player())
    EndIf
  Next
EndProcedure
Timer_Register("Player", #True, 10000, @Player_Main())
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 268
; FirstLine = 250
; Folding = --
; EnableXP