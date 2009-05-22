include('shared.lua')

//Draw. We draw the the model ingame. *NOTE* Things renfdered first are under the others..

function ENT:Draw()
//self.BaseClass.Draw(self) //Overriding rendering, so no BaseClass for you.
self:DrawModel() //Draw the model.
end

function ENT:DrawEntityOutline() //Removes the mouse-over outline.
return
end

function VendingMenu() --this is temporary, remember to make a function that uses the seed table.
 local VendFrame = vgui.Create("DFrame")
 	VendFrame:SetPos(ScrW() / 2,ScrH() / 2)
	VendFrame:SetSize(100,300)
	VendFrame:SetTitle("Vending Menu")
	VendFrame:SetVisible(true)
	VendFrame:MakePopup()
 
 local VendButtons = vgui.Create("DButton")
	VendButtons:SetParent(VendFrame)
	VendButtons:SetText("Melon Seed")
	VendButtons:SetPos(10, 25)
	VendButtons:SetSize(75, 25)
	VendButtons.DoClick = 	function ()
							Msg("OH GOD THIS ISN'T MADE YET\n")
							tblArgs = {}
							tblArgs[1] = LocalPlayer()
							tblArgs[2] = "seed_melon"
							tblArgs[3] = 1
							player.concommand("HM_VendItem\n")
						end
						
	 local VendButtons = vgui.Create("DButton")
	VendButtons:SetParent(VendFrame)
	VendButtons:SetText("Guwaggle Seed")
	VendButtons:SetPos(10, 55)
	VendButtons:SetSize(75, 25)
	VendButtons.DoClick = 	function ()
							Msg("OH GOD THIS ISN'T MADE YET\n")
						end
						
	 local VendButtons = vgui.Create("DButton")
	VendButtons:SetParent(VendFrame)
	VendButtons:SetText("Baby ..Seed?")
	VendButtons:SetPos(10, 85)
	VendButtons:SetSize(75, 25)
	VendButtons.DoClick = 	function ()
							Msg("OH GOD THIS ISN'T MADE YET\n")
						end
end
usermessage.Hook( "call_vmenu", VendingMenu )