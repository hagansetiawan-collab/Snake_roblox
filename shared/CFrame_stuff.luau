local CFrame_stuff = {}

export type CFrame_stuff = {Get_look_orientation : (Part, boolean)->unknown}


function CFrame_stuff.Get_magnitude(Vector3 : Vector3): number
    local Magnitude = 0

    if Vector3.X ~= 0 then
        Magnitude += Vector3.X
    end

    if Vector3.Y ~= 0 then
        Magnitude += Vector3.Y
    end

    if Vector3.Z ~= 0 then
        Magnitude += Vector3.Z
    end

    Magnitude = math.abs(Magnitude)
    return Magnitude
end

function CFrame_stuff.Move_object(Object : Part, Distance : number, Orientation : string)
    if Orientation == "Front" then
        Object.Position = Object.Position + Vector3.new(Distance, 0,0)
    elseif Orientation == "Back" then
        Object.Position = Object.Position + Vector3.new(-Distance, 0,0)
    elseif Orientation == "Right" then
        Object.Position = Object.Position + Vector3.new(0,0,Distance)
    elseif Orientation == "Left" then
        Object.Position = Object.Position + Vector3.new(0,0,-Distance)
    end
end

--[[
    My own CFrame.LookVector implementation but returns a definite string

    @param Part The part that you want to know which is facing
    

]]

function CFrame_stuff.Get_look_orientation(Part : Part, In_radians : boolean?):unknown
    local _,Y,_ = Part.CFrame:ToOrientation()

    if In_radians then
        if Y  > -0.15 and Y <= 0.15 then
            return 0
    
        elseif Y > 1.4 and Y <= 1.7 then
            return 1.57079633
        
        elseif (Y < -3.0 and Y >= -3.141) or (Y > 3.0 and Y <= 3.141) then
            return 3.14159265
        
        elseif Y < -1.4 and Y >= -1.7 then
            return -1.57079633
        end
        return nil
    end

    if Y  > -0.15 and Y <= 0.15 then
        return "Front"
    
    elseif Y > 1.4 and Y <= 1.7 then
        return "Right"
    
    elseif (Y < -3.0 and Y >= -3.141) or  (Y > 3.0 and Y <= 3.141) then
        return "Back"
    
    elseif Y < -1.4 and Y >= -1.7 then
        return "Left"
    end

    return "Dont know"
end

return CFrame_stuff