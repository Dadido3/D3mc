--Lua_Event_Add("Test", "Timer", 100, "Timer_Test")
Lua_Event_Delete("Test")

function Timer_Test()
	local timer = os.clock()
	local X
	local Y
	
	for ix = 64, 63+32 do
		X = ix - 64
		for iy = 160, 160+32 do
			Y = iy - 64
			local Rotation = math.rad(math.sin(X*0.02+Y*0.03+timer*0.05)*20)
			local Sin_X = math.cos(Rotation)
			local Sin_Y = math.sin(Rotation)
			for iz = 63, 63 do
				Metadata = 3.5+math.sin(Sin_X*X*0.3+Sin_Y*Y*0.3+timer*0.4)*3.5
				--Metadata = math.random(16)-1
				World_Block_Set(1, ix, iy, iz, 9, Metadata, -1, -1, -1, 1, 0, 0)
			end
		end
	end
end

local Start_Time = os.clock()

--for ix = -30, 30 do
--	for iy = -30, 30 do
--		for iz = -30, 30 do
--			Dist = math.pow(ix, 2) + math.pow(iy, 2) + math.pow(iz, 2)
--			if Dist < 30*30 then
--				--World_Block_Set(1, ix, iy, iz, -1, -1, -1, -1, -1, 0, 0, 0)
--				World_Block_Set(1, 88+ix, 88+iy, 70+iz, 35, math.mod(50+iz, 16), -1, -1, -1, 1, 0, 0)
--			end
--		end
--	end
--end

print(os.clock() - Start_Time)

if Last_E_ID ~= nil then
	i = 1
	while Last_E_ID[i] ~= nil do
		Entity_Delete(Last_E_ID[i])
		i = i + 1
	end
end

Last_E_ID = {}
for i = 1, 100 do
	--Last_E_ID[i] = Entity_Add(1, 27+math.sin(i/10)*i/20, -57+math.cos(i/10)*i/20, 60, "O", Entity_Type_Player, 0, 0)
	--Last_E_ID[i] = Entity_Add(1, 185+math.sin(i/5)*i/20, -35+math.cos(i/5)*i/20, 44, "Notch", Entity_Type_Mob, 91, 0)
	--Last_E_ID[i] = Entity_Add(1, 185+math.sin(i/5)*i/20, -35+math.cos(i/5)*i/20, 44, "Notch", Entity_Type_Mob, 91, 0)
	--if math.random(2) == 1 then
	--	Last_E_ID[i] = Entity_Add(1, math.random(), -50+math.random(), 60, "Wolfie", Entity_Type_Mob, 95, 1)
	--else
	--	Last_E_ID[i] = Entity_Add(1, 43+math.random(), -20+math.random(), 21, "Wolfie", Entity_Type_Mob, 50, 1)
	--end
	--Last_E_ID[i] = Entity_Add(1, -8+math.random(), -35-math.random(), 100, "Wolfie", Entity_Type_Item, 1+math.random(20), 1)
	--Last_E_ID[i] = Entity_Add(1, 42+math.random(30), 16+math.random(30), 80+math.random()*40, "Wolfie", Entity_Type_ObjectVehicle, 70, 1)
	--Last_E_ID[i] = Entity_Add(1, 345+math.random()*10, -30+math.random()*10, 180+math.random(), "Wolfie", Entity_Type_Mob, 95, 1)
end