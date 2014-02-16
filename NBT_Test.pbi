EnableExplicit

; #################################################### Documentation #############################################

; #################################################### Initstuff #################################################

; #################################################### Includes ##################################################

XIncludeFile "Includes/NBT.pbi"

; #################################################### Constants #################################################

; #################################################### Structures ################################################

; #################################################### Variables #################################################

; #################################################### Declares ##################################################

; #################################################### Macros ####################################################

; #################################################### Procedures ################################################

; #################################################### Initstuff #################################################

OpenConsole()

Global *Temp.NBT_Element

*Temp.NBT_Element = NBT_Read_File("C:\Users\David Vogel\Desktop\Dropbox\Purebasic\Minecraft\SMP-Server\Documentation\NBT\level.dat")
;*Temp.NBT_Element = NBT_Read_File("C:\Users\David Vogel\Desktop\Dropbox\Purebasic\Minecraft\SMP-Server\Documentation\NBT\bigtest.nbt")
;*Temp.NBT_Element = NBT_Read_File("C:\Users\David Vogel\Desktop\Dropbox\Purebasic\Minecraft\SMP-Server\Documentation\NBT\Dadido3.dat")
;*Temp.NBT_Element = NBT_Read_File("C:\Users\David Vogel\Desktop\Dropbox\Purebasic\Minecraft\SMP-Server\Documentation\NBT\NBT_Stuff.txt")

PrintN("Debug: "+NBT_Error_Get())

SetClipboardText(NBT_Tag_Serialize(*Temp\NBT_Tag))

Global Temp_Memory_Size, *Temp_Memory, *Temp_2.NBT_Element, String.s

Temp_Memory_Size = NBT_Get_Ram_Size(*Temp)
*Temp_Memory = AllocateMemory(Temp_Memory_Size)

PrintN("Debug: "+NBT_Error_Get())

