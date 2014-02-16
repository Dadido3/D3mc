local Entity_Enderman_Temp = {}

function Entity_Enderman(Entity_ID)
	local World_ID = Entity_Get_World(Entity_ID)
	local X, Y, Z = Entity_Get_Position(Entity_ID)
	local VX, VY, VZ = Entity_Get_Velocity(Entity_ID)
	local Yaw, Pitch, Roll = Entity_Get_Rotation(Entity_ID)
	
	local Sin = -math.sin(math.rad(Yaw)) -- X
	local Cos = math.cos(math.rad(Yaw)) -- Y
	
	if Entity_Enderman_Temp[Entity_ID] == nil then
		Entity_Enderman_Temp[Entity_ID] = {}
		Entity_Enderman_Temp[Entity_ID].Mode = 0
	end
	
	if Entity_Enderman_Temp[Entity_ID].Mode == 1 then
		VX = Sin * 1
		VY = Cos * 1
		Entity_Set_Velocity(Entity_ID, VX, VY, VZ, 0, 0)
		if math.random(200) == 1 then
			Entity_Enderman_Temp[Entity_ID].Mode = math.random(3)-1
		end
	elseif Entity_Enderman_Temp[Entity_ID].Mode == 2 then
		if math.random(4) == 1 then
			Yaw = Yaw + math.random()*80 - 40
			Pitch = math.random()*30-15
			Roll = 0
			Entity_Set_Rotation(Entity_ID, Yaw, Pitch, Roll, 1, 0)
			if math.random(8) == 1 then
				Entity_Enderman_Temp[Entity_ID].Mode = math.random(3)-1
			end
		end
	else
		if math.random(50) == 1 then
			Entity_Enderman_Temp[Entity_ID].Mode = math.random(3)-1
		end
	end
	
	if math.random(50) == 1 then
		--Entity_Delete(Entity_ID)
	end
	
	if math.random(100) == 1 then
		World_Effect_Sound(World_ID, "mob.endermen.idle", X, Y, Z+2, 1, 1)
	end
end