if SERVER then return end

include("peggies_phone.lua")

cg_save_data = save_data or {}

function phone_var:start_conquer_game()
	cg_save_data:load_save_game()
	self:create_game_ui()
	self:refresh_game_screen()
end

function cg_save_data:load_save_game()
	if not file.Exists("conquer_game", "DATA") then file.CreateDir("conquer_game") end
	
	local player_id = LocalPlayer():SteamID64()
	local file_path = ("conquer_game/save_data_for_%s.txt"):format(string.Trim(player_id))

	-- create fresh save file if the player doesn't have a save file
	if !file.Exists(file_path, "DATA") then
		file.Write(file_path,
			"@R\n" ..
			"1000\n" ..
			"1000\n" ..
			"1000\n" ..
			"@P\n" ..
			"5\n" ..
			"1\n" ..
			"@P\n" ..
			"4\n" ..
			"1\n" ..
			"@P\n" ..
			"4\n" ..
			"1")
	end

	-- fetching save file content:
	local player_file = file.Read(file_path, "DATA")
	local lines = string.Explode("\n", player_file)

	-- setting up variables needed to read out file content:
	local read_res = false
	local read_per = false
	local skip = false
	local temp
	local res_table = {}
	self.per_table = {}

	for _, v in pairs(lines) do

		if v == "@R" then
			read_res = true
			continue
		elseif v == "@P" then
			read_res = false
			read_per = true
			continue
		end

		if read_res == true then
			table.insert(res_table, v)
		elseif read_per == true then
			if skip == false then
				temp = v
				skip = true
				continue
			elseif skip == true then
				table.Add(self.per_table, {{strength = temp, level = v}})
				skip = false
				continue
			end
		end
	end

	self.fuel = tonumber(string.Trim(res_table[1], "\n"))
	self.metal = tonumber(string.Trim(res_table[2], "\n"))
	self.money = tonumber(string.Trim(res_table[3], "\n"))
end

function cg_save_data:save_game()
	local player_id = LocalPlayer():SteamID64()
	local file_path = ("conquer_game/save_data_for_%s.txt"):format(string.Trim(player_id))

	local res_string = "@R\n" ..
		self.fuel .. "\n" ..
		self.metal .. "\n" ..
		self.money .. "\n"

	local per_string = ""
	for _, sub_table in pairs(self.per_table) do
		per_string = per_string .. "@P\n" .. sub_table.strength .. "\n" .. sub_table.level .. "\n"
	end

	file.Write(file_path, res_string .. per_string)
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

	-- Change the home button so it brings you back to the home-screen instead of closing:
	self.home_button.DoClick = function()
		cg_save_data:save_game()
		self.game_screen:Remove()
		self.home_button.DoClick = function()
			phone_var.main_frame:Remove()
		end
	end
end

function phone_var:refresh_game_screen(window_type)
	if !IsValid(self.game_screen) then return end

	if IsValid(self.playable_screen) then self.playable_screen:Remove() end

	self.playable_screen = self.game_screen:Add("DPanel")
	self.playable_screen:Dock(FILL)
	self.playable_screen.Paint = nil

	if window_type == 2 then
		self.left_list = self.playable_screen:Add("DPanel")
		self.left_list:Dock(LEFT)
		self.left_list:SetWide(self.game_screen:GetWide()/2+1)
		self.left_list.Paint = nil

		self.right_list = self.playable_screen:Add("DPanel")
		self.right_list:Dock(RIGHT)
		self.right_list:SetWide(self.game_screen:GetWide()/2)
		self.right_list.Paint = nil

		local counter = 1
		for k, v in pairs(cg_save_data.per_table) do
			self.person = vgui.Create("DPanel")
			self.person:Dock(TOP)
			self.person:SetTall(self.game_screen:GetTall()/11.1)
			self.person.Paint = function (s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125))
				draw.RoundedBox(0, 2, 2, w-4, h-4, Color(175, 175, 175))
				draw.SimpleText(k, "CloseCaption_Bold", 12, self.person:GetTall()/2-3, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText("Base Strength: " .. v.strength, "Trebuchet18", self.person:GetWide()/8*7, self.person:GetTall()/4+5, Color(0, 0, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				draw.SimpleText("Level: " .. v.level, "Trebuchet18", self.person:GetWide()/8*7, self.person:GetTall()/4*3-5, Color(0, 0, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
			if counter % 2 == 1 then
				self.person:SetParent(self.left_list)
			else
				self.person:SetParent(self.right_list)
			end
			counter = counter + 1
		end
	end
end