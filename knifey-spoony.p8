pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- knifey spoony
-- by jonic
-- v1.1.0

--[[
  "i see you've played knifey spoony before"

  full code is on github here:
  https://github.com/jonic/knifey-spoony
]]

-->8
-- global setup

score             = 0
high_score        = 0
high_score_beaten = false

-->8
-- helpers

function draw_sprite(s)
  i  = s.i
  x  = s.x * 8
  y  = s.y * 8
  w  = s.w or 1
  h  = s.h or 1
  fx = s.fx or false
  fy = s.fy or false
  spr(i, x, y, w, h, fx, fy)
end

function draw_sprites(sprites)
  for s in all(sprites) do
    draw_sprite(s)
  end
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

-->8
-- message strings
text = {
  about             = 'a game by jonic',
  game_over         = 'game over!',
  high_score        = 'high score: ',
  high_score_beaten = '** new high score **',
  how_to_play       = 'how to play:',
  instructions      = 'knifey \139 | \145 spoony',
  knifey            = 'knifey',
  play_again        = 'press x to play again',
  score             = 'score: ',
  spoony            = 'spoony',
  start_game        = 'press x to start',
  title             = 'knifey spoony',

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
    outline = outline or nil
    x       = self:center(str)

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
-- game screens

function screen_game_over()
  return {
    _update = function()
      if (btnp(5)) screens:go_to('playing')
    end,

    _draw = function()
      high_score_text = text:get('high_score') .. high_score
      score_text      = text:get('score') .. score

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
    sprites = {
      buttons = {
        knifey = {
          { i = 4,  x = 2, y = 12, w = 4, h = 2 },
          { i = 8,  x = 2, y = 12, w = 4, h = 2 },
          { i = 12, x = 2, y = 12, w = 4, h = 2 },
          { i = 8,  x = 2, y = 12, w = 4, h = 2 }
        },
        spoony = {
          { i = 36, x = 10, y = 12, w = 4, h = 2 },
          { i = 40, x = 10, y = 12, w = 4, h = 2 },
          { i = 44, x = 10, y = 12, w = 4, h = 2 },
          { i = 40, x = 10, y = 12, w = 4, h = 2 }
        }
      },
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
      score = {
        { i = 134, x = 6, y = 11, w = 4, h = 4 }
      },
      utensils = {
        knifey = {
          {
            -- red knife
            { i = 35,  x = 7, y = 3, w = 2, h = 8 },
            { i = 114, x = 6, y = 8, w = 4, h = 1 }
          },
          {
            -- thin knife
            { i = 53, x = 6.5, y = 4, w = 1, h = 3 },
            { i = 38, x = 7.5, y = 3, w = 1, h = 8 }
          },
          {
            -- master sword
            { i = 39, x = 7, y = 3, w = 2, h = 8 }
          }
        },
        spoony = {
          {
            { i = 33,  x = 7, y = 3, w = 1, h = 8 },
            { i = 34,  x = 8, y = 3, w = 1, h = 4 },
            { i = 130, x = 8, y = 9, w = 1, h = 2 }
          },
          {
            { i = 43, x = 7, y = 3, w = 2, h = 8 }
          },
          {
            { i = 45, x = 7, y = 3, w = 2, h = 8 }
          }
        }
      }
    },

    button_animations_defaults = {
      knifey = {
        animating = false,
        frame     = 1
      },
      spoony = {
        animating = false,
        frame     = 1
      },
    },

    button_animations  = {},
    round_timeout      = 0,
    timeout            = 0,
    timeout_minimum    = 20,
    timeout_multiplier = 0.95,
    utensil            = nil,

    animate_button = function(self, button)
      self.button_animations[button].animating = true
    end,

    choose_utensil = function(self)
      self.utensil         = rnd(1) > 0.5 and text.knifey or text.spoony
      utensil_array        = self.sprites.utensils[self.utensil]
      self.utensil_index   = rndint(1, #utensil_array)
      self.utensil_sprites = utensil_array[self.utensil_index]
    end,

    decrease_timeout = function(self)
      local new_timeout = self.timeout * self.timeout_multiplier
      self.timeout = mid(self.timeout_minimum, new_timeout, self.timeout)
    end,

    draw_button = function(self, button)
      button_animation = self.button_animations[button]
      button_sprites   = self.sprites.buttons[button]

      if (button_animation.animating) then
        button_animation.frame += 1
      end

      draw_sprite(button_sprites[button_animation.frame])

      if (button_animation.frame >= #button_sprites) then
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

    draw_frame = function(self)
      draw_sprites(self.sprites.frame)
    end,

    draw_timer = function(self)
      rectfill(10, 8, self:timeout_width() - 20, 8, 8)
    end,

    draw_score = function(self)
      draw_sprites(self.sprites.score)
    end,

    draw_utensil = function(self)
      draw_sprites(self.utensil_sprites)
    end,

    evaluate_input = function(self, choice)
      if (choice == self.utensil) then
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

    new_round = function(self)
      self.round_timeout = self.timeout
      self:choose_utensil()
    end,

    reset_animations = function(self)
      self.button_animations = self.button_animations_defaults
    end,

    reset_values = function(self)
      self.timeout      = 120
      high_score_beaten = false
      score             = 0
    end,

    round_failed = function()
      update_high_score()
      screens:go_to('game_over')
    end,

    round_passed = function(self)
      score += 1
      update_high_score()
      self:decrease_timeout()
      self:new_round()
    end,

    timeout_width = function(self)
      return flr((self.round_timeout / self.timeout) * 128)
    end,

    _init = function(self)
      self:reset_animations()
      self:reset_values()
      self:new_round()
    end,

    _update = function(self)
      self.round_timeout -= 1

      if (self.round_timeout < 0) then
        return screens:go_to('game_over')
      end

      self:get_input()
    end,

    _draw = function(self)
      self:draw_frame()
      self:draw_timer()
      self:draw_utensil()
      self:draw_score()
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

    _draw = function()
      high_score_text = text:get('high_score') .. high_score

      rectfill(0, 0, 128, 128, 2)

      text:show('title',           16, 7, 0)
      text:show('about',           24, 7, 5)
      text:show('start_game',      40, 7, 0)
      text:output(high_score_text, 56, 7, 0)
      text:show('how_to_play',     72, 7, 5)
      text:show('instructions',    80, 7, 5)
    end
  }
end

screens = {
  current = {
    name     = nil,
    instance = nil
  },

  definitions = {
    game_over = screen_game_over(),
    playing   = screen_playing(),
    title     = screen_title()
  },

  get_instance = function(self)
    self.current.instance = self.definitions[self.current.name]

    if (self.just_updated) then
      self:_init()
      self.just_updated = false
    end
  end,

  go_to = function(self, name)
    self.current.name = name
    self.just_updated = true
    self:get_instance()
  end,

  _init = function(self)
    if (table_has_key(self.current.instance, '_init')) then
      self.current.instance:_init()
    end
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
aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a9999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a9000000007077077770777707777077770707700000000000000000000000000000000000000000000000000077770777707777077770777707077000000000
a9000000007077070770077007707077000707700000000000000000000000000000000000000000000000000070000707707077070770707707077000000000
a9000000007077070770077007700077700777700000000000000000000000000000000000000000000000000077770777707077070770707707777000000000
a9000000007770070770077007770077000077000000000000000000000000000000000000000000000000000000770700007077070770707700770000000000
a9000000007077070770777707700077770077000000000000000000000000000000000000000000000000000077770700007777077770707700770000000000
a9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a900000000888888888888888888888888888800000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbb00000000000
99000000088888888888888888888888888888800000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000
99000000088888888888888888888888888888800000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000
99000000022222222222222222222222222222200000000000000000000000000000000000000000000000000333333333333333333333333333333000000000
99000000022222222222222222222222222222200000000000000000000000000000000000000000000000000333333333333333333333333333333000000000
a9000000011111111111111111111111111111100000000000000000000000000000000000000000000000000111111111111111111111111111111000000000
99000000007776660000000000000007700000000000000000000760766000000000000000000000076000000000006655000000000000665500000000000000
99000000077777666600000000000077f80000000000000000076655766660000000000000000007665500000000065555500000000006555550000000000000
99000000777777766660000000000778f88000000000000000766555766666000000000000000076655500000000655555550000000065555555000000000000
99000000771777776666000000007788f88800000000000000766555766666600000000000000076655500000006555005555000000655500555500000000000
99000000711177777666600000077888f08880000000000007665555766666660000000000000766555500000065550000555500006555000055550000000000
9900000071d117777666660000778888f00088000000000007665555766666665000000000000766555500000065500005555500006550000555550000000000
990000007ddd11777766660007788888f00008800000000076655555766666665500000000007665555500000655000055555550065500005555555000000000
990000007ddd11177766660007888888f00000800000000076655555766666665550000000007665555500000650000555555550065000055555555000000000
990000007dddd1177766666078888888f00000080000000076655555766666665555000000007665555500000650005555556550065000555555655000000000
990000007dddd111776666608888888ff00000080000000766655555766666665555500000076665555500006550005555556655655000555555665500000000
990000007dddd11177666660888888fff00000080000000766555555766666665555500000076655555500006500055555556655650005555555665500000000
990000007ddddd117776666688888ffff00000080000000766555555766666665555550000076655555500006500555555556655650055555555665500000000
990000007ddddd11777666668888fffff00000080000000765555555766666665555550000076555555500006500555555566655650055555556665500000000
990000007ddddd1117766666888ffffff00000080000007665555555766666665555555000766555555500006505555555666655650555555566665500000000
99aaaaaa7ddddd111776666688fffffff00000080000007665555555766666665555555000766555555500005505555555666555550555555566655500000000
499999997ddddd11177666668ffffffff00000080000007665555555766666665555555000766555555500005555555556666555555555555666655500000000
0000009477dddd1117766666fffffff8f00000080000006655555555766666665555555500665555555500000555555566666550055555556666655000000000
0000009407dddd1117766666ffffff88f00000080000006655555555766666665555555500565555555500000555556666665550055555666666555000000000
0000009407ddd11117766666fffff888f00000080000006655555555766666665555555500055555555500000055666666655500005566666665550000000000
0000009407ddd11117666660ffff8888f00000080000006655555555766666665555555500005555555500000005556666555000000555666655500000000000
0000009407ddd11177666660fff88888f00000080000006655555555766666665555555500075555555500000000555555550000000055555555000000000000
00000094077d111177666600ff888888f00000080000006655555555766666665555555500765555555500000000055555500000000005555550000000000000
999999940071111177666600f8888888f00000080000006555555555766666665555555500655555555500000000005555000000000000555500000000000000
44444444007711177666600088888888f00000080000006555555555766666665555555500655555555500000000000550000000000000055000000000000000
94000000000771776666000088888888f00000080000006555555555766666665555555500655555555500000000000550000000000000055000000000000000
94000000000777766660000088888888f00000080000006555555555766666665555555500655555555500000000000550000000000000055000000000000000
94000000007777666600000088888888f00000080000006555555555766666665555555500655555555500000000000550000000000000055000000000000000
94000000007776666000000088888888f00000080000006555555555766666665555555500655555555500000000000550000000000000055000000000000000
94000000007766660000000088888888f00000080000006555555555766666665555555500655555555500000000000550000000000000055000000000000000
94000000077766660000000088888888f00000080000006555555555766666665555555500655555555500000000000550000000000000055000000000000000
94000000077666600000000088888888f00000080000006555555555766666665555555500655555555500000000000550000000000000055000000000000000
94000000077666600000000088888888f00000080000005555555555766666665555555500555555555500000000000550000000000000055000000000000000
aaaaaaaa077666000000000088888888f00000080000000555555555766666665555555500055555555500000000006555000000000000655500000000000000
99999999777666000000000088888888f00000000000000555555555766666665555555500055555555500000000006555000000000000655500000000000000
00000000777666000000000088888888f00000080000000555555555766666665555555500055555555500000000006555000000000000655500000000000000
00000000777766000000000088888888f00000080000000555555555766666655555555500055555555500000000006555000000000000655500000000000000
00000000777766000000000088888888f00000000000000055555555766666655555555500005555555500000000005555000000000000555500000000000000
00000000777776000000000088888888f00000000000000055555555766666655555555500005555555500000000005555000000000000555500000000000000
00000000777776000000000088888888f00000000000000055555555666666655555555500005555555500000000005555000000000000555500000000000000
00000000777776000000000088888888800000080000000000000000555555555555555500000555555000000000005555000000000000555500000000000000
999999997777766000000000000000000000000000000000ffffff42111111111110000000000055550000000000005555000000000000555500000000000000
99999999777777600000766ddddddddddddddddddd55000044444442ffff4ff44f44422200000055550000000000005555000000000000555500000000000000
000000000777776000076ddd66666666666666650dd5500044422442444444444444224200000055550000000000005555000000000000555500000000000000
0000000007777760000dddd66ddd77777dddddd550dd500044265242444444444444224200000055550000000000005555000000000000555500000000000000
0000000007777766000dddd6ddd6dddddddd5ddd50d5500044255242444444444444422200000055550000000000005555000000000000555500000000000000
00000000077777760000dddd5dddd5555555ddd50555000044422442444444444444224200000055550000000000005555000000000000555500000000000000
00000000007777760000000ddddddddddddddddd5000000044444442444444444444422200000055550000000000005555000000000000555500000000000000
000000000077777600000000055555555555555000000000444ff442222222222222224200000055550000000000005555000000000000555500000000000000
00000000007777776000000000001111111100000000000044ffff42000011111111000000000655555000000000065555500000000011111111000000000000
0000000000777777600000000000222222220000000000004ff44ff2000022222222000000000655555000000000065555500000000022222222000000000000
0000000000777777760000000000444444220000000000004f4444f2000044444422000000000655555000000000065555500000000044444422000000000000
0000000000077777760000000000444444420000000000004f4444f2000044444442000000000555555000000000055555500000000044444442000000000000
0000000000077777776000000000222222220000000000004f444442000022222222000000000556655000000000055665500000000022222222000000000000
00000000000777777760000000004444444200000000000044444442000044444442000000006565555500000000656555550000000044444442000000000000
aaaaaaaa00007777776600000000444444420000000000004f444422000044444442000000006565555500000000656555550000000044444442000000000000
99999999000077777776000000004444444200000000000044422222000044444442000000005565555500000000556555550000000044444442000000000000
00000000000077777776000000004444444200000000000000000000000044444442000000005655550500000000565555050000000044444442000000000000
00000000000007777776000000002222222200000000000066666665000022222222000000005655550500000000565555050000000022222222000000000000
00000000000007777776000000004444444200000000000066555555000044444442000000005555500500000000555550050000000044444442000000000000
00000000000007777766000000004444444200000000000065555555000044444442000000000555505000000000055550500000000044444442000000000000
00000000000007777766000000004444442200000000000055555555000044444422000000000555005000000000055500500000000044444422000000000000
00000000000000777760000000002222222100000000000055555555000022222221000000000050050000000000005005000000000022222221000000000000
aa9999a9000000766660000000066666665550000000000005555550000666666655500000000055550000000000005555000000000666666655500000000000
99999999000000066600000000065555555110000000000000555500000655555551100000000005500000000000000550000000000655555551100000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000aaaaaaa9aaa9999999999990000000000000000000000000000000000000000000000000000
00000000007077077770777707777077770707700000000000009999999999999999999999999000000000000077770777707777077770777707077000000000
00000000007077077770777707777077770707700000000000009000000000000000000000009000000000000077770777707777077770777707077000000000
00000000007077077770777707777077770707700000000000009000000000000000000000009000000000000077770777707777077770777707077000000000
00000000007077070770077007707077000707700000000000009011111111111111111111109000000000000070000707707077070770707707077000000000
00080000007077070770077007700077700777700000000000009017771777177717771777109000000000000077770777707077070770707707777000000000
00080000007770070770077007770077000077000000000000009017111711171717171711109000000000000000770700007077070770707700770000000000
00080000007077070770777707700077770077000000000000009017771711171717171771109000000000000077770700007777077770707700770000000000
0008000088888888888888888888888888888888000000000000901117171117171771171110900000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000
0008000088888888888888888888888888888888000000000000901777177717771717177710900000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000
0008000088888888888888888888888888888888000000000000901111111111111111111110900000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb00000000
00080000222222222222222222222222222222220000000000009011111111111111111111109000000000003333333333333333333333333333333300000000
00080000111111111111111111111111111111110000000000009011111555155515551111109000000000001111111111111111111111111111111100000000
00000000000000000000000000000000000000000000000000009011111515151515151111109000000000000000000000000000000000000000000000000000
00000000007077077770777707777077770707700000000000009011111515151515151111109000000000000077770777707777077770777707077000000000
00000000007077070770077007707077000707700000000000009011111515151515151111109000000000000070000707707077070770707707077000000000
00000000007077070770077007700077700777700000000000009011111555155515551111109000000000000077770777707077070770707707777000000000
00000000007770070770077007770077000077000000000000009001111111111111111111009000000000000000770700007077070770707700770000000000
00000000007077070770777707700077770077000000000000009000000000000000000000009000000000000077770700007777077770707700770000000000
00000000000000000000000000000000000000000000000000009aaaaaaaaaaaaaa99aaa99999000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000999999999999999999999990000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000088888888888888888888888888000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbb00000000000
000000000088888888888888888888888888880000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000
000000000088888888888888888888888888880000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000
00000000002222222222222222222222222222000000000000000000000000000000000000000000000000000033333333333333333333333333330000000000
00000000002222222222222222222222222222000000000000000000000000000000000000000000000000000033333333333333333333333333330000000000
00000000002222222222222222222222222222000000000000000000000000000000000000000000000000000033333333333333333333333333330000000000
00000000001111111111111111111111111111000000000000000000000000000000000000000000000000000011111111111111111111111111110000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
