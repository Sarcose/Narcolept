--[[	--the shaders in outer pixels 9/27
mask = {}
mask.damagemask_s = newSpriteSheet('assets/masks/damagemask_s.png',112,112)
mask.shader = lg.newShader[[
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
		if(Texel(texture,texture_coords).a == 1.0){discard;}		//need to remove this if check
		return vec4(1.0);
	}
]]	
--]]
shaders = {}
shaders.whiteout = love.graphics.newShader[[
	vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords){
		return vec4(1, 1, 1, Texel(texture, textureCoords).a) * color;
	}
	]]
shaders.outline = love.graphics.newShader[[
	vec4 resultCol;
	extern vec2 stepSize;
	extern vec3 pixCol;

	vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
	{
		// get color of pixels:
		number alpha = 4*texture2D( texture, texturePos ).a;
		alpha -= texture2D( texture, texturePos + vec2( stepSize.x, 0.0f ) ).a;
		alpha -= texture2D( texture, texturePos + vec2( -stepSize.x, 0.0f ) ).a;
		alpha -= texture2D( texture, texturePos + vec2( 0.0f, stepSize.y ) ).a;
		alpha -= texture2D( texture, texturePos + vec2( 0.0f, -stepSize.y ) ).a;

		// calculate resulting color
			resultCol = vec4( pixCol.x, pixCol.y, pixCol.z, alpha );
		// return color for current pixel
		return resultCol;
	}
]]
