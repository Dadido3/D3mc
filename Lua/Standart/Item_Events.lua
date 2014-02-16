function Item_Place_Tree(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local Entity_ID = Network_Client_Entity_Get(Network_Client_ID)
	local Yaw, Pitch = Entity_Get_Rotation(Entity_ID)
	
	local Sin = math.sin(math.rad(Yaw)) -- X
	local Cos = math.cos(math.rad(Yaw)) -- Y
	local Abs_Sin = math.abs(Sin)
	local Abs_Cos = math.abs(Cos)
	
	local Abs_Pitch_Cos = math.abs(math.cos(math.rad(Pitch)))
	
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
	
	if Abs_Pitch_Cos > 0.5 then
		if Abs_Sin > Abs_Cos then
			-- X
			Metadata = Metadata + 4
		else
			-- Y
			Metadata = Metadata + 8
		end
	end
	
	World_Block_Set(World_ID, X, Y, Z, Type, Metadata, -1, -1, -1, 2, 1, 1)
	--Message_Send_2_All("§cDebug: "..tostring(Abs_Pitch_Cos))
end

function Item_Place_Stairs(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local Entity_ID = Network_Client_Entity_Get(Network_Client_ID)
	local Yaw = Entity_Get_Rotation(Entity_ID)
	
	local Sin = math.sin(math.rad(Yaw)) -- X
	local Cos = math.cos(math.rad(Yaw)) -- Y
	local Abs_Sin = math.abs(Sin)
	local Abs_Cos = math.abs(Cos)
	
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
	
	if Direction == 1 or (Direction ~= 0 and Cursor_Z < 8) then
		Metadata = 0
	else
		Metadata = 4
	end
	
	if Abs_Sin > Abs_Cos and Sin < 0 then
		-- X+
	elseif Abs_Sin > Abs_Cos and Sin > 0 then
		Metadata = Metadata + 1	-- X-
	elseif Abs_Cos > Abs_Sin and Cos > 0 then
		Metadata = Metadata + 2	-- Y+
	else
		Metadata = Metadata + 3	-- Y-
	end
	
	World_Block_Set(World_ID, X, Y, Z, Type, Metadata, -1, -1, -1, 2, 1, 1)
	--Message_Send_2_All("§cDebug: "..tostring(Metadata))
end

function Item_Place_Slab(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	if Direction == 255 then
		return 0
	end
	
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y, Z)
	if Result == 1 and Type == Temp_Type then
		World_Block_Set(World_ID, X, Y, Z, 0, Metadata, -1, -1, -1, 2, 1, 1)
		Message_Send_2_Client(Network_Client_ID, "§cSlabs not completly implemented yet!")
	else
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
		end
		
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y, Z)
		if Result == 1 and Type == Temp_Type then
			World_Block_Set(World_ID, X, Y, Z, 0, Metadata, -1, -1, -1, 2, 1, 1)
			Message_Send_2_Client(Network_Client_ID, "§cSlabs not completly implemented yet!")
		else
			if Direction == 1 or (Direction ~= 0 and Cursor_Z < 8) then
				--Metadata = Metadata + 0
			else
				Metadata = Metadata + 8
			end
			
			World_Block_Set(World_ID, X, Y, Z, Type, Metadata, -1, -1, -1, 2, 1, 1)
		end
	end
end

function Item_Place_Door(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local Entity_ID = Network_Client_Entity_Get(Network_Client_ID)
	local Yaw = Entity_Get_Rotation(Entity_ID)
	
	local Temp_Type
	
	local RX, RY, RZ	-- Coordinates of the door to the right
	local LX, LY, LZ	-- Coordinates of the door to the left
	
	local Sin = math.sin(math.rad(Yaw)) -- X
	local Cos = math.cos(math.rad(Yaw)) -- Y
	local Abs_Sin = math.abs(Sin)
	local Abs_Cos = math.abs(Cos)
	
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
	
	if Type == 324 then
		Type = 64
	elseif Type == 330 then
		Type = 71
	else
		return 0
	end
	
	local Bottom_Metadata, Top_Metadata
	
	if Abs_Sin > Abs_Cos and Sin < 0 then
		Bottom_Metadata = 0	-- X+
		RX, RY, RZ = X, Y+1, Z
		LX, LY, LZ = X, Y-1, Z
	elseif Abs_Sin > Abs_Cos and Sin > 0 then
		Bottom_Metadata = 2	-- X-
		RX, RY, RZ = X, Y-1, Z
		LX, LY, LZ = X, Y+1, Z
	elseif Abs_Cos > Abs_Sin and Cos > 0 then
		Bottom_Metadata = 1	-- Y+
		RX, RY, RZ = X-1, Y, Z
		LX, LY, LZ = X+1, Y, Z
	else
		Bottom_Metadata = 3	-- Y-
		RX, RY, RZ = X+1, Y, Z
		LX, LY, LZ = X-1, Y, Z
	end
	
	local Result, Temp_Type = World_Block_Get(World_ID, LX, LY, LZ)
	if Result == 1 and Temp_Type == Type then
		Top_Metadata = 8 + 1
	else
		Top_Metadata = 8
	end
	
	World_Block_Set(World_ID, X, Y, Z, Type, Bottom_Metadata, -1, -1, -1, 2, 1, 1)
	World_Block_Set(World_ID, X, Y, Z+1, Type, Top_Metadata, -1, -1, -1, 2, 1, 1)
	
	--Message_Send_2_All("§cDoor-Building: Metadata="..tostring(Metadata).." X="..tostring(Cursor_X).." Y="..tostring(Cursor_Y))
end

function Item_Place_Torch(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	if Direction == 0 then
		Z = Z - 1
		return 0
	elseif Direction == 1 then
		Z = Z + 1
		Metadata = 5
	elseif Direction == 2 then
		Y = Y - 1
		Metadata = 4
	elseif Direction == 3 then
		Y = Y + 1
		Metadata = 3
	elseif Direction == 4 then
		X = X - 1
		Metadata = 2
	elseif Direction == 5 then
		X = X + 1
		Metadata = 1
	else
		return 0
	end
	
	World_Block_Set(World_ID, X, Y, Z, Type, Metadata, -1, -1, -1, 2, 1, 1)
end

function Item_Place_Redstone_Repeater(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local Entity_ID = Network_Client_Entity_Get(Network_Client_ID)
	local Yaw = Entity_Get_Rotation(Entity_ID)
	
	local Sin = math.sin(math.rad(Yaw)) -- X
	local Cos = math.cos(math.rad(Yaw)) -- Y
	local Abs_Sin = math.abs(Sin)
	local Abs_Cos = math.abs(Cos)
	
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
	
	if Abs_Sin > Abs_Cos and Sin < 0 then
		Metadata = 1	-- X+
	elseif Abs_Sin > Abs_Cos and Sin > 0 then
		Metadata = 3	-- X-
	elseif Abs_Cos > Abs_Sin and Cos > 0 then
		Metadata = 2	-- Y+
	else
		Metadata = 0	-- Y-
	end
	
	World_Block_Set(World_ID, X, Y, Z, 93, Metadata, -1, -1, -1, 2, 1, 1)
	--Message_Send_2_All("§cDebug: "..tostring(Yaw))
end

function Item_Place_Redstone_Torch(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	if Direction == 0 then
		Z = Z - 1
		return 0
	elseif Direction == 1 then
		Z = Z + 1
		Metadata = 5
	elseif Direction == 2 then
		Y = Y - 1
		Metadata = 4
	elseif Direction == 3 then
		Y = Y + 1
		Metadata = 3
	elseif Direction == 4 then
		X = X - 1
		Metadata = 2
	elseif Direction == 5 then
		X = X + 1
		Metadata = 1
	else
		return 0
	end
	
	World_Block_Set(World_ID, X, Y, Z, Type, Metadata, -1, -1, -1, 2, 1, 1)
	Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, -1, 1, 1, 0)
end

function Item_Place_Redstone_Lever(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local Entity_ID = Network_Client_Entity_Get(Network_Client_ID)
	local Yaw = Entity_Get_Rotation(Entity_ID)
	
	local Sin = math.sin(math.rad(Yaw)) -- X
	local Cos = math.cos(math.rad(Yaw)) -- Y
	local Abs_Sin = math.abs(Sin)
	local Abs_Cos = math.abs(Cos)
	
	if Direction == 0 then
		Z = Z - 1
		Metadata = 7
	elseif Direction == 1 then
		Z = Z + 1
		Metadata = 5
	elseif Direction == 2 then
		Y = Y - 1
		Metadata = 4
	elseif Direction == 3 then
		Y = Y + 1
		Metadata = 3
	elseif Direction == 4 then
		X = X - 1
		Metadata = 2
	elseif Direction == 5 then
		X = X + 1
		Metadata = 1
	else
		return 0
	end
	
	World_Block_Set(World_ID, X, Y, Z, Type, Metadata, -1, -1, -1, 2, 1, 1)
end

function Item_Place_Redstone_Button(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local Entity_ID = Network_Client_Entity_Get(Network_Client_ID)
	local Yaw = Entity_Get_Rotation(Entity_ID)
	
	local Sin = math.sin(math.rad(Yaw)) -- X
	local Cos = math.cos(math.rad(Yaw)) -- Y
	local Abs_Sin = math.abs(Sin)
	local Abs_Cos = math.abs(Cos)
	
	if Direction == 0 then
		Z = Z - 1
		return 0
	elseif Direction == 1 then
		Z = Z + 1
		return 0
	elseif Direction == 2 then
		Y = Y - 1
		Metadata = 4
	elseif Direction == 3 then
		Y = Y + 1
		Metadata = 3
	elseif Direction == 4 then
		X = X - 1
		Metadata = 2
	elseif Direction == 5 then
		X = X + 1
		Metadata = 1
	else
		return 0
	end
	
	World_Block_Set(World_ID, X, Y, Z, Type, Metadata, -1, -1, -1, 2, 1, 1)
end

function Item_Place_Redstone_Piston(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local Entity_ID = Network_Client_Entity_Get(Network_Client_ID)
	local Yaw, Pitch = Entity_Get_Rotation(Entity_ID)
	
	local Sin = math.sin(math.rad(Yaw)) -- X
	local Cos = math.cos(math.rad(Yaw)) -- Y
	local Abs_Sin = math.abs(Sin)
	local Abs_Cos = math.abs(Cos)
	
	local Abs_Pitch_Cos = math.abs(math.cos(math.rad(Pitch)))
	local Pitch_Sin = math.sin(math.rad(Pitch))
	
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
	
	if Abs_Pitch_Cos > 0.65 then
		if Abs_Sin > Abs_Cos and Sin < 0 then
			Metadata = 4
		elseif Abs_Sin > Abs_Cos and Sin > 0 then
			Metadata = 5
		elseif Abs_Cos > Abs_Sin and Cos > 0 then
			Metadata = 2
		else
			Metadata = 3
		end
	elseif Pitch_Sin > 0 then
		Metadata = 1
	else
		Metadata = 0
	end
	
	World_Block_Set(World_ID, X, Y, Z, Type, Metadata, -1, -1, -1, 2, 1, 1)
	--Message_Send_2_All("§cDebug: "..tostring(Abs_Pitch_Cos))
end

function Item_Place_Spawn_Egg(Network_Client_ID, World_ID, X, Y, Z, Direction, Cursor_X, Cursor_Y, Cursor_Z, Type, Metadata)
	local Client_Entity_ID = Network_Client_Entity_Get(Network_Client_ID)
	local Yaw, Pitch, Roll = Entity_Get_Rotation(Client_Entity_ID)
	local Entity_Type = Metadata
	
	Pitch = 0
	
	local Entity_ID = Entity_Add(World_ID, X+Cursor_X/16, Y+Cursor_Y/16, Z+Cursor_Z/16, Entity_Type, "")
	Entity_Set_Rotation(Entity_ID, Yaw, Pitch, Roll, 0)
	
	--Message_Send_2_All("§cDebug: Spawn-Egg: "..tostring(Type))
end