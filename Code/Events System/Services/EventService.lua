local Knit = require(game:GetService('ReplicatedStorage').Packages.Knit)
local Events = require(script.Events)

local EventsService = Knit.CreateService{
	Name = 'EventsService',
	Client = {
		EventStarted = Knit.CreateSignal(),
		EventEnded = Knit.CreateSignal()
	}
}

function EventsService:StartEvent(eventName)
	local currentEvent
	for _, event in pairs(Events) do
		if event.Name == eventName then
			currentEvent = event
			break
		end
	end
	print('Starting event:', currentEvent.Name)
	
	
	currentEvent:Start()
	self.Client.EventStarted:FireAll(currentEvent.Name, currentEvent.Duration)
	
	task.delay(currentEvent.Duration, function()
		self:EndEvent(currentEvent)
	end)
end

function EventsService:EndEvent(event)
	print('Ending event:', event.Name)
	
	self.Client.EventEnded:FireAll(event.Name, event.Duration)
	event:End()
end

function EventsService:KnitStart()
	local availableEvents = #Events
	local randomEvent = Events[Random.new():NextInteger(1, availableEvents)]
	task.wait(5)
	self:StartEvent(randomEvent.Name)
end

return EventsService
