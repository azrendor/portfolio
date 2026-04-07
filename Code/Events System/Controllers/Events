local Knit = require(game:GetService('ReplicatedStorage').Packages.Knit)
local MainGui = game:GetService('Players').LocalPlayer.PlayerGui:WaitForChild('Main')
local EventText = MainGui.EventFrame.EventText

local EventsController = Knit.CreateController {
	Name = 'EventsController',
}

local function Typewrite(textLabel, text, speed, toEmpty)
	local sound = game.ReplicatedStorage.Assets.Typewrite:Clone()
	sound.Parent = workspace
	
	if toEmpty then
		local currentText = textLabel.Text
		for i = #currentText, 1, -1 do
			sound:Play()
			textLabel.Text = currentText:sub(1, i - 1)
			task.wait(speed)
		end
		task.wait(0.5)
		
		return
	end

	for i = 1, #text do
		sound:Play()
		textLabel.Text = text:sub(1, i)
		task.wait(speed)
	end
	
	sound:Destroy()
end


function EventsController:KnitStart()

	local EventsService = Knit.GetService('EventsService')

	EventsService.EventStarted:Connect(function(eventName, eventDuration)
		print(`Event started on Client: {eventName}, {eventDuration}`)
		EventText.Visible = true
		EventText.Text = Typewrite(EventText, `{eventName}\n{eventDuration}s`, 0.05, false)
	end)

	EventsService.EventEnded:Connect(function(eventName, eventDuration)
		print(`Event ended on Client: {eventName}, {eventDuration}`)
		EventText.Text = Typewrite(EventText, `{eventName}\n{eventDuration}s`, 0.05, true)

	end)
end

return EventsController
