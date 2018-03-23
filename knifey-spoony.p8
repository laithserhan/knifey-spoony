pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- knifey spoony
-- by jonic + ribbon black
-- v0.4.3

--[[
  "i see you've played knifey
  spoony before"

  jonic: this is my first real
  attempt to make a game with
  pico-8. it's a bit messy,
  because i've spent a long time
  trying to figure out systems
  for things such as displaying
  groups of sprites, animating
  elements, and dispalying text.

  i haven't made any attempt to
  optimise this code, so it
  should be easy for a beginner
  to get to grips with it. if
  you're struggling to read it
  in pico-8, the full code is
  on github here:

  https://github.com/jonic/knifey-spoony
]]

-->8
-- global vars

high_score        = 0
high_score_beaten = false
score             = 0

-->8
-- helper functions

-- clone and copy from https://gist.github.com/MihailJP/3931841
function clone(t) -- deep-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = clone(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end

function copy(t) -- shallow-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do target[k] = v end
    setmetatable(target, meta)
    return target
end

function draw_sprite(s)
  local i  = s.i
  local x  = s.x * 8
  local y  = s.y * 8
  local w  = s.w or 1
  local h  = s.h or 1
  local fx = s.fx or false
  local fy = s.fy or false

  spr(i, x, y, w, h, fx, fy)
end

function draw_sprites(sprites)
  for s in all(sprites) do
    draw_sprite(s)
  end
end

function reset_globals()
  high_score_beaten  = false
  score              = 0
end

function rndint(min, max)
  return flr(rnd(max)) + min
end

function table_has_key(table, key)
  return table[key] ~= nil
end

function update_high_score()
  if (score > high_score) then
    high_score        = score
    high_score_beaten = true
    dset(0, high_score)
  end

  global_score = score
end

function update_score()
  score += 1
  update_high_score()
end

-->8
-- sprites

sprites = {
  global = {
    frame = {
      -- top
      { i = 0,  x = 0,  y = 0 },
      { i = 1,  x = 1,  y = 0 },
      { i = 1,  x = 2,  y = 0 },
      { i = 1,  x = 3,  y = 0 },
      { i = 1,  x = 4,  y = 0 },
      { i = 1,  x = 5,  y = 0 },
      { i = 1,  x = 6,  y = 0 },
      { i = 1,  x = 7,  y = 0 },
      { i = 1,  x = 8,  y = 0 },
      { i = 1,  x = 9,  y = 0 },
      { i = 1,  x = 10, y = 0 },
      { i = 1,  x = 11, y = 0 },
      { i = 1,  x = 12, y = 0 },
      { i = 1,  x = 13, y = 0 },
      { i = 1,  x = 14, y = 0 },
      { i = 2,  x = 15, y = 0 },

      -- left side
      { i = 3,  x = 0, y = 1  },
      { i = 3,  x = 0, y = 2  },
      { i = 16, x = 0, y = 3  },
      { i = 16, x = 0, y = 4  },
      { i = 17, x = 0, y = 5  },
      { i = 17, x = 0, y = 6  },
      { i = 17, x = 0, y = 7  },
      { i = 17, x = 0, y = 8  },
      { i = 17, x = 0, y = 9  },
      { i = 17, x = 0, y = 10 },
      { i = 17, x = 0, y = 11 },
      { i = 17, x = 0, y = 12 },
      { i = 17, x = 0, y = 13 },
      { i = 17, x = 0, y = 14 },

      --bottom
      { i = 18, x = 0,  y = 15 },
      { i = 19, x = 1,  y = 15 },
      { i = 19, x = 2,  y = 15 },
      { i = 32, x = 3,  y = 15 },
      { i = 32, x = 4,  y = 15 },
      { i = 33, x = 5,  y = 15 },
      { i = 33, x = 6,  y = 15 },
      { i = 33, x = 7,  y = 15 },
      { i = 33, x = 8,  y = 15 },
      { i = 34, x = 9,  y = 15 },
      { i = 34, x = 10, y = 15 },
      { i = 35, x = 11, y = 15 },
      { i = 35, x = 12, y = 15 },
      { i = 35, x = 13, y = 15 },
      { i = 35, x = 14, y = 15 },
      { i = 48, x = 15, y = 15 },

      -- right side
      { i = 49, x = 15, y = 1  },
      { i = 49, x = 15, y = 2  },
      { i = 49, x = 15, y = 3  },
      { i = 49, x = 15, y = 4  },
      { i = 49, x = 15, y = 5  },
      { i = 49, x = 15, y = 6  },
      { i = 49, x = 15, y = 7  },
      { i = 49, x = 15, y = 8  },
      { i = 49, x = 15, y = 9  },
      { i = 49, x = 15, y = 10 },
      { i = 49, x = 15, y = 11 },
      { i = 49, x = 15, y = 12 },
      { i = 49, x = 15, y = 13 },
      { i = 49, x = 15, y = 14 },
    },
  },
  playing = {
    buttons = {
      knifey = {
        { i = 4,  x = 2, y = 12, w = 4, h = 2 },
        { i = 8,  x = 2, y = 12, w = 4, h = 2 },
        { i = 12, x = 2, y = 12, w = 4, h = 2 },
        { i = 8,  x = 2, y = 12, w = 4, h = 2 },
      },
      spoony = {
        { i = 36, x = 10, y = 12, w = 4, h = 2 },
        { i = 40, x = 10, y = 12, w = 4, h = 2 },
        { i = 44, x = 10, y = 12, w = 4, h = 2 },
        { i = 40, x = 10, y = 12, w = 4, h = 2 },
      },
    },
    score = {
      { i = 134, x = 6, y = 11, w = 4, h = 4 },
    },
    utensils = {
      knifey = {
        {
          -- red knife
          { i = 75,  x = 7, y = 2, w = 2, h = 4 },
          { i = 77,  x = 7, y = 6, w = 2 },
          { i = 93,  x = 6, y = 7 },
          { i = 94,  x = 7, y = 7 },
          { i = 79,  x = 8, y = 7 },
          { i = 95,  x = 9, y = 7 },
          { i = 105, x = 7, y = 8, w = 2, h = 2 },
        },
        {
          -- thin knife
          { i = 64, x = 7, y = 2, w = 2, h = 4 },
          { i = 66, x = 7, y = 6, w = 2, h = 4 },
        },
        {
          -- metal knife
          { i = 64,  x = 7, y = 2, w = 2, h = 2 },
          { i = 68,  x = 7, y = 4 },
          { i = 113, x = 8, y = 4 },
          { i = 112, x = 7, y = 5, w = 2 },
          { i = 84,  x = 7, y = 6, w = 2, h = 3 },
          { i = 69,  x = 7, y = 9, w = 2 },
        },
        {
          -- master sword
          { i = 71, x = 7, y = 2, w = 2, h = 4 },
          { i = 73, x = 7, y = 6, w = 2, h = 4 },
        }
      },
      spoony = {
        {
          -- white spoon
          { i = 130, x = 7, y = 2, w = 2, h = 4 },
          { i = 132, x = 7, y = 6, w = 1, h = 2 },
          { i = 164, x = 7, y = 8, w = 2, h = 2 },
        },
        {
          -- metal spoon
          { i = 109, x = 7, y = 2, w = 2, h = 2 },
          { i = 128, x = 7, y = 4, w = 2, h = 4 },
          { i = 116, x = 7, y = 8, w = 2 },
          { i = 69,  x = 7, y = 9, w = 2 },
        },
        {
          -- wood handle spoon
          { i = 109, x = 7, y = 2, w = 2, h = 2 },
          { i = 128, x = 7, y = 4, w = 2, h = 4 },
          { i = 105, x = 7, y = 8, w = 2, h = 2 },
        },
      },
    },
  },
  title = {
    bottom_line = {
      { i = 19, x = 2,  y = 10 },
      { i = 19, x = 3,  y = 10 },
      { i = 32, x = 4,  y = 10 },
      { i = 33, x = 5,  y = 10 },
      { i = 33, x = 6,  y = 10 },
      { i = 33, x = 7,  y = 10 },
      { i = 33, x = 8,  y = 10 },
      { i = 33, x = 9,  y = 10 },
      { i = 33, x = 10, y = 10 },
      { i = 33, x = 11, y = 10 },
    },
    knife = {
      { i = 138, x = 2, y = 3, w = 2, h = 3 }
    },
    spoon = {
      { i = 140, x = 12, y = 10, w = 2, h = 3 }
    },
    text = {
      -- k
      { i = 192, x = 2, y = 6, w = 2, h = 2 },
      -- n
      { i = 192, x = 4, y = 6, h = 2 },
      { i = 194, x = 5, y = 6, h = 2 },
      -- i
      { i = 195, x = 6, y = 6 },
      { i = 208, x = 6, y = 7 },
      -- f
      { i = 192, x = 7, y = 6, h = 2 },
      { i = 196, x = 8, y = 6, h = 2 },
      -- e
      { i = 192, x = 9, y = 6, h = 2 },
      { i = 197, x = 10, y = 6, h = 2 },
      -- y
      { i = 198, x = 11, y = 6, w = 2, h = 2 },
      -- s
      { i = 224, x = 2, y = 8, w = 2, h = 2 },
      -- p
      { i = 192, x = 4, y = 8, h = 2 },
      { i = 227, x = 5, y = 8, h = 2 },
      -- o
      { i = 228, x = 6, y = 8, h = 2 },
      { i = 194, x = 7, y = 8 },
      { i = 245, x = 7, y = 9 },
      -- o
      { i = 228, x = 8, y = 8, h = 2 },
      { i = 194, x = 9, y = 8 },
      { i = 245, x = 9, y = 9 },
      -- n
      { i = 192, x = 10, y = 8, h = 2 },
      { i = 194, x = 11, y = 8, h = 2 },
      -- y
      { i = 198, x = 12, y = 8, w = 2, h = 2 },
    },
    top_line = {
      { i = 1, x = 4,  y = 5 },
      { i = 1, x = 5,  y = 5 },
      { i = 1, x = 6,  y = 5 },
      { i = 1, x = 7,  y = 5 },
      { i = 1, x = 8,  y = 5 },
      { i = 1, x = 9,  y = 5 },
      { i = 1, x = 10, y = 5 },
      { i = 1, x = 11, y = 5 },
      { i = 1, x = 12, y = 5 },
      { i = 1, x = 13, y = 5 },
    },
  },
}

-->8
-- text

text = {
  about             = '2018 jonic + ribbon black',
  game_over         = 'game over!',
  high_score        = 'high score: ',
  high_score_beaten = '** new high score **',
  knifey            = 'knifey',
  play_again        = 'press x to play again',
  score             = 'score: ',
  spoony            = 'spoony',

  center = function(self, str)
    return 64 - #str * 2
  end,

  get = function(self, key)
    return self[key]
  end,

  outline = function(self, str, x, y, color, outline)
    print(str, x - 1, y, outline)
    print(str, x + 1, y, outline)
    print(str, x, y - 1, outline)
    print(str, x, y + 1, outline)
    print(str, x, y,     color)
  end,

  output = function(self, str, y, color, outline)
    local outline = outline or nil
    local x       = self:center(str)

    if (outline != nil) then
      return self:outline(str, x, y, color, outline)
    end

    print(str, x, y, color)
  end,

  show = function(self, key, y, color, outline)
    self:output(self:get(key), y, color, outline)
  end
}

-->8
-- screens

function screen_game_over()
  return {
    _update = function()
      if (btnp(5)) screens:go_to('playing')
    end,

    _draw = function()
      local high_score_text = text:get('high_score') .. high_score
      local score_text      = text:get('score') .. score

      rectfill(0, 0, 128, 128, 8)

      text:show('game_over',       16, 7, 0)
      text:output(score_text,      32, 7, 0)
      text:output(high_score_text, 40, 7, 0)

      if (high_score_beaten) then
        text:show('high_score_beaten', 56, 7, 0)
      end

      text:show('play_again', 112, 7, 5)
    end
  }
end

function screen_playing()
  return {
    defaults = {
      button_animations = {
        knifey = {
          animating = false,
          frame     = 1
        },
        spoony = {
          animating = false,
          frame     = 1
        },
      },

      timeout = {
        max        = 150,
        min        = 20,
        multiplier = 0.95,
        remaining  = 0,
        start      = 120,
      },
    },

    button_animations = {},
    timeout = {},
    timer = {
      color     = 8,
      height    = 2,
      max_width = 120,
      start_x   = 4,
      start_y   = 4,
    },
    utensil = {
      current = nil,
      sprites = {},
    },

    animate_button = function(self, button)
      self.button_animations[button].animating = true
    end,

    choose_utensil = function(self)
      self.utensil.current = rnd(1) > 0.5 and text.knifey or text.spoony
      self:get_utensil_sprites()
    end,

    decrease_timeout_remaining = function(self)
      self.timeout.remaining -= 1
      if (self.timeout.remaining <= 0) screens:go_to('game_over')
    end,

    decrease_timeout_start = function(self)
      local new_timeout = self.timeout.start * self.timeout.multiplier
      self.timeout.start = mid(self.timeout.min, new_timeout, self.timeout.start)
    end,

    draw_button = function(self, button)
      local button_animation = self.button_animations[button]
      local button_sprites   = sprites.playing.buttons[button]

      if (button_animation.animating) button_animation.frame += 1

      draw_sprite(button_sprites[button_animation.frame])

      if (button_animation.frame == #button_sprites) then
        button_animation.animating = false
        button_animation.frame     = 1
      end
    end,

    draw_buttons = function(self)
      self:draw_button(text.knifey)
      self:draw_button(text.spoony)
    end, 

    draw_floor = function(self)
      rectfill(4, 111, 123, 112, 15)
      rectfill(4, 113, 123, 119, 4)
      rectfill(4, 120, 123, 123, 2)
    end,

    draw_timer = function(self)
      x = self.timer.start_x + self:timer_width()
      y = self.timer.start_y + self.timer.height - 1
      rectfill(self.timer.start_x, self.timer.start_y, x, y, self.timer.color)
    end,

    evaluate_input = function(self, choice)
      if (choice == self.utensil.current) then
        self:round_passed()
      else
        self:round_failed()
      end
    end,

    get_input = function(self)
      if (btnp(0)) then
        self:animate_button(text.knifey)
        self:evaluate_input(text.knifey)
      end

      if (btnp(1)) then
        self:animate_button(text.spoony)
        self:evaluate_input(text.spoony)
      end
    end,

    get_utensil_sprites = function(self)
      local utensil_array = sprites.playing.utensils[self.utensil.current]
      local utensil_index = rndint(1, #utensil_array)
      self.utensil.sprites = utensil_array[utensil_index]
    end,

    new_round = function(self)
      self.timeout.remaining = self.timeout.start
      self:choose_utensil()
    end,

    reset = function(self)
      self.timeout           = copy(self.defaults.timeout)
      self.button_animations = clone(self.defaults.button_animations)
      reset_globals()
    end,

    round_failed = function()
      screens:go_to('game_over')
    end,

    round_passed = function(self)
      update_score()
      self:decrease_timeout_start()
      self:new_round()
    end,

    timer_width = function(self)
      local elapsed_percentage = self.timeout.remaining / self.timeout.start
      return flr(elapsed_percentage * self.timer.max_width)
    end,

    _init = function(self)
      self:reset()
      self:new_round()
    end,

    _update = function(self)
      self:decrease_timeout_remaining()
      self:get_input()
    end,

    _draw = function(self)
      draw_sprites(sprites.global.frame)
      self:draw_timer()
      draw_sprites(self.utensil.sprites)
      draw_sprites(sprites.playing.score)
      self:draw_buttons()
      self:draw_floor()
    end
  }
end

function screen_title()
  return {
    _update = function()
      if (btnp(5)) screens:go_to('playing')
    end,

    _draw = function(self)
      draw_sprites(sprites.title.knife)
      draw_sprites(sprites.title.top_line)
      draw_sprites(sprites.title.text)
      draw_sprites(sprites.title.bottom_line)
      draw_sprites(sprites.title.spoon)
      draw_sprites(sprites.global.frame)

      text:show('about', 119, 7)
    end
  }
end

screens = {
  current = {
    instance = nil
  },

  definitions = {
    game_over = screen_game_over(),
    playing   = screen_playing(),
    title     = screen_title()
  },

  go_to = function(self, name)
    self.current.instance = self.definitions[name]
    self:_init()
  end,

  _init = function(self)
    local can_init = table_has_key(self.current.instance, '_init')
    if (can_init) self.current.instance:_init()
  end,

  _update = function(self)
    self.current.instance:_update()
  end,

  _draw = function(self)
    self.current.instance:_draw()
  end
}

-->8
-- game loop

function _init()
  cartdata('knifeyspoony')
  high_score = dget(0)
  screens:go_to('title')
end

function _update()
  screens:_update()
end

function _draw()
  cls()
  screens:_draw()
end
__gfx__
aaaaaaaaaaaaaaaaaaaaaaa4a9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a99999999999999999999994a9000000007077077770777707777077770707700000000000000000000000000000000000000000000000000000000000000000
a90000000000000000000094a9000000007077070770077007707077000707700000000000000000000000000000000000000000000000000000000000000000
a90000000000000000000094a9000000007077070770077007700077700777700070770777707777077770777707077000000000000000000000000000000000
a90000000000000000000094a9000000007770070770077007770077000077000070770707700770077070770007077000707707777077770777707777070770
a90000000000000000000094a9000000007077070770777707700077770077000070770707700770077000777007777000707707777077770777707777070770
a90000000000000000000094a9000000000000000000000000000000000000000077700707700770077700770000770000707707777077770777707777070770
a90000000000000000000094a9000000000000000000000000000000000000000070770707707777077000777700770000707707077007700770707700070770
a9000000990000009900000000000000000000000000000000000000000000000000000000000000000000000000000000707707077007700770007770077770
a9000000990000009900000000000000000888888888888888888888888880000000000000000000000000000000000000777007077007700777007700007700
a9000000990000009900000000000000008888888888888888888888888888000088888888888888888888888888880000707707077077770770007777007700
99000000990000009900000000000000008888888888888888888888888888000888888888888888888888888888888088888888888888888888888888888888
99000000990000009900000000000000002222222222222222222222222222000888888888888888888888888888888088888888888888888888888888888888
a9000000990000009900000000000000002222222222222222222222222222000222222222222222222222222222222088888888888888888888888888888888
990000009900000099aaaaaaaaaaaaaa002222222222222222222222222222000222222222222222222222222222222022222222222222222222222222222222
99000000990000004999999999999999001111111111111111111111111111000111111111111111111111111111111011111111111111111111111111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000007777077770777707777077770707700000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000007000070770707707077070770707700000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000007777077770707707077070770777700077770777707777077770777707077000000000000000000000000000000000
00000000000000000000000000000000000077070000707707077070770077000070000707707077070770707707077000777707777077770777707777070770
00000000000000000000000000000000007777070000777707777070770077000077770777707077070770707707777000777707777077770777707777070770
aa9999a9999999999999999999999999000000000000000000000000000000000000770700007077070770707700770000777707777077770777707777070770
99999999999999994999944444444444000000000000000000000000000000000077770700007777077770707700770000700007077070770707707077070770
00000094000000940000000000000000000000000000000000000000000000000000000000000000000000000000000000777707777070770707707077077770
00000094000000940000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000007707000070770707707077007700
0000009400000094000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbb00000bbbbbbbbbbbbbbbbbbbbbbbbbb00000777707000077770777707077007700
0000009400000094000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbb000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
00000094000000940000000000000000003333333333333333333333333333000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
000000940000009400000000000000000033333333333333333333333333330003333333333333333333333333333330bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
99999994000000940000009999400000003333333333333333333333333333000333333333333333333333333333333033333333333333333333333333333333
44444444000000940000009999400000001111111111111111111111111111000111111111111111111111111111111011111111111111111111111111111111
0000000007600000000555555555000000665555000056555505000076600000000000007666666655555555000000077000000088888888f000000800000000
000000076655000000055555555500000056555500005655550500007666600000000000766666665555555500000077f800000088888888f0000000dddddddd
000000766555000000055555555500000005555500005555500500007666660000000000766666665555555500000778f880000088888888f000000866666665
000000766555000000055555555500000000555500000555505000007666666000000000766666655555555500007788f888000088888888f00000087dddddd5
000007665555000000005555555500000007555500000555005000007666666600000000766666655555555500077888f088800088888888f0000000dddd5ddd
000007665555000000005555555500000076555500000050050000007666666650000000766666655555555500778888f000880088888888f00000005555ddd5
000076655555000000005555555500000065555500000055550000007666666655000000666666655555555507788888f000088088888888f0000000dddddddd
000076655555000000000000000000000065555500000005500000007666666655500000555555555555555507888888f0000080888888888000000855555550
00007665555500000000ffffff4200000005555555550000000000007666666655550000111111111110000078888888f0000008000000000000000000000000
000766655555000000004444444200000005555555550000000000007666666655555000ffff4ff44f4442228888888ff00000080000766ddddddddddd550000
0007665555550000000044422442000000055555555500000000000076666666555550004444444444442242888888fff000000800076ddd666666660dd55000
000766555555000000004426524200000005555555550000000000007666666655555500444444444444224288888ffff0000008000dddd66ddd777750dd5000
00076555555500000000442552420000000055555555000000000000766666665555550044444444444442228888fffff0000008000dddd6ddd6dddd50d55000
0076655555550000000044422442000000005555555500000000000076666666555555504444444444442242888ffffff00000080000dddd5dddd55505550000
007665555555000000004444444200000000555555550000000000007666666655555550444444444444422288fffffff00000080000000ddddddddd50000000
00766555555500000000444ff4420000000005555550000000000000766666665555555022222222222222428ffffffff0000008000000000555555500000000
0066555555550000000044ffff42000000000055550000000000000076666666555555550000111111110000fffffff8f0000008000000665500000000000000
006655555555000000004ff44ff2000000000055550000000000000076666666555555550000222222220000ffffff88f0000008000006555550000000000000
006655555555000000004f4444f2000000000055550000000000000076666666555555550000444444220000fffff888f0000008000065555555000000000000
006655555555000000004f4444f2000000000055550000000000000076666666555555550000444444420000ffff8888f0000008000655500555500000000000
006655555555000000004f444442000000000055550000000000000076666666555555550000222222220000fff88888f0000008006555000055550000000000
0066555555550000000044444442000000000055550000000000000076666666555555550000444444420000ff888888f0000008006550000555550000000000
006555555555000000004f444422000000000055550000000000000076666666555555550000444444420000f8888888f0000008065500005555555000000000
006555555555000000004442222200000000005555000000000000007666666655555555000044444442000088888888f0000008065000055555555000000000
006555555555000000000000000000000000065555500000000000007666666655555555000044444442000088888888f0000008065000555555655000000000
006555555555000000006666666500000000065555500000000000007666666655555555000022222222000088888888f0000008655000555555665500000000
006555555555000000006655555500000000065555500000000000007666666655555555000044444442000088888888f0000008650005555555665500000000
006555555555000000006555555500000000055555500000000000007666666655555555000044444442000088888888f0000008650055555555665500000000
006555555555000000005555555500000000055665500000000000007666666655555555000044444422000088888888f0000008650055555556665500000000
006555555555000000005555555500000000656555550000000000007666666655555555000022222221000088888888f0000008650555555566665500000000
006555555555000000000555555000000000656555550000000000007666666655555555000666666655500088888888f0000008550555555566655500000000
005555555555000000000055550000000000556555550000000000007666666655555555000655555551100088888888f0000008555555555666655500000000
0555555566666550007776660000000007766600ffffffff00000aaaaaaa9aaa9999999999990000000000000000000000000000000000000000000000000000
0555556666665550077777666600000077766600444444440000999999999999999999999999900000000000000000000000000bbb0000000000000000000000
0055666666655500777777766660000077766600444444440000900000000000000000000000900000000000000000000000000bbb0000000000000000000000
0005556666555000771777776666000077776600444444440000900000000000000000000000900000800000000000000000000bbb0000000000000000000000
0000555555550000711177777666600077776600444444440000901111111111111111111110900000880000000000000000000bbb0000000000000000000000
000005555550000071d117777666660077777600444444440000901111111111111111111110900000888000000000000000000bbb0000000000000000000000
00000055550000007ddd11777766660077777600444444440000901111111111111111111110900000888800000000000000000bbb0000000000000000000000
00000005500000007ddd11177766660077777600444444440000901111111111111111111110900000888880000000000000000bbb0000000000000000000000
00000005500000007dddd1177766666077777660444444440000901111111111111111111110900000888888000000000000000bbb0000000000000000000000
00000005500000007dddd1117766666077777760222222220000901111111111111111111110900000888888800000000000000bbb0000000000000000000000
00000005500000007dddd111776666600777776022222222000090111111111111111111111090000088888888000000000000bbbbb000000000000000000000
00000005500000007ddddd1177766666077777602222222200009011111111111111111111109000008888888800000000000bbbbbbb00000000000000000000
00000005500000007ddddd117776666607777766222222220000901111111111111111111110900000888888880000000000bbbbbbbbb0000000000000000000
00000005500000007ddddd111776666607777776000000000000901111111111111111111110900000888888880000000000bbbbbbbbb0000000000000000000
00000005500000007ddddd111776666600777776000000000000901111111111111111111110900000888888880000000000bbbbbbbbb0000000000000000000
00000005500000007ddddd111776666600777776000000000000901111111111111111111110900000888888880000000000bbbbbbbbb0000000000000000000
000000655500000077dddd111776666600777777600000000000901111111111111111111110900000888888880000000000bbbbbbbbb0000000000000000000
000000655500000007dddd1117766666007777776000000000009001111111111111111111009000008888888800000000000bbbbbbb00000000000000000000
000000655500000007ddd11117766666007777777600000000009000000000000000000000009000008888888800000000000bbbbbbb00000000000000000000
000000655500000007ddd11117666660000777777600000000009aaaaaaaaaaaaaa99aaa999990000088888888000000000000bbbbb000000000000000000000
000000555500000007ddd1117766666000077777776000000000099999999999999999999999000000888888880000000000000bbb0000000000000000000000
0000005555000000077d111177666600000777777760000000000000000000000000000000000000008888888800000000000000000000000000000000000000
00000055550000000071111177666600000077777766000000000000000000000000000000000000008888888800000000000000000000000000000000000000
00000055550000000077111776666000000077777776000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000055550000000007717766660000000077777776000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000055550000000007777666600000000007777776000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000055550000000077776666000000000007777776000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000055550000000077766660000000000007777766000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000055550000000077666600000000000007777766000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000055550000000777666600000000000000777760000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000055550000000776666000000000000000766660000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000055550000000776666000000000000000066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777707777777777770000770000777777777777777700777770007777700000000000000000000000000000000000000000000000000000000000000000
00777777707777777777777000777000777777777777777700777770007777700000000000000000000000000000000000000000000000000000000000000000
00777777707777777777777700777700777777777777777700777770007777700000000000000000000000000000000000000000000000000000000000000000
00777777707777777777777700777770777777777777777700777770007777700000000000000000000000000000000000000000000000000000000000000000
00777777707777777777777700777777700000007000000000777770007777700000000000000000000000000000000000000000000000000000000000000000
00777777707777777777777700777777700000007000000000777770007777700000000000000000000000000000000000000000000000000000000000000000
00777777777777777777777700777777777700007777000000777777777777700000000000000000000000000000000000000000000000000000000000000000
00777777777777707777777700000000777700007777000000777777777777700000000000000000000000000000000000000000000000000000000000000000
00777777777777007777777700000000777700007777000000000777777700000000000000000000000000000000000000000000000000000000000000000000
00777777707777707077777700000000700000007000000000000777777700000000000000000000000000000000000000000000000000000000000000000000
00777777707777777077777700000000700000007000000000000777777700000000000000000000000000000000000000000000000000000000000000000000
00777777707777777077777700000000700000007777777700000777777700000000000000000000000000000000000000000000000000000000000000000000
00777777707777777077777700000000700000007777777700000777777700000000000000000000000000000000000000000000000000000000000000000000
00777777707777777077777700000000700000007777777700000777777700000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077777777777770077777777777700000077770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777777777770077777777777770000777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777777777770077777770777777007777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777777777770077777770777777007777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777777777770077777770777777007777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777700000000077777770777777007777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777777777770077777770777777007777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777777777770000000077777777007777777077777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777777777770000000077777770007777777077777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777770000000070000000007777777077777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777777777770000000070000000007777777077777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777777777770000000070000000007777777077777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777777777770000000070000000007777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777777777700000000070000000000777777777777000000000000000000000000000000000000000000000000000000000000000000000000000000000
