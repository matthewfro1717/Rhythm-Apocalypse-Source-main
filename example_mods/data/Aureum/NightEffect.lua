function onCreatePost()
	makeLuaSprite('NightEffect', 'Bambi/NightEffect', 0, 0)
	addLuaSprite('NightEffect',true)
	setObjectCamera('NightEffect', 'camgame')
	setProperty('NightEffect.scale.x', 100.5);
    setProperty('NightEffect.scale.y', 100.5);
	setProperty('NightEffect.alpha', 0.6)

end