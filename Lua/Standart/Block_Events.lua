function Block_Rightclick_Noteblock(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	
	Metadata = Cursor_X
	
	--Message_Send_2_All("§cNoteblock clicked at: X="..tostring(Cursor_X).." Y="..tostring(Cursor_Y).." Z="..tostring(Cursor_Z).." Metadata="..tostring(Metadata))
	--World_Effect_Explosion(World_ID, X, Y, Z, 1)
	--World_Effect_Sound_Or_Particle(World_ID, 1007, X, Y, Z, 2)
	World_Effect_Sound(World_ID, "note.pling", X+0.5, Y+0.5, Z+0.5, 1, 31/63+(2^(Metadata/12)-1)/2)--(0+Metadata)/16)
	--World_Effect_Sound_Or_Particle(World_ID, 1005, X, Y, Z, 2256+Metadata)--(0+Metadata)/16)
	--World_Block_Set(World_ID, X, Y, Z, Type, Metadata, -1, -1, -1, 2, 1, 1)
	World_Effect_Action(World_ID, X, Y, Z, 0, Metadata, Type)
end

function Block_Rightclick_Door(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local Result, Temp_Type = World_Block_Get(World_ID, X, Y, Z-1)
	if Result == 1 and Temp_Type == Type then
		Z = Z - 1
		Result, Type, Metadata = World_Block_Get(World_ID, X, Y, Z)
	end
	
	if Metadata >= 4 then
		Metadata = Metadata - 4
	else
		Metadata = Metadata + 4
	end
	
	World_Effect_Sound_Or_Particle(World_ID, 1010, X, Y, Z, 0)
	
	World_Block_Set(World_ID, X, Y, Z, Type, Metadata, -1, -1, -1, 2, 1, 1)
	--Message_Send_2_All("§cMetadata="..tostring(Metadata))
end

function Block_Leftclick_Door(Network_Client_ID, World_ID, X, Y, Z, Face, State, Type, Metadata)
	local Result, Temp_Type = World_Block_Get(World_ID, X, Y, Z+1)
	if Result == 1 and Temp_Type == Type then
		World_Block_Set(World_ID, X, Y, Z+1, 0, 0, -1, -1, -1, 2, 1, 1)
	end
	local Result, Temp_Type = World_Block_Get(World_ID, X, Y, Z-1)
	if Result == 1 and Temp_Type == Type then
		World_Block_Set(World_ID, X, Y, Z-1, 0, 0, -1, -1, -1, 2, 1, 1)
	end
	
	World_Block_Set(World_ID, X, Y, Z, 0, 0, -1, -1, -1, 2, 1, 1)
end

function Block_Rightclick_Redstone_Repeater(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local Delay = bit32.extract(Metadata, 2, 2)
	
	Delay = Delay + 1
	if Delay == 4 then
		Delay = 0
		World_Effect_Sound_Or_Particle(World_ID, 1000, X, Y, Z, 0)
	else
		World_Effect_Sound_Or_Particle(World_ID, 1001, X, Y, Z, 0)
	end
	
	Metadata = bit32.replace(Metadata, Delay, 2, 2)
	
	World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 2, 1, 0)
	--Message_Send_2_All("§cDebug: Delay:"..tostring(Delay))
end

function Block_Rightclick_Redstone_Lever(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local State = bit32.extract(Metadata, 3, 1)
	
	if State == 1 then
		Metadata = bit32.replace(Metadata, 0, 3, 1)
		World_Effect_Sound_Or_Particle(World_ID, 1000, X, Y, Z, 0)
	else
		Metadata = bit32.replace(Metadata, 1, 3, 1)
		World_Effect_Sound_Or_Particle(World_ID, 1001, X, Y, Z, 0)
	end
	
	World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 2, 1, 1)
	--Message_Send_2_All("§cDebug: State:"..tostring(State))
	Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, -1, 1, 1, 0)
end

function Block_Rightclick_Redstone_Button(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local State = bit32.extract(Metadata, 3, 1)
	
	if State == 1 then
		Metadata = bit32.replace(Metadata, 0, 3, 1)
		World_Effect_Sound_Or_Particle(World_ID, 1000, X, Y, Z, 0)
	else
		Metadata = bit32.replace(Metadata, 1, 3, 1)
		World_Effect_Sound_Or_Particle(World_ID, 1001, X, Y, Z, 0)
	end
	
	World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 2, 1, 1)
	--Message_Send_2_All("§cDebug: State:"..tostring(State))
	Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, -1, 1, 1, 0)
end

function Block_Rightclick_TNT(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local Entity_Type = 20 -- TNT
	
	Entity_Add(World_ID, X+0.5, Y+0.5, Z+0.5, Entity_Type, "")
	--Message_Send_2_All("§cDebug: Spawn-Egg: "..tostring(Type))
	World_Block_Set(World_ID, X, Y, Z, 0, 0, -1, -1, -1, 2, 1, 1)
end