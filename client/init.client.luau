local Player = game.Players.LocalPlayer

local ScreenGui = Player.PlayerGui:WaitForChild("ScreenGui")
local Up = ScreenGui.Up
local Down = ScreenGui.Down
local Left = ScreenGui.Left
local Right = ScreenGui.Right
local Undo = ScreenGui.Undo

local Move_remote = game.ReplicatedStorage.Move_remote
local Move_client = game.ReplicatedStorage.Move_client
local Move_undo = game.ReplicatedStorage.Move_undo

Up.Activated:Connect(function()
    Move_remote:FireServer("Up") -- Fires input
end)

Down.Activated:Connect(function()
    Move_remote:FireServer("Down") -- Fires input
end)

Right.Activated:Connect(function()
    Move_remote:FireServer("Right") -- Fires input
end)

Left.Activated:Connect(function()
    Move_remote:FireServer("Left") -- Fires input
end)

Undo.Activated:Connect(function()
    Move_undo:FireServer() 
end)

Move_client.OnClientEvent:Connect(function(Object : Part, New_position : Vector3)
    Object.Position = New_position
end)
