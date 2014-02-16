EnableExplicit

; #################################################### Documentation #############################################
; 
; Version History:
; - 0.000 18.12.2010
;     
; - 0.100 Current
;     + Reallocate packet-buffers if needed!
; 
; 
; 
; 
; Todo:
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
; #################################################### Includes ##################################################

; #### External
XIncludeFile "Includes/PolarSSL.pbi"
XIncludeFile "Includes/D3HT.pbi"
XIncludeFile "Includes/D3NBT.pbi"
XIncludeFile "Includes/ZLib.pbi"

; #### Shared
XIncludeFile "S_Includes/Constants.pbi"
XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Declares ##################################################

Declare   Build_Mode_Do_Place(*Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z)
Declare   Build_Mode_Do_Dig(*Network_Client.Network_Client, *World.World, X, Y, Z, Face, State)
Declare   Build_Mode_Set(*Network_Client.Network_Client, Mode.s)
Declare   Build_Mode_Integer_Set(*Network_Client.Network_Client, Number, Value.q)
Declare   Build_Mode_Integer_Get(*Network_Client.Network_Client, Number)

Declare   Command_Do(*Network_Client.Network_Client, Input.s)

Declare   Entity_Send_Add(*Entity.Entity, *Network_Client.Network_Client)
Declare   Entity_Send_Delete(*Entity.Entity, *Network_Client.Network_Client)
Declare   Entity_Add(*World.World, X.d, Y.d, Z.d, Type, Name.s)
Declare   Entity_Delete(*Entity.Entity)
Declare   Entity_Set_Position(*Entity.Entity, X.d, Y.d, Z.d, To_Client)
Declare   Entity_Set_Rotation(*Entity.Entity, Yaw.f, Pitch.f, Roll.f, Send, To_Client)

Declare   Entity_Type_Get(ID)

Declare   Entity_Inventory_Initialize(*Entity.Entity, Inventory_Type)
Declare   Entity_Inventory_Set(*Entity.Entity, Slot, Item_Type, Item_Count, Item_Uses)
Declare   Entity_Inventory_Get_Type(*Entity.Entity, Slot)
Declare   Entity_Inventory_Get_Count(*Entity.Entity, Slot)
Declare   Entity_Inventory_Get_Uses(*Entity.Entity, Slot)
Declare   Entity_Inventory_Holding_Slot_Set(*Entity.Entity, Slot)
Declare   Entity_Inventory_Mouse_Swap(*Entity.Entity, Slot, Rightclick, *Network_Client.Network_Client)

Declare   Network_Client_Add(Client_ID)
Declare   Network_Client_Delete(*Network_Client.Network_Client)
Declare   Network_Client_Enable_Encryption(*Network_Client.Network_Client, *IV)
Declare   Network_Client_Enable_Decryption(*Network_Client.Network_Client, *IV)
Declare   Network_Client_Get(Client_ID)
Declare   Network_Client_Input_Handler(*Network_Client.Network_Client)

Declare   Network_Client_Inventory_Window_Open(*Network_Client.Network_Client, *Entity.Entity)
Declare   Network_Client_Inventory_Window_Close(*Network_Client.Network_Client, Window_ID)

Declare   Player_Add(Name.s)
Declare   Player_Database_Close()
Declare   Player_Get_By_ID(ID)
Declare   Player_Get_By_Name(Name.s, Create_If_Nonexistent=0)

