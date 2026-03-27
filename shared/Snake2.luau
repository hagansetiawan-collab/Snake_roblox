--!strict
local Snake_segment = {}

type Table_snake_segment = {
	Physique : Part,
	Order : number,
    Change_postion : (Snake_segment, Vector3)->Vector3,
    Get_position : (Snake_segment)->Vector3,
    Get_size : (Snake_segment)->Vector3
}

export type Snake_segment = typeof(setmetatable({}::Table_snake_segment, Snake_segment))

Snake_segment.__index = Snake_segment

function Snake_segment.new(Physique : Part, Order : number):Snake_segment
	local self = setmetatable({}, Snake_segment) :: Snake_segment

	self.Physique = Physique
	self.Order = Order
	return self
end

function Snake_segment:Change_position(New_position : Vector3):Vector3
    local Original_position = self.Physique.Position
	self.Physique.Position = New_position
    return Original_position
end

function Snake_segment:Get_position()
	return self.Physique.Position
end

function Snake_segment:Get_size()
	return self.Physique.Size
end

    local Move_snake = {} -- Move command, indent for internal class
    Move_snake.__index = Move_snake

    type Table_move_snake = {
        Client : Snake_segment,
        Input : string, 
        Distance : number,
        Old_position : Vector3,
        New_position : Vector3,
        Undo : (Move_snake)->nil,
        Redo : (Move_snake, Snake_segment)->nil,
        _Up : (Move_snake)->nil,
        _Down : (Move_snake)->nil,
        _Left : (Move_snake)->nil,
        _Right : (Move_snake)->nil
    }

    export type Move_snake = typeof(setmetatable({}::Table_move_snake, Move_snake))

    function Move_snake.execute(Client : Snake_segment, Input : string, Distance : number, History_table : {}):Move_snake
        local self = setmetatable({}, Move_snake) :: Move_snake
        self.Input = Input
        self.Distance = Distance
        self.Old_position = Client:Get_position() 
        self.Client = Client

        if Input == "Up" then
            self:_Up()
        elseif Input == "Down" then
            self:_Down()
        elseif Input == "Right" then
            self:_Right()
        elseif Input == "Left" then
            self:_Left()
        end

        self.New_position = Client:Get_position()
        function self:Undo() -- Explicit addition : Inside the object because I need the object to be able to remove itself from the table
            self = self :: Move_snake

            for i, Move : Move_snake in ipairs(History_table) do
                if Move ~= self then continue end

                if i ~= #History_table then 
                    warn("Cannot undo, not the most recent command.")
                    continue
                end

                Client:Change_position(self.Old_position) 
                table.remove(History_table, #History_table)
                return
            end
            warn("Undo failed.")
            return
        end

        function self:Redo(To_client : Snake_segment) -- Explicit addition : Might change this, for right now im just focusing on trying to make snake
           
            self = self :: Move_snake 

            To_client:Change_position(self.New_position)
            return
        end



        table.insert(History_table, self)

        return self
    end 

    function Move_snake:_Up()
        self = self :: Move_snake -- Explicit addition : I dont know why it needs this

        self.Client:Change_position(self.Client:Get_position() + Vector3.new(self.Distance,0,0))
    end


    function Move_snake:_Down()
        self = self :: Move_snake -- Explicit addition : I dont know why it needs this

        self.Client:Change_position(self.Client:Get_position() + Vector3.new(-self.Distance,0,0))
    end


    function Move_snake:_Right()
        self = self :: Move_snake -- Explicit addition : I dont know why it needs this

        self.Client:Change_position(self.Client:Get_position() + Vector3.new(0,0,self.Distance))
    end


    function Move_snake:_Left()
        self = self :: Move_snake -- Explicit addition : I dont know why it needs this

        self.Client:Change_position(self.Client:Get_position() + Vector3.new(0,0,-self.Distance))
    end


local Snake = {}
Snake.__index = Snake

type Table_snake = {
    Physique : {Snake_segment},
    Snake_model : {Part},
    Head : Snake_segment,
    Forming_delay : number,
    Size : number,
    Get_position : (Snake)->Vector3,
    Move_up : (Snake)->nil,
    Move_down : (Snake)->nil,
    Move_right : (Snake)->nil,
    Move_left : (Snake)->nil,
    _Initialize_physique : (Snake)->nil,
    _Initialize_segments : (Snake)->nil,
}

export type Snake = typeof(setmetatable({}::Table_snake, Snake))

function Snake.new(Snake_model : {Part}, Forming_delay : number, History_table : {Move_snake}):Snake
    local self = setmetatable({}, Snake) :: Snake
    self.Snake_model = Snake_model
    self.Physique = {}
    self.Forming_delay = Forming_delay
    self.Size = 0

    self:_Initialize_physique()

    self:_Initialize_segments()

    for i, Segment : Snake_segment in ipairs(self.Physique) do -- Initializes the Move history based on snake size
        Move_snake.execute(Segment,"Up",10, History_table)
    end 

    function self:Move_up()
        for i,Segment : Snake_segment in ipairs(self.Physique) do
            if i == 1 then 
                Move_snake.execute(Segment, "Up", 10, History_table)
                continue
            end

            History_table[#History_table - i]:Redo(Segment) 
        end
        table.remove(History_table,1)
        return
    end

    function self:Move_down()
        for i,Segment : Snake_segment in ipairs(self.Physique) do
            if i == 1 then 
                Move_snake.execute(Segment, "Down", 10, History_table)
                continue
            end

            History_table[#History_table - i]:Redo(Segment) 
            
        end
        table.remove(History_table,1)
        return
    end

    function self:Move_left()
        for i,Segment : Snake_segment in ipairs(self.Physique) do
            if i == 1 then 
                Move_snake.execute(Segment, "Left", 10, History_table)
                continue
            end

            History_table[#History_table - i]:Redo(Segment) 
            
        end
        table.remove(History_table,1)
        return
    end

    function self:Move_right()
        for i,Segment : Snake_segment in ipairs(self.Physique) do
            if i == 1 then 
                Move_snake.execute(Segment, "Right", 10, History_table)
                continue
            end

            History_table[#History_table - i]:Redo(Segment) 
            
        end
        table.remove(History_table,1)
        return
    end

    return self
end

function Snake:_Initialize_physique()
    self = self :: Snake
    for i, Part in ipairs(self.Snake_model) do

        if i == 1 then
            self.Head = Snake_segment.new(Part,i)
            self.Physique[i] = self.Head
            self.Size += 1
            continue
        end

        self.Physique[i] = Snake_segment.new(Part, i)
        self.Size += 1
    end
end


function Snake:_Initialize_segments()
    self = self :: Snake
    for i, Segment : Snake_segment in ipairs(self.Physique) do
        if i == 1 then continue end

        Segment:Change_position(self.Physique[i-1]:Get_position() - Vector3.new(-self.Head:Get_size().X,0,0))
        task.wait(self.Forming_delay)
    end
end

function Snake:Get_position():Vector3
    return self.Head:Get_position()
end
return Snake
