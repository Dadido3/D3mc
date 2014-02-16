function Physic_Redstone_Button(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	local State = bit32.extract(Metadata, 3, 1)
	
	if State == 1 then
		Metadata = bit32.replace(Metadata, 0, 3, 1)
		World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 1, 1, 0, Current_Trigger_Time)
		Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, -1, 1, 1, 0)
		World_Effect_Sound_Or_Particle(World_ID, 1000, X, Y, Z, 0)
	end
end