local Events = {}

for index, event in pairs(script:GetChildren()) do
	if event:IsA("ModuleScript") then
		Events[index] = require(event)
	end
end

return Events
