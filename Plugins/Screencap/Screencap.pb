; ################################################### Documentation #########################################
; 
; Todo:
;  - 
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
; ################################################### Includes ##############################################

IncludePath "../../"
XIncludeFile "Plugins/SDK/Include.pbi"

; ################################################### Inits #################################################

; ################################################### Konstants #############################################

#Plugin_Name = "Screencap"
#Plugin_Author = "David Vogel"

Global ScreenCap_Map_ID = 1
Global ScreenCap_Offset_X = 0   ; Offset der Eingabe
Global ScreenCap_Offset_Y = 0   ; Offset der Eingabe
Global ScreenCap_Scale = 1      ; Skalierung der Eingabe
Global ScreenCap_Size_X = 50    ; Ausgabegröße (Eingabegroße = Size_X * Scale)
Global ScreenCap_Size_Y = 50    ; Ausgabegröße (Eingabegroße = Size_Y * Scale)
Global ScreenCap_Time = 500

; ################################################### Structures ############################################

Structure Plugin_Main
  
EndStructure

Structure RGB_2_Type_Element
  R.a
  G.a
  B.a
  Type.a
  Meta.a
EndStructure
Global NewList RGB_2_Type_Element.RGB_2_Type_Element()

Global Dim RGB_2_Type.u(255,255,255)

Global Dim Pow_2(512)

; ################################################### Declares ##############################################

; ################################################### Prototypes ############################################

; ################################################### Procedures ############################################

Procedure Pow_2_Create()
  For i = 0 To 255
    Pow_2(255+i) = Pow(i, 2)
    Pow_2(255-i) = Pow(i, 2)
  Next
EndProcedure

Procedure RGB_2_Type_Add(Type.a, Meta.a, R.a, G.a, B.a)
  AddElement(RGB_2_Type_Element())
  RGB_2_Type_Element()\R = R
  RGB_2_Type_Element()\G = G
  RGB_2_Type_Element()\B = B
  RGB_2_Type_Element()\Type = Type
  RGB_2_Type_Element()\Meta = Meta
EndProcedure

Procedure RGB_2_Type_Generate()
  PrintN(LSet("",32, "#"))
  For R.a = 0 To 255
    If R & 7 = 0
      Print("#")
    EndIf
    For G.a = 0 To 255
      For B.a = 0 To 255
        Max_Dist = 200000
        ForEach RGB_2_Type_Element()
          Dist = Pow_2(255+R-RGB_2_Type_Element()\R)+Pow_2(255+G-RGB_2_Type_Element()\G)+Pow_2(255+B-RGB_2_Type_Element()\B)
          If Max_Dist > Dist
            Max_Dist = Dist
            RGB_2_Type(R,G,B) = RGB_2_Type_Element()\Type + RGB_2_Type_Element()\Meta << 8
          EndIf
        Next
      Next
    Next
  Next
  PrintN("")
EndProcedure

ProcedureCDLL Init(*Plugin_Info.Plugin_Info, *Plugin_Function.Plugin_Function) ; Aufgerufen beim Laden der Library / Called with the loading of the library
  *Plugin_Info\Name = #Plugin_Name
  *Plugin_Info\Version = #Plugin_Version
  *Plugin_Info\Author = #Plugin_Author
  
  Define_Prototypes(*Plugin_Function)
  
  ; #############
  
  OpenConsole()
  
  Pow_2_Create()
  
  RGB_2_Type_Add(1 , 0, 125,125,125)    ; Stone
  RGB_2_Type_Add(3 , 0, 134,096,067)    ; Dirt
  RGB_2_Type_Add(4 , 0, 117,117,117)    ; Cobble
  RGB_2_Type_Add(5 , 0, 157,128,079)    ; Wood
  RGB_2_Type_Add(7 , 0, 084,084,084)    ; Solid
  RGB_2_Type_Add(12, 0, 218,210,158)    ; Sand
  RGB_2_Type_Add(13, 0, 136,126,126)    ; Gravel
  RGB_2_Type_Add(14, 0, 143,140,125)    ; Gold ore
  RGB_2_Type_Add(15, 0, 136,130,127)    ; Iron ore
  RGB_2_Type_Add(16, 0, 115,115,115)    ; Coal ore
  RGB_2_Type_Add(17, 0, 155,125,077)    ; Log
  RGB_2_Type_Add(19, 0, 182,182,057)    ; Sponge
  RGB_2_Type_Add(22, 0, 029,071,166)    ; Lapis Lazuli Block
  RGB_2_Type_Add(24, 0, 218,210,159)    ; Sandstone
  ;RGB_2_Type_Add(25, 0, 101,068,051)    ; Noteblock
  
  RGB_2_Type_Add(35, 0, 222,222,222)    ; Wool White
  RGB_2_Type_Add(35, 1, 234,127,055)    ; Wool Orange
  RGB_2_Type_Add(35, 2, 191,075,201)    ; Wool Magenta
  RGB_2_Type_Add(35, 3, 104,139,212)    ; Wool Light Blue
  RGB_2_Type_Add(35, 4, 194,181,028)    ; Wool Yellow
  RGB_2_Type_Add(35, 5, 059,189,048)    ; Wool Light Green
  RGB_2_Type_Add(35, 6, 217,131,155)    ; Wool Pink
  RGB_2_Type_Add(35, 7, 066,066,066)    ; Wool Gray
  RGB_2_Type_Add(35, 8, 158,166,166)    ; Wool Light Gray
  RGB_2_Type_Add(35, 9, 039,117,149)    ; Wool Cyan
  RGB_2_Type_Add(35,10, 129,054,196)    ; Wool Purple
  RGB_2_Type_Add(35,11, 039,051,154)    ; Wool Blue
  RGB_2_Type_Add(35,12, 086,051,028)    ; Wool Brown
  RGB_2_Type_Add(35,13, 056,077,024)    ; Wool Dark Green
  RGB_2_Type_Add(35,14, 164,045,041)    ; Wool Red
  RGB_2_Type_Add(35,15, 027,023,023)    ; Wool Black
  
  RGB_2_Type_Add(41, 0, 249,236,078)    ; Gold Block
  RGB_2_Type_Add(42, 0, 230,230,230)    ; Iron Block
  RGB_2_Type_Add(45, 0, 156,110,097)    ; Brick
  ;RGB_2_Type_Add(46, 0, 170,077,051)    ; TNT
  RGB_2_Type_Add(48, 0, 091,108,091)    ; Mossy Cobble
  RGB_2_Type_Add(49, 0, 020,018,030)    ; Obsidian
  ;RGB_2_Type_Add(54, 0, 131,094,037)    ; Chest
  RGB_2_Type_Add(56, 0, 129,140,143)    ; Diamond ore
  RGB_2_Type_Add(57, 0, 100,219,214)    ; Diamond Block
  ;RGB_2_Type_Add(58, 0, 107,071,043)    ; Crafting Table
  RGB_2_Type_Add(60, 0, 115,076,045)    ; Farmland dry
  RGB_2_Type_Add(60, 1, 075,041,014)    ; Farmland wet
  RGB_2_Type_Add(61, 0, 096,096,096)    ; Furnace
  RGB_2_Type_Add(60, 0, 115,076,045)    ; Farmland dry
  RGB_2_Type_Add(73, 0, 133,107,107)    ; Redstone ore
  RGB_2_Type_Add(80, 0, 240,251,251)    ; Snow block
  RGB_2_Type_Add(82, 0, 159,164,177)    ; Clay
  RGB_2_Type_Add(86, 0, 193,118,021)    ; Pumpkin
  RGB_2_Type_Add(87, 0, 110,053,051)    ; Netherrack
  RGB_2_Type_Add(88, 0, 085,064,052)    ; Soul Sand
  RGB_2_Type_Add(89, 0, 137,113,065)    ; Glowstone
  RGB_2_Type_Add(80, 0, 240,251,251)    ; Snow block
  
  RGB_2_Type_Generate()
  
  ProcedureReturn #Result_Success
