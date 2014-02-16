; ################################################### Prototypes ############################################

Prototype   Block_Get(Type)

Prototype   Entity_Add(*World.World, X.d, Y.d, Z.d, Type, Name.s)
Prototype   Entity_Delete(*Entity.Entity)
Prototype   Entity_Get_By_ID(Entity_ID)
Prototype   Entity_Set_Position(*Entity.Entity, X.d, Y.d, Z.d, To_Client)
Prototype   Entity_Set_Velocity(*Entity.Entity, VX.d, VY.d, VZ.d, Send, To_Client)
Prototype   Entity_Set_Rotation(*Entity.Entity, Yaw.f, Pitch.f, Roll.f, Send, To_Client)
Prototype   Entity_Set_World(*Entity.Entity, *World.World)
Prototype   Entity_Inventory_Slot_Get(*Entity.Entity, Slot)
Prototype   Entity_Inventory_Set(*Entity.Entity, Slot, Item_Type, Item_Count, Item_Uses)
Prototype   Entity_Inventory_Get_Type(*Entity.Entity, Slot)
Prototype   Entity_Inventory_Get_Count(*Entity.Entity, Slot)
Prototype   Entity_Inventory_Get_Uses(*Entity.Entity, Slot)
Prototype   Entity_Inventory_Holding_Slot_Set(*Entity.Entity, Slot)
Prototype   Entity_Inventory_Get_Free_Slot(*Entity.Entity, Item_Type, Item_Metadata)
Prototype   Entity_Inventory_Insert(*Entity.Entity, *Entity_Item.Entity)

Prototype   Files_File_Get(Name.s, *Result)
Prototype   Files_Folder_Get(Name.s, *Result)

Prototype   Item_Get(Type)

Prototype   Log_Add(Type.s, Message.s, _Include.s, _Procedure.s, _Line, _Thread)

Prototype   Message_Send_2_Client(*Network_Client.Network_Client, Message.s)
Prototype   Message_Send_2_World(*World.World, Message.s)
Prototype   Message_Send_2_All(Message.s)

Prototype   Network_Client_Get(Client_ID)

Prototype   Timer_Register(ID.s, Realtime, Time, *Function, Max_Iterations=10)
Prototype   Timer_Unregister(ID.s)

Prototype   World_Get_By_ID(World_ID)
Prototype   World_Get_Column_X(X)
Prototype   World_Get_Column_Y(Y)
Prototype   World_Get_Region_X(X)
Prototype   World_Get_Region_Y(Y)
Prototype   World_Block_Get(*World.World, X, Y, Z, *Type.Ascii=0, *Metadata.Ascii=0, *BlockLight.Ascii=0, *SkyLight.Ascii=0, *Playerdata.Ascii=0)
Prototype   World_Block_Set(*World.World, X, Y, Z, Type=-1, Metadata=-1, BlockLight=-1, SkyLight=-1, Playerdata=-1, Send=1, Light=1, Physic=1, Current_Trigger_Time=0)
Prototype   World_Column_Get(*World.World, X, Y, Create_If_Nonexistent=0, Load=0)
Prototype   World_Physic_Queue_Add(*World.World, X, Y, Z, *World_Column.World_Column, Trigger_Time, Trigger_Type)
Prototype   World_Effect_Explosion(*World.World, X.d, Y.d, Z.d, R.f)
Prototype   World_Effect_Sound_Or_Particle(*World.World, Effect_ID, X, Y, Z, Data_)
Prototype   World_Effect_Sound(*World.World, Sound_Name.s, X.d, Y.d, Z.d, Volume.f, Pitch.f)
Prototype   World_Effect_Action(*World.World, X, Y, Z, Byte_1, Byte_2, Block_Type)

; ################################################### Structure/Variables ###################################

; #### Aufrufbare Serverfunktionen / Callable server-functions

Structure Plugin_Function_Block
  *Get
EndStructure

Structure Plugin_Function_Entity
  *Add
  *Delete
  *Get_By_ID
  *Set_Position
  *Set_Velocity
  *Set_Rotation
  *Set_World
  *Inventory_Slot_Get
  *Inventory_Set
  *Inventory_Get_Type
  *Inventory_Get_Count
  *Inventory_Get_Uses
  *Inventory_Holding_Slot_Set
  *Inventory_Get_Free_Slot
  *Inventory_Insert
EndStructure

Structure Plugin_Function_Files
  *File_Get
  *Folder_Get
EndStructure

Structure Plugin_Function_Item
  *Get
