function Physic_Redstone_Wire_Helper(World_ID, X, Y, Z, Type, Metadata)
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y, Z)
	if Result == 1 then
		if Temp_Type == Type then
			if Metadata < Temp_Metadata-1 then
				Metadata = Temp_Metadata-1
			end
		end
	end
	
	return Metadata
end

function Physic_Redstone_Wire(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	local Old_Metadata = Metadata
	
	if Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z, -1, 1, 0, 0) == 1 then
		Metadata = 15
	else
		Metadata = 0
		
		local iz = -1
		Metadata = Physic_Redstone_Wire_Helper(World_ID, X+1, Y  , Z+iz, Type, Metadata)
		Metadata = Physic_Redstone_Wire_Helper(World_ID, X  , Y+1, Z+iz, Type, Metadata)
		Metadata = Physic_Redstone_Wire_Helper(World_ID, X-1, Y  , Z+iz, Type, Metadata)
		Metadata = Physic_Redstone_Wire_Helper(World_ID, X  , Y-1, Z+iz, Type, Metadata)
		
		local iz = 0
		Metadata = Physic_Redstone_Wire_Helper(World_ID, X+1, Y  , Z+iz, Type, Metadata)
		Metadata = Physic_Redstone_Wire_Helper(World_ID, X  , Y+1, Z+iz, Type, Metadata)
		Metadata = Physic_Redstone_Wire_Helper(World_ID, X-1, Y  , Z+iz, Type, Metadata)
		Metadata = Physic_Redstone_Wire_Helper(World_ID, X  , Y-1, Z+iz, Type, Metadata)
		
		local iz = 1
		local Result, Temp_Type = World_Block_Get(World_ID, X, Y, Z+iz)
		if Result == 1 and Temp_Type == 0 then
			Metadata = Physic_Redstone_Wire_Helper(World_ID, X+1, Y  , Z+iz, Type, Metadata)
			Metadata = Physic_Redstone_Wire_Helper(World_ID, X  , Y+1, Z+iz, Type, Metadata)
			Metadata = Physic_Redstone_Wire_Helper(World_ID, X-1, Y  , Z+iz, Type, Metadata)
			Metadata = Physic_Redstone_Wire_Helper(World_ID, X  , Y-1, Z+iz, Type, Metadata)
		end
	end
	
	World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 1, 1, 0, Current_Trigger_Time)
	
	if Old_Metadata ~= Metadata then
		Physic_Redstone_Helper_Wire_Activator(World_ID, X, Y, Z, Current_Trigger_Time)
	end
	Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, -1, 0, 1, Current_Trigger_Time)
end