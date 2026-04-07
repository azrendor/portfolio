local Event = {}
Event.Name = 'Meteor Rain'
Event.Duration = 30
Event.MeteorRate = 2
Event.CurrentEventThread = nil
local _Event = workspace.Event

function Event:Start()
	print('Meteor rain started')
	
	Event.CurrentEventThread = task.spawn(function()
		local timer = 0
		repeat
			timer += 1
			task.wait(1)

			for i = 1, Event.MeteorRate do
				-- Randomize spawn position
				local x, y, z = math.random(-300, 300), 400, math.random(-300, 300)
				local Meteor = game:GetService('ReplicatedStorage').Assets.Meteor:Clone()
				Meteor:SetPrimaryPartCFrame(CFrame.new(x, y, z))
				Meteor.Parent = _Event
				Meteor.Fire:Play()

				-- Calculate time to hit baseplate
				local baseplateY = workspace.Baseplate.Position.Y
				local distance = y - baseplateY
				local speed = 100
				local timeToHit = distance / speed
				task.delay(timeToHit, function()
					if not Meteor then return end
					
					local explosion = Instance.new('Explosion')
					explosion.BlastPressure = math.huge
					explosion.ExplosionType = Enum.ExplosionType.NoCraters
					explosion.BlastRadius = 35
					explosion.Position = Vector3.new(Meteor.PrimaryPart.Position.X, baseplateY, Meteor.PrimaryPart.Position.Z)
					explosion.Parent = workspace
					
					Meteor.Explosion:Play()
					task.wait(Meteor.Explosion.TimeLength)
					Meteor:Destroy()
				end)

				print("Meteor will hit the baseplate in", timeToHit, "seconds.")

				-- Movement logic
				local connection
				connection = game:GetService('RunService').Heartbeat:Connect(function(dt)
					if Meteor and Meteor.PrimaryPart then
						local currentCFrame = Meteor:GetPrimaryPartCFrame()
						Meteor:SetPrimaryPartCFrame(currentCFrame * CFrame.new(0, -speed * dt, 0))
					else
						connection:Disconnect()
					end
				end)
				
				Meteor.Destroying:Once(function()
					if connection then
						connection:Disconnect()
					end
				end)

			end
		until timer == Event.Duration

	end)

end

function Event:End()
	if Event.CurrentEventThread then
		task.cancel(Event.CurrentEventThread)
	end
	
	print('Meteor rain ended.')
end

return Event
