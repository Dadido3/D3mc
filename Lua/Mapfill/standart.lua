function Mapfill_standart(World_ID, Chunk_X, Chunk_Y, Seed, Generation_State)
	for ix = 0, World_Chunk_Size_X-1 do
		for iy = 0, World_Chunk_Size_Y-1 do
			for iz = 0, 5 do
				
				local X = ix + Chunk_X * World_Chunk_Size_X
				local Y = iy + Chunk_Y * World_Chunk_Size_Y
				local Z = iz
				
				if Z == 0 then
					World_Block_Set(World_ID, X, Y, Z, 7, 0, -1, -1, 0, 1, 0, 0)
				elseif Z == 5 then
					World_Block_Set(World_ID, X, Y, Z, 2, 0, -1, -1, 0, 1, 0, 0)
				else
					World_Block_Set(World_ID, X, Y, Z, 3, 0, -1, -1, 0, 1, 0, 0)
				end
				
			end
		end
	end
	
	return 0 -- Disables any further generation steps
end