function Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z, Direction, Check_Torch, Fored_Wire_Connection, Check_Wire, Check_Block)
	if (Direction == -1 or Direction == 0) then	-- Y-
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y-1, Z)
		if Result == 1 then
			if Check_Wire == 1 and Temp_Type == 55 and Temp_Metadata > 0 then
				if Fored_Wire_Connection == 1 then
					return 1
				else
					local Result_A, Temp_Type_A, Temp_Metadata_A = World_Block_Get(World_ID, X-1, Y-1, Z)
					local Result_B, Temp_Type_B, Temp_Metadata_B = World_Block_Get(World_ID, X+1, Y-1, Z)
					if Result_A == 1 and Result_B == 1 and Temp_Type_A ~= 55 and Temp_Type_B ~= 55 and Temp_Type_A ~= 93 and Temp_Type_B ~= 93 and Temp_Type_A ~= 94 and Temp_Type_B ~= 94 then
						return 1
					end
				end
			elseif Temp_Type == 94 and bit32.extract(Temp_Metadata, 0, 2) == 2 then
				return 1
			elseif (Temp_Type == 69 or Temp_Type == 77) and bit32.extract(Temp_Metadata, 3, 1) == 1 then
				return 1
			elseif Check_Torch == 1 and Temp_Type == 76 then
				return 1
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				if Physic_Redstone_Helper_Block_State(World_ID, X, Y-1, Z, -1, Check_Torch, 0, 1, 0) == 1 then
					return 1
				end
			end
		end
	end
	if (Direction == -1 or Direction == 1) then	-- X+
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X+1, Y, Z)
		if Result == 1 then
			if Check_Wire == 1 and Temp_Type == 55 and Temp_Metadata > 0 then
				if Fored_Wire_Connection == 1 then
					return 1
				else
					local Result_A, Temp_Type_A, Temp_Metadata_A = World_Block_Get(World_ID, X+1, Y-1, Z)
					local Result_B, Temp_Type_B, Temp_Metadata_B = World_Block_Get(World_ID, X+1, Y+1, Z)
					if Result_A == 1 and Result_B == 1 and Temp_Type_A ~= 55 and Temp_Type_B ~= 55 and Temp_Type_A ~= 93 and Temp_Type_B ~= 93 and Temp_Type_A ~= 94 and Temp_Type_B ~= 94  then
						return 1
					end
				end
			elseif Temp_Type == 94 and bit32.extract(Temp_Metadata, 0, 2) == 3 then
				return 1
			elseif (Temp_Type == 69 or Temp_Type == 77) and bit32.extract(Temp_Metadata, 3, 1) == 1 then
				return 1
			elseif Check_Torch == 1 and Temp_Type == 76 then
				return 1
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				if Physic_Redstone_Helper_Block_State(World_ID, X+1, Y, Z, -1, Check_Torch, 0, 1, 0) == 1 then
					return 1
				end
			end
		end
	end
	if (Direction == -1 or Direction == 2) then	-- Y+
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y+1, Z)
		if Result == 1 then
			if Check_Wire == 1 and Temp_Type == 55 and Temp_Metadata > 0 then
				if Fored_Wire_Connection == 1 then
					return 1
				else
					local Result_A, Temp_Type_A, Temp_Metadata_A = World_Block_Get(World_ID, X-1, Y+1, Z)
					local Result_B, Temp_Type_B, Temp_Metadata_B = World_Block_Get(World_ID, X+1, Y+1, Z)
					if Result_A == 1 and Result_B == 1 and Temp_Type_A ~= 55 and Temp_Type_B ~= 55 and Temp_Type_A ~= 93 and Temp_Type_B ~= 93 and Temp_Type_A ~= 94 and Temp_Type_B ~= 94  then
						return 1
					end
				end
			elseif Temp_Type == 94 and bit32.extract(Temp_Metadata, 0, 2) == 0 then
				return 1
			elseif (Temp_Type == 69 or Temp_Type == 77) and bit32.extract(Temp_Metadata, 3, 1) == 1 then
				return 1
			elseif Check_Torch == 1 and Temp_Type == 76 then
				return 1
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				if Physic_Redstone_Helper_Block_State(World_ID, X, Y+1, Z, -1, Check_Torch, 0, 1, 0) == 1 then
					return 1
				end
			end
		end
	end
	if (Direction == -1 or Direction == 3) then	-- X-
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X-1, Y, Z)
		if Result == 1 then
			if Check_Wire == 1 and Temp_Type == 55 and Temp_Metadata > 0 then
				if Fored_Wire_Connection == 1 then
					return 1
				else
					local Result_A, Temp_Type_A, Temp_Metadata_A = World_Block_Get(World_ID, X-1, Y-1, Z)
					local Result_B, Temp_Type_B, Temp_Metadata_B = World_Block_Get(World_ID, X-1, Y+1, Z)
					if Result_A == 1 and Result_B == 1 and Temp_Type_A ~= 55 and Temp_Type_B ~= 55 and Temp_Type_A ~= 93 and Temp_Type_B ~= 93 and Temp_Type_A ~= 94 and Temp_Type_B ~= 94  then
						return 1
					end
				end
			elseif Temp_Type == 94 and bit32.extract(Temp_Metadata, 0, 2) == 1 then
				return 1
			elseif (Temp_Type == 69 or Temp_Type == 77) and bit32.extract(Temp_Metadata, 3, 1) == 1 then
				return 1
			elseif Check_Torch == 1 and Temp_Type == 76 then
				return 1
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				if Physic_Redstone_Helper_Block_State(World_ID, X-1, Y, Z, -1, Check_Torch, 0, 1, 0) == 1 then
					return 1
				end
			end
		end
	end
	if (Direction == -1 or Direction == 4) then	-- Z+
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y, Z+1)
		if Result == 1 then
			if Temp_Type == 55 and Temp_Metadata > 0 then
				return 1
			elseif (Temp_Type == 69 or Temp_Type == 77) and bit32.extract(Temp_Metadata, 3, 1) == 1then
				return 1
			elseif Check_Torch == 1 and Temp_Type == 76 then
				return 1
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				if Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z+1, -1, Check_Torch, 0, 1, 0) == 1 then
					return 1
				end
			end
		end
	end
	if (Direction == -1 or Direction == 5) then	-- Z-
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y, Z-1)
		if Result == 1 then
			if Temp_Type == 76 then
				return 1
			elseif (Temp_Type == 69 or Temp_Type == 77) and bit32.extract(Temp_Metadata, 3, 1) == 1then
				return 1
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				if Physic_Redstone_Helper_Block_State(World_ID, X, Y, Z-1, -1, 0, 0, 1, 0) == 1 then
					return 1
				end
			end
		end
	end
	
	
	return 0
