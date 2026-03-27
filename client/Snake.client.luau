-- The player
local Player = game.Players.LocalPlayer

-- Models
local Snake_model = game.Workspace.Snake_test

-- Buttons
local ScreenGui = Player.PlayerGui:WaitForChild("ScreenGui")
local Up = ScreenGui.Up
local Down = ScreenGui.Down
local Left = ScreenGui.Left
local Right = ScreenGui.Right
local Undo = ScreenGui.Undo

-- Remote events
local Moved_to_server = game.ReplicatedStorage.Moved_to_server
local Moved_to_client = game.ReplicatedStorage.Moved_to_client

-- Main

Up.Activated:Connect(function()
    Moved_to_server:FireServer("Up")
end)

Down.Activated:Connect(function()
    Moved_to_server:FireServer("Down")
end)

Left.Activated:Connect(function()
    Moved_to_server:FireServer("Left")
end)

Right.Activated:Connect(function()
    Moved_to_server:FireServer("Right")
end)

-- Replicates positions of the snake to the client
Moved_to_client.OnClientEvent:Connect(function(New_positions)
    local Segments = Snake_model:GetChildren()
    for i, _ in ipairs(Segments) do
        Segments[i].Position = New_positions[i]
    end
end)