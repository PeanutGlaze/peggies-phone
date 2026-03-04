if SERVER then return end

include("peggies_phone.lua")

function phone_var:start_conquer_game(ply)
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
		self:fill_screen(0)
	end

	self.right_button = self.nav_bar:Add("DButton")
	self.right_button:Dock(RIGHT)
	self.right_button:SetWide(self.screen:GetWide()/3)
	self.right_button:SetText("Manage")
	self.right_button:SetTextColor(Color(0, 0, 0))
	self.right_button.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125))
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(175, 175, 175))
	end
	self.right_button.DoClick = function()
		self:fill_screen(1)
	end

	self.mid_button = self.nav_bar:Add("DButton")
	self.mid_button:Dock(FILL)
	self.mid_button:SetText("Develop")
	self.mid_button:SetTextColor(Color(0, 0, 0))
	self.mid_button.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125))
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(175, 175, 175))
	end
	self.mid_button.DoClick = function()
		self:fill_screen(2)
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
		draw.SimpleText("Res1: " .. "0", "DefaultSmall", 12, 12, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	self.res3_info = self.res_bar:Add("DPanel")
	self.res3_info:Dock(RIGHT)
	self.res3_info:SetWide(self.screen:GetWide()/3)
	self.res3_info.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125))
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(175, 175, 175))
		draw.SimpleText("Res3: " .. "0", "DefaultSmall", 12, 12, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	self.res2_info = self.res_bar:Add("DPanel")
	self.res2_info:Dock(FILL)
	self.res2_info.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(125, 125, 125))
		draw.RoundedBox(0, 2, 2, w-4, h-4, Color(175, 175, 175))
		draw.SimpleText("Res2: " .. "0", "DefaultSmall", 12, 12, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	self.playable_screen = self.game_screen:Add("DPanel")
	self.playable_screen:Dock(FILL)
	self.playable_screen.Paint = function(s, w, h) end
end

function phone_var:fill_screen(window_type)
	if not IsValid(self.game_screen) == 1 then return end
end