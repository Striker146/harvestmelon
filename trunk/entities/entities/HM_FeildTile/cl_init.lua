include('shared.lua')

//Draw. We draw the the model ingame. *NOTE* Things renfdered first are under the others..

function ENT:Draw()
//self.BaseClass.Draw(self) //Overriding rendering, so no BaseClass for you.
self:DrawModel() //Draw the model.
end

function ENT:DrawEntityOutline() //Removes the mouse-over outline.
return
end