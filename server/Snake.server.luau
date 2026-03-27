-- Modules
local Snake_module = require(game.ReplicatedStorage.Shared.Snake2)

-- Models
local Snake_model = game.Workspace.Snake_test

-- Tables 

-- The keys are player userIds and the values are history tables filled with Move objects
local History_tables = {} :: {[number] : {Snake_module.Move_snake}}

-- Objects
local Snake = Snake_module.new(Snake_model:GetChildren(), 0.5, History_tables)

-- Remote events
local Moved_to_server = game.ReplicatedStorage.Moved_to_server
local Moved_to_client = game.ReplicatedStorage.Moved_to_client

-- Main

Moved_to_server.OnServerEvent:Connect(function(Player : Player, Input : string)
    if Input == "Up" then
        Snake:Move_up()
    elseif Input == "Down" then
        Snake:Move_down()
    elseif Input == "Left" then
        Snake:Move_left()
    elseif Input == "Right" then
        Snake:Move_right()
    end

    -- Table that has the new segments to extract the positions out of
    local New_positions = {} :: {Vector3}
    for _, Physique in ipairs(Snake.Physique) do
        table.insert(New_positions, Physique:Get_position())
    end
    Moved_to_client:FireClient(Player, New_positions)
end)

