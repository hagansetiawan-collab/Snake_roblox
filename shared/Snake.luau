--!strict
local Snake_segment = {}

type Table_snake_segment = {
	Physique : Part,
	Order : number,
}

export type Snake_segment = typeof(setmetatable({}::Table_snake_segment, Snake_segment))

Snake_segment.__index = Snake_segment

function Snake_segment.new(Physique : Part, Order : number):Snake_segment
	local self = setmetatable({}, Snake_segment) :: Snake_segment

	self.Physique = Physique
	self.Order = Order
	return self
end

function Snake_segment:Change_position(New_position : Vector3)
	self.Physique.Position = New_position
end

function Snake_segment:Get_position()
	return self.Physique.Position
end

function Snake_segment:Get_size()
	return self.Physique.Size
end
local Snake = {}

Snake.__index = Snake

type Table_snake = {
	Physique : {Snake_segment},
	Head : Snake_segment,
	Size : number,
}

export type Snake = typeof(setmetatable({}::Table_snake, Snake))

function Snake.new(Model : {Part}): Snake
	local self = setmetatable({}, Snake) :: Snake
	self.Physique = {}
	self.Size = 1

	-- Put the segments in physique table
	
	for i, Part in Model do
		Part.Anchored = true
		self.Physique[i] = Snake_segment.new(Part, i)
	end

	-- Initializes the snake, forms the snake body (Puts each segment in its place)

	for i = 1, #self.Physique do
		if i == 1 then 
			self.Head = self.Physique[i]
			continue
		end
		print(self.Physique)
		self.Physique[i]:Change_position(self.Physique[i - 1]:Get_position() + Vector3.new(0,0,self.Head:Get_size().Z))
		self.Size += 1
	end
	return self
end

function Snake:Change_position(New_position : Vector3, Delay : number)
	-- Stores Positions before moving
	local Original_positions = {} :: {Vector3}

	local function Get_original_positions(): {Vector3}
		local Original_positions = {} :: {Vector3}
		for i, Segment : Snake_segment in ipairs(self.Physique) do
			Original_positions[i] = Segment:Get_position()
		end
		return Original_positions
	end

	-- Move the whole body
 	for i, Segment in ipairs(self.Physique) do
		
		if i == 1 then 
			Original_positions = Get_original_positions()
			self.Physique[i]:Change_position(New_position)
			task.wait(Delay)
		else
			self.Physique[i]:Change_position(Original_positions[i - 1])
			task.wait(Delay)
		end
	end
end

function Snake:Get_position():Vector3
	return self.Head:Get_position()
end

return Snake

	