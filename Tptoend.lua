-- 🕒 Wait for game and player to fully load
if not game:IsLoaded() then
    game.Loaded:Wait()
end
repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.PlayerGui:FindFirstChild("LoadingScreenPrefab") == nil

-- 🔥 Auto-end screen skip
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("EndDecision"):FireServer(false)

-- 🧊 Anchor player before moving
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
wait(0.5)

-- 📍 Move to initial position
repeat task.wait()
	game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
	wait(0.5)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(80, 3, -9000)
until workspace.RuntimeItems:FindFirstChild("MaximGun")

-- 🧠 Activate the MaximGun
wait(0.3)
for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
	if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
		v.VehicleSeat.Disabled = false
		v.VehicleSeat:SetAttribute("Disabled", false)
		v.VehicleSeat:Sit(game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"))
	end
end

-- 🔄 Retry sit if needed
wait(0.5)
for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
	if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.VehicleSeat.Position).Magnitude < 400 then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
	end
end

wait(1)
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Sit == true
wait(0.5)
game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Sit = false
wait(0.5)

-- 🔁 Make sure sit is solid
repeat task.wait()
	for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
		if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.VehicleSeat.Position).Magnitude < 400 then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
		end
	end
until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Sit == true

-- 🚂 Tween to train conductor seat if available
wait(0.9)
for i, v in pairs(workspace:GetChildren()) do
	if v:IsA("Model") and v:FindFirstChild("RequiredComponents") then
		if v.RequiredComponents:FindFirstChild("Controls") 
			and v.RequiredComponents.Controls:FindFirstChild("ConductorSeat") 
			and v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat") then

			local TpTrain = game:GetService("TweenService"):Create(
				game.Players.LocalPlayer.Character.HumanoidRootPart,
				TweenInfo.new(25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
				{CFrame = v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat").CFrame * CFrame.new(0, 20, 0)}
			)
			TpTrain:Play()

			-- 🧲 Attach velocity control
			if game.Players.LocalPlayer.Character 
			and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") 
			and game.Players.LocalPlayer.Character.Humanoid.RootPart 
			and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil then
				local bv = Instance.new("BodyVelocity")
				bv.Name = "VelocityHandler"
				bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
				bv.MaxForce = Vector3.new(100000, 100000, 100000)
				bv.Velocity = Vector3.new(0, 0, 0)
			end

			TpTrain.Completed:Wait()
		end
	end
end

-- 🏁 🚀 GO STRAIGHT TO END
wait(1)
while true do
	if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Sit == true then
		local TpEnd = game:GetService("TweenService"):Create(
			game.Players.LocalPlayer.Character.HumanoidRootPart,
			TweenInfo.new(17, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{CFrame = CFrame.new(-328, 28, -49040)} -- 🌟 Final End Position
		)
		TpEnd:Play()

		-- 🧲 Add BodyVelocity temporarily for smoothness
		if game.Players.LocalPlayer.Character 
		and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") 
		and game.Players.LocalPlayer.Character.Humanoid.RootPart 
		and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil then
			local bv = Instance.new("BodyVelocity")
			bv.Name = "VelocityHandler"
			bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
			bv.MaxForce = Vector3.new(100000, 100000, 100000)
			bv.Velocity = Vector3.new(0, 0, 0)
		end

		TpEnd.Completed:Wait()

		-- 🔓 REMOVE BodyVelocity so you can walk again!
		local vh = game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler")
		if vh then
			vh:Destroy()
		end

		break -- ✅ DONE
	end
	task.wait()
end
