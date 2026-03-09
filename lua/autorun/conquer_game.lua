if SERVER then return end

include("peggies_phone.lua")

cg_save_data = save_data or {}

function phone_var:start_conquer_game(ply)
	cg_save_data:load_save_game(ply)
	self:create_game_ui()
	self:refresh_game_screen(0)
end

function cg_save_data:load_save_game(ply)
	if not file.Exists("conquer_game", "DATA") then file.CreateDir("conquer_game") end

	local player_id = ply:SteamID64()
	local file_path = ("conquer_game/save_data_for_%s.txt"):format(string.Trim(player_id))

	-- create fresh save file if the player doesn't have a save file
	if !file.Exists(file_path, "DATA") then
		file.Write(file_path,
			"@R\n" ..
			"11\n" ..
			"22\n" ..
			"33\n" ..
			"@P\n" ..
			"5\n" ..
			"1\n" ..
			"@P\n" ..
			"4\n" ..
			"1")
	end

	local player_file = file.Read(file_path, "DATA")
	local lines = string.Explode("\n", player_file)
	local read_res = false
	local read_per = false
	local skip = false
	local temp
	self.res_table = {}
	self.per_table = {}

	for k, v in pairs(lines) do

		if v == "@R" then
			read_res = true
			continue
		elseif v == "@P" then
			read_res = false
			read_per = true
			continue
		end

		if read_res == true then
			table.insert(self.res_table, v)
		elseif read_per == true then
			if skip == false then
				temp = v
				skip = true
				continue
			elseif skip == true then
				table.Add(self.per_table, {{temp, v}})
				skip = false
				continue
			end
		end
	end

	self.fuel = tonumber(string.Trim(self.res_table[1], "\n"))
	self.metal = tonumber(string.Trim(self.res_table[2], "\n"))
	self.money = tonumber(string.Trim(self.res_table[3], "\n"))
end

function cg_save_data:save_game()

	local res_string = "@R\n" ..
		self.res_table[1] .. "\n" ..
		self.res_table[2] .. "\n" ..
		self.res_table[3] .. "\n"

	local per_string = ""
	for k, sub_table in pairs(self.per_table) do
		per_string = per_string .. "@P\n" .. sub_table[1] .. "\n" .. sub_table[2] .. "\n"
	end

	file.Write("conquer_game/test_save.txt", res_string .. per_string)
end

function phone_var:create_game_ui()
	if not IsValid(self.screen) == 1 then return end

	self.game_screen = self.screen:Add("DPanel")
	self.game_screen:Dock(FILL)
	self.game_screen.Paint = function(s, w, h) end

	self.nav_bar = self.game_screen:Add("DPanel")
	self.nav_bar:Dock(BOTTOM)
	self.nav_bar:SetTall(self.screen:GetTall()/15)
	self.nav_bar.Paint = function(s, w, h) end

	self.left_button = self.nav_bar:Add("DButton")
	self.left_button:Dock(LEFT)
	self.left_button:SetWide(self.screen:GetWide()/3)
	self.left_button:SetText("Attack")
	self.left_button:SetTextColor(Color(0, 0, 0))
	self.left_button.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125))
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(175, 175, 175))
	end
	self.left_button.DoClick = function()
		self:refresh_game_screen(0)
	end

	self.mid_button = self.nav_bar:Add("DButton")
	self.mid_button:Dock(LEFT)
	self.mid_button:SetWide(self.screen:GetWide()/3)
	self.mid_button:SetText("Develop")
	self.mid_button:SetTextColor(Color(0, 0, 0))
	self.mid_button.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125))
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(175, 175, 175))
	end
	self.mid_button.DoClick = function()
		self:refresh_game_screen(1)
	end

	self.right_button = self.nav_bar:Add("DButton")
	self.right_button:Dock(FILL)
	self.right_button:SetText("Manage")
	self.right_button:SetTextColor(Color(0, 0, 0))
	self.right_button.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125))
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(175, 175, 175))
	end
	self.right_button.DoClick = function()
		self:refresh_game_screen(2)
	end

	self.res_bar = self.game_screen:Add("DPanel")
	self.res_bar:Dock(TOP)
	self.res_bar:SetTall(self.screen:GetTall()/23)
	self.res_bar.Paint = function(s, w, h) end

	self.res1_info = self.res_bar:Add("DPanel")
	self.res1_info:Dock(LEFT)
	self.res1_info:SetWide(self.screen:GetWide()/3)
	self.res1_info.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125))
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(175, 175, 175))
		draw.SimpleText("Fuel: " .. tostring(cg_save_data.fuel), "DefaultSmall", 12, 12, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	self.res2_info = self.res_bar:Add("DPanel")
	self.res2_info:Dock(LEFT)
	self.res2_info:SetWide(self.screen:GetWide()/3)
	self.res2_info.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125))
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(175, 175, 175))
		draw.SimpleText("Metal: " .. tostring(cg_save_data.metal), "DefaultSmall", 12, 12, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	self.res3_info = self.res_bar:Add("DPanel")
	self.res3_info:Dock(FILL)
	self.res3_info.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125))
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(175, 175, 175))
		draw.SimpleText("$€: " .. tostring(cg_save_data.money), "DefaultSmall", 12, 12, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	self.home_button.DoClick = function()
		cg_save_data:save_game()
		self.game_screen:Remove()
		self.home_button.DoClick = function()
			phone_var.main_frame:Remove()
		end
	end
end

function phone_var:refresh_game_screen(window_type)
	if not IsValid(self.game_screen) == 1 then return end

	if IsValid(self.playable_screen) then self.playable_screen:Remove() end

	self.playable_screen = self.game_screen:Add("DPanel")
	self.playable_screen:Dock(FILL)
end