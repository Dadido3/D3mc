; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "S_Includes/Structures.pbi"

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Constants #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

Macro World_Column_Compress(_Buffer, _Buffer_Size, _Dest_Buffer, _Dest_Buffer_Size)
  Temp_Size = compressBound(_Buffer_Size)
  *Temp = AllocateMemory(Temp_Size)
  If Not *Temp
    ; Add Error-Handler here
    Log_Add_Error("AllocateMemory")
    ProcedureReturn #Result_Fail
  EndIf
  If compress(*Temp, @Temp_Size, _Buffer, _Buffer_Size) = #Z_OK
    If _Dest_Buffer
      *Result = ReAllocateMemory(_Dest_Buffer, Temp_Size)
    Else
      *Result = AllocateMemory(Temp_Size)
    EndIf
    If Not *Result
      ; Add Error-Handler here
      Log_Add_Error("ReAllocateMemory or AllocateMemory")
      FreeMemory(*Temp)
      ProcedureReturn #Result_Fail
    EndIf
    _Dest_Buffer = *Result
    _Dest_Buffer_Size = Temp_Size
    CopyMemory(*Temp, _Dest_Buffer, Temp_Size)
    FreeMemory(*Temp)
  Else
    ; Add Error-Handler here
    Log_Add_Error("compress")
    FreeMemory(*Temp)
    ProcedureReturn #Result_Fail
  EndIf
EndMacro

Macro World_Column_Uncompress(_Buffer, _Buffer_Size, _Dest_Buffer, _Dest_Buffer_Size, _Raw_Size)
  Temp_Size = _Raw_Size
  *Temp = AllocateMemory(Temp_Size)
  If Not *Temp
    ; Add Error-Handler here
    Log_Add_Error("AllocateMemory")
    ProcedureReturn #Result_Fail
  EndIf
  If uncompress(*Temp, @Temp_Size, _Buffer, _Buffer_Size) = #Z_OK
    If _Dest_Buffer
      *Result = ReAllocateMemory(_Dest_Buffer, Temp_Size)
    Else
      *Result = AllocateMemory(Temp_Size)
    EndIf
    If Not *Result
      ; Add Error-Handler here
      Log_Add_Error("ReAllocateMemory or AllocateMemory")
      FreeMemory(*Temp)
      ProcedureReturn #Result_Fail
    EndIf
    _Dest_Buffer = *Result
    _Dest_Buffer_Size = Temp_Size
    CopyMemory(*Temp, _Dest_Buffer, Temp_Size)
    FreeMemory(*Temp)
  Else
    ; Add Error-Handler here
    Log_Add_Error("uncompress")
    FreeMemory(*Temp)
    ProcedureReturn #Result_Fail
  EndIf
EndMacro

; #################################################### Procedures ################################################

