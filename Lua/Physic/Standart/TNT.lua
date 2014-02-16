function Physic_TNT(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	local R = 5
	
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y, Z-1)
	if Result == 1 and Temp_Type == 0 then
		World_Block_Set(World_ID, X, Y, Z, 0, 0, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
		World_Block_Set(World_ID, X, Y, Z-1, 46, 0, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
	else
		World_Block_Set(World_ID, X, Y, Z, 0, 0, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
		for ix = -R, R do
			for iy = -R, R do
				for iz = -R, R do
					local Distance = math.sqrt(ix*ix + iy*iy + iz*iz)
					if Distance <= R then
						local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X+ix, Y+iy, Z+iz)
						if Temp_Type ~= Type then
							World_Block_Set(World_ID, X+ix, Y+iy, Z+iz, 0, 0, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
						end
					end
				end
			end
		end
		
		World_Effect_Explosion(World_ID, X, Y, Z, R)
		World_Effect_Sound(World_ID, "random.explode", X+0.5, Y+0.5, Z+0.5, 1, 1)
	end
end