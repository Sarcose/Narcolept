la = love.audio
lg = love.graphics
la.newAdvancedSource = require 'lib.asl'

require 'src.utility'
require 'lib.batteries.class'
require 'shaders.opshaders'

SFrame = require 'lib.slog-frame'
SText = require 'lib.slog-text'
hexcolors = require 'lib.hexcolors'
colors = require 'src.visual.colors'

local aspect_ratio = require 'lib.aspect'
local moonshine = require 'lib.moonshine'

rand = love.math.random

--[[======AESTHETICS======]]
fonts = {}
lsize = 20*3
fsize = 18*3
msize = 16*3
ssize = 12*3
fonts.defaultfont = lg.newFont(fsize)
fonts.defaultfont_m = lg.newFont(msize)
fonts.defaultfont_s = lg.newFont(ssize)
fonts.gothicfont = lg.newFont('assets/fonts/Avqest-eeel.ttf',fsize,'mono')
fonts.gothicfont_m = lg.newFont('assets/fonts/Avqest-eeel.ttf',msize,'mono')
fonts.gothicfont_s = lg.newFont('assets/fonts/Avqest-eeel.ttf',ssize,'mono')
fonts.futurefont_l = lg.newFont('assets/fonts/RETRO_SPACE.ttf',lsize,'mono')
fonts.futurefont = lg.newFont('assets/fonts/RETRO_SPACE.ttf',fsize,'mono')
fonts.futurefont_m = lg.newFont('assets/fonts/RETRO_SPACE.ttf',msize,'mono')
fonts.futurefont_s = lg.newFont('assets/fonts/RETRO_SPACE.ttf',ssize,'mono')
fonts.digivolve_l = lg.newFont('assets/fonts/Digivolve.ttf',lsize,'mono')
fonts.digivolve = lg.newFont('assets/fonts/Digivolve.ttf',fsize,'mono')
fonts.digivolve_m = lg.newFont('assets/fonts/Digivolve.ttf',msize,'mono')
fonts.digivolve_s = lg.newFont('assets/fonts/Digivolve.ttf',ssize,'mono')
fonts.vengeance_l = lg.newFont('assets/fonts/vengeance.ttf',lsize,'mono')
fonts.vengeance = lg.newFont('assets/fonts/vengeance.ttf',fsize,'mono')
fonts.vengeance_m = lg.newFont('assets/fonts/vengeance.ttf',msize,'mono')
fonts.vengeance_s = lg.newFont('assets/fonts/vengeance.ttf',ssize,'mono')

--[[======GLOBALS=========]]
updatecounter = 0


--[[======DISPLAY THINGS==]]
w_width = lg.getWidth()
w_height = lg.getHeight()
GAME_W = 640--widescreen: 896x504
GAME_H = 576--gameboy: 640x576                      
local TICKRATE = 1/60
local WINDOW


--[[======PHYSICS=========]]
bump = require 'lib.bump'
flux = require 'lib.flux'

--[[=====CONTROLS============]]
baton = require 'lib.baton'
controller = require 'lib.controller'


--[[=====STATES==============]]
local state = {}
state.menu = require 'lib.states.menu'
state.game = require 'lib.states.game'

function love.run()
  if love.math then
      love.math.setRandomSeed(os.time())
  end

  if love.load then love.load(arg) end

  local previous = love.timer.getTime()
  local lag = 0.0
  while true do
      local current = love.timer.getTime()
      local elapsed = current - previous
      previous = current
      lag = lag + elapsed

      if love.event then
          love.event.pump()
          for name, a,b,c,d,e,f in love.event.poll() do
              if name == "quit" then
                  if not love.quit or not love.quit() then
                      return a
                  end
              end
              love.handlers[name](a,b,c,d,e,f)
          end
      end

      while lag >= TICKRATE do
          love.update(TICKRATE)
          lag = lag - TICKRATE
      end

      if love.graphics and love.graphics.isActive() then
          love.graphics.clear(love.graphics.getBackgroundColor())
          love.graphics.origin()
          love.draw(lag / TICKRATE)
          love.graphics.present()
      end

  end
end


function state:update(dt)
  self[self.state]:update(dt)
  if self[self.state].state_change then self.state = self[self.state].state_change end
end

function state:draw()
  if self[self.state].loaded then
    self[self.state]:draw()     
    lg.setCanvas()
    lg.clear()
    effect(function()
      lg.draw(WINDOW,0,0,0,aspect_ratio.scale)
    end)
  end 
  lg.setCanvas()
end

function love.load()
	love.mouse.setVisible(false)
    --[[Set Window Stuff]]
    local w, h = love.graphics.getDimensions()
    aspect_ratio:init(w, h, GAME_W, GAME_H)
    WINDOW = love.graphics.newCanvas(aspect_ratio.dig_w, aspect_ratio.dig_h)

    for i,v in pairs(colors) do --change colors to 1.0 normalized range cuz im lazy
		colors[i][1] = colors[i][1]/255
		colors[i][2] = colors[i][2]/255
		colors[i][3] = colors[i][3]/255	
	end

  effect = moonshine(lg.getWidth(),lg.getHeight(),moonshine.effects.chromasep).chain(moonshine.effects.pixelate)
	effect.chromasep.radius = 10
	effect.chromasep.angle = 0
	effect.pixelate.size = {1,20}
  effect.pixelate.feedback = 0.1
  effect.disable('chromasep','pixelate')
  love.math.setRandomSeed(os.time() + love.mouse.getX())
	love.graphics.setDefaultFilter("nearest", "nearest")
  
  state.state = 'menu'

end

function love.update(dt)
  controller:update(dt)
  updatecounter = updatecounter + 1
  flux.update(dt)
  state:update(dt)
end

function love.draw()
  lg.setCanvas({
    {WINDOW},
    stencil = true
  })

  state:draw()
end