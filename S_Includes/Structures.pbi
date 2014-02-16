; ###################################
;-       Universal Structures
; ###################################

Structure Vector_3D
  X.d
  Y.d
  Z.d
EndStructure

Structure Coordinate
  X.l
  Y.l
  Z.l
  
  *World_Column.World_Column
EndStructure

Structure Position
  X.d
  Y.d
  Z.d
  
  Yaw.f           ; Rotation around Z axis in degree
  Pitch.f         ; Rotation around the rotated Y axis in degree
  Roll.f          ; Rotation around the rotated X axis in degree
EndStructure

; ###################################
;-         Plugin Structures
; ###################################

Structure Plugin_Info
  Name.s{16}                  ; Bezeichnung des Plugins (16 Zeichen!) / Name of the Plugin (16 Chars!)
  Version.l                   ; Pluginversion (Wird geändert wenn ältere Plugins nicht mehr kompatibel sind) /  Pluginversion
  Author.s{16}                ; Autor des Plugins (16 Zeichen!) / Author of the plugin (16 Chars!)
EndStructure

Structure Plugin_Result_Element
  *Pointer
  ID.l
EndStructure

; ###################################
;-        Command Structures
; ###################################

Structure Command_Parameters
  Raw.s
  
  Name.s
  
  Operator.s [#Command_Operators]
EndStructure

Structure Command
  ID.s
  
  Name.s
  
  *Function;.Command_Prototype
EndStructure

; ###################################
;-      Build_Mode Structures
; ###################################

Structure Build_Mode
  ID.s
  
  Name.s
  
  *Place_Function
  *Dig_Function
EndStructure

; ###################################
;-        Network Structures
; ###################################

Structure Network_Packet
  *Data
  Data_Size.i
  
  Max_Write_Offset.i  ; Used to split the packets
  Split_Counter.i     ; Used to split the packets
  Write_Offset.i      ; Indicates also the size
  Read_Offset.i       ; 
  
  Encrypted.i         ; Can be #True, #False or -1 (-1 pretends it from being encrypted)
  
  Disconnect_After.a  ; Disconnects the Client after sending
EndStructure

Structure Network_Client_World_Column
  X.i
  Y.i
  *World_Column.World_Column
  
  Sent.l
EndStructure

Structure Network_Client_Inventory_Window
  Window_ID.a
  *Network_Client.Network_Client
  *Entity.Entity
EndStructure

Structure Network_Client_Inventory_Slot_Mouse
  Type.w
  Count.a
  Uses.u
EndStructure

Structure Network_Client_Build_Mode
  Mode.s
  
  State.i
  Integer.q [#Network_Client_Build_Mode_Variables]
  Coordinate.Coordinate [#Network_Client_Build_Mode_Coordinates]
EndStructure

Structure AES_CFB
  AESCipher_ID.i
  Bits.l
  Mode.l
  IV.a[32]
  IV_Position.i
EndStructure

Structure Network_Client_AES
  Encryption.AES_CFB
  Decryption.AES_CFB
  Encryption_Enabled.l
  Decryption_Enabled.l
EndStructure

Structure Network_Client
  ID.i
  IP.l
  
  Logged_In.i
  Login_Name.s
  
  AES.Network_Client_AES
  
  IN_Packet.Network_Packet
  List OUT_Packet.Network_Packet()
  Jammed_Output.l
  
  Ping.l
  Ping_Time.l ; Time when the keep-alive packet was sent
  Ping_ID.l   ; ID of the keep-alive packet
  
  List World_Column.Network_Client_World_Column()
  
  *Player.Player
  
  *Entity.Entity
  
  Inventory_Slot_Mouse.Network_Client_Inventory_Slot_Mouse
  List Inventory_Window.Network_Client_Inventory_Window()
  
  Build_Mode.Network_Client_Build_Mode
EndStructure

; ###################################
;-         Entity Structures
; ###################################

Structure Entity_Type
  ID.l
  Name.s
  
  Category.l
  
  On_Client.l
  
  Inventory_Type.l
  Destroy_Time.l          ; in s
  Physic_Type.l
  Gravity.d               ; m/s²
  Boundary_Center_X.d     ; Position and size of the collision boundary
  Boundary_Center_Y.d
  Boundary_Center_Z.d
  Boundary_Halfwidth_X.d
  Boundary_Halfwidth_Y.d
  Boundary_Halfwidth_Z.d
  
  Event.s
  Event_Time.l            ; in ms
EndStructure

Structure Entity_Inventory_Slot
  Slot.l
  
  Type.w
  Count.a
  Uses.u
EndStructure

Structure Entity_Inventory
  List Slot.Entity_Inventory_Slot()
  Type.i
  Slots.i
  List *Window.Network_Client_Inventory_Window()
EndStructure

Structure Entity
  ID.l
  Type.i
  
  Name_Prefix.s{8}
  Name.s{32}
  Name_Suffix.s{8}
  
  X.d             ; m
  Y.d             ; m
  Z.d             ; m
  
  VX.d            ; m/s
  VY.d            ; m/s
  VZ.d            ; m/s
  
  Yaw.f           ; Rotation around Z axis in degree
  Pitch.f         ; Rotation around the rotated Y axis in degree
  Roll.f          ; Rotation around the rotated X axis in degree
  
  Column_X.i      ; Column where the entity is in (in m/#World_Column_Size_X)
  Column_Y.i      ; Column where the entity is in (in m/#World_Column_Size_Y)
  *World.World
  *World_Column.World_Column
  
  Send_New.i      ; #True if entity is new
  Send_Mask.i     ; Mask for sending
  Send_Timer.i    ; Timer for sending
  
  *Network_Client.Network_Client
  
  *Inventory.Entity_Inventory
  Holding_Slot.u
  
  Destroy_Timer.i
  Event_Timer.i
  
  ; #### Other stuff
  Item_Type.l
  Item_Count.l
  Item_Uses.l
EndStructure

; ###################################
;-         Player Structures
; ###################################

Structure Player
  ID.l
  
  Name_Prefix.s
  Name.s
  Name_Suffix.s
  Custom_Name.a
  
  Rank.l
  
  Counter_Login.l
  Counter_Kick.l
  Counter_Ban.l
  Ontime.l
  IP.s
  Stopped_Date.q
  Banned_Date.q
  Muted_Date.q
  Message_Stop.s
  Message_Ban.s
  Message_Kick.s
  Message_Mute.s
  Message_Rank.s
  
  Write_To_Database.l
EndStructure

; ###################################
;-         Rank Structures
; ###################################

Structure Rank
  Rank.l
  
  Name.s
  
  Prefix.s
  Suffix.s
EndStructure

; ###################################
;-         World Structures
; ###################################

Structure World_Collision_Box
  Center.Vector_3D
  Halfwidth.Vector_3D
EndStructure

Structure World_Column
  *World.World
  X.i             ; Real coordinates = X * Column_Size_X
  Y.i             ; Real coordinates = Y * Column_Size_Y
  
  List *Network_Client.Network_Client() ; A list of pointers to clients which "see" this Column
  List *Entity.Entity()                 ; A list of pointers to entities on this Column
  
  Generation_State.i  ; If <> 0 then the Column needs to be generated (Filled with land), If over 100 it will only generate if there are chunks around this chunk
  Neighbour_Columns.l ; Amount of Neighbours
  
  Format.i[#World_Column_Chunks]              ; Defines the format how the map-data is stored
  Format_Change_Date.i[#World_Column_Chunks]  ; Point of time(Date()), when the format will be changed (Raw --> ZLib --> HDD)
  HDD_Save_Date.i                             ; Point of time(Date()), when the Column will be saved to HDD
  
  *Blockdata[#World_Column_Chunks]
  Blockdata_Size.i[#World_Column_Chunks]
  *Metadata[#World_Column_Chunks]
  Metadata_Size.i[#World_Column_Chunks]
  *Lightdata[#World_Column_Chunks]
  Lightdata_Size.i[#World_Column_Chunks]
  *Playerdata[#World_Column_Chunks]
  Playerdata_Size.i[#World_Column_Chunks]
  
  Empty.a[#World_Column_Chunks]   ; True if Chunk is empty (No sending of it. No saving)
  
  *Light_Queue_Mask
  Light_Queue_Size.i
  *Physic_Queue_Mask
  Physic_Queue_Size.i
  *Send_Queue_Mask
  Send_Queue_Size.i
  
  *Send_Buffer
  Send_Buffer_Size.i
  Send_Buffer_Time.i  ; Point of time(Date()), when the send-buffer will be cleared
EndStructure

Structure World_Physic_Queue_Element
  X.l
  Y.l
  Z.l
  
  *World_Column.World_Column
  
  No_Check.a
EndStructure

Structure World_Physic_Queue
  Trigger_Time.q
  
  List Element.World_Physic_Queue_Element()
EndStructure

Structure World_Send_Queue
  X.l
  Y.l
  Z.l
  
  *World_Column.World_Column
  
  Old_Type.a
  Old_Metadata.a
  
  No_Check.a
EndStructure

Structure World
  ID.l
  UID.s {32}
  Name.s
  Directory.s
  
  Save_Date.i
  
  Version.i
  
  Time_Mode.l       ; Normal, Realtime
  Time_Factor.f     ; Factor
  Time.f            ; in seconds from midnight
  Time_Send_Date.i  ; Date() when the time should be sent next time
  
  Spawn.Position
  Spawn_Priority.l
  
  Generator.s
  Seed.l
  
  Limit_Radius.l    ; Limit Columns to a specific radius
  
  List Light_Queue.Coordinate()
  List Physic_Queue.World_Physic_Queue()
  List Send_Queue.World_Send_Queue()
  
  *Column_Finder.D3HT_Table              ; A hashtable to find elements fast
  List Column.World_Column()
EndStructure

; ###################################
;-        Item Structures
; ###################################

Structure Item
  Name.s
  Name_Short.s
  
  Place_Event.s
  Dig_Event.s
  Corresponding_Block.l
  
  Stackable_Amount.l
  
  On_Client.u
EndStructure

; ###################################
;-        Block Structures
; ###################################

Structure Block
  Name.s
  Name_Short.s
  
  On_Client.a
  
  Physic_Type.i
  Physic_Event.s
  
  Physic_Time.q
  Physic_Time_Random.q
  Physic_Quantisation.q
  Physic_Allowed_Trigger_Type.i
  Physic_Repeat.i
  Physic_On_Load.i
  
  Collision_Boundary.l
  
  Create_Event.s
  Delete_Event.s
  Rightclick_Event.s
  Leftclick_Event.s
  
  Rank_Place.w
  Rank_Delete.w
  
  After_Delete.a
  
  Corresponding_Item.l
  
  Killer.i
  
  Color.l
  
  Light_Emit.i
  Light_Decrease.i
EndStructure
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 128
; FirstLine = 102
; EnableXP
; DisableDebugger