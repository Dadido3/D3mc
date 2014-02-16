function Mapfill_Quantize(X, Y, Factor)
	return math.floor(X/Factor)*Factor, math.floor(Y/Factor)*Factor
end

function Mapfill_Random(X, Y, Seed)
	local Value = X + Y*1.2345 + Seed*5.6789
	local Value = Value + Value - X
	local Value = Value + Value + Y
	local Value = Value + Value + X * 12.3
	local Value = Value + Value - Y * 45.6
	local Value = Value + math.sin(X*78.9012)+Y + math.cos(Seed*78.9012)
	local Value = Value + math.cos(Y*12.3456)-X + math.sin(Seed*Value+Value+X)
	local Value = Value + math.sin(Y*45.6789)+X + math.cos(Seed*Value+Value-Y)
	return Value - math.floor(Value)
end

function Mapfill_Random_Map(Chunk_X, Chunk_Y, Chunks, Result_Size, Randomness, Seed)
	local Chunk_Size = 16 -- in m
	local Map_Divider = Chunks -- in 1
	local Map_Pos_X, Map_Pos_Y = Mapfill_Quantize(Chunk_X, Chunk_Y, Map_Divider) -- in Chunks
	local Map_Pos_X_m, Map_Pos_Y_m = Map_Pos_X*Chunk_Size, Map_Pos_Y*Chunk_Size -- in m
	local Map_Offset_X, Map_Offset_Y = Chunk_X-Map_Pos_X, Chunk_Y-Map_Pos_Y -- in Chunks
	--local Map_Offset_X_m, Map_Offset_Y_m = Map_Offset_X*Chunk_Size/Result_Size, Map_Offset_Y*Chunk_Size/Result_Size -- in m
	
	local Map = {}
	
	-- Fill it with random start values
	local Size = 1 -- (2x2)
	for ix = 0, Size do
		Map[ix] = {}
		for iy = 0, Size do
			Map[ix][iy] = Mapfill_Random(Map_Pos_X_m + ix*Chunk_Size*Chunks, Map_Pos_Y_m + iy*Chunk_Size*Chunks, Seed)
		end
	end
	
	-- Do the iterations
	while Size < Chunks*Result_Size do
		
		-- Resize the array
		for ix = Size+1, Size*2 do
			Map[ix] = {}
		end
		for ix = Size, 0, -1 do
			for iy = Size, 0, -1 do
				Map[ix*2][iy*2] = Map[ix][iy]
			end
		end
		Size = Size * 2
		
		local Size_Factor = Chunks*Chunk_Size / Size
		
		local Random_Factor = Randomness
		
		-- The diamond step
		for ix = 1, Size, 2 do
			for iy = 1, Size, 2 do
				local Temp_Avg = (Map[ix+1][iy+1] + Map[ix-1][iy+1] + Map[ix+1][iy-1] + Map[ix-1][iy-1]) / 4
				local Temp_Max = math.max(math.abs(Temp_Avg-Map[ix+1][iy+1]), math.abs(Temp_Avg-Map[ix-1][iy+1]), math.abs(Temp_Avg-Map[ix+1][iy-1]), math.abs(Temp_Avg-Map[ix-1][iy-1]))
				Map[ix][iy] = Temp_Avg + ((Mapfill_Random(Map_Pos_X_m + ix*Size_Factor, Map_Pos_Y_m + iy*Size_Factor, Seed)*2-1) * Temp_Max * Random_Factor)
			end
		end
		
		-- The square step
		for ix = 0, Size, 2 do
			for iy = 1, Size, 2 do
				local Temp_Avg = (Map[ix][iy-1] + Map[ix][iy+1]) / 2
				local Temp_Max = math.max(math.abs(Temp_Avg-Map[ix][iy-1]), math.abs(Temp_Avg-Map[ix][iy+1]))
				Map[ix][iy] = Temp_Avg + ((Mapfill_Random(Map_Pos_X_m + ix*Size_Factor, Map_Pos_Y_m + iy*Size_Factor, Seed)*2-1) * Temp_Max * Random_Factor)
			end
		end
		for ix = 1, Size, 2 do
			for iy = 0, Size, 2 do
				local Temp_Avg = (Map[ix-1][iy] + Map[ix+1][iy]) / 2
				local Temp_Max = math.max(math.abs(Temp_Avg-Map[ix-1][iy]), math.abs(Temp_Avg-Map[ix+1][iy]))
				Map[ix][iy] = Temp_Avg + ((Mapfill_Random(Map_Pos_X_m + ix*Size_Factor, Map_Pos_Y_m + iy*Size_Factor, Seed)*2-1) * Temp_Max * Random_Factor)
			end
		end
		
	end
	
	-- Return the Map
	
	local Result = {}
	
	for ix = 0, Result_Size do
		Result[ix] = {}
		for iy = 0, Result_Size do
			Result[ix][iy] = Map[Map_Offset_X*Result_Size+ix][Map_Offset_Y*Result_Size+iy]
		end
	end
	
	return Result
end