Declare   Plugin_Do_Event_Client_Add(*Network_Client.Network_Client)
Declare   Plugin_Do_Event_Client_Delete(*Network_Client.Network_Client)
Declare   Plugin_Do_Event_Client_Login(*Network_Client.Network_Client, Name.s)
Declare   Plugin_Do_Event_Client_Logout(*Network_Client.Network_Client, Name.s)
Declare   Plugin_Do_Event_World_Column_Fill(Destination.s, *World.World, *World_Column.World_Column, Seed, Generation_State)
Declare   Plugin_Do_Event_World_Physic(Destination.s, *World.World, X, Y, Z, Type, Metadata, Current_Trigger_Time)
Declare   Plugin_Do_Event_Block_Rightclick(Destination.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
Declare   Plugin_Do_Event_Block_Leftclick(Destination.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Face, State, Type, Metadata)
Declare   Plugin_Do_Event_Entity(Destination.s, *Entity.Entity)
Declare   Plugin_Do_Event_Item_Place(Destination.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
Declare   Plugin_Do_Event_Item_Dig(Destination.s, *Network_Client.Network_Client, *World.World, X, Y, Z, Face, State, Type, Metadata)

Declare   World_Block_Destroy(*World.World, X, Y, Z, Current_Trigger_Time=0, Spawn_Pickup=#False)
Declare   World_Block_Set(*World.World, X, Y, Z, Type=-1, Metadata=-1, BlockLight=-1, SkyLight=-1, Playerdata=-1, Send=1, Light=1, Physic=1, Current_Trigger_Time=0)
Declare   World_Block_Get(*World.World, X, Y, Z, *Type.Ascii=0, *Metadata.Ascii=0, *BlockLight.Ascii=0, *SkyLight.Ascii=0, *Playerdata.Ascii=0)

Declare   World_Get_By_ID(World_ID)
Declare   World_Get_By_UID(World_UID.s)
Declare   World_Get_By_Spawn_Priority()

Declare   World_Column_Get_Offset(X, Y, Z)
Declare   World_Column_Get_Coordinate_Offset(X, Y, Z)
Declare   World_Column_Change_Format(*World.World, *World_Column.World_Column, Chunks, Format)
Declare   World_Column_Compress_For_Sending(*World.World, *World_Column.World_Column)
Declare   World_Column_Get(*World.World, X, Y, Create_If_Nonexistent=0, Load=0)
Declare   World_Column_Add(*World.World, X, Y, Format, Needs_Generation=#False)
Declare   World_Column_Block_Set(*World.World, *World_Column.World_Column, X, Y, Z, Type=-1, Metadata=-1, BlockLight=-1, SkyLight=-1, Playerdata=-1, Send=1, Light=1, Physic=1, Current_Trigger_Time=0)
Declare   World_Column_Block_Get(*World.World, *World_Column.World_Column, X, Y, Z, *Type.Ascii=0, *Metadata.Ascii=0, *BlockLight.Ascii=0, *SkyLight.Ascii=0, *Playerdata.Ascii=0)

; #################################################### Macros ####################################################

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

; #################################################### Includes ##################################################

OpenConsole()

;Global *Test_Entity.Entity

; #### Internal
XIncludeFile "Includes/Error.pbi"
XIncludeFile "Includes/Log.pbi"
XIncludeFile "Includes/Timer.pbi"
XIncludeFile "Includes/Files.pbi"
XIncludeFile "Includes/System.pbi"
XIncludeFile "Includes/Item.pbi"
XIncludeFile "Includes/Block.pbi"
XIncludeFile "Includes/Rank.pbi"
XIncludeFile "Includes/Network_Server.pbi"
XIncludeFile "Includes/Player.pbi"
XIncludeFile "Includes/Message.pbi"
XIncludeFile "Includes/World.pbi"
XIncludeFile "Includes/Entity.pbi"
XIncludeFile "Includes/Entity_Event.pbi"
XIncludeFile "Includes/Entity_Type.pbi"
XIncludeFile "Includes/Entity_Send.pbi"
XIncludeFile "Includes/Entity_Inventory.pbi"
XIncludeFile "Includes/Entity_Physic.pbi"
XIncludeFile "Includes/Build_Mode.pbi"
XIncludeFile "Includes/Plugin.pbi"
XIncludeFile "Includes/Command.pbi"

; #################################################### Startup ###################################################

OpenCryptRandom()

Define Temp_Filename.s

Temp_Filename = Space(Files_File_Get("Item", 0))
Files_File_Get("Item", @Temp_Filename)
Item_Load(Temp_Filename)

Temp_Filename = Space(Files_File_Get("Block", 0))
Files_File_Get("Block", @Temp_Filename)
Block_Load(Temp_Filename)

Temp_Filename = Space(Files_File_Get("Players", 0))
Files_File_Get("Players", @Temp_Filename)
Player_Database_Open(Temp_Filename)

Network_Encryption_Init()

Network_Server_Start(25565)

Define i
For i = 0 To 1000
  ;Entity_Add(World(), Random(250)-100, Random(250)-100, 115+Random(10), "", #Entity_Type_Mob, 90+Random(3), 1)
  ;Entity_Add(World(), Random(250)-100, Random(250)-100, 115+Random(10), "", #Entity_Type_Mob, 50+Random(7), 1)
Next

;*Test_Entity.Entity = Entity_Add(World_Get_By_ID(1), 10, 10, 115, "ASDF", #Entity_Type_Player, 0, 0)

Log_Add_Info("Everthing started")

; #################################################### Main ######################################################

Repeat
  
  Timer_Main()
  
  Delay(10)
  
ForEver
; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 33
; FirstLine = 16
; EnableXP
; EnableOnError
; Executable = D3_Server.x86.exe
; EnableCompileCount = 246
; EnableBuildCount = 10