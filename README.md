# nclassic (neo classic)
A tiny class module for Lua, improving on [rxi/classic](https://github.com/rxi/classic) to take advantage of some lua 5.4 convensions. 

Attempts to stay simple and provide decent performance by avoiding over-abstraction.

## Usage
The [module](https://github.com/ImpishDeathTech/nclassic/blob/master/nclassic.lua) should be dropped into an existing project, or dropped into the lua/5.4 directory, and required as convension:
```lua
Object = require('nclassic')
```

### Creating a new class
[classic example: Point](https://github.com/rxi/classic/blob/master/README.md)

nclassic example:
```lua
Vector2 = Object:extend('Vector2')

function Vector2:new(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Vector2:delete(
  self.x = nil
  self.y = nil
end

print(tostring(Vector2)) -- prints a string similar to class: 0x563b7a1dacc0
```

### Creating a new object and playing with it
[classic example: Point](https://github.com/rxi/classic/blob/master/README.md)

nclassic example:
```lua
a = Vector2(23, 33)
print(a.x + 50)
print(a.y / 3)
print(tostring(a)) -- prints a string similar to 'Vector2: 0x563b7a1dacc0' or 'object: 0x563b7a1dacc0' depending on if a string was provided to 
```

### Extending a class
[classic example: Rect](https://github.com/rxi/classic/blob/master/README.md)

nclassic example:
```lua

Vector3 = Vector2:extend('Vector3')

function Vector3:new(x, y, z)
  self:fields(Vector2(x, y))
  self.z = z or 0
end

function Vector3:delete()
  self.super.delete(self)
  self.z = nil
end
```

# Checking an object's type
```lua
local v = Vector2(666, math.pi)
v:is(Object)  -- true
v:is(Vector2) -- true
v:is(Vector3) -- true
```

# Using mixins
[classic example: PairPrinter](https://github.com/rxi/classic/blob/master/README.md)

nclassic examples: override and fields

```lua
Rect = Vector2:extend('Rect')
Rect:override({
  new = function (self, x, y, w, h)
    self:fields(Vector2(x, y),
    {
      width  = w or 0,
      height = h or 0
    })
  end,
  delete = function (self)
    for k, _ in pairs(self)
      self[k] = nil
      collectgarbage('step')
    end
  end})
 
 Trig = Vector2:extend('Trig')
 Trig:override(Rect)
```

### Using static members
[classic example: Point.scale](https://github.com/rxi/classic/blob/master/README.md)

nclassic example:
```lua
Vector2 = Object:extend('Vector2')
Vector2.offset = 50

function Vector2:new(x, y)
  self.x = x or 0
  self.y = y or 0
end

function Vector2:move()
  return Vector2(self.x + offset, self.y + offset)
end
```

### Creating a metamethod
[classic example: __tostring](https://github.com/rxi/classic/blob/master/README.md)

nclassic example:
```lua
-- adding new metamethods
function Vector2:__add(value)
  if type(value) == 'number' then
    return Vector2(self.x + value, self.y + value)
  elseif type(value) == 'table' and type(value.is) == 'function' and value:is(Vector2) then
    return Vector2(self.x + value.x, self.y + value.y)
  else 
    error("bad argument #1 to '__add' (number or Vector2 expected, got "..type(value) ..")")
  end
end

a = Vector2(23, 44); b = Vector2(44, 45.5)
c = a + b
```

## License
This module is free software; you can redistribute it and/or modify it under the terms of the MIT license. See [LICENSE](https://github.com/ImpishDeathTech/nclassic/blob/master/LICENSE) for details.