EndStructure

Structure Plugin_Function_Log
  *Add
EndStructure

Structure Plugin_Function_Message
  *Send_2_Client
  *Send_2_World
  *Send_2_All
EndStructure

Structure Plugin_Function_Network_Client
  *Get
EndStructure

Structure Plugin_Function_Timer
  *Register
  *Unregister
EndStructure

Structure Plugin_Function_World
  *Get_By_ID
  *Get_Column_X
  *Get_Column_Y
  *Get_Region_X
  *Get_Region_Y
  
  *Block_Get
  *Block_Set
  
  *Column_Get
  
  *Effect_Explosion
  *Effect_Sound_Or_Particle
  *Effect_Sound
  *Effect_Action
  
  *Physic_Queue_Add
EndStructure

Structure Plugin_Function
  Block.Plugin_Function_Block
  Entity.Plugin_Function_Entity
  Files.Plugin_Function_Files
  Item.Plugin_Function_Item
  Log.Plugin_Function_Log
  Message.Plugin_Function_Message
  Network_Client.Plugin_Function_Network_Client
  Timer.Plugin_Function_Timer
  World.Plugin_Function_World
EndStructure
Global Plugin_Function.Plugin_Function

; ################################################### Procedures ############################################

CompilerIf #Plugin_Define_Prototypes
Procedure Define_Prototypes(*Pointer.Plugin_Function)
  ; #### Block
  Global Block_Get.Block_Get = *Pointer\Block\Get
  
  ; #### Entity
  Global Entity_Add.Entity_Add = *Pointer\Entity\Add
  Global Entity_Delete.Entity_Delete = *Pointer\Entity\Delete
  Global Entity_Get_By_ID.Entity_Get_By_ID = *Pointer\Entity\Get_By_ID
  Global Entity_Set_Position.Entity_Set_Position = *Pointer\Entity\Set_Position
  Global Entity_Set_Velocity.Entity_Set_Velocity = *Pointer\Entity\Set_Velocity
  Global Entity_Set_Rotation.Entity_Set_Rotation = *Pointer\Entity\Set_Rotation
  Global Entity_Set_World.Entity_Set_World = *Pointer\Entity\Set_World
  Global Entity_Inventory_Slot_Get.Entity_Inventory_Slot_Get = *Pointer\Entity\Inventory_Slot_Get
  Global Entity_Inventory_Set.Entity_Inventory_Set = *Pointer\Entity\Inventory_Set
  Global Entity_Inventory_Get_Type.Entity_Inventory_Get_Type = *Pointer\Entity\Inventory_Get_Type
  Global Entity_Inventory_Get_Count.Entity_Inventory_Get_Count = *Pointer\Entity\Inventory_Get_Count
  Global Entity_Inventory_Get_Uses.Entity_Inventory_Get_Uses = *Pointer\Entity\Inventory_Get_Uses
  Global Entity_Inventory_Holding_Slot_Set.Entity_Inventory_Holding_Slot_Set = *Pointer\Entity\Inventory_Holding_Slot_Set
  Global Entity_Inventory_Get_Free_Slot.Entity_Inventory_Get_Free_Slot = *Pointer\Entity\Inventory_Get_Free_Slot
  Global Entity_Inventory_Insert.Entity_Inventory_Insert = *Pointer\Entity\Inventory_Insert
  
  ; #### Files
  Global Files_File_Get.Files_File_Get = *Pointer\Files\File_Get
  Global Files_Folder_Get.Files_Folder_Get = *Pointer\Files\Folder_Get
  
  ; #### Log
  Global Log_Add.Log_Add = *Pointer\Log\Add
  
  ; #### Message
  Global Message_Send_2_Client.Message_Send_2_Client = *Pointer\Message\Send_2_Client
  Global Message_Send_2_World.Message_Send_2_World = *Pointer\Message\Send_2_World
  Global Message_Send_2_All.Message_Send_2_All = *Pointer\Message\Send_2_All
  
  ; #### Network_Client
  Global Network_Client_Get.Network_Client_Get = *Pointer\Network_Client\Get
  
  ; #### Timer
  Global Timer_Register.Timer_Register = *Pointer\Timer\Register
  Global Timer_Unregister.Timer_Unregister = *Pointer\Timer\Unregister
  
  ; #### World
  Global World_Get_By_ID.World_Get_By_ID = *Pointer\World\Get_By_ID
  Global World_Get_Column_X.World_Get_Column_X = *Pointer\World\Get_Column_X
  Global World_Get_Column_Y.World_Get_Column_Y = *Pointer\World\Get_Column_Y
  Global World_Get_Region_X.World_Get_Region_X = *Pointer\World\Get_Region_X
  Global World_Get_Region_Y.World_Get_Region_Y = *Pointer\World\Get_Region_Y
  Global World_Block_Get.World_Block_Get = *Pointer\World\Block_Get
  Global World_Block_Set.World_Block_Set = *Pointer\World\Block_Set
  Global World_Column_Get.World_Column_Get = *Pointer\World\Column_Get
  Global World_Effect_Explosion.World_Effect_Explosion = *Pointer\World\Effect_Explosion
  Global World_Effect_Sound_Or_Particle.World_Effect_Sound_Or_Particle = *Pointer\World\Effect_Sound_Or_Particle
  Global World_Effect_Sound.World_Effect_Sound = *Pointer\World\Effect_Sound
  Global World_Effect_Action.World_Effect_Action = *Pointer\World\Effect_Action
  
  Global World_Physic_Queue_Add.World_Physic_Queue_Add = *Pointer\World\Physic_Queue_Add
