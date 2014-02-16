; ###################################
;-       General Constants
; ###################################

#Version = 100
#Version_World_File = 1000

#Direction_XP = %00000001
#Direction_XN = %00000010
#Direction_YP = %00000100
#Direction_YN = %00001000
#Direction_ZP = %00010000
#Direction_ZN = %00100000

#Direction_X = %00000011
#Direction_Y = %00001100
#Direction_Z = %00110000

; ###################################
;-        Command Constants
; ###################################

#Command_Operators = 10

; ###################################
;-        Physic Constants
; ###################################

#Gravity = -18.0 ; m/s

; ###################################
;-       Function Results
; ###################################

#Result_Fail = 0
#Result_Success = 1

; ###################################
;-          Log Constants
; ###################################

#Log_Type_Information = "INF "
#Log_Type_Warning     = "WARN"
#Log_Type_Error       = "ERRO"
#Log_Type_Chat        = "CHT "
#Log_Type_Debug       = "DEBG"

; ###################################
;-        Network Constants
; ###################################

#Network_Client_Build_Mode_Variables = 5
#Network_Client_Build_Mode_Coordinates = 5

; ###################################
;-         World Constants
; ###################################

#World_Time_Send_Time = 1;s

#World_Save_Time = 60;s

#World_Filename_Config = "Config.txt"
#World_Filename_Overview = "Overview.png"
#World_Filename_Region_Directory = "region/"
#World_Filename_Region_Prefix = "r."
#World_Filename_Region_Seperator = "."
#World_Filename_Region_Suffix = ".mca"

#World_Send_Max_Distance = 10
#World_Send_Min_Distance = 8

#World_Chunk_Size_X = 16
#World_Chunk_Size_Y = 16
#World_Chunk_Size_Z = 16

#World_Chunk_Blockdata_Size = #World_Chunk_Size_X * #World_Chunk_Size_Y * #World_Chunk_Size_Z
#World_Chunk_Metadata_Size = #World_Chunk_Size_X * #World_Chunk_Size_Y * #World_Chunk_Size_Z / 2
#World_Chunk_Lightdata_Size = #World_Chunk_Size_X * #World_Chunk_Size_Y * #World_Chunk_Size_Z
#World_Chunk_Playerdata_Size = #World_Chunk_Size_X * #World_Chunk_Size_Y * #World_Chunk_Size_Z

#World_Column_Chunks = 16

#World_Column_Size_X = #World_Chunk_Size_X
#World_Column_Size_Y = #World_Chunk_Size_Y
#World_Column_Size_Z = #World_Chunk_Size_Z * #World_Column_Chunks

#World_Column_Bitmask_Size = (7 + #World_Column_Size_X * #World_Column_Size_Y * #World_Column_Size_Z) / 8

#World_Region_Sector_Size = 4096
#World_Region_Size_X = 32 ; Size in Columns!
#World_Region_Size_Y = 32 ; Size in Columns!

Enumeration
  #World_Column_Format_None
  #World_Column_Format_Raw
  #World_Column_Format_ZLib
  #World_Column_Format_HDD
EndEnumeration

#World_Column_Send_Buffer_Time = 600;s

#World_Column_Format_Raw_2_ZLib_Time = 120;s
#World_Column_Format_ZLib_2_HDD_Time = 240;s

#World_Column_HDD_Save_Time = 60;s  should be smaller than #World_Column_Format_Raw_2_ZLib_Time to avoid compress/decompress orgies
#World_Column_HDD_Save_Max = 10

; ###################################
;-         Entity Constants
; ###################################

#Entity_Movement_Send_Trigger = 0.03125

#Entity_Send_Position = %00000001
#Entity_Send_Rotation = %00000010
#Entity_Send_Velocity = %00000100

#Entity_Type_Item_Destroy_Time = 5*60 ; 5min

Enumeration
  #Entity_Type_Player
  #Entity_Type_Item
  #Entity_Type_Experience_Orb
  #Entity_Type_Painting
  #Entity_Type_ObjectVehicle  ; Boat, Minecart, Arrows...
  #Entity_Type_Mob
  #Entity_Type_Tile           ; Contains NBT-Data: Chest, Workbench...
EndEnumeration

Enumeration
  #Entity_Inventory_Type_Player = 1
  #Entity_Inventory_Type_Chest
  #Entity_Inventory_Type_Workbench
  #Entity_Inventory_Type_Furnance
EndEnumeration

Enumeration
  #Entity_Physic_None
  #Entity_Physic_Standard
EndEnumeration

; ###################################
;-          Item Constants
; ###################################

#Item_Amount_Max = 32767
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 16
; EnableXP
; DisableDebugger