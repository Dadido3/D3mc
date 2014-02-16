function Physic_Redstone_Torch_On(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	local Direction
	
	if Metadata == 1 then
		Direction = 3
	elseif Metadata == 2 then
		Direction = 1
	elseif Metadata == 3 then
		Direction = 0
	elseif Metadata == 4 then
		Direction = 2
	else
		Direction = 5
	end
	
	--Message_Send_2_All("§cDebug: Metadata:"..tostring(Metadata))
	
	if Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z, Direction, 0, 0, 0, 1) == 1 then
		World_Block_Set(World_ID, X, Y, Z, 75, -1, -1, -1, -1, 1, 1, 0, Current_Trigger_Time)
		Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, -1, 1, 1, Current_Trigger_Time)
		--World_Effect_Sound_Or_Particle(World_ID, 1000, X, Y, Z, 16)
		--World_Effect_Sound_Or_Particle(World_ID, 2001, X, Y, Z, 16)
	end
end

function Physic_Redstone_Torch_Off(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	local Direction
	
	if Metadata == 1 then
		Direction = 3
	elseif Metadata == 2 then
		Direction = 1
	elseif Metadata == 3 then
		Direction = 0
	elseif Metadata == 4 then
		Direction = 2
	else
		Direction = 5
	end
	
	if Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z, Direction, 0, 0, 0, 1) == 0 then
		World_Block_Set(World_ID, X, Y, Z, 76, -1, -1, -1, -1, 1, 1, 0, Current_Trigger_Time)
		Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, -1, 1, 1, Current_Trigger_Time)
		--World_Effect_Sound_Or_Particle(World_ID, 1001, X, Y, Z, 0)
	end
end