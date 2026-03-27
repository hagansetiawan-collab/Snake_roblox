--!strict
-- Implementing a move command just for the head of the snake
-- Will be testing this using normal Parts and see if I can do undo with it (Undoable!)
-- Using the move command history to move the snake segments

local Move_snake = {}
Move_snake.__index = Move_snake

type Table_move_snake = {
    Client : Part,
    Input : string, 
    Distance : number,
    Old_position : Vector3,
    Undo : (Move_snake)->nil,
    _Up : (Move_snake)->nil,
    _Down : (Move_snake)->nil,
    _Left : (Move_snake)->nil,
    _Right : (Move_snake)->nil
}

export type Move_snake = typeof(setmetatable({}::Table_move_snake, Move_snake))

function Move_snake.execute(Client : Part, Input : string, Distance : number, History_table : {}):Move_snake
    local self = setmetatable({}, Move_snake) :: Move_snake
    self.Client = Client
    self.Input = Input
    self.Distance = Distance
    self.Old_position = self.Client.Position

    if Input == "Up" then
        self:_Up()
    elseif Input == "Down" then
        self:_Down()
    elseif Input == "Right" then
        self:_Right()
    elseif Input == "Left" then
        self:_Left()
    end

    function self:Undo() -- Explicit addition : Inside the object because I need the object to be able to remove itself from the table
        self = self :: Move_snake

        for i, Move : Move_snake in ipairs(History_table) do
            if Move ~= self then continue end

            if i ~= #History_table then 
                warn("Cannot undo, not the most recent command.")
                continue
            end

            self.Client.Position = self.Old_position
            table.remove(History_table, #History_table)
            return
        end
        warn("Undo failed.")
        return
    end

    table.insert(History_table, self)

    return self
end 

function Move_snake:_Up()
    self = self :: Move_snake -- Explicit addition : I dont know why it needs this

    self.Client.Position = self.Client.Position + Vector3.new(self.Distance,0,0)
end


function Move_snake:_Down()
    self = self :: Move_snake -- Explicit addition : I dont know why it needs this

    self.Client.Position = self.Client.Position + Vector3.new(-self.Distance,0,0)
end


function Move_snake:_Right()
    self = self :: Move_snake -- Explicit addition : I dont know why it needs this

    self.Client.Position = self.Client.Position + Vector3.new(0,0,self.Distance)
end


function Move_snake:_Left()
    self = self :: Move_snake -- Explicit addition : I dont know why it needs this

    self.Client.Position = self.Client.Position + Vector3.new(0,0,-self.Distance)
end


return Move_snake