end

function Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, Direction, Check_Wire, Check_Block, Current_Trigger_Time)
	if Direction == -1 or Direction == 0 then	-- Y-
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y-1, Z)
		if Result == 1 then
			if Check_Wire == 1 and Temp_Type == 55 then
				World_Physic_Queue_Add(World_ID, X, Y-1, Z, Current_Trigger_Time, 10)
			elseif (Temp_Type == 94 or Temp_Type == 93) and bit32.extract(Temp_Metadata, 0, 2) == 0 then
				World_Physic_Queue_Add(World_ID, X, Y-1, Z, Current_Trigger_Time+bit32.extract(Temp_Metadata, 2, 2)*100, 10)
			elseif Temp_Type == 123 or Temp_Type == 124 or Temp_Type == 75 or Temp_Type == 76 or Temp_Type == 29 or Temp_Type == 33 then
				World_Physic_Queue_Add(World_ID, X, Y-1, Z, Current_Trigger_Time, 10)
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				Physic_Redstone_Helper_Block_Activator(World_ID, X, Y-1, Z, -1, 0, 0, Current_Trigger_Time)
			end
		end
	end
	if Direction == -1 or Direction == 1 then	-- X+
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X+1, Y, Z)
		if Result == 1 then
			if Check_Wire == 1 and Temp_Type == 55 then
				World_Physic_Queue_Add(World_ID, X+1, Y, Z, Current_Trigger_Time, 10)
			elseif (Temp_Type == 94 or Temp_Type == 93) and bit32.extract(Temp_Metadata, 0, 2) == 1 then
				World_Physic_Queue_Add(World_ID, X+1, Y, Z, Current_Trigger_Time+bit32.extract(Temp_Metadata, 2, 2)*100, 10)
			elseif Temp_Type == 123 or Temp_Type == 124 or Temp_Type == 75 or Temp_Type == 76 or Temp_Type == 29 or Temp_Type == 33 then
				World_Physic_Queue_Add(World_ID, X+1, Y, Z, Current_Trigger_Time, 10)
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				Physic_Redstone_Helper_Block_Activator(World_ID, X+1, Y, Z, -1, 0, 0, Current_Trigger_Time)
			end
		end
	end
	if Direction == -1 or Direction == 2 then	-- Y+
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y+1, Z)
		if Result == 1 then
			if Check_Wire == 1 and Temp_Type == 55 then
				World_Physic_Queue_Add(World_ID, X, Y+1, Z, Current_Trigger_Time, 10)
			elseif (Temp_Type == 94 or Temp_Type == 93) and bit32.extract(Temp_Metadata, 0, 2) == 2 then
				World_Physic_Queue_Add(World_ID, X, Y+1, Z, Current_Trigger_Time+bit32.extract(Temp_Metadata, 2, 2)*100, 10)
			elseif Temp_Type == 123 or Temp_Type == 124 or Temp_Type == 75 or Temp_Type == 76 or Temp_Type == 29 or Temp_Type == 33 then
				World_Physic_Queue_Add(World_ID, X, Y+1, Z, Current_Trigger_Time, 10)
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				Physic_Redstone_Helper_Block_Activator(World_ID, X, Y+1, Z, -1, 0, 0, Current_Trigger_Time)
			end
		end
	end
	if Direction == -1 or Direction == 3 then	-- X-
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X-1, Y, Z)
		if Result == 1 then
			if Check_Wire == 1 and Temp_Type == 55 then
				World_Physic_Queue_Add(World_ID, X-1, Y, Z, Current_Trigger_Time, 10)
			elseif (Temp_Type == 94 or Temp_Type == 93) and bit32.extract(Temp_Metadata, 0, 2) == 3 then
				World_Physic_Queue_Add(World_ID, X-1, Y, Z, Current_Trigger_Time+bit32.extract(Temp_Metadata, 2, 2)*100, 10)
			elseif Temp_Type == 123 or Temp_Type == 124 or Temp_Type == 75 or Temp_Type == 76 or Temp_Type == 29 or Temp_Type == 33 then
				World_Physic_Queue_Add(World_ID, X-1, Y, Z, Current_Trigger_Time, 10)
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				Physic_Redstone_Helper_Block_Activator(World_ID, X-1, Y, Z, -1, 0, 0, Current_Trigger_Time)
			end
		end
	end
	if Direction == -1 or Direction == 4 then	-- Z+
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y, Z+1)
		if Result == 1 then
			if Check_Wire == 1 and Temp_Type == 55 then
				World_Physic_Queue_Add(World_ID, X, Y, Z+1, Current_Trigger_Time, 10)
			elseif Temp_Type == 123 or Temp_Type == 124 or Temp_Type == 75 or Temp_Type == 76 or Temp_Type == 29 or Temp_Type == 33 then
				World_Physic_Queue_Add(World_ID, X, Y, Z+1, Current_Trigger_Time, 10)
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z+1, -1, 0, 0, Current_Trigger_Time)
			end
		end
	end
	if Direction == -1 or Direction == 5 then	-- Z-
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y, Z-1)
		if Result == 1 then
			if Check_Wire == 1 and Temp_Type == 55 then
				World_Physic_Queue_Add(World_ID, X, Y, Z-1, Current_Trigger_Time, 10)
			elseif Temp_Type == 123 or Temp_Type == 124 or Temp_Type == 75 or Temp_Type == 76 or Temp_Type == 29 or Temp_Type == 33 then
				World_Physic_Queue_Add(World_ID, X, Y, Z-1, Current_Trigger_Time, 10)
			elseif Check_Block == 1 and Temp_Type > 0 and Temp_Type < 20 then
				Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z-1, -1, 0, 0, Current_Trigger_Time)
			end
		end
	end
