function Physic_Redstone_Lamp_On(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	if Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z, -1, 1, 0, 1, 1) == 1 then
		return 1
	end
	
	World_Block_Set(World_ID, X, Y, Z, 123, 0, -1, -1, -1, 1, 1, 0, Current_Trigger_Time)
end

function Physic_Redstone_Lamp_Off(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	if Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z, -1, 1, 0, 1, 1) == 1 then
		World_Block_Set(World_ID, X, Y, Z, 124, 0, -1, -1, -1, 1, 1, 0, Current_Trigger_Time)
	end
end