Temp_Memory_Size = NBT_Write_Ram(*Temp, *Temp_Memory, Temp_Memory_Size, #True)

PrintN("Debug: "+NBT_Error_Get())

*Temp_2.NBT_Element = NBT_Read_Ram(*Temp_Memory, Temp_Memory_Size)

PrintN("Debug: "+NBT_Error_Get())

NBT_Write_File(*Temp_2, "C:\Users\David Vogel\Desktop\Dropbox\Purebasic\Minecraft\SMP-Server\Documentation\NBT\output.nbt")

PrintN("Debug: "+NBT_Error_Get())
PrintN("")

PrintN("Serialised:")
PrintN(NBT_Tag_Serialize(*Temp_2\NBT_Tag))

PrintN("")
PrintN("Debug: "+NBT_Error_Get())
PrintN("")

PrintN("Reading-Test: "+NBT_Tag_Get_String(NBT_Tag(NBT_Tag(NBT_Tag(*Temp_2\NBT_Tag, "nested compound test"), "egg"), "name")))
PrintN("Debug: "+NBT_Error_Get())
PrintN("")
PrintN("Reading-Test: "+StrF(NBT_Tag_Get_Float(NBT_Tag(NBT_Tag(NBT_Tag(*Temp_2\NBT_Tag, "nested compound test"), "egg"), "value"))))
PrintN("Debug: "+NBT_Error_Get())
PrintN("")
PrintN("Reading-Test: "+StrF(NBT_Tag_Get_Float(NBT_Tag(NBT_Tag(NBT_Tag(*Temp_2\NBT_Tag, "nested compound test"), "egg"), "shouldgiveanarror"))))
PrintN("Debug: "+NBT_Error_Get())
PrintN("")
NBT_Tag_Add(NBT_Tag(NBT_Tag(NBT_Tag(*Temp_2\NBT_Tag, "nested compound test"), "egg"), "name"), "Test", #NBT_Tag_String)
NBT_Tag_Set_String(NBT_Tag(NBT_Tag(NBT_Tag(*Temp_2\NBT_Tag, "nested compound test"), "egg"), "Test"), "Blörp")
PrintN("Debug: "+NBT_Error_Get())
PrintN("")
NBT_Tag_Add(NBT_Tag(NBT_Tag(*Temp_2\NBT_Tag, "nested compound test"), "egg"), "Test", #NBT_Tag_String)
NBT_Tag_Set_String(NBT_Tag(NBT_Tag(NBT_Tag(*Temp_2\NBT_Tag, "nested compound test"), "egg"), "Test"), "Blörp")
PrintN("Debug: "+NBT_Error_Get())
PrintN("")
PrintN("Reading-Test: "+NBT_Tag_Get_String(NBT_Tag(NBT_Tag(NBT_Tag(*Temp_2\NBT_Tag, "nested compound test"), "egg"), "Test")))
PrintN("Debug: "+NBT_Error_Get())
PrintN("")
PrintN("Reading-Test: "+NBT_Tag_Get_Name(*Temp_2\NBT_Tag))
PrintN("Debug: "+NBT_Error_Get())
PrintN("")
PrintN("Reading-Test: "+Str(NBT_Tag_Count(*Temp_2\NBT_Tag)))
PrintN("Debug: "+NBT_Error_Get())
PrintN("")
PrintN("Serialised:")
PrintN(NBT_Tag_Serialize(*Temp_2\NBT_Tag))
PrintN("Debug: "+NBT_Error_Get())
PrintN("")
PrintN("#############################################")
PrintN("")

Global i, j
Global *NBT_Test.NBT_Element = NBT_Element_Add()
NBT_Tag_Set_Name(*NBT_Test\NBT_Tag, "Rooty!")
NBT_Tag_Add(*NBT_Test\NBT_Tag, "Compound thingy", #NBT_Tag_Compound)
For i = 0 To 200
  NBT_Tag_Add(NBT_Tag(*NBT_Test\NBT_Tag, "Compound thingy"), "Item"+Str(i), 1+Random(10))
Next
NBT_Tag_Add(*NBT_Test\NBT_Tag, "listy! äaewüpl12µq´lö´p´246ßóÒ", #NBT_Tag_List, #NBT_Tag_Compound)
For i = 0 To 200
  NBT_Tag_Add(NBT_Tag(*NBT_Test\NBT_Tag, "listy! äaewüpl12µq´lö´p´246ßóÒ"), "", #NBT_Tag_Compound)
  For j = 0 To 10
    NBT_Tag_Add(NBT_Tag_Index(NBT_Tag(*NBT_Test\NBT_Tag, "listy! äaewüpl12µq´lö´p´246ßóÒ"), i), "hurz"+Str(j), 1+Random(10))
  Next
Next
PrintN("Debug: "+NBT_Error_Get())
;PrintN("Serialised:")
;PrintN(NBT_Tag_Serialize(*NBT_Test\NBT_Tag))
;SetClipboardText(NBT_Tag_Serialize(*NBT_Test\NBT_Tag))
PrintN("Debug: "+NBT_Error_Get())

PrintN("Saving: "+Str(NBT_Write_File(*NBT_Test, "C:\Users\David Vogel\Desktop\Dropbox\Purebasic\Minecraft\SMP-Server\Documentation\NBT\output.nbt")))

Global *NBT_Test_2.NBT_Element = NBT_Read_File("C:\Users\David Vogel\Desktop\Dropbox\Purebasic\Minecraft\SMP-Server\Documentation\NBT\output.nbt")
PrintN("Serialised: In Clipboard!")
;PrintN(NBT_Tag_Serialize(*NBT_Test\NBT_Tag))
PrintN("Debug: "+NBT_Error_Get())
If *NBT_Test_2
  ;SetClipboardText(NBT_Tag_Serialize(*NBT_Test_2\NBT_Tag))
EndIf


; #################################################### Datasections ##############################################

Input()

;Repeat
;  Delay(100)
;ForEver
; IDE Options = PureBasic 4.60 Beta 4 (Windows - x64)
; CursorPosition = 34
; EnableUnicode
; EnableXP
; Executable = Test.exe
; Compiler = PureBasic 4.60 Beta 4 (Windows - x86)