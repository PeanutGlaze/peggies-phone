if SERVER then return end

phone_var = phone_var or {}

function phone_var:create_phone()
	-- Defining some magic numbers:
	local phone_width = ScrW()/7
	local phone_height = ScrH()/2.33

	self.main_frame = vgui.Create("DFrame")
	self.main_frame:SetSize(phone_width, phone_height)
	self.main_frame:SetPos(ScrW()-phone_width-25, ScrH()-phone_height-25)
	self.main_frame:ShowCloseButton(false)
	self.main_frame:SetTitle("")
	self.main_frame:DockPadding(0, 0, 0, 0)
	self.main_frame.Paint = function(s, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(75, 75, 75))
	end

	self.bot_bar = self.main_frame:Add("DPanel")
	self.bot_bar:Dock(BOTTOM)
	self.bot_bar:SetTall(50)
	self.bot_bar.Paint = function(s, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(125, 125, 125))
	end

	self.home_button = self.bot_bar:Add("DButton")
	self.home_button:SetSize(40, 40)
	self.home_button:SetPos(phone_width/2-20, self.home_button:GetY()+5)
	self.home_button:SetText("")
	self.home_button.Paint = function(s, w, h)
		draw.RoundedBox(255, 0, 0, w, h, Color(100, 100, 100))
	end
	self.home_button.DoClick = function()
		phone_var.main_frame:Remove()
	end

	self.screen = self.main_frame:Add("DPanel")
	self.screen:DockMargin(5, 5, 5, 5)
	self.screen:Dock(FILL)
	self.screen.Paint = function(s, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(200, 200, 200))
	end

	self.time_bar = self.screen:Add("DPanel")
	self.time_bar:Dock(TOP)
	self.time_bar:SetTall(20)
	self.time_bar.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(180, 180, 180))
		draw.SimpleText(os.date("%X"), "DefaultSmall", 10, 10, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(os.date("%x"), "DefaultSmall", self.time_bar:GetWide()-10, 10, Color(0, 0, 0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	self.app_icon1 = self.screen:Add("DButton")
	self.app_icon1:SetText("")
	self.app_icon1:SetPos(20, 35)
	self.app_icon1:SetSize(50, 50)
	self.app_icon1.Paint = function(s, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(100, 100, 200))
		draw.SimpleText("C", "CloseCaption_Bold", 18, 23, Color(0, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	self.app_icon1.DoClick = function()
		phone_var:start_conquer_game(LocalPlayer())
	end

	self.main_frame:MakePopup()
end

hook.Add("ShowHelp", "press_f1", function()
	if IsValid(phone_var.main_frame) then 
		phone_var.main_frame:Remove()
		return
	else
		phone_var:create_phone()
	end
end)