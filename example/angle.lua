local Object = require 'nclassic'

local Angle = Object:extend('angle')
-- the radix is the number of digits to represent after the radix point
-- defaulted to 0 so an integer is seen by default
Angle.radix     = 0

-- the contained angle value will always be a degree value
-- thus, we will need a variable to check
-- wether or not to cast it as radians when 
-- calling the __tostring method, or for a couple of other
-- things this class does
Angle.asradians = false

-- for the new function that is called. This can act as a constructor
-- or a complete reset of the resulting object
--
-- by the __call function, we'll give it 3
-- parameters
-- @param angle = the value, can be an Angle or number value
-- @param asRad = boolean that checks wether or not to make this
--                a radian
-- @param radix = the muffhuggin radix, bro
function Angle:new(angle, asRad, radix)
    angle = angle or 0.0
    asRad = asRad or false
    radix = radix or 0

    if asRad then
        -- use it's own 'is' to check the angle, in case it is not an Angle
        -- since we want a radian from this, we'll set 'asradians' to true
        if self.is(angle, Angle) then
            self.angle     = angle.angle
            self.radix     = angle.radix
            self.asradians = true
        
        -- set it to the defaults of a radian
        -- a radian's default radix is 2. that way if say, the angle is 180
        -- we'll see only 2 digits of pi. If you want different, dewit
        elseif type(angle) == 'number' then
            self.angle     = angle * (180 / math.pi)
            self.radix     = 2
            self.asradians = true
        end
    else
        -- do the same as above, but copy everything from the angle
        if self.is(angle, Angle) then
            self:fields(angle)
        
        -- else, set to the default values given
        elseif type(angle) == 'number' then
            self.angle     = angle
            self.radix     = radix
        end
    end
end

-- get value as is, to be fair
function Angle:asDegrees()
    return self.angle
end

-- get value cast to radians
function Angle:asRadians()
    return self.angle * math.pi / 180
end

-- this class, and resulting objects, are also essentially factories
-- produce a degree
function Angle:degrees(angle)    
    return Angle(angle)
end

-- produce a radian
function Angle:radians(angle)   
    return Angle(angle, true)
end

-- We can do some cool stuff with metatables in 5.4, this was something I only recently found out
-- For instance, we can do operator overloads, like in c++!
-- So, lets do some arithimatic and comparison overloads. The type of the resulting Angle should
-- be of the lvalue's radix and type

function Angle:__add(angle)
    if self.is(angle, Angle) then
        local o = Angle(self.angle + angle.angle)
        o.radix     = self.radix
        o.asradians = self.asradians
        return o

    elseif type(value) == 'number' then
        local o = Angle(self.angle + angle)
        o.radix     = self.radix
        o.asradians = self.asradians
        return o
    else
        error(string.format("bad argument #1 to 'add' (angle or number expected, got %s)" , type(angle)))
    end
end

function Angle:__sub(angle)
    if self.is(angle, Angle) then
        local o = Angle(self.angle - angle.angle)
        o.asradians = self.asradians
        o.radix = self.radix
        return o

    elseif type(value) == 'number' then
        local o = Angle(self.angle - angle)
        o.asradians = self.asradians
        o.radix = self.radix
        return o
    else
        error(string.format("bad argument #1 to 'sub' (angle or number expecetd, got %s)", type(angle)))
    end
end

function Angle:__mul(angle)
    if self.is(angle, Angle) then
        local o     = Angle(self.angle * angle.angle, self.asradians)
        o.asradians = self.asradians
        o.radix     = self.radix

    elseif type(value) == 'number' then
        local o     = Angle(self.angle * angle)
        o.asradians = self.asradians
        o.radix     = self.radix
        return o
    else
        error(string.format("bad argument #1 to 'sub' (angle or number expecetd, got %s)", type(angle)))
    end
end

function Angle:__div(angle)
    if self.is(angle, Angle) then
        local o     = Angle(self.angle / angle.angle)
        o.asradians = self.asradians
        o.radix     = self.radix
        return o

    elseif type(value) == 'number' then
        local o     = Angle(self.angle / angle)
        o.asradians = self.asradians
        o.radix     = self.radix
        return o
    else
        error(string.format("bad argument #1 to 'sub' (angle or number expecetd, got %s)", type(angle)))
    end
end

-- these just require boolean returns
-- so check against angles, numbers, and specify for if 
-- we should check against radians or degrees
function Angle:__lt(angle)
    if self.is(angle, Angle) then
        return self.angle < angle.angle

    elseif type(value) == 'number' then
        if self.asradians then
            return self:asRadians() < number
        else 
            return self.angle < angle
        end
    else
        return false
    end
end

function Angle:__le(angle)
    if self.is(angle, Angle) then
        return self.angle <= angle.angle

    elseif type(value) == 'number' then
        if self.asradians then
            return self:asRadians() <= number
        else
            return self.angle <= angle
        end
    else
        return false
    end
end


function Angle:__eq(angle)
    if self.is(angle, Angle) then
        return self.angle == angle.angle

    elseif type(value) == 'number' then
        if self.asradians then
            return self:asRadians() <= number
        else
            return self.angle == angle
        end
    else
        return false
    end
end

-- switches to radian mode
-- @returns a string the value cast to radians and suffixed with a 'rad' marker
function Angle:rad()
    local radix = string.format(".%d", self.radix)
    self.asradians = true

    radix = "%"..radix.."f rad"
    return string.format(radix, self:asRadians())
end

-- set radix with error checking
function Angle:setRadix(num)
    assert(type(num) == 'number',
        string.format("badargument #1 to 'setradix' (number expected, got %s)", type(num)))

    self.radix = math.abs(math.floor(num))
end

-- switches to degree mode
-- return a string with the value suffixed with a '°' marker
function Angle:deg()
    local radix = string.format(".%d", self.radix)

    self.asradians = false
    radix = "%"..radix.."f°"
    return string.format(radix, self:asDegrees())
end

-- __tostring the value as
function Angle:__tostring()
    if self.asradians then
        return self:rad()
    else
        return self:deg()
    end
end

return Angle