end

function Physic_Redstone_Helper_Wire_Activator(World_ID, X, Y, Z, Current_Trigger_Time)
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X-1, Y, Z)
	if Result == 1 and Temp_Type == 55 then
		World_Physic_Queue_Add(World_ID, X-1, Y, Z, Current_Trigger_Time, 10)
	end
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X+1, Y, Z)
	if Result == 1 and Temp_Type == 55 then
		World_Physic_Queue_Add(World_ID, X+1, Y, Z, Current_Trigger_Time, 10)
	end
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y+1, Z)
	if Result == 1 and Temp_Type == 55 then
		World_Physic_Queue_Add(World_ID, X, Y+1, Z, Current_Trigger_Time, 10)
	end
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y-1, Z)
	if Result == 1 and Temp_Type == 55 then
		World_Physic_Queue_Add(World_ID, X, Y-1, Z, Current_Trigger_Time, 10)
	end
	
	local iz = -1
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X-1, Y, Z+iz)
	if Result == 1 and Temp_Type == 55 then
		World_Physic_Queue_Add(World_ID, X-1, Y, Z+iz, Current_Trigger_Time, 10)
	end
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X+1, Y, Z+iz)
	if Result == 1 and Temp_Type == 55 then
		World_Physic_Queue_Add(World_ID, X+1, Y, Z+iz, Current_Trigger_Time, 10)
	end
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y+1, Z+iz)
	if Result == 1 and Temp_Type == 55 then
		World_Physic_Queue_Add(World_ID, X, Y+1, Z+iz, Current_Trigger_Time, 10)
	end
	local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y-1, Z+iz)
	if Result == 1 and Temp_Type == 55 then
		World_Physic_Queue_Add(World_ID, X, Y-1, Z+iz, Current_Trigger_Time, 10)
	end
	
	local iz = 1
	local Result, Temp_Type = World_Block_Get(World_ID, X, Y, Z+iz)
	if Result == 1 and Temp_Type == 0 then
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X-1, Y, Z+iz)
		if Result == 1 and Temp_Type == 55 then
			World_Physic_Queue_Add(World_ID, X-1, Y, Z+iz, Current_Trigger_Time, 10)
		end
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X+1, Y, Z+iz)
		if Result == 1 and Temp_Type == 55 then
			World_Physic_Queue_Add(World_ID, X+1, Y, Z+iz, Current_Trigger_Time, 10)
		end
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y+1, Z+iz)
		if Result == 1 and Temp_Type == 55 then
			World_Physic_Queue_Add(World_ID, X, Y+1, Z+iz, Current_Trigger_Time, 10)
		end
		local Result, Temp_Type, Temp_Metadata = World_Block_Get(World_ID, X, Y-1, Z+iz)
		if Result == 1 and Temp_Type == 55 then
			World_Physic_Queue_Add(World_ID, X, Y-1, Z+iz, Current_Trigger_Time, 10)
		end
	end
end

function Physic_Redstone_Helper_Delete(Network_Client_ID, World_ID, X, Y, Z, Face, State, Type, Metadata)
	World_Block_Set(World_ID, X, Y, Z, 0, 0, -1, -1, -1, 2, 1, 1)
	
	if Type == 55 then
		Physic_Redstone_Helper_Wire_Activator(World_ID, X, Y, Z, 0)
		Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, -1, 1, 1, 0)
	else
		Physic_Redstone_Helper_Block_Activator(World_ID, X, Y, Z, -1, 1, 1, 0)
	end
end