function Mapfill_Heightmap_Fractal(Chunk_X, Chunk_Y, Quantisation, It_Per_Chunk, Randomness, Seed)
	local Chunk_Size = 16
	
	-- Fill it with random start values
	local Size = It_Per_Chunk -- (2x2)
	local Heightmap = Mapfill_Random_Map(Chunk_X, Chunk_Y, Quantisation, Size, Randomness, Seed)
	
	-- Do the iterations
	while Size < Chunk_Size do
		
		-- Resize the array
		for ix = Size+1, Size*2 do
			Heightmap[ix] = {}
			--for iy = Size+1, Size*2 do
			--	Heightmap[ix][iy] = 0
			--end
		end
		for ix = Size, 0, -1 do
			for iy = Size, 0, -1 do
				Heightmap[ix*2][iy*2] = Heightmap[ix][iy]
			end
		end
		Size = Size * 2
		
		-- The diamond step
		for ix = 1, Size, 2 do
			for iy = 1, Size, 2 do
				Heightmap[ix][iy] = (Heightmap[ix+1][iy+1] + Heightmap[ix-1][iy+1] + Heightmap[ix+1][iy-1] + Heightmap[ix-1][iy-1]) / 4
			end
		end
		
		-- The square step
		for ix = 0, Size, 2 do
			for iy = 1, Size, 2 do
				Heightmap[ix][iy] = (Heightmap[ix][iy-1] + Heightmap[ix][iy+1]) / 2
			end
		end
		for ix = 1, Size, 2 do
			for iy = 0, Size, 2 do
				Heightmap[ix][iy] = (Heightmap[ix-1][iy] + Heightmap[ix+1][iy]) / 2
			end
		end
	end
	
	-- Return the Heightmap
	
	return Heightmap
end

function Mapfill_Tree(World_ID, X, Y, Z, Size, Type)
	if Type == 'oak' then
		local Block_Size = math.floor(Size * 5)
		if Block_Size > 7 then Block_Size = 7 end
		if Block_Size < 6 then Block_Size = 6 end
		for iz = 0, Block_Size-2 do
			World_Block_Set(World_ID, X, Y, Z+iz, 17, 0, 0, 0, 0, 0, 0, 0)
		end
		local Radius = 0.5
		for iz = Block_Size, Block_Size-4, -1 do
			local Int_Radius = math.ceil(Radius)
			for ix = -Int_Radius, Int_Radius do
				for iy = -Int_Radius, Int_Radius do
					local Dist = math.sqrt(math.pow(ix,2) + math.pow(iy,2))
					if Dist <= Radius then
						local Result, Type = World_Block_Get(World_ID, X+ix, Y+iy, Z+iz)
						if Result and Type == 0 then
							if iz >= Block_Size then
								World_Block_Set(World_ID, X+ix, Y+iy, Z+iz, 18, 0, -1, -1, 0, 1, 1, 0)
							else
								World_Block_Set(World_ID, X+ix, Y+iy, Z+iz, 18, 0, -1, -1, 0, 1, 0, 0)
							end
						end
					end
				end
			end
			if Radius < 2 then
				Radius = Radius + 0.7
			end
		end
	elseif Type == 'birch' then
		local Block_Size = math.floor(Size * 5)
		if Block_Size > 7 then Block_Size = 7 end
		if Block_Size < 6 then Block_Size = 6 end
		for iz = 0, Block_Size-2 do
			World_Block_Set(World_ID, X, Y, Z+iz, 17, 2, 0, 0, 0, 0, 0, 0)
		end
		local Radius = 0.5
		for iz = Block_Size, Block_Size-4, -1 do
			local Int_Radius = math.ceil(Radius)
			for ix = -Int_Radius, Int_Radius do
				for iy = -Int_Radius, Int_Radius do
					local Dist = math.sqrt(math.pow(ix,2) + math.pow(iy,2))
					if Dist <= Radius then
						local Result, Type = World_Block_Get(World_ID, X+ix, Y+iy, Z+iz)
						if Result and Type == 0 then
							if iz >= Block_Size then
								World_Block_Set(World_ID, X+ix, Y+iy, Z+iz, 18, 2, -1, -1, 0, 1, 1, 0)
							else
								World_Block_Set(World_ID, X+ix, Y+iy, Z+iz, 18, 2, -1, -1, 0, 1, 0, 0)
							end
						end
					end
				end
			end
			if Radius < 2 then
				Radius = Radius + 0.7
			end
		end
	elseif Type == 'pine' then
		local Block_Size = math.floor(Size * 7)
		for iz = 0, Block_Size-2 do
			World_Block_Set(World_ID, X, Y, Z+iz, 17, 1, 0, 0, 0, 0, 0, 0)
		end
		local Radius = 0
		local Step = 0
		for iz = Block_Size, 3, -1 do
			for ix = -Radius, Radius do
				for iy = -Radius, Radius do
					if Radius == 0 or ( math.abs(ix) < Radius and math.abs(iy) < Radius ) then
						local Result, Type = World_Block_Get(World_ID, X+ix, Y+iy, Z+iz)
						if Result and Type == 0 then
							if iz >= Block_Size-2 then
								World_Block_Set(World_ID, X+ix, Y+iy, Z+iz, 18, 1, -1, -1, 0, 1, 1, 0)
							else
								World_Block_Set(World_ID, X+ix, Y+iy, Z+iz, 18, 1, -1, -1, 0, 1, 0, 0)
							end
						end
					end
				end
			end
			Step = Step + 1
			if Step == 3 then
				Step = 0
				Radius = Radius - 1
			else
				Radius = Radius + 1
			end
		end
	end
end