Procedure World_Column_Get_Offset(X, Y, Z)
  ProcedureReturn ((X) + ((Y) * #World_Column_Size_X) + ((Z) * #World_Column_Size_X * #World_Column_Size_Y))
EndProcedure

Procedure World_Chunk_Get_Offset(X, Y, Z)
  ProcedureReturn ((X) + ((Y) * #World_Chunk_Size_X) + ((Z) * #World_Chunk_Size_X * #World_Chunk_Size_Y))
EndProcedure

Procedure World_Column_Get(*World.World, X, Y, Create_If_Nonexistent=0, Load=0)
  Protected World_Column_Key.Coordinate, Found
  Protected *Result
  Protected File_ID, Temp_Value_A.Eight_Bytes_Ext, Temp_Value_B.Eight_Bytes_Ext, Temp_Value_C.Eight_Bytes_Ext
  Protected Offset_X, Offset_Y
  
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Null
  EndIf
  
  If ListIndex(*World\Column()) <> -1 And *World\Column()\X = X And *World\Column()\Y = Y
    ProcedureReturn *World\Column()
  EndIf
  
  World_Column_Key\X = X
  World_Column_Key\Y = Y
  *Result = D3HT_Element_Get_Integer(*World\Column_Finder, World_Column_Key)
  
  If *Result
    ProcedureReturn *Result
  Else
    Found = #False
    If Load
      ; #### Search on HDD
      File_ID = ReadFile(#PB_Any, *World\Directory+#World_Filename_Region_Directory+#World_Filename_Region_Prefix+Str(World_Get_Region_X(X))+#World_Filename_Region_Seperator+Str(World_Get_Region_X(Y))+#World_Filename_Region_Suffix)
      If File_ID
        Offset_X = X - World_Get_Region_X(X) * #World_Region_Size_X
        Offset_Y = Y - World_Get_Region_Y(Y) * #World_Region_Size_Y
        
        FileSeek(File_ID, (Offset_X + Offset_Y*#World_Region_Size_X)*4)
        Temp_Value_A\Bytes\C = ReadAsciiCharacter(File_ID)
        Temp_Value_A\Bytes\B = ReadAsciiCharacter(File_ID)
        Temp_Value_A\Bytes\A = ReadAsciiCharacter(File_ID)
        Temp_Value_B\Bytes\A = ReadAsciiCharacter(File_ID)
        ; #### Check if chunk is generated!
        If Temp_Value_A\Long*#World_Region_Sector_Size < Lof(File_ID) And Temp_Value_B\Ascii
          FileSeek(File_ID, Temp_Value_A\Long*#World_Region_Sector_Size)
          Temp_Value_C\Bytes\D = ReadAsciiCharacter(File_ID) ; #### Size
          Temp_Value_C\Bytes\C = ReadAsciiCharacter(File_ID)
          Temp_Value_C\Bytes\B = ReadAsciiCharacter(File_ID)
          Temp_Value_C\Bytes\A = ReadAsciiCharacter(File_ID)
          If Temp_Value_C\Long > 0
            Found = #True
          EndIf
        ElseIf Temp_Value_A\Long
          Log_Add_Warn("Invalid Entry in Header (Offset="+Str(Temp_Value_A\Long)+" Sectors="+Str(Temp_Value_B\Bytes\A)+")")
        EndIf
        
        CloseFile(File_ID)
      EndIf
    EndIf
    
    If Found
      ; #### Found, prepare reading from it
      ProcedureReturn World_Column_Add(*World, X, Y, #World_Column_Format_HDD, 0)
    ElseIf Create_If_Nonexistent
      ; #### Not found, create a new Column
      ProcedureReturn World_Column_Add(*World, X, Y, #World_Column_Format_Raw, 1)
    EndIf
  EndIf
  
  ProcedureReturn #Null
EndProcedure

Procedure World_Column_Add(*World.World, X, Y, Format, Generation_State=0)
  Protected World_Column_Key.Coordinate
  Protected *World_Column.World_Column
  Protected *Temp_World_Column.World_Column
  Protected i, ix, iy
  
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Null
  EndIf
  
  
  LastElement(*World\Column())
  If Not AddElement(*World\Column())
    ; Add Error-Handler here
    Log_Add_Error("AddElement")
    ProcedureReturn #Null
  EndIf
  
  *World_Column = *World\Column()
  
  World_Column_Key\X = X
  World_Column_Key\Y = Y
  If Not D3HT_Element_Set_Integer(*World\Column_Finder, World_Column_Key, *World\Column())
    ; Add Error-Handler here
    Log_Add_Error("D3HT_Element_Set_Integer")
    DeleteElement(*World\Column())
    ProcedureReturn #Result_Fail
  EndIf
  
  *World\Column()\World = *World
  *World\Column()\X = X
  *World\Column()\Y = Y
  
  *World\Column()\Generation_State = Generation_State
  
  For i = 0 To #World_Column_Chunks-1
    *World\Column()\Format[i] = #World_Column_Format_None
  Next
  
  If Not World_Column_Change_Format(*World, *World\Column(), $FFFF, Format)
    ; Add Error-Handler here
    Log_Add_Error("World_Column_Change_Format")
    DeleteElement(*World\Column())
    D3HT_Element_Free(*World\Column_Finder, World_Column_Key)
    ProcedureReturn #Result_Fail
  EndIf
  
  For ix = -1 To 1
    For iy = -1 To 1
      *Temp_World_Column = World_Column_Get(*World, X+ix, Y+iy)
      If *Temp_World_Column And *Temp_World_Column <> *World_Column
        *Temp_World_Column\Neighbour_Columns + 1
        *World_Column\Neighbour_Columns + 1
      EndIf
    Next
  Next
  
  ProcedureReturn *World_Column
EndProcedure

Procedure World_Column_Delete(*World.World, *World_Column.World_Column)
  Protected World_Column_Key.Coordinate
  Protected *Temp_World_Column.World_Column
  Protected i, X, Y, ix, iy
  
  X = *World_Column\X
  Y = *World_Column\Y
  
  World_Column_Key\X = X
  World_Column_Key\Y = Y
  D3HT_Element_Free(*World\Column_Finder, World_Column_Key)
  
  For i = 0 To 15
    If *World_Column\Blockdata[i] : FreeMemory(*World_Column\Blockdata[i]) : EndIf
    If *World_Column\Metadata[i] : FreeMemory(*World_Column\Metadata[i]) : EndIf
    If *World_Column\Lightdata[i] : FreeMemory(*World_Column\Lightdata[i]) : EndIf
    If *World_Column\Playerdata[i] : FreeMemory(*World_Column\Playerdata[i]) : EndIf
  Next
  
  ; #### Todo: Delete entities from Column...
  ; #### Todo: Delete any queue elements...
  Log_Add_Warn("Function World_Column_Delete isn't properly implemented yet, can possibly cause errors and memory-leaks!")
  
  SelectElement(*World\Column(), *World_Column)
  DeleteElement(*World\Column())
  
  For ix = -1 To 1
    For iy = -1 To 1
      *Temp_World_Column = World_Column_Get(*World, X+ix, Y+iy)
      If *Temp_World_Column
        *Temp_World_Column\Neighbour_Columns - 1
      EndIf
    Next
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Column_File_Write(*World.World, *World_Column.World_Column)
  Protected File_ID
  Protected Offset_X, Offset_Y
  Protected Temp_Value_A.Eight_Bytes_Ext, Temp_Value_B.Eight_Bytes_Ext, Temp_Value_C.Eight_Bytes_Ext, Temp_Value_D.Eight_Bytes_Ext
  Protected *Temp_Buffer, Temp_Buffer_Size, NBT_Error.s
  Protected *Temp_NBT.NBT_Element, *Temp_NBT_Tag.NBT_Tag
  Protected i, Chunk, Compression
  Protected Sector_Start_Pos
  Protected NewList Used_Sector.Eight_Bytes_Ext()
  Protected *Empty_Buffer
  
  ;Protected Debug_Time
  ;Debug_Time = ElapsedMilliseconds()
  
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column
    ; Add Error-Handler here
    Log_Add_Error("*World_Column")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not World_Column_Change_Format(*World, *World_Column, $FFFF, #World_Column_Format_Raw)
    ; Add Error-Handler here
    Log_Add_Error("World_Column_Change_Format to Raw")
    ProcedureReturn #Result_Fail
  EndIf
  
  *Temp_NBT = NBT_Element_Add()
  If Not *Temp_NBT
    ; Add Error-Handler here
    Log_Add_Error("NBT_Element_Add() Error:"+NBT_Error_Get())
    ProcedureReturn #Result_Fail
  EndIf
  
  *Temp_NBT_Tag = *Temp_NBT\NBT_Tag
  *Temp_NBT_Tag = NBT_Tag_Add(*Temp_NBT_Tag, "Level", #NBT_Tag_Compound)
  NBT_Tag_Add(*Temp_NBT_Tag, "TerrainPopulated", #NBT_Tag_Byte)
  NBT_Tag_Add(*Temp_NBT_Tag, "xPos", #NBT_Tag_Long)
  NBT_Tag_Add(*Temp_NBT_Tag, "yPos", #NBT_Tag_Long)
  NBT_Tag_Add(*Temp_NBT_Tag, "LastUpdate", #NBT_Tag_Quad)
  NBT_Tag_Add(*Temp_NBT_Tag, "Biomes", #NBT_Tag_Byte_Array)
  NBT_Tag_Add(*Temp_NBT_Tag, "Entities", #NBT_Tag_List, #NBT_Tag_Compound)
  NBT_Tag_Add(*Temp_NBT_Tag, "Sections", #NBT_Tag_List, #NBT_Tag_Compound)
  NBT_Tag_Add(*Temp_NBT_Tag, "TileEntities", #NBT_Tag_List, #NBT_Tag_Compound)
  NBT_Tag_Add(*Temp_NBT_Tag, "HeightMap", #NBT_Tag_Byte_Array)
  For i = 0 To #World_Column_Chunks-1
    If *World_Column\Empty[i] = #False
      *Temp_NBT_Tag = NBT_Tag(NBT_Tag(*Temp_NBT\NBT_Tag, "Level"), "Sections")
      *Temp_NBT_Tag = NBT_Tag_Add(*Temp_NBT_Tag, "", #NBT_Tag_Compound)
      NBT_Tag_Set_Number(NBT_Tag_Add(*Temp_NBT_Tag, "Y", #NBT_Tag_Byte), i)
      NBT_Tag_Add(*Temp_NBT_Tag, "Blocks", #NBT_Tag_Byte_Array)
      NBT_Tag_Add(*Temp_NBT_Tag, "Data", #NBT_Tag_Byte_Array)
      NBT_Tag_Add(*Temp_NBT_Tag, "BlockLight", #NBT_Tag_Byte_Array)
      NBT_Tag_Add(*Temp_NBT_Tag, "SkyLight", #NBT_Tag_Byte_Array)
      NBT_Tag_Set_Array(NBT_Tag(*Temp_NBT_Tag, "Blocks"), *World_Column\Blockdata[i], #World_Chunk_Blockdata_Size)
      NBT_Tag_Set_Array(NBT_Tag(*Temp_NBT_Tag, "Data"), *World_Column\Metadata[i], #World_Chunk_Metadata_Size)
      NBT_Tag_Set_Array(NBT_Tag(*Temp_NBT_Tag, "BlockLight"), *World_Column\Lightdata[i], #World_Chunk_Lightdata_Size/2)
      NBT_Tag_Set_Array(NBT_Tag(*Temp_NBT_Tag, "SkyLight"), *World_Column\Lightdata[i]+#World_Chunk_Lightdata_Size/2, #World_Chunk_Lightdata_Size/2)
    EndIf
  Next
  
  Temp_Buffer_Size = NBT_Get_Ram_Size(*Temp_NBT)
  *Temp_Buffer = AllocateMemory(Temp_Buffer_Size)
  If Not *Temp_Buffer
    ; Add Error-Handler here
    Log_Add_Error("*Temp_Buffer")
    NBT_Element_Delete(*Temp_NBT)
    ProcedureReturn #Result_Fail
  EndIf
  
  Temp_Buffer_Size = NBT_Write_Ram(*Temp_NBT, *Temp_Buffer, Temp_Buffer_Size, #NBT_Compression_ZLib)
  If Not Temp_Buffer_Size
    ; Add Error-Handler here
    Log_Add_Error("NBT_Write_Ram() Error:"+NBT_Error_Get())
    NBT_Element_Delete(*Temp_NBT)
    FreeMemory(*Temp_Buffer)
    ProcedureReturn #Result_Fail
  EndIf
  
  NBT_Element_Delete(*Temp_NBT)
  
  NBT_Error = NBT_Error_Get()
  If NBT_Error
    ; Add Error-Handler here
    Log_Add_Error("NBT_Error: "+NBT_Error)
    ProcedureReturn #Result_Fail
  EndIf
  
  CreateDirectory(*World\Directory+#World_Filename_Region_Directory)
  
  File_ID = OpenFile(#PB_Any, *World\Directory+#World_Filename_Region_Directory+#World_Filename_Region_Prefix+Str(World_Get_Region_X(*World_Column\X))+#World_Filename_Region_Seperator+Str(World_Get_Region_X(*World_Column\Y))+#World_Filename_Region_Suffix)
  If Not File_ID
    ; Add Error-Handler here
    Log_Add_Error("OpenFile")
    FreeMemory(*Temp_Buffer)
    ProcedureReturn #Result_Fail
  EndIf
  
  ; #### Reserve sectors if file is new
  If Lof(File_ID) < #World_Region_Sector_Size*2
    FileSeek(File_ID, Lof(File_ID))
    *Empty_Buffer = AllocateMemory(#World_Region_Sector_Size*2)
    WriteData(File_ID, *Empty_Buffer, #World_Region_Sector_Size*2 - Lof(File_ID))
    FreeMemory(*Empty_Buffer)
  EndIf
  
  ; #### Round filesize to sectorsize
  If Lof(File_ID) < (1+(Lof(File_ID)-1)/#World_Region_Sector_Size)*#World_Region_Sector_Size
    FileSeek(File_ID, Lof(File_ID))
    *Empty_Buffer = AllocateMemory(#World_Region_Sector_Size)
    WriteData(File_ID, *Empty_Buffer, (1+(Lof(File_ID)-1)/#World_Region_Sector_Size)*#World_Region_Sector_Size - Lof(File_ID))
    FreeMemory(*Empty_Buffer)
  EndIf
  
  ; #### Remove old data
  Offset_X = *World_Column\X - World_Get_Region_X(*World_Column\X) * #World_Region_Size_X
  Offset_Y = *World_Column\Y - World_Get_Region_Y(*World_Column\Y) * #World_Region_Size_Y
  
  FileSeek(File_ID, (Offset_X + Offset_Y*#World_Region_Size_X)*4)
  Temp_Value_A\Bytes\C = ReadAsciiCharacter(File_ID) ; #### Offset
  Temp_Value_A\Bytes\B = ReadAsciiCharacter(File_ID)
  Temp_Value_A\Bytes\A = ReadAsciiCharacter(File_ID)
  Temp_Value_B\Bytes\A = ReadAsciiCharacter(File_ID) ; #### Amount of sectors
  FileSeek(File_ID, (Offset_X + Offset_Y*#World_Region_Size_X)*4)
  WriteLong(File_ID, 0)
  If Temp_Value_A\Long*#World_Region_Sector_Size < Lof(File_ID)
    FileSeek(File_ID, Temp_Value_A\Long*#World_Region_Sector_Size)
    WriteLong(File_ID, 0)
    WriteAsciiCharacter(File_ID, 0)
  Else
    Log_Add_Warn("Invalid Entry in Header (Offset="+Str(Temp_Value_A\Long)+" Sectors="+Str(Temp_Value_B\Bytes\A)+")")
  EndIf
  
  ; #### Find free sectors
  AddElement(Used_Sector()) ; Header Sectors
  Used_Sector()\Long = 0
  Used_Sector()\Bytes\E = 2
  FileSeek(File_ID, 0)
  For i = 0 To 1023
    Temp_Value_A\Bytes\C = ReadAsciiCharacter(File_ID) ; #### Offset
    Temp_Value_A\Bytes\B = ReadAsciiCharacter(File_ID)
    Temp_Value_A\Bytes\A = ReadAsciiCharacter(File_ID)
    Temp_Value_B\Bytes\A = ReadAsciiCharacter(File_ID) ; #### Amount of sectors
    If Temp_Value_A\Long And Temp_Value_B\Ascii
      AddElement(Used_Sector())
      Used_Sector()\Long = Temp_Value_A\Long
      Used_Sector()\Bytes\E = Temp_Value_B\Ascii
    EndIf
  Next
  SortStructuredList(Used_Sector(), #PB_Sort_Ascending, OffsetOf(Eight_Bytes\E), #PB_Ascii)
  SortStructuredList(Used_Sector(), #PB_Sort_Ascending, OffsetOf(Eight_Bytes_Ext\Long), #PB_Long)
  
  Sector_Start_Pos = 0
  ForEach Used_Sector()
    If (Used_Sector()\Long - Sector_Start_Pos)*#World_Region_Sector_Size >= Temp_Buffer_Size
      Break
    EndIf
    Sector_Start_Pos = Used_Sector()\Long + Used_Sector()\Bytes\E
  Next
  
  ; #### Write it
  FileSeek(File_ID, (Offset_X + Offset_Y*#World_Region_Size_X)*4)
  Temp_Value_A\Long = Sector_Start_Pos
  WriteAsciiCharacter(File_ID, Temp_Value_A\Bytes\C) ; #### Offset
  WriteAsciiCharacter(File_ID, Temp_Value_A\Bytes\B)
  WriteAsciiCharacter(File_ID, Temp_Value_A\Bytes\A)
  WriteAsciiCharacter(File_ID, 1+(Temp_Buffer_Size-1)/#World_Region_Sector_Size) ; #### Amount of sectors needed
  FileSeek(File_ID, Sector_Start_Pos*#World_Region_Sector_Size)
  Temp_Value_C\Long = Temp_Buffer_Size
  WriteAsciiCharacter(File_ID, Temp_Value_C\Bytes\D) ; #### Size
  WriteAsciiCharacter(File_ID, Temp_Value_C\Bytes\C)
  WriteAsciiCharacter(File_ID, Temp_Value_C\Bytes\B)
  WriteAsciiCharacter(File_ID, Temp_Value_C\Bytes\A)
  WriteAsciiCharacter(File_ID, 2) ; #### Compression (ZLib)
  
  If Not WriteData(File_ID, *Temp_Buffer, Temp_Buffer_Size) = Temp_Buffer_Size
    ; Add Error-Handler here
    Log_Add_Error("WriteData()")
    FreeMemory(*Temp_Buffer)
    CloseFile(File_ID)
    ProcedureReturn #Result_Fail
  EndIf
  
  ; #### Round filesize to sectorsize
  If Lof(File_ID) < (1+(Lof(File_ID)-1)/#World_Region_Sector_Size)*#World_Region_Sector_Size
    FileSeek(File_ID, Lof(File_ID))
    *Empty_Buffer = AllocateMemory(#World_Region_Sector_Size)
    WriteData(File_ID, *Empty_Buffer, (1+(Lof(File_ID)-1)/#World_Region_Sector_Size)*#World_Region_Sector_Size - Lof(File_ID))
    FreeMemory(*Empty_Buffer)
  EndIf
  
  CloseFile(File_ID)
  FreeMemory(*Temp_Buffer)
  
  ;Log_Add_Debug("Needed: "+Str(ElapsedMilliseconds()-Debug_Time)+"ms")
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Column_File_Read(*World.World, *World_Column.World_Column)
  Protected File_ID
  Protected Offset_X, Offset_Y
  Protected Temp_Value_A.Eight_Bytes_Ext, Temp_Value_B.Eight_Bytes_Ext, Temp_Value_C.Eight_Bytes_Ext, Temp_Value_D.Eight_Bytes_Ext
  Protected *Temp_Buffer, Temp_Buffer_Size
  Protected *Temp_NBT.NBT_Element, *Temp_NBT_Tag.NBT_Tag
  Protected i, Chunk, Compression
  
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column
    ; Add Error-Handler here
    Log_Add_Error("*World_Column")
    ProcedureReturn #Result_Fail
  EndIf
  
  File_ID = ReadFile(#PB_Any, *World\Directory+#World_Filename_Region_Directory+#World_Filename_Region_Prefix+Str(World_Get_Region_X(*World_Column\X))+#World_Filename_Region_Seperator+Str(World_Get_Region_X(*World_Column\Y))+#World_Filename_Region_Suffix)
  If Not File_ID
    ; Add Error-Handler here
    Log_Add_Error("ReadFile")
    ProcedureReturn #Result_Fail
  EndIf
  
  Offset_X = *World_Column\X - World_Get_Region_X(*World_Column\X) * #World_Region_Size_X
  Offset_Y = *World_Column\Y - World_Get_Region_Y(*World_Column\Y) * #World_Region_Size_Y
  
  FileSeek(File_ID, (Offset_X + Offset_Y*#World_Region_Size_X)*4)
  Temp_Value_A\Bytes\C = ReadAsciiCharacter(File_ID) ; #### Offset
  Temp_Value_A\Bytes\B = ReadAsciiCharacter(File_ID)
  Temp_Value_A\Bytes\A = ReadAsciiCharacter(File_ID)
  Temp_Value_B\Bytes\A = ReadAsciiCharacter(File_ID) ; #### Amount of sectors
  If Temp_Value_A\Long*#World_Region_Sector_Size >= Lof(File_ID)
    ; Add Error-Handler here
    Log_Add_Error("Sector outside of File")
    CloseFile(File_ID)
    ProcedureReturn #Result_Fail
  EndIf
  FileSeek(File_ID, Temp_Value_A\Long*#World_Region_Sector_Size)
  Temp_Value_C\Bytes\D = ReadAsciiCharacter(File_ID) ; #### Size
  Temp_Value_C\Bytes\C = ReadAsciiCharacter(File_ID)
  Temp_Value_C\Bytes\B = ReadAsciiCharacter(File_ID)
  Temp_Value_C\Bytes\A = ReadAsciiCharacter(File_ID)
  Temp_Value_D\Bytes\A = ReadAsciiCharacter(File_ID) ; #### Compression
  
  ; #### Column isn't generated or missing
  If Temp_Value_C\Long <= 0
    World_Column_Change_Format(*World, *World_Column, $FFFF, #World_Column_Format_None)
    ProcedureReturn #Result_Fail
  EndIf
  
  Select Temp_Value_D\Bytes\A
    Case 0 : Compression = #NBT_Compression_None
    Case 1 : Compression = #NBT_Compression_GZip
    Case 2 : Compression = #NBT_Compression_ZLib
    Default
      ; Add Error-Handler here
      Log_Add_Error("Unkown Compression")
      CloseFile(File_ID)
      ProcedureReturn #Result_Fail
  EndSelect
  
  Temp_Buffer_Size = Temp_Value_C\Long
  *Temp_Buffer = AllocateMemory(Temp_Buffer_Size)
  If Not *Temp_Buffer
    ; Add Error-Handler here
    Log_Add_Error("*Temp_Buffer")
    CloseFile(File_ID)
    ProcedureReturn #Result_Fail
  EndIf
  
  ReadData(File_ID, *Temp_Buffer, Temp_Buffer_Size)
  
  CloseFile(File_ID)
  
  *Temp_NBT = NBT_Read_Ram(*Temp_Buffer, Temp_Buffer_Size, Compression)
  If Not *Temp_NBT
    ; Add Error-Handler here
    Log_Add_Error("*Temp_NBT Error:"+NBT_Error_Get())
    FreeMemory(*Temp_Buffer)
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not World_Column_Change_Format(*World, *World_Column, $FFFF, #World_Column_Format_None)
    ; Add Error-Handler here
    Log_Add_Error("World_Column_Change_Format to None")
    ProcedureReturn #Result_Fail
  EndIf
  If Not World_Column_Change_Format(*World, *World_Column, $FFFF, #World_Column_Format_Raw)
    ; Add Error-Handler here
    Log_Add_Error("World_Column_Change_Format to Raw")
    ProcedureReturn #Result_Fail
  EndIf
  
  ; #### Read /Level/Sections/
  For i = 0 To #World_Column_Chunks-1
    *Temp_NBT_Tag = NBT_Tag_Index(NBT_Tag(NBT_Tag(*Temp_NBT\NBT_Tag, "Level"), "Sections"), i)
    If Not *Temp_NBT_Tag
      NBT_Error_Get()
      Break
    EndIf
    Chunk = NBT_Tag_Get_Number(NBT_Tag(*Temp_NBT_Tag, "Y"))
    If Chunk >= 0 And Chunk < #World_Column_Chunks
      NBT_Tag_Get_Array(NBT_Tag(*Temp_NBT_Tag, "Blocks"), *World_Column\Blockdata[Chunk], #World_Chunk_Blockdata_Size)
      NBT_Tag_Get_Array(NBT_Tag(*Temp_NBT_Tag, "Data"), *World_Column\Metadata[Chunk], #World_Chunk_Metadata_Size)
      NBT_Tag_Get_Array(NBT_Tag(*Temp_NBT_Tag, "BlockLight"), *World_Column\Lightdata[Chunk], #World_Chunk_Lightdata_Size/2)
      NBT_Tag_Get_Array(NBT_Tag(*Temp_NBT_Tag, "SkyLight"), *World_Column\Lightdata[Chunk]+#World_Chunk_Lightdata_Size/2, #World_Chunk_Lightdata_Size/2)
      *World_Column\Empty[Chunk] = #False
    EndIf
  Next
  
  FreeMemory(*Temp_Buffer)
  NBT_Element_Delete(*Temp_NBT)
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Column_Change_Format(*World.World, *World_Column.World_Column, Chunks, Format)
  Protected *Temp, Temp_Size, *Result, i
  ;Protected File_ID
  ;Protected Temp_Value_A.Eight_Bytes_Ext, Temp_Value_B.Eight_Bytes_Ext, Temp_Value_C.Eight_Bytes_Ext, Temp_Value_D.Eight_Bytes_Ext
  Protected Offset_X, Offset_Y
  
  If Not *World_Column
    ; Add Error-Handler here
    Log_Add_Error("*World_Column")
    ProcedureReturn #Result_Fail
  EndIf
  
  ; #### Clear everything if format is none
  If Format = #World_Column_Format_None
    For i = 0 To #World_Column_Chunks-1
      If Chunks & (1<<i)
        If *World_Column\Blockdata[i]  : FreeMemory(*World_Column\Blockdata[i])  : *World_Column\Blockdata[i] = 0  : EndIf
        If *World_Column\Metadata[i]   : FreeMemory(*World_Column\Metadata[i])   : *World_Column\Metadata[i] = 0   : EndIf
        If *World_Column\Lightdata[i]  : FreeMemory(*World_Column\Lightdata[i])  : *World_Column\Lightdata[i] = 0  : EndIf
        If *World_Column\Playerdata[i] : FreeMemory(*World_Column\Playerdata[i]) : *World_Column\Playerdata[i] = 0 : EndIf
        *World_Column\Format[i] = Format
        *World_Column\Format_Change_Date[i] = 0
      EndIf
    Next
    *World_Column\HDD_Save_Date = 0
    ProcedureReturn #Result_Success
  EndIf
  
  For i = 0 To #World_Column_Chunks-1
    If Chunks & (1<<i)
      Select *World_Column\Format[i]
        Case #World_Column_Format_None
          ; #### Clear everything if old format is none
          If *World_Column\Blockdata[i]  : FreeMemory(*World_Column\Blockdata[i])  : *World_Column\Blockdata[i] = 0  : EndIf
          If *World_Column\Metadata[i]   : FreeMemory(*World_Column\Metadata[i])   : *World_Column\Metadata[i] = 0   : EndIf
          If *World_Column\Lightdata[i]  : FreeMemory(*World_Column\Lightdata[i])  : *World_Column\Lightdata[i] = 0  : EndIf
          If *World_Column\Playerdata[i] : FreeMemory(*World_Column\Playerdata[i]) : *World_Column\Playerdata[i] = 0 : EndIf
          Select Format
            Case #World_Column_Format_Raw, #World_Column_Format_ZLib
              ; #### None --> Raw or ZLib
              *World_Column\Blockdata_Size[i] = #World_Chunk_Blockdata_Size
              *World_Column\Blockdata[i] = AllocateMemory(*World_Column\Blockdata_Size[i])
              If Not *World_Column\Blockdata[i]
                ; Add Error-Handler here
                Log_Add_Error("AllocateMemory")
                ProcedureReturn #Result_Fail
              EndIf
              
              *World_Column\Metadata_Size[i] = #World_Chunk_Metadata_Size
              *World_Column\Metadata[i] = AllocateMemory(*World_Column\Metadata_Size[i])
              If Not *World_Column\Metadata[i]
                ; Add Error-Handler here
                Log_Add_Error("AllocateMemory")
                ProcedureReturn #Result_Fail
              EndIf
              
              *World_Column\Lightdata_Size[i] = #World_Chunk_Lightdata_Size
              *World_Column\Lightdata[i] = AllocateMemory(*World_Column\Lightdata_Size[i])
              If Not *World_Column\Lightdata[i]
                ; Add Error-Handler here
                Log_Add_Error("AllocateMemory")
                ProcedureReturn #Result_Fail
              EndIf
              
              *World_Column\Playerdata_Size[i] = #World_Chunk_Playerdata_Size
              *World_Column\Playerdata[i] = AllocateMemory(*World_Column\Playerdata_Size[i])
              If Not *World_Column\Playerdata[i]
                ; Add Error-Handler here
                Log_Add_Error("AllocateMemory")
                ProcedureReturn #Result_Fail
              EndIf
              
              FillMemory(*World_Column\Lightdata[i], *World_Column\Lightdata_Size[i]/2, 0)
              FillMemory(*World_Column\Lightdata[i]+*World_Column\Lightdata_Size[i]/2, *World_Column\Lightdata_Size[i]/2, 255)
              If i = 0
                FillMemory(*World_Column\Blockdata[i], 16*16, 7)
                *World_Column\Empty[i] = #False
              Else
                *World_Column\Empty[i] = #True
              EndIf
              
              *World_Column\Format_Change_Date[i] = Date() + #World_Column_Format_Raw_2_ZLib_Time
              *World_Column\Format[i] = Format
              
              If Format = #World_Column_Format_ZLib
                World_Column_Compress(*World_Column\Blockdata[i], *World_Column\Blockdata_Size[i], *World_Column\Blockdata[i], *World_Column\Blockdata_Size[i])
                World_Column_Compress(*World_Column\Metadata[i], *World_Column\Metadata_Size[i], *World_Column\Metadata[i], *World_Column\Metadata_Size[i])
                World_Column_Compress(*World_Column\Lightdata[i], *World_Column\Lightdata_Size[i], *World_Column\Lightdata[i], *World_Column\Lightdata_Size[i])
                World_Column_Compress(*World_Column\Playerdata[i], *World_Column\Playerdata_Size[i], *World_Column\Playerdata[i], *World_Column\Playerdata_Size[i])
                
                *World_Column\Format_Change_Date[i] = Date() + #World_Column_Format_ZLib_2_HDD_Time
              EndIf
              
            Case #World_Column_Format_HDD
              ; #### None --> HDD
              *World_Column\Format[i] = Format
              *World_Column\Format_Change_Date[i] = 0
              *World_Column\HDD_Save_Date = 0
              *World_Column\Empty[i] = #False
              
          EndSelect
          
        Case #World_Column_Format_Raw
          Select Format
            Case #World_Column_Format_Raw
              ; #### Raw --> Raw
              *World_Column\Format_Change_Date[i] = Date() + #World_Column_Format_Raw_2_ZLib_Time
              
            Case #World_Column_Format_ZLib
              ; #### Raw --> ZLib
              World_Column_Compress(*World_Column\Blockdata[i], *World_Column\Blockdata_Size[i], *World_Column\Blockdata[i], *World_Column\Blockdata_Size[i])
              World_Column_Compress(*World_Column\Metadata[i], *World_Column\Metadata_Size[i], *World_Column\Metadata[i], *World_Column\Metadata_Size[i])
              World_Column_Compress(*World_Column\Lightdata[i], *World_Column\Lightdata_Size[i], *World_Column\Lightdata[i], *World_Column\Lightdata_Size[i])
              World_Column_Compress(*World_Column\Playerdata[i], *World_Column\Playerdata_Size[i], *World_Column\Playerdata[i], *World_Column\Playerdata_Size[i])
              
              *World_Column\Format[i] = Format
              *World_Column\Format_Change_Date[i] = Date() + #World_Column_Format_ZLib_2_HDD_Time
              
            Case #World_Column_Format_HDD
              ; #### Raw --> HDD
              If Chunks = $FFFF
                
                If Not World_Column_File_Write(*World, *World_Column)
                  ProcedureReturn #Result_Fail
                EndIf
                
                For i = 0 To #World_Column_Chunks-1
                  FreeMemory(*World_Column\Blockdata[i]) : *World_Column\Blockdata[i] = 0 : *World_Column\Blockdata_Size[i] = 0
                  FreeMemory(*World_Column\Metadata[i]) : *World_Column\Metadata[i] = 0 : *World_Column\Metadata_Size[i] = 0
                  FreeMemory(*World_Column\Lightdata[i]) : *World_Column\Lightdata[i] = 0 : *World_Column\Lightdata_Size[i] = 0
                  FreeMemory(*World_Column\Playerdata[i]) : *World_Column\Playerdata[i] = 0 : *World_Column\Playerdata_Size[i] = 0
                  
                  *World_Column\Format[i] = Format
                  *World_Column\Format_Change_Date[i] = 0
                  *World_Column\HDD_Save_Date = 0
                Next
              Else
                ProcedureReturn #Result_Fail
              EndIf
              ProcedureReturn #Result_Success ; #### To avoid looping, one call is enough
              
          EndSelect
          
        Case #World_Column_Format_ZLib
          Select Format
            Case #World_Column_Format_Raw
              ; #### ZLib --> Raw
              World_Column_Uncompress(*World_Column\Blockdata[i], *World_Column\Blockdata_Size[i], *World_Column\Blockdata[i], *World_Column\Blockdata_Size[i], #World_Chunk_Blockdata_Size)
              World_Column_Uncompress(*World_Column\Metadata[i], *World_Column\Metadata_Size[i], *World_Column\Metadata[i], *World_Column\Metadata_Size[i], #World_Chunk_Metadata_Size)
              World_Column_Uncompress(*World_Column\Lightdata[i], *World_Column\Lightdata_Size[i], *World_Column\Lightdata[i], *World_Column\Lightdata_Size[i], #World_Chunk_Lightdata_Size)
              World_Column_Uncompress(*World_Column\Playerdata[i], *World_Column\Playerdata_Size[i], *World_Column\Playerdata[i], *World_Column\Playerdata_Size[i], #World_Chunk_Playerdata_Size)
              
              *World_Column\Format[i] = Format
              *World_Column\Format_Change_Date[i] = Date() + #World_Column_Format_Raw_2_ZLib_Time
              
            Case #World_Column_Format_ZLib
              ; #### ZLib --> ZLib
              *World_Column\Format_Change_Date[i] = Date() + #World_Column_Format_ZLib_2_HDD_Time
              
            Case #World_Column_Format_HDD
              ; #### ZLib --> HDD
              If Chunks = $FFFF
                
                If Not World_Column_File_Write(*World, *World_Column)
                  ProcedureReturn #Result_Fail
                EndIf
                
                For i = 0 To #World_Column_Chunks-1
                  FreeMemory(*World_Column\Blockdata[i]) : *World_Column\Blockdata[i] = 0 : *World_Column\Blockdata_Size[i] = 0
                  FreeMemory(*World_Column\Metadata[i]) : *World_Column\Metadata[i] = 0 : *World_Column\Metadata_Size[i] = 0
                  FreeMemory(*World_Column\Lightdata[i]) : *World_Column\Lightdata[i] = 0 : *World_Column\Lightdata_Size[i] = 0
                  FreeMemory(*World_Column\Playerdata[i]) : *World_Column\Playerdata[i] = 0 : *World_Column\Playerdata_Size[i] = 0
                  
                  *World_Column\Format[i] = Format
                  *World_Column\Format_Change_Date[i] = 0
                  *World_Column\HDD_Save_Date = 0
                Next
              Else
                ProcedureReturn #Result_Fail
              EndIf
              ProcedureReturn #Result_Success ; #### To avoid looping, one call is enough
              
          EndSelect
          
        Case #World_Column_Format_HDD
          Select Format
            Case #World_Column_Format_Raw
              ; #### HDD --> Raw
              If Not World_Column_File_Read(*World, *World_Column)
                ProcedureReturn #Result_Fail
              EndIf
              ProcedureReturn #Result_Success ; #### To avoid looping, one call is enough
              
            Case #World_Column_Format_ZLib
              ; #### HDD --> ZLib
              If Not World_Column_File_Read(*World, *World_Column)
                ProcedureReturn #Result_Fail
              EndIf
              
              For i = 0 To #World_Column_Chunks-1
                If Chunks & (1<<i)
                  World_Column_Compress(*World_Column\Blockdata[i], *World_Column\Blockdata_Size[i], *World_Column\Blockdata[i], *World_Column\Blockdata_Size[i])
                  World_Column_Compress(*World_Column\Metadata[i], *World_Column\Metadata_Size[i], *World_Column\Metadata[i], *World_Column\Metadata_Size[i])
                  World_Column_Compress(*World_Column\Lightdata[i], *World_Column\Lightdata_Size[i], *World_Column\Lightdata[i], *World_Column\Lightdata_Size[i])
                  World_Column_Compress(*World_Column\Playerdata[i], *World_Column\Playerdata_Size[i], *World_Column\Playerdata[i], *World_Column\Playerdata_Size[i])
                  
                  *World_Column\Format[i] = Format
                  *World_Column\Format_Change_Date[i] = Date() + #World_Column_Format_ZLib_2_HDD_Time
                EndIf
              Next
              ProcedureReturn #Result_Success ; #### To avoid looping, one call is enough
              
            Case #World_Column_Format_HDD
              ; #### HDD --> HDD
              *World_Column\Format_Change_Date[i] = 0
              *World_Column\HDD_Save_Date = 0
              
          EndSelect
      EndSelect
    EndIf
  Next
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Column_Compress_For_Sending(*World.World, *World_Column.World_Column)
  Protected *Temp, Temp_Size, *Result, *Raw_Temp, Raw_Temp_Size, Raw_Temp_Pos, i, j
  Protected Chunk_Sendmask
  
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column
    ; Add Error-Handler here
    Log_Add_Error("*World_Column")
    ProcedureReturn #Result_Fail
  EndIf
  
  *World_Column\Send_Buffer_Time = Date() + #World_Column_Send_Buffer_Time
  
  If *World_Column\Send_Buffer And *World_Column\Send_Buffer_Size
    ProcedureReturn #Result_Success
  EndIf
  
  Chunk_Sendmask = 0
  For i = 0 To #World_Column_Chunks-1
    If *World_Column\Empty[i] = #False Or *World_Column\Format[i] = #World_Column_Format_HDD
      Chunk_Sendmask | 1<<i
    EndIf
  Next
  
  If Not World_Column_Change_Format(*World, *World_Column, Chunk_Sendmask, #World_Column_Format_Raw)
    ; Add Error-Handler here
    Log_Add_Error("World_Column_Change_Format")
    ProcedureReturn #Result_Fail
  EndIf
  
  Raw_Temp_Size = 0
  For i = 0 To #World_Column_Chunks-1
    If *World_Column\Empty[i] = #False
      Raw_Temp_Size + *World_Column\Blockdata_Size[i] + *World_Column\Metadata_Size[i] + *World_Column\Lightdata_Size[i]
    EndIf
  Next
  Raw_Temp_Size + 256 ; Size of Biome-Data-Array
  *Raw_Temp = AllocateMemory(Raw_Temp_Size)
  If *Raw_Temp
    For i = 0 To #World_Column_Chunks-1
      If *World_Column\Empty[i] = #False
        CopyMemory(*World_Column\Blockdata[i], *Raw_Temp+Raw_Temp_Pos, #World_Chunk_Blockdata_Size)
        ; #### Replace with "On_Client"
        For j = 0 To #World_Chunk_Blockdata_Size-1
          PokeA(*Raw_Temp+Raw_Temp_Pos+j, Block(PeekA(*Raw_Temp+Raw_Temp_Pos+j))\On_Client)
        Next
        Raw_Temp_Pos + #World_Chunk_Blockdata_Size
      EndIf
    Next
    For i = 0 To #World_Column_Chunks-1
      If *World_Column\Empty[i] = #False
        CopyMemory(*World_Column\Metadata[i], *Raw_Temp+Raw_Temp_Pos, #World_Chunk_Metadata_Size)
        Raw_Temp_Pos + #World_Chunk_Metadata_Size
      EndIf
    Next
    For i = 0 To #World_Column_Chunks-1
      If *World_Column\Empty[i] = #False
        CopyMemory(*World_Column\Lightdata[i], *Raw_Temp+Raw_Temp_Pos, #World_Chunk_Lightdata_Size/2)
        Raw_Temp_Pos + #World_Chunk_Lightdata_Size/2
      EndIf
    Next
    For i = 0 To #World_Column_Chunks-1
      If *World_Column\Empty[i] = #False
        CopyMemory(*World_Column\Lightdata[i]+#World_Chunk_Lightdata_Size/2, *Raw_Temp+Raw_Temp_Pos, #World_Chunk_Lightdata_Size/2)
        Raw_Temp_Pos + #World_Chunk_Lightdata_Size/2
      EndIf
    Next
    
    World_Column_Compress(*Raw_Temp, Raw_Temp_Size, *World_Column\Send_Buffer, *World_Column\Send_Buffer_Size)
    
    FreeMemory(*Raw_Temp)
    ProcedureReturn #Result_Success
  Else
    ; Add Error-Handler here
    Log_Add_Error("AllocateMemory")
    ProcedureReturn #Result_Fail
  EndIf
  
  ; Add Error-Handler here
  Log_Add_Error("Result_Fail")
  ProcedureReturn #Result_Fail
EndProcedure

Procedure World_Column_Block_Set(*World.World, *World_Column.World_Column, X, Y, Z, Type=-1, Metadata=-1, BlockLight=-1, SkyLight=-1, Playerdata=-1, Send=1, Light=1, Physic=1, Current_Trigger_Time=0)
  Protected *Pointer.Ascii, Offset
  Protected ix, iy, iz
  Protected GX, GY, GZ
  Protected Chunk, Chunk_X, Chunk_Y, Chunk_Z
  Protected Do_Send, Do_Physic, Do_Light, Delete_Sendbuffer
  Protected Old_Type, Old_Metadata
  Protected *Temp_World_Column.World_Column
  
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column
    ; Add Error-Handler here
    Log_Add_Error("*World_Column")
    ProcedureReturn #Result_Fail
  EndIf
  
  If X < 0 Or X >= #World_Column_Size_X Or Y < 0 Or Y >= #World_Column_Size_Y Or Z < 0 Or Z >= #World_Column_Size_Z
    ; Add Error-Handler here
    ;Log_Add_Error("Coordinate outside of the Column") ; Causes console spam if everything goes wrong ;)
    ProcedureReturn #Result_Fail
  EndIf
  
  Chunk = Z / #World_Chunk_Size_Z
  Chunk_X = X
  Chunk_Y = Y
  Chunk_Z = Z - Chunk*#World_Chunk_Size_Z
  
  If Chunk < 0 Or Chunk >= #World_Column_Chunks
    ; Add Error-Handler here
    Log_Add_Error("Chunk index invalid")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not World_Column_Change_Format(*World, *World_Column, 1<<Chunk, #World_Column_Format_Raw)
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Offset = World_Chunk_Get_Offset(Chunk_X, Chunk_Y, Chunk_Z)
  
  If Offset < 0 Or Offset >= #World_Chunk_Blockdata_Size
    ; Add Error-Handler here
    Log_Add_Error("Offset outside of the Chunk")
    ProcedureReturn #Result_Fail
  EndIf
  
  ; #### Change: Type
  If Type >= 0 And Type <= 255
    *Pointer = *World_Column\Blockdata[Chunk] + Offset
    Old_Type = *Pointer\a
    
    ; #### Change data
    If Old_Type <> Type
      *Pointer\a = Type
      Do_Send = 1
      Do_Light = 1
      Do_Physic = 1
      Delete_Sendbuffer = 1
    EndIf
  ElseIf Metadata >= 0 And Metadata <= 15
    *Pointer = *World_Column\Blockdata[Chunk] + Offset
    Old_Type = *Pointer\a
  EndIf
  
  ; #### Change: Metadata
  If Metadata >= 0 And Metadata <= 15
    *Pointer = *World_Column\Metadata[Chunk] + Offset/2
    If Offset & 1
      Old_Metadata = *Pointer\a >> 4
      If Old_Metadata <> Metadata
        *Pointer\a & $0F
        *Pointer\a | Metadata << 4
        Do_Send = 1
        Do_Physic = 1
        Delete_Sendbuffer = 1
      EndIf
    Else
      Old_Metadata = *Pointer\a & $0F
      If Old_Metadata <> Metadata
        *Pointer\a & $F0
        *Pointer\a | Metadata
        Do_Send = 1
        Do_Physic = 1
        Delete_Sendbuffer = 1
      EndIf
    EndIf
  ElseIf Type >= 0 And Type <= 255
    *Pointer = *World_Column\Metadata[Chunk] + Offset/2
    If Offset & 1
      Old_Metadata = *Pointer\a >> 4
    Else
      Old_Metadata = *Pointer\a & $0F
    EndIf
  EndIf
  
  ; #### Change: BlockLight
  If BlockLight >= 0 And BlockLight <= 15
    *Pointer = *World_Column\Lightdata[Chunk] + Offset/2
    If Offset & 1
      If *Pointer\a >> 4 <> BlockLight
        *Pointer\a & $0F
        *Pointer\a | BlockLight << 4
        Delete_Sendbuffer = 1
      EndIf
    Else
      If *Pointer\a & $0F <> BlockLight
        *Pointer\a & $F0
        *Pointer\a | BlockLight
        Delete_Sendbuffer = 1
      EndIf
    EndIf
  EndIf
  
  ; #### Change: SkyLight
  If SkyLight >= 0 And SkyLight <= 15
    *Pointer = *World_Column\Lightdata[Chunk] + (Offset + *World_Column\Lightdata_Size[Chunk])/2
    If Offset & 1
      If *Pointer\a >> 4 <> SkyLight
        *Pointer\a & $0F
        *Pointer\a | SkyLight << 4
        Delete_Sendbuffer = 1
      EndIf
    Else
      If *Pointer\a & $0F <> SkyLight
        *Pointer\a & $F0
        *Pointer\a | SkyLight
        Delete_Sendbuffer = 1
      EndIf
    EndIf
  EndIf
  
  ; #### Change: Playerdata
  If Playerdata >= 0 And Playerdata <= 255
    *Pointer = *World_Column\Playerdata[Chunk] + Offset
    *Pointer\a = Playerdata
  EndIf
  
  ; #### Get global coordinates
  GX = *World_Column\X*#World_Column_Size_X+X
  GY = *World_Column\Y*#World_Column_Size_Y+Y
  GZ = Z
  
  ; #### Delete Sendbuffer
  If Delete_Sendbuffer And *World_Column\Send_Buffer
    FreeMemory(*World_Column\Send_Buffer)
    *World_Column\Send_Buffer = 0
    *World_Column\Send_Buffer_Size = 0
  EndIf
  
  ; #### Chunk isn't empty anymore
  If Delete_Sendbuffer
    *World_Column\Empty[Chunk] = #False
  EndIf
  
  ; #### Activate HDD-Saving
  If Delete_Sendbuffer And *World_Column\HDD_Save_Date = 0
    *World_Column\HDD_Save_Date = Date() + #World_Column_HDD_Save_Time
  EndIf
  
  ; #### Send Blockchange
  If Send And Do_Send
    If Send = 1
      World_Send_Queue_Add(*World, GX, GY, GZ, *World_Column, Old_Type, Old_Metadata, #False)
    Else
      World_Send_Queue_Add(*World, GX, GY, GZ, *World_Column, Old_Type, Old_Metadata, #True)
    EndIf
  EndIf
  
  ; #### Lighting
  If Light And Do_Light
    World_Light_Queue_Add(*World, GX, GY, GZ, *World_Column)
  EndIf
  
  ; #### Physics
  If Physic And Do_Physic
    If Not Current_Trigger_Time
      Current_Trigger_Time = Timer_Milliseconds()
    EndIf
    For ix = -1 To 1
      For iy = -1 To 1
        *Temp_World_Column = World_Column_Get(*World, World_Get_Column_X(GX+ix), World_Get_Column_Y(GY+iy))
        For iz = -1 To 1
          If ix <> 0 Or iy <> 0 Or iz <> 0
            World_Physic_Queue_Add(*World, GX+ix, GY+iy, GZ+iz, *Temp_World_Column, Current_Trigger_Time, 20)
          Else
            World_Physic_Queue_Add(*World, GX+ix, GY+iy, GZ+iz, *Temp_World_Column, Current_Trigger_Time, 10)
          EndIf
        Next
      Next
    Next
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure World_Column_Block_Get(*World.World, *World_Column.World_Column, X, Y, Z, *Type.Ascii=0, *Metadata.Ascii=0, *BlockLight.Ascii=0, *SkyLight.Ascii=0, *Playerdata.Ascii=0)
  Protected *Pointer.Ascii, Offset
  Protected Chunk, Chunk_X, Chunk_Y, Chunk_Z
  
  If Not *World
    ; Add Error-Handler here
    Log_Add_Error("*World")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not *World_Column
    ; Add Error-Handler here
    Log_Add_Error("*World_Column")
    ProcedureReturn #Result_Fail
  EndIf
  
  If X < 0 Or X >= #World_Column_Size_X Or Y < 0 Or Y >= #World_Column_Size_Y Or Z < 0 Or Z >= #World_Column_Size_Z
    ; Add Error-Handler here
    ;Log_Add_Error("Coordinate outside of the Column") ; Causes console spam if everything goes wrong ;)
    ProcedureReturn #Result_Fail
  EndIf
  
  Chunk = Z / #World_Chunk_Size_Z
  Chunk_X = X
  Chunk_Y = Y
  Chunk_Z = Z - Chunk*#World_Chunk_Size_Z
  
  If Chunk < 0 Or Chunk >= #World_Column_Chunks
    ; Add Error-Handler here
    Log_Add_Error("Chunk index invalid")
    ProcedureReturn #Result_Fail
  EndIf
  
  If Not World_Column_Change_Format(*World, *World_Column, 1<<Chunk, #World_Column_Format_Raw)
    ; Add Error-Handler here
    ProcedureReturn #Result_Fail
  EndIf
  
  Offset = World_Chunk_Get_Offset(Chunk_X, Chunk_Y, Chunk_Z)
  
  If Offset < 0 Or Offset >= #World_Chunk_Blockdata_Size
    ; Add Error-Handler here
    Log_Add_Error("Offset outside of the Chunk")
    ProcedureReturn #Result_Fail
  EndIf
  
  ; #### Read: Type
  If *Type
    *Pointer = *World_Column\Blockdata[Chunk] + Offset
    *Type\a = *Pointer\a
  EndIf
  
  ; #### Read: Metadata
  If *Metadata
    *Pointer = *World_Column\Metadata[Chunk] + Offset/2
    If Offset & 1
      *Metadata\a = *Pointer\a >> 4
    Else
      *Metadata\a = *Pointer\a & $0F
    EndIf
  EndIf
  
  ; #### Read: BlockLight
  If *BlockLight
    *Pointer = *World_Column\Lightdata[Chunk] + Offset/2
    If Offset & 1
      *BlockLight\a = *Pointer\a >> 4
    Else
      *BlockLight\a = *Pointer\a & $0F
    EndIf
  EndIf
  
  ; #### Read: SkyLight
  If *SkyLight
    *Pointer = *World_Column\Lightdata[Chunk] + (Offset + *World_Column\Lightdata_Size[Chunk])/2
    If Offset & 1
      *SkyLight\a = *Pointer\a >> 4
    Else
      *SkyLight\a = *Pointer\a & $0F
    EndIf
  EndIf
  
  ; #### Read: Playerdata
  If *Playerdata
    *Pointer = *World_Column\Playerdata[Chunk] + Offset
    *Playerdata\a = *Pointer\a
  EndIf
  
  ProcedureReturn #Result_Success
EndProcedure

; #################################################### Initstuff #################################################

; #################################################### Datasections ##############################################
; IDE Options = PureBasic 5.21 LTS Beta 1 (Windows - x64)
; CursorPosition = 411
; FirstLine = 402
; Folding = ---
; EnableXP
; DisableDebugger