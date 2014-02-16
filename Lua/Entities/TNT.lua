function Entity_TNT(Entity_ID)
	local World_ID = Entity_Get_World(Entity_ID)
	local X, Y, Z = Entity_Get_Position(Entity_ID)
	
	Entity_Delete(Entity_ID)
	World_Effect_Explosion(World_ID, X, Y, Z, 10)
	World_Effect_Sound(World_ID, "random.explode", X+0.5, Y+0.5, Z+0.5, 1, 1)
end