function Mapfill_skyislands(World_ID, Chunk_X, Chunk_Y, Seed, Generation_State)
	local Chunk_Size = 16
	local Offset_X = Chunk_X * Chunk_Size -- in Blocks
	local Offset_Y = Chunk_Y * Chunk_Size -- in Blocks
	
	--local Start_Time = os.clock()
	
	local Heightmap_0 = Mapfill_Heightmap_Fractal(Chunk_X, Chunk_Y, 1, 1, 1, 0)
	local Heightmap_1 = Mapfill_Heightmap_Fractal(Chunk_X, Chunk_Y, 1, 1, 1, 1)
	local Total_Height = Mapfill_Heightmap_Fractal(Chunk_X, Chunk_Y, 4, 1, 0, 1)
	
	local Treetypemap = Mapfill_Heightmap_Fractal(Chunk_X, Chunk_Y, 8, 1, 0.0, 3)
	
	if Generation_State == 1 then
		-- Build the chunk
		for ix = 0, Chunk_Size-1 do
			for iy = 0, Chunk_Size-1 do
				
				local Total_Height = 20 + Total_Height[ix][iy]*60
				local Height_0 = math.floor(Total_Height + Heightmap_0[ix][iy] * 50)
				local Height_1 = math.floor(70 + Heightmap_1[ix][iy] * 15)
				
				for iz = Height_0, Height_1 do
					if iz == Height_1 then
						World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 2, 0, 0, 0, 0, 0, 1, 0)
					else
						World_Block_Set(World_ID, Offset_X+ix, Offset_Y+iy, iz, 3, 0, 0, 0, 0, 0, 0, 0)
					end
				end
			end
		end
		return 100 -- Next step ONLY if there are neighbours around the chunk
	else
		-- Build the trees
		for ix = 0, Chunk_Size-1 do
			for iy = 0, Chunk_Size-1 do
				
				local Total_Height = 20 + Total_Height[ix][iy]*60
				local Height_0 = math.floor(Total_Height + Heightmap_0[ix][iy] * 50)
				local Height_1 = math.floor(70 + Heightmap_1[ix][iy] * 15)
				
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
				
				for iz = Height_0, Height_1 do
					if iz == Height_1 and math.random(40) == 1 then
						Mapfill_Tree(World_ID, Offset_X+ix, Offset_Y+iy, iz+1, 1+math.random(), Treetype)
					end
				end
			end
		end
		--Message_Send_2_All("§eTime to generate the Chunk: "..tostring(math.ceil((os.clock()-Debug_Time)*1000)/1000).."s")
		return 0 -- Disables any further generation steps
	end
	
	return 0 -- should never be reached
end