EndProcedure
CompilerEndIf

; ################################################### Insert all function adresses to the structure #########

CompilerIf #Plugin_Define_Prototypes = #False
Plugin_Function\Block\Get = @Block_Get()

Plugin_Function\Entity\Add = @Entity_Add()
Plugin_Function\Entity\Delete = @Entity_Delete()
Plugin_Function\Entity\Get_By_ID = @Entity_Get_By_ID()
Plugin_Function\Entity\Set_Position = @Entity_Set_Position()
Plugin_Function\Entity\Set_Velocity = @Entity_Set_Velocity()
Plugin_Function\Entity\Set_Rotation = @Entity_Set_Rotation()
Plugin_Function\Entity\Set_World = @Entity_Set_World()
Plugin_Function\Entity\Inventory_Slot_Get = @Entity_Inventory_Slot_Get()
Plugin_Function\Entity\Inventory_Set = @Entity_Inventory_Set()
Plugin_Function\Entity\Inventory_Get_Type = @Entity_Inventory_Get_Type()
Plugin_Function\Entity\Inventory_Get_Count = @Entity_Inventory_Get_Count()
Plugin_Function\Entity\Inventory_Get_Uses = @Entity_Inventory_Get_Uses()
Plugin_Function\Entity\Inventory_Holding_Slot_Set = @Entity_Inventory_Holding_Slot_Set()
Plugin_Function\Entity\Inventory_Get_Free_Slot = @Entity_Inventory_Get_Free_Slot()
Plugin_Function\Entity\Inventory_Insert = @Entity_Inventory_Insert()

Plugin_Function\Files\File_Get = @Files_File_Get()
Plugin_Function\Files\Folder_Get = @Files_Folder_Get()

Plugin_Function\Item\Get = @Item_Get()

Plugin_Function\Log\Add = @Log_Add()

Plugin_Function\Message\Send_2_Client = @Message_Send_2_Client()
Plugin_Function\Message\Send_2_World = @Message_Send_2_World()
Plugin_Function\Message\Send_2_All = @Message_Send_2_All()

Plugin_Function\Network_Client\Get = @Network_Client_Get()

Plugin_Function\Timer\Register = @Timer_Register()
Plugin_Function\Timer\Unregister = @Timer_Unregister()

Plugin_Function\World\Get_By_ID = @World_Get_By_ID()
Plugin_Function\World\Get_Column_X = @World_Get_Column_X()
Plugin_Function\World\Get_Column_Y = @World_Get_Column_Y()
Plugin_Function\World\Get_Region_X = @World_Get_Region_X()
Plugin_Function\World\Get_Region_Y = @World_Get_Region_Y()
Plugin_Function\World\Block_Get = @World_Block_Get()
Plugin_Function\World\Block_Set = @World_Block_Set()
Plugin_Function\World\Column_Get = @World_Column_Get()
Plugin_Function\World\Effect_Explosion = @World_Effect_Explosion()
Plugin_Function\World\Effect_Sound_Or_Particle = @World_Effect_Sound_Or_Particle()
Plugin_Function\World\Effect_Sound = @World_Effect_Sound()
Plugin_Function\World\Effect_Action = @World_Effect_Action()
Plugin_Function\World\Physic_Queue_Add = @World_Physic_Queue_Add()
CompilerEndIf

; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 9
; Folding = -
; EnableXP