EndProcedure

ProcedureCDLL Deinit() ; Aufgerufen beim Entladen der Library / Called with the unloading of the library
  
  ProcedureReturn #Result_Success
EndProcedure

Procedure MakeDesktopScreenshot(ImageNr,x,y,Width,Height) 
   hImage = CreateImage(ImageNr,Width,Height) 
   hDC    = StartDrawing(ImageOutput(ImageNr)) 
   DeskDC = GetDC_(GetDesktopWindow_()) 
      BitBlt_(hDC,0,0,Width,Height,DeskDC,x,y,#SRCCOPY) 
   StopDrawing() 
   ReleaseDC_(GetDesktopWindow_(),DeskDC) 
   ProcedureReturn hImage 
EndProcedure

ProcedureCDLL Main()
  Static Timer
  
  If GetAsyncKeyState_(#VK_LCONTROL) & 1 And GetAsyncKeyState_(#VK_LSHIFT) & 1
    ScreenCap_Offset_X = DesktopMouseX()
    ScreenCap_Offset_Y = DesktopMouseY()
  EndIf
  
  If Timer < ElapsedMilliseconds()
    Timer = ElapsedMilliseconds() + ScreenCap_Time
    
    Start_Time = ElapsedMilliseconds()
    
    *Map_Data = World_Get_By_ID(ScreenCap_Map_ID)
    If *Map_Data
      MakeDesktopScreenshot(0, ScreenCap_Offset_X, ScreenCap_Offset_Y, ScreenCap_Size_X*ScreenCap_Scale, ScreenCap_Size_Y*ScreenCap_Scale) 
      If StartDrawing(ImageOutput(0))
        
        For ix = 0 To ScreenCap_Size_X/16
          For iy = 0 To ScreenCap_Size_Y/16
            For cix = 0 To 15
              X = ix*16 + cix
              For ciy = 0 To 15
                Y = iy*16 + ciy
                
                If X < ScreenCap_Size_X And Y < ScreenCap_Size_Y
                  
                  Color = Point(X*ScreenCap_Scale, Y*ScreenCap_Scale)
                  If Color <> Color_Old
                    Color_Old = Color
                    
                    R.a = Red(Color)
                    G.a = Green(Color)
                    B.a = Blue(Color)
                    Block.a = RGB_2_Type(R,G,B)
                    Meta.a = RGB_2_Type(R,G,B) >> 8
                  EndIf
                  
                  World_Block_Set(*Map_Data, -26+X, 399+Y, 63, Block, Meta, 0, 0, 0, 1, 0, 0)
                  
                EndIf
              Next
            Next
          Next
        Next
        
        StopDrawing()
      EndIf
      FreeImage(0)
    EndIf
    
    PrintN("Time "+StrF((ElapsedMilliseconds()-Start_Time)/1000, 3)+"s")
    
  EndIf
EndProcedure
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; ExecutableFormat = Shared Dll
; CursorPosition = 227
; FirstLine = 212
; Folding = --
; EnableUnicode
; EnableThread
; EnableXP
; EnableOnError
; Executable = Screencap.x64.dll
; DisableDebugger