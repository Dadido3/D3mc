; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

Structure Command_Main
  File_Save.i
  File_Last_Date.i
EndStructure

; #################################################### Variables #################################################

Global Command_Main.Command_Main

Global NewList Command.Command()

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Prototypes ################################################

Prototype Command_Prototype(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

Procedure Command_Give(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  Protected Type, Amount, Metadata, i
  Protected *Entity.Entity
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If *Network_Client\Entity
    Type = -1
    If *Command_Parameters\Operator[0]
      
      Type = Val(*Command_Parameters\Operator [0])
      For i = 0 To #Item_Amount_Max
        If Item(i)\Name
          If LCase(Item(i)\Name) = LCase(*Command_Parameters\Operator[0]) Or Item(i)\Name_Short = *Command_Parameters\Operator[0]
            Type = i
          EndIf
        EndIf
      Next
      Amount = Val(*Command_Parameters\Operator [1])
      If Amount = 0 : Amount = 64 : EndIf
      
      Metadata = Val(*Command_Parameters\Operator [2])
      
      *Entity = Entity_Add(*Network_Client\Entity\World, *Network_Client\Entity\X, *Network_Client\Entity\Y, *Network_Client\Entity\Z, 1, "")
      If *Entity
        *Entity\Item_Type = Type
        *Entity\Item_Count = Amount
        *Entity\Item_Uses = Metadata
      EndIf
      
    EndIf
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Command_Teleport(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  ForEach Network_Client()
    If Network_Client()\Entity
      If LCase(Network_Client()\Entity\Name) = LCase(*Command_Parameters\Operator [0])
        Entity_Set_World(*Network_Client\Entity, Network_Client()\Entity\World)
        Entity_Set_Position(*Network_Client\Entity, Network_Client()\Entity\X, Network_Client()\Entity\Y, Network_Client()\Entity\Z+0.1, 1)
        Break
      EndIf
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Command_Explode(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If *Network_Client\Entity
    ForEach Network_Client()
      Network_Client_Packet_Send_Explosion(Network_Client(), *Network_Client\Entity\X, *Network_Client\Entity\Y, *Network_Client\Entity\Z, 3)
    Next
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Command_Box(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  Protected i, Replace_Type
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Replace_Type = -1
  If *Command_Parameters\Operator[0]
    Replace_Type = Val(*Command_Parameters\Operator[0])
    For i = 0 To #Item_Amount_Max
      If Item(i)\Name
        If LCase(Item(i)\Name) = LCase(*Command_Parameters\Operator[0]) Or Item(i)\Name_Short = *Command_Parameters\Operator[0]
          Replace_Type = i
        EndIf
      EndIf
    Next
  EndIf
  
  Build_Mode_Set(*Network_Client, "Box")
  Build_Mode_Integer_Set(*Network_Client, 0, Replace_Type)
  
  ProcedureReturn #Result_Success
EndProcedure

;---------------------------------------------------------------

Procedure Command_Client_List(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  Protected Message.s
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Network_Client_Packet_Send_Chat_Message(*Network_Client, "§ePlayers:")
  
  ForEach Network_Client()
    If Network_Client()\Entity
      
      Message + "§f" + Network_Client()\Entity\Name + "§e | "
      
    EndIf
  Next
  
  Network_Client_Packet_Send_Chat_Message(*Network_Client, Message)
  
  ProcedureReturn #Result_Success
EndProcedure

;---------------------------------------------------------------

Procedure Command_Plugin_List(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  Protected Message.s
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Network_Client_Packet_Send_Chat_Message(*Network_Client, "§ePlugins:")
  
  ForEach Plugin()
    If Plugin()\Library_ID
      Message = "§a"
    Else
      Message = "§4"
    EndIf
    Message + Plugin()\Plugin_Info\Name + " §f(Auth.:" + Plugin()\Plugin_Info\Author + ")"
    
    Network_Client_Packet_Send_Chat_Message(*Network_Client, Message)
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Command_Plugin_Load(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  Protected Plugin.s, Found
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Plugin = *Command_Parameters\Operator [0]
  
  Found = 0
  ForEach Plugin()
    If LCase(Plugin()\Plugin_Info\Name) = LCase(Plugin)
      Found = 1
      If Plugin_Load(Plugin())
        Network_Client_Packet_Send_Chat_Message(*Network_Client, "§aPlugin '"+Plugin()\Filename+"' loaded")
      Else
        Network_Client_Packet_Send_Chat_Message(*Network_Client, "§4Plugin '"+Plugin()\Filename+"' not loaded")
      EndIf
    EndIf
  Next
  If Found = 0
    Network_Client_Packet_Send_Chat_Message(*Network_Client, "§eCant find the plugin '"+Plugin+"'")
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Command_Plugin_Unload(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  Protected Plugin.s, Found
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Plugin = *Command_Parameters\Operator [0]
  
  Found = 0
  ForEach Plugin()
    If LCase(Plugin()\Plugin_Info\Name) = LCase(Plugin)
      Found = 1
      If Plugin_Unload(Plugin())
        Network_Client_Packet_Send_Chat_Message(*Network_Client, "§4Plugin '"+Plugin()\Filename+"' unloaded")
      Else
        Network_Client_Packet_Send_Chat_Message(*Network_Client, "§aPlugin '"+Plugin()\Filename+"' not unloaded")
      EndIf
    EndIf
  Next
  If Found = 0
    Network_Client_Packet_Send_Chat_Message(*Network_Client, "§eCant find the plugin '"+Plugin+"'")
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

;---------------------------------------------------------------

Procedure Command_World_List(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  Protected Message.s
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Network_Client_Packet_Send_Chat_Message(*Network_Client, "§eWorlds:")
  
  ForEach World()
    Message + "§f"+World()\Name+" §e| "
  Next
  
  If Message
    Network_Client_Packet_Send_Chat_Message(*Network_Client, Message)
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Command_World_Set_Spawn(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If *Network_Client\Entity
    If *Network_Client\Entity\World
      *Network_Client\Entity\World\Spawn\X     = *Network_Client\Entity\X
      *Network_Client\Entity\World\Spawn\Y     = *Network_Client\Entity\Y
      *Network_Client\Entity\World\Spawn\Z     = *Network_Client\Entity\Z
      *Network_Client\Entity\World\Spawn\Yaw   = *Network_Client\Entity\Yaw
      *Network_Client\Entity\World\Spawn\Pitch = *Network_Client\Entity\Pitch
      *Network_Client\Entity\World\Spawn\Roll  = *Network_Client\Entity\Roll
      
      Network_Client_Packet_Send_Chat_Message(*Network_Client, "§2Changed Spawn.")
      ProcedureReturn #Result_Success
    EndIf
  EndIf
  
  ProcedureReturn #Result_Fail
EndProcedure

Procedure Command_World_Change(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If *Network_Client\Entity
    ForEach World()
      If LCase(World()\Name) = LCase(*Command_Parameters\Operator [0])
        Entity_Set_World(*Network_Client\Entity, World())
        ProcedureReturn #Result_Success
      EndIf
    Next
  EndIf
  
  ProcedureReturn #Result_Fail
EndProcedure

Procedure Command_World_Time(*Network_Client.Network_Client, *Command_Parameters.Command_Parameters)
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *Command_Parameters
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  If *Network_Client\Entity
    If *Network_Client\Entity\World
      Select LCase(*Command_Parameters\Operator [0])
        Case "day", "midday"
          *Network_Client\Entity\World\Time = 12*3600
          Network_Client_Packet_Send_Chat_Message(*Network_Client, "§2Changed Time.")
        Case "night", "midnight"
          *Network_Client\Entity\World\Time = 0*3600
          Network_Client_Packet_Send_Chat_Message(*Network_Client, "§2Changed Time.")
        Case "morning"
          *Network_Client\Entity\World\Time = 6*3600
          Network_Client_Packet_Send_Chat_Message(*Network_Client, "§2Changed Time.")
        Case "evening"
          *Network_Client\Entity\World\Time = 18*3600
          Network_Client_Packet_Send_Chat_Message(*Network_Client, "§2Changed Time.")
        Case "set"
          *Network_Client\Entity\World\Time = ValF(*Command_Parameters\Operator [1])*3600
          Network_Client_Packet_Send_Chat_Message(*Network_Client, "§2Changed Time.")
        Case "factor"
          *Network_Client\Entity\World\Time_Factor = ValF(*Command_Parameters\Operator [1])
          Network_Client_Packet_Send_Chat_Message(*Network_Client, "§2Changed Time-Factor.")
        Case "mode"
          Select LCase(*Command_Parameters\Operator [1])
            Case "normal" : *Network_Client\Entity\World\Time_Mode = 0
              Network_Client_Packet_Send_Chat_Message(*Network_Client, "§2Changed Time-Mode.")
            Case "realtime" : *Network_Client\Entity\World\Time_Mode = 1
              Network_Client_Packet_Send_Chat_Message(*Network_Client, "§2Changed Time-Mode.")
            Default
              Network_Client_Packet_Send_Chat_Message(*Network_Client, "§4Unkown parameters.")
              ProcedureReturn #Result_Fail
          EndSelect
        Default
          Network_Client_Packet_Send_Chat_Message(*Network_Client, "§4Unkown parameters.")
          ProcedureReturn #Result_Fail
      EndSelect
      
      ProcedureReturn #Result_Success
    EndIf
  EndIf
  
  ProcedureReturn #Result_Fail
EndProcedure

;---------------------------------------------------------------

Procedure Command_Do(*Network_Client.Network_Client, Input.s)
  Protected Command_Parameters.Command_Parameters
  Protected i
  
  If Not *Network_Client
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Command_Parameters\Raw = Input
  
  Command_Parameters\Name = StringField(Input, 1, " ")
  
  For i = 0 To #Command_Operators-1
    Command_Parameters\Operator [i] = StringField(Input, i+2, " ")
    If Command_Parameters\Operator[i] = ""
      Break
    EndIf
  Next
  
  ForEach Command()
    If LCase(Command()\Name) = LCase(Command_Parameters\Name)
      
      If Command()\Function
        CallFunctionFast(Command()\Function, *Network_Client, Command_Parameters)
      EndIf
      
      Break
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure Command_Init_Internal()
  ForEach Command()
    Select Command()\ID
      Case "Give" : Command()\Function = @Command_Give()
      Case "Teleport" : Command()\Function = @Command_Teleport()
      Case "Explode" : Command()\Function = @Command_Explode()
      Case "Box" : Command()\Function = @Command_Box()
      
      Case "Client_List" : Command()\Function = @Command_Client_List()
      
      Case "Plugin_List" : Command()\Function = @Command_Plugin_List()
      Case "Plugin_Load" : Command()\Function = @Command_Plugin_Load()
      Case "Plugin_Unload" : Command()\Function = @Command_Plugin_Unload()
      
      Case "World_List" : Command()\Function = @Command_World_List()
      Case "World_Set_Spawn" : Command()\Function = @Command_World_Set_Spawn()
      Case "World_Change" : Command()\Function = @Command_World_Change()
      Case "World_Time" : Command()\Function = @Command_World_Time()
    EndSelect
  Next
EndProcedure

Procedure Command_Load(Filename.s)
  Protected i
  
  If OpenPreferences(Filename.s)
    
    ClearList(Command())
    
    If ExaminePreferenceGroups()
      While NextPreferenceGroup()
        AddElement(Command())
        
        Command()\ID = PreferenceGroupName()
        Command()\Name = ReadPreferenceString("Name", "")
        
      Wend
    EndIf
    
    Command_Init_Internal()
    
    ClosePreferences()
    ;Command_Main\File_Save = 1
    Command_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure Command_Save(Filename.s)
  Protected i
  Protected File_ID
  
  File_ID = CreateFile(#PB_Any, Filename)
  If IsFile(File_ID)
    
    ForEach Command()
      WriteStringN(File_ID, "["+Command()\ID+"]")
      WriteStringN(File_ID, "Name = "+Command()\Name)
      WriteStringN(File_ID, "")
    Next
    
    CloseFile(File_ID)
    Command_Main\File_Last_Date = GetFileDate(Filename, #PB_Date_Modified)
  EndIf
EndProcedure

Procedure Command_Main()
  Protected Filename.s
  Filename = Space(Files_File_Get("Command", 0))
  Files_File_Get("Command", @Filename)
  
  If Command_Main\File_Save
    Command_Main\File_Save = 0
    
    Command_Save(Filename)
  Else
    
    If Command_Main\File_Last_Date <> GetFileDate(Filename, #PB_Date_Modified)
      Command_Load(Filename)
    EndIf
  EndIf
  
EndProcedure
Timer_Register("Command", 0, 1000, @Command_Main())

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################


; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 427
; FirstLine = 416
; Folding = ---
; EnableXP