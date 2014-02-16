local Physic_Game_Of_Life_Syncer = {}

function Physic_Game_Of_Life(World_ID, X, Y, Z, Type, Metadata, Current_Trigger_Time)
	-- 0 Alive
	-- 8 Born next generation
	-- 15 Dead
	-- 12 Dead next generation
	
	if Physic_Game_Of_Life_Syncer[World_ID] == nil then
		Physic_Game_Of_Life_Syncer[World_ID] = {}
	end
	
	--Message_Send_2_All(tostring(Current_Trigger_Time))
	
	if Physic_Game_Of_Life_Syncer[World_ID].Time ~= Current_Trigger_Time then
		--Message_Send_2_All("§cDebug: "..tostring(Current_Trigger_Time))
		Physic_Game_Of_Life_Syncer[World_ID].Time = Current_Trigger_Time
		if Physic_Game_Of_Life_Syncer[World_ID].State == nil or Physic_Game_Of_Life_Syncer[World_ID].State == 1 then
			Physic_Game_Of_Life_Syncer[World_ID].State = 0
			--Message_Send_2_All("§cDebug: A")
		else
			Physic_Game_Of_Life_Syncer[World_ID].State = 1
			--Message_Send_2_All("§cDebug: B")
		end
	end
	
	if Physic_Game_Of_Life_Syncer[World_ID].State == 0 then
		local Counter = 0
		
		for ix = -1, 1 do
			for iy = -1, 1 do
				for iz = -1, 1 do
					if ix ~= 0 or iy ~= 0 or iz ~= 0 then
						local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X+ix, Y+iy, Z+iz)
						if Result == 1 and Temp_Type == 255 and (Temp_Metadata == 0 or Temp_Metadata == 12) then
							Counter = Counter + 1
						end
					end
				end
			end
		end
		
		--Message_Send_2_All("§cDebug: X="..tostring(X).." Y="..tostring(Y))
		if Metadata == 8 or Metadata == 12 then
			-- Not the correct type, try it next time (readding to the queue)
			World_Physic_Queue_Add(World_ID, X, Y, Z, Current_Trigger_Time, 10)
		elseif Metadata == 0 and (Counter < 2 or Counter > 3) then
			Metadata = 12
			World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
		elseif Metadata == 15 and Counter == 3 then
			Metadata = 8
			World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
		end
	else
		--Message_Send_2_All("§cDebug: B")
		if Metadata == 0 or Metadata == 15 then
			--Message_Send_2_All("§casd: X="..tostring(X).." Y="..tostring(Y))
			-- Not the correct type, try it next time (readding to the queue)
			World_Physic_Queue_Add(World_ID, X, Y, Z, Current_Trigger_Time, 10)
		elseif Metadata == 8 then
			Metadata = 0
			World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
		elseif Metadata == 12 then
			Metadata = 15
			World_Block_Set(World_ID, X, Y, Z, -1, Metadata, -1, -1, -1, 1, 1, 1, Current_Trigger_Time)
		end
	end
	
	--Message_Send_2_All("§cDoor-Building: Metadata="..tostring(Metadata).." X="..tostring(X).." Y="..tostring(Y))
end