o = {}

function o:load()
	self.loaded = true
	self.cs = 1	
	self.ns = 1 --next state
	self.state = {}
	self.state[1] = {
		life = 1, 
		x = GAME_W/2 - _G.fonts.futurefont_l:getWidth('Game Crash Presents')/2,
		y = GAME_H/2 - _G.fonts.futurefont_l:getHeight('Game Crash Presents')/2,
		text = '[font=futurefont_l][textspeed = 0.01][raindrop=0.4]'..colorhex('dark_orchid')..'Game Crash Presents',
		wait = 1,
	}
	self.state[2] = {
		life = 3, 
		x = GAME_W/2 - _G.fonts.futurefont_l:getWidth('A tiny game')/2,
		y = GAME_H/2 - _G.fonts.futurefont_l:getHeight('A')/2,
		wait = 1.4,
		}
	self.state[2].text = '[font=futurefont_l][textspeed = 0][shake]'..colorhex('pale_green')..'A tiny game'
	self.state[3] = {
		x = GAME_W/2 - _G.fonts.digivolve_l:getWidth('N A R C O L E P T O R')/2,
		y = GAME_H/2 - _G.fonts.digivolve_l:getHeight('A')/2,
		life=4,
		wait=100,	
		text = '[font=vengeance]'..colorhex('violet')..'[bounce=30]N A R C O L E P T O R'
	}
	self.state[self.cs].a_text = SText.new()
	self.state[self.cs].a_text:send(self.state[self.cs].text)

	self.background = {
		draw = function(self)
			--lg.setColor(colors.dark_grey_blue)
			--lg.rectangle('fill',0,0,GAME_W,GAME_H)
		end
	}
end

function o:setupTextBox()
	self.state[self.cs].a_text = SText:new()
	self.state[self.cs].a_text:send(self.state[self.cs].text)
end

function o:update(dt)
	self:checkinputs()
	if not self.loaded then self:load() end
	if self.ns > 3 then
		self.ns = 1
		self.loaded = false
		return 'start' 
	else
		if self.cs ~= self.ns then
			self.cs = self.ns
			self:setupTextBox()
		else
			if self.state[self.cs].a_text == nil then
				self:setupTextBox()
			end
			if self.state[self.cs].x_path and self.state[self.cs].y_path then
				self.state[self.cs].x,self.state[self.cs].y = moveBetweenTwoPoints(
					self.state[self.cs].x,
					self.state[self.cs].y,
					self.state[self.cs].x_path,
					self.state[self.cs].y_path,
					self.state[self.cs].speed*dt,
					self.state[self.cs].min_step
				)		
			end
			self.state[self.cs].life = self.state[self.cs].life - dt
			if self.state[self.cs].life < 0 then
				if self.state[self.cs].wait ~= nil then
					self.state[self.cs].wait = self.state[self.cs].wait - dt
					if self.state[self.cs].wait < 0 then
						self.ns = self.ns + 1
					end
					
				else
					self.ns = self.ns + 1
				end
			end
		end
		self.state[self.cs].a_text:update(dt)
	end
end
function o:draw()
	--self.background:draw()
	self.state[self.cs].a_text:draw(self.state[self.cs].x,self.state[self.cs].y)
	lg.rectangle('line',0,0,GAME_W,GAME_H)
end
function o:drawParticles()

end
function o:checkinputs()
	if controller:pressed('action') then
		self:skip()
	end
end


function o:skip()
	self.ns = self.ns + 1

end

return o