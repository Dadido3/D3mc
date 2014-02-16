local Height_Solid = 0
local Height_Water = 41
local Height_Sand = 42
local Height_Grass = 100

function Mapfill_normal(World_ID, Chunk_X, Chunk_Y, Seed, Generation_State)
	local Chunk_Size = 16
	local Offset_X = Chunk_X * Chunk_Size -- in Blocks
	local Offset_Y = Chunk_Y * Chunk_Size -- in Blocks
	
	Start_Time = os.clock()
	
	if Generation_State == 1 then
		local Heightmap = Mapfill_Heightmap_Fractal(Chunk_X, Chunk_Y, 8, 4, 1, Seed)
		local Roughtmap = Mapfill_Heightmap_Fractal(Chunk_X+1, Chunk_Y+1, 2, 1, 0.5, Seed+1)
		local Offsetmap = Mapfill_Heightmap_Fractal(Chunk_X+1, Chunk_Y+1, 8, 1, 0.2, Seed+2)
		
		-- Build the chunk
		for ix = 0, Chunk_Size-1 do
			for iy = 0, Chunk_Size-1 do
				
				local Offset = (math.cos(Offsetmap[ix][iy]*12+2)-1+2*Offsetmap[ix][iy]*6)*7
				
				local Height = math.floor(Offset + Heightmap[ix][iy]*Roughtmap[ix][iy]*50)
				local Stone_Height = math.floor(Height - (0.6-Offsetmap[ix][iy]*Roughtmap[ix][iy])*20)
				
				local Max_Height = math.max(0, Height, Height_Water, Stone_Height)
				
				for iz = 0, Max_Height do
					if iz <= Height_Solid then
						World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 7, 0, 0, 0, 0, 0, 0, 0)
					elseif iz <= Height_Water then
						if iz <= Stone_Height then
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 1, 0, 0, 0, 0, 0, 0, 0)
						elseif iz < Height then
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 3, 0, 0, 0, 0, 0, 0, 0)
						elseif iz == Height then
							if iz < Height_Water - 3 then
								World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 13, 0, 0, 0, 0, 0, 0, 0)
							else
								World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 12, 0, 0, 0, 0, 0, 0, 0)
							end
						else
							if iz == Max_Height then
								World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 8, 0, 0, 0, 0, 0, 1, 0)
							else
								World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 8, 0, 0, 0, 0, 0, 0, 0)
							end
						end
					elseif iz <= Height_Sand then
						if iz <= Stone_Height then
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 1, 0, 0, 0, 0, 0, 0, 0)
						elseif iz+1 < Height then
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 3, 0, 0, 0, 0, 0, 0, 0)
						else
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 12, 0, 0, 0, 0, 0, 0, 0)
						end
					elseif iz <= Height_Grass-Roughtmap[ix][iy]*15 then
						if iz <= Stone_Height then
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 1, 0, 0, 0, 0, 0, 0, 0)
						elseif iz < Height then
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 3, 0, 0, 0, 0, 0, 0, 0)
						else
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 2, 0, 0, 0, 0, 0, 0, 0)
							--World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz+1, 59, math.abs(math.sin((Offset_X+ix)/10+(Offset_Y+iy)/12))*3, -1, -1, 0, 0, 0, 0)
						end
					else
						if iz < Stone_Height then
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 1, 0, 0, 0, 0, 0, 0, 0)
						elseif iz == Stone_Height then
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 1, 0, 0, 0, 0, 0, 0, 0)
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz+1, 78, 0, -1, -1, 0, 0, 0, 0)
						elseif iz < Height then
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 3, 0, 0, 0, 0, 0, 0, 0)
						else
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 2, 0, 0, 0, 0, 0, 0, 0)
							World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz+1, 78, 0, -1, -1, 0, 0, 0, 0)
						end
					end
				end
			end
		end
		return 100 -- Next step ONLY if there are neighbours around the chunk
	else-- Build the trees, decoration
		local Heightmap = Mapfill_Heightmap_Fractal(Chunk_X, Chunk_Y, 8, 4, 1, Seed)
		local Roughtmap = Mapfill_Heightmap_Fractal(Chunk_X+1, Chunk_Y+1, 2, 1, 0.5, Seed+1)
		local Offsetmap = Mapfill_Heightmap_Fractal(Chunk_X+1, Chunk_Y+1, 8, 1, 0.2, Seed+2)
		local Treetypemap = Mapfill_Heightmap_Fractal(Chunk_X, Chunk_Y, 8, 1, 0.0, Seed+3)
		local Treetype
		
		-- Some wild grass, flowers
		for i = 1, Treetypemap[7][7]*20 do
			local ix = math.floor(math.random()*(Chunk_Size))
			local iy = math.floor(math.random()*(Chunk_Size))
			
			local Offset = (math.cos(Offsetmap[ix][iy]*12+2)-1+2*Offsetmap[ix][iy]*6)*7
			local Height = math.floor(Offset + Heightmap[ix][iy]*Roughtmap[ix][iy]*50)
			
			local Result, Type, Metadata, Blocklight, Skylight, Player = World_Block_Get(World_ID, Offset_X+ix, Offset_Y+iy, Height)
			if Type == 2 then
				local Deco_Type = math.floor(math.random()*20)
				if Deco_Type == 0 then
					World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, Height+1, 37, 0, -1, -1, 0, 0, 0, 0)
				elseif Deco_Type == 1 then
					World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, Height+1, 38, 0, -1, -1, 0, 0, 0, 0)
				else
					World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, Height+1, 31, 1, -1, -1, 0, 0, 0, 0)
				end
			elseif Type == 8 then
				local Deco_Type = math.floor(math.random()*10)
				if Deco_Type == 0 then
					--World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, Height+1, 111, 0, -1, -1, 0, 0, 0, 0)
				else
				end
			end
		end
		
		-- some trees
		for i = 1, 6 do
			local ix = math.floor(math.random()*(Chunk_Size))
			local iy = math.floor(math.random()*(Chunk_Size))
			
			local Offset = (math.cos(Offsetmap[ix][iy]*12+2)-1+2*Offsetmap[ix][iy]*6)*7
			local Height = math.floor(Offset + Heightmap[ix][iy]*Roughtmap[ix][iy]*50)
			
			if Treetypemap[ix][iy] <= 0.2 then
				Treetype = ""
			elseif Treetypemap[ix][iy] <= 0.4 then
				Treetype = "pine"
			elseif Treetypemap[ix][iy] <= 0.6 then
				Treetype = "birch"
			elseif Treetypemap[ix][iy] <= 0.8 then
				Treetype = "oak"
			else
				Treetype = ""
			end
			
			local Result, Type, Metadata, Blocklight, Skylight, Player = World_Block_Get(World_ID, Offset_X+ix, Offset_Y+iy, Height)
			if Type == 2 then
				Mapfill_Tree(World_ID, Offset_X+ix, Offset_Y+iy, Height+1, 1+math.random(), Treetype)
			end
		end
		return 0 -- Disables any further generation steps
	end
	
	return 0 -- should never be reached
end