function Physic_Redstone_Repeater_Off(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	local Direction_In = bit32.extract(Metadata, 0, 2)
	local Direction_Out = bit32.extract(Metadata, 0, 2)
	local Delay = bit32.extract(Metadata, 2, 2)
	
	--Message_Send_2_All("§cDebug: Direction:"..tostring(Direction).." Delay:"..tostring(Delay))
	
	Direction_In = Direction_In + 2
	if Direction_In > 3 then
		Direction_In = Direction_In - 4
	end
	if Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z, Direction_In, 1, 1, 1, 1) == 1 then
		World_Block_Set(World_ID, X, Y, Z, 94, -1, -1, -1, -1, 1, 1, 0, Current_Trigger_Time)
		
		Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, Direction_Out, 1, 1, Current_Trigger_Time)
		
		--World_Physic_Queue_Add(World_ID, X, Y, Z, Current_Trigger_Time, 0)
		--World_Effect_Sound_Or_Particle(World_ID, 2002, X, Y, Z, 1)
	end
end

function Physic_Redstone_Repeater_On(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	local Direction_In = bit32.extract(Metadata, 0, 2)
	local Direction_Out = bit32.extract(Metadata, 0, 2)
	local Delay = bit32.extract(Metadata, 2, 2)
	
	--Message_Send_2_All("§cDebug: Direction:"..tostring(Direction).." Delay:"..tostring(Delay))
	
	Direction_In = Direction_In + 2
	if Direction_In > 3 then
		Direction_In = Direction_In - 4
	end
	if Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z, Direction_In, 1, 1, 1, 1) == 0 then
		World_Block_Set(World_ID, X, Y, Z, 93, -1, -1, -1, -1, 1, 1, 0, Current_Trigger_Time)
		
		Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, Direction_Out, 1, 1, Current_Trigger_Time)
		
		--World_Physic_Queue_Add(World_ID, X, Y, Z, Current_Trigger_Time, 0)
	end
end