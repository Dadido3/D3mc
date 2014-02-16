local Physic_Redstone_Piston_Pushable = {}

for i = 0, 255 do
	Physic_Redstone_Piston_Pushable[i] = 1
end

Physic_Redstone_Piston_Pushable[7] = 0
Physic_Redstone_Piston_Pushable[23] = 0
Physic_Redstone_Piston_Pushable[25] = 0
Physic_Redstone_Piston_Pushable[26] = 0
Physic_Redstone_Piston_Pushable[29] = 2
Physic_Redstone_Piston_Pushable[33] = 2
Physic_Redstone_Piston_Pushable[34] = 0
Physic_Redstone_Piston_Pushable[36] = 0
Physic_Redstone_Piston_Pushable[49] = 0
Physic_Redstone_Piston_Pushable[50] = 0
Physic_Redstone_Piston_Pushable[51] = 0
Physic_Redstone_Piston_Pushable[52] = 0
Physic_Redstone_Piston_Pushable[54] = 0
Physic_Redstone_Piston_Pushable[58] = 0
Physic_Redstone_Piston_Pushable[61] = 0
Physic_Redstone_Piston_Pushable[62] = 0
Physic_Redstone_Piston_Pushable[63] = 0
Physic_Redstone_Piston_Pushable[64] = 0
Physic_Redstone_Piston_Pushable[68] = 0
Physic_Redstone_Piston_Pushable[71] = 0
Physic_Redstone_Piston_Pushable[75] = 0
Physic_Redstone_Piston_Pushable[76] = 0
Physic_Redstone_Piston_Pushable[77] = 0
Physic_Redstone_Piston_Pushable[84] = 0
Physic_Redstone_Piston_Pushable[90] = 0
Physic_Redstone_Piston_Pushable[93] = 0
Physic_Redstone_Piston_Pushable[94] = 0
Physic_Redstone_Piston_Pushable[95] = 0
Physic_Redstone_Piston_Pushable[96] = 0
Physic_Redstone_Piston_Pushable[116] = 0
Physic_Redstone_Piston_Pushable[117] = 0
Physic_Redstone_Piston_Pushable[118] = 0
Physic_Redstone_Piston_Pushable[119] = 0
Physic_Redstone_Piston_Pushable[120] = 0
Physic_Redstone_Piston_Pushable[130] = 0
Physic_Redstone_Piston_Pushable[131] = 0
Physic_Redstone_Piston_Pushable[132] = 0

function Physic_Redstone_Piston_Check(World_ID, X, Y, Z, Direction, Counter)
	if Direction == 0 then
		Z = Z - 1
	elseif Direction == 1 then
		Z = Z + 1
	elseif Direction == 2 then
		Y = Y - 1
	elseif Direction == 3 then
		Y = Y + 1
	elseif Direction == 4 then
		X = X - 1
	elseif Direction == 5 then
		X = X + 1
	else
		return 0
	end
	
	Counter = Counter - 1
	
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y, Z)
	if Result == 1 then
		if Temp_Type == 0 then
			return 1
		elseif Physic_Redstone_Piston_Pushable[Temp_Type] == 0 then
			return 0
		elseif Physic_Redstone_Piston_Pushable[Temp_Type] == 2 and bit32.extract(Temp_Metadata, 3, 1) == 0 then
		end
	end
	
	if Counter > 0 then
		if Physic_Redstone_Piston_Check(World_ID, X, Y, Z, Direction, Counter) == 0 then
			return 0
		end
	else
		return 0
	end
	
	return 1
end

function Physic_Redstone_Piston_Push(World_ID, X, Y, Z, Direction, Sticky, Current_Trigger_Time)
	local To_X, To_Y, To_Z = X, Y, Z
	
	if Direction == 0 then
		Z = Z - 1
		To_Z = Z - 1
	elseif Direction == 1 then
		Z = Z + 1
		To_Z = Z + 1
	elseif Direction == 2 then
		Y = Y - 1
		To_Y = Y - 1
	elseif Direction == 3 then
		Y = Y + 1
		To_Y = Y + 1
	elseif Direction == 4 then
		X = X - 1
		To_X = X - 1
	elseif Direction == 5 then
		X = X + 1
		To_X = X + 1
	else
		return 0
	end
	
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, To_X, To_Y, To_Z)
	local Result_From, Temp_Type_From, Temp_Metadata_From = World_Block_Get(World_ID, X, Y, Z)
	if Result == 1 and Result_From == 1 and Temp_Type ~= 0 and Temp_Type_From ~= 0 then
		Physic_Redstone_Piston_Push(World_ID, X, Y, Z, Direction, Sticky, Current_Trigger_Time)
	end
	
	
	if Result_From == 1 and Temp_Type_From ~= 0 then
		World_Block_Set(World_ID, To_X, To_Y, To_Z, Temp_Type_From, Temp_Metadata_From, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
	end
	
	World_Block_Set(World_ID, X, Y, Z, 34, bit32.replace(Direction, Sticky, 3, 1), -1, -1, -1, 0, 1, 0, Current_Trigger_Time)
	
	--World_Block_Set(World_ID, X, Y, Z, 37, 0, -1, -1, -1, 1, 1, 0, Current_Trigger_Time)
	
	return 1
end

function Physic_Redstone_Piston_Pull(World_ID, X, Y, Z, Direction, Sticky, Current_Trigger_Time)
	local From_X, From_Y, From_Z = X, Y, Z
	
	if Direction == 0 then
		Z = Z - 1
		From_Z = Z - 1
	elseif Direction == 1 then
		Z = Z + 1
		From_Z = Z + 1
	elseif Direction == 2 then
		Y = Y - 1
		From_Y = Y - 1
	elseif Direction == 3 then
		Y = Y + 1
		From_Y = Y + 1
	elseif Direction == 4 then
		X = X - 1
		From_X = X - 1
	elseif Direction == 5 then
		X = X + 1
		From_X = X + 1
	else
		return 0
	end
	
	if Sticky == 1 then
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, From_X, From_Y, From_Z)
		if Result == 1 and Physic_Redstone_Piston_Pushable[Temp_Type] == 1 then
			World_Block_Set(World_ID, X, Y, Z, Temp_Type, Temp_Metadata, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
			World_Block_Set(World_ID, From_X, From_Y, From_Z, 0, 0, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
		elseif Result == 1 and Physic_Redstone_Piston_Pushable[Temp_Type] == 2 and bit32.extract(Temp_Metadata, 3, 1) == 0 then
			World_Block_Set(World_ID, X, Y, Z, Temp_Type, Temp_Metadata, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
			World_Block_Set(World_ID, From_X, From_Y, From_Z, 0, 0, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
		else
			World_Block_Set(World_ID, X, Y, Z, 0, 0, -1, -1, -1, 1, 1, 0, Current_Trigger_Time)
		end
	else
		World_Block_Set(World_ID, X, Y, Z, 0, 0, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
	end
	
	return 1
end

function Physic_Redstone_Piston(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	local State = bit32.extract(Metadata, 3, 1)
	local Direction = bit32.extract(Metadata, 0, 3)
	local New_State = Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z, -1, 1, 0, 1, 1)
	
	if State == 0 then
		if New_State == 1 and Physic_Redstone_Piston_Check(World_ID, X, Y, Z, Direction, 17) == 1 then
			Metadata = bit32.replace(Metadata, 1, 3, 1)
			Physic_Redstone_Piston_Push(World_ID, X, Y, Z, Direction, 0, Current_Trigger_Time)
			World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 0, 1, 0, Current_Trigger_Time)
			World_Effect_Sound(World_ID, "tile.piston.out", X+0.5, Y+0.5, Z+0.5, 1, 1)
			World_Effect_Action(World_ID, X, Y, Z, 0, Direction, Type)
		end
	else
		if New_State == 0 then
			Metadata = bit32.replace(Metadata, 0, 3, 1)
			Physic_Redstone_Piston_Pull(World_ID, X, Y, Z, Direction, 0, Current_Trigger_Time)
			World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 0, 1, 0, Current_Trigger_Time)
			World_Effect_Sound(World_ID, "tile.piston.in", X+0.5, Y+0.5, Z+0.5, 1, 1)
			World_Effect_Action(World_ID, X, Y, Z, 1, Direction, Type)
		end
	end
end

function Physic_Redstone_Sticky_Piston(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	local State = bit32.extract(Metadata, 3, 1)
	local Direction = bit32.extract(Metadata, 0, 3)
	local New_State = Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z, -1, 1, 0, 1, 1)
	
	if State == 0 then
		if New_State == 1 and Physic_Redstone_Piston_Check(World_ID, X, Y, Z, Direction, 17) == 1 then
			Metadata = bit32.replace(Metadata, 1, 3, 1)
			Physic_Redstone_Piston_Push(World_ID, X, Y, Z, Direction, 1, Current_Trigger_Time)
			World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 0, 1, 0, Current_Trigger_Time)
			World_Effect_Sound(World_ID, "tile.piston.out", X+0.5, Y+0.5, Z+0.5, 1, 1)
			World_Effect_Action(World_ID, X, Y, Z, 0, Direction, Type)
		end
	else
		if New_State == 0 then
			Metadata = bit32.replace(Metadata, 0, 3, 1)
			Physic_Redstone_Piston_Pull(World_ID, X, Y, Z, Direction, 1, Current_Trigger_Time)
			World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 0, 1, 0, Current_Trigger_Time)
			World_Effect_Sound(World_ID, "tile.piston.in", X+0.5, Y+0.5, Z+0.5, 1, 1)
			World_Effect_Action(World_ID, X, Y, Z, 1, Direction, Type)
			
		end
	end
end