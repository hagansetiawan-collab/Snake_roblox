local Snake_test = game.Workspace.Snake_test
local Move_snake = require(game.ReplicatedStorage.Shared.Move_command)
local Head = Snake_test.Head
local Segment1 = Snake_test.Segment1

local Move_history = {} :: {[Player] : {}}

local Move_remote : RemoteEvent = game.ReplicatedStorage.Move_remote
local Move_client : RemoteEvent = game.ReplicatedStorage.Move_client
local Move_undo : RemoteEvent = game.ReplicatedStorage.Move_undo

local function On_join(Player)
    Move_history[`Player{Player.UserId}`] = {}
end

game.Players.PlayerAdded:Connect(On_join)

-- When any button that moves snake is pressed, moves the snake 5 studs to that 
Move_remote.OnServerEvent:Connect(function(Player, Input)
    Move_snake.execute(Head, Input, 5, Move_history[`Player{Player.UserId}`])
    Move_client:FireAllClients(Head, Head.Position)
end)

-- When undo button pressed, check and undo
Move_undo.OnServerEvent:Connect(function(Player)
    local Player_moves = Move_history[`Player{Player.UserId}`]

    if #Player_moves == 0 then return end

    Player_moves[#Player_moves]:Undo()
    
    Move_client:FireAllClients(Head, Head.Position)
end)







