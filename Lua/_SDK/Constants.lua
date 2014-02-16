-- ###################################
--         Physic Constants
-- ###################################

Gravity = -16.0 -- m/s

-- ###################################
--        Function Results
-- ###################################

Result_Fail = 0
Result_Success = 1

-- ###################################
--           Log Constants
-- ###################################

Log_Type_Information = "INF "
Log_Type_Warning     = "WARN"
Log_Type_Error       = "ERRO"
Log_Type_Chat        = "CHT "

-- ###################################
--         Network Constants
-- ###################################

Network_Client_Build_Mode_Coordinates = 5

-- ###################################
--          World Constants
-- ###################################

World_Max_Preregister_Distance = 10
World_Max_Register_Distance = 8

World_Chunk_Size_X = 16
World_Chunk_Size_Y = 16
World_Chunk_Size_Z = 128

World_Chunk_Blockdata_Size = World_Chunk_Size_X * World_Chunk_Size_Y * World_Chunk_Size_Z
World_Chunk_Metadata_Size = World_Chunk_Size_X * World_Chunk_Size_Y * World_Chunk_Size_Z / 2
World_Chunk_Lightdata_Size = World_Chunk_Size_X * World_Chunk_Size_Y * World_Chunk_Size_Z
World_Chunk_Playerdata_Size = World_Chunk_Size_X * World_Chunk_Size_Y * World_Chunk_Size_Z

World_Chunk_Format_Raw   = 0
World_Chunk_Format_ZLib  = 1
World_Chunk_Format_HDD   = 1

World_Chunk_Send_Buffer_Time = 600--s

World_Chunk_Format_Raw_2_ZLib_Time = 30--s
World_Chunk_Format_ZLib_2_HDD_Time = 120--s

World_Chunk_Format_HDD_Time = 180--s

-- ###################################
--          Entity Constants
-- ###################################

Entity_Movement_Send_Trigger = 0.03125

Entity_Send_Position = 1
Entity_Send_Rotation = 2
Entity_Send_Velocity = 4

Entity_Type_Item_Destroy_Time = 5*60 -- 5min

--Enumeration
  Entity_Type_Player		= 0
  Entity_Type_Mob			= 1
  Entity_Type_Item			= 2
  Entity_Type_ObjectVehicle	= 3  -- Boat, Minecart...
  Entity_Type_Block			= 4  -- Chest, Workbench...
--EndEnumeration

--Enumeration
  Entity_Type_ObjectVehicle_Boat             = 1
  Entity_Type_ObjectVehicle_Minecart         = 10
  Entity_Type_ObjectVehicle_Storage_Cart     = 11
  Entity_Type_ObjectVehicle_Powered_Cart     = 12
  Entity_Type_ObjectVehicle_Activated_TNT    = 50
  Entity_Type_ObjectVehicle_Arrow            = 60
  Entity_Type_ObjectVehicle_Thrown_Snowball  = 61
  Entity_Type_ObjectVehicle_Thrown_Egg       = 62
  Entity_Type_ObjectVehicle_Falling_Sand     = 70
  Entity_Type_ObjectVehicle_Falling_Gravel   = 71
--EndEnumeration

Entity_Inventory_Slots = 54

--Enumeration
  Entity_Inventory_Type_Player    = -1
  Entity_Inventory_Type_Chest     = 0
  Entity_Inventory_Type_Workbench = 1
  Entity_Inventory_Type_Furnance  = 2
--EndEnumeration

--Enumeration
  Entity_Physic_None = 0
  Entity_Physic_Item = 1
--EndEnumeration