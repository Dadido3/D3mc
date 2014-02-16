Lua_Event_Add("Standart_Messages_Login", "Client_Login", 0, "Standart_Messages_Login")
function Standart_Messages_Login(Client_ID, Name)
	Message_Send_2_All("§e"..Name.." logged in")
end

Lua_Event_Add("Standart_Messages_Logout", "Client_Logout", 0, "Standart_Messages_Logout")
function Standart_Messages_Logout(Client_ID, Name)
	Message_Send_2_All("§e"..Name.." logged out")
end

--Lua_Event_Add("Temp_Message", "Timer", 20000, "Temp_Message")
function Temp_Message()
	Message_Send_2_All("§cJust a message to prevent timeouts. Will be changed later")
end