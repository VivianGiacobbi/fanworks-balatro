local blindsToLoad = {
    'hog',
    'tray',
    'vod',
    'finger',
    'mochamike',
}

if not fnwk_enabled['enableAltArt'] then
	return
end

for i, v in ipairs(blindsToLoad) do
	local blindInfo = assert(SMODS.load_file("blinds/" .. v .. ".lua"))()

	blindInfo.key = v
	blindInfo.atlas = v
	if blindInfo.color then
		blindInfo.boss_colour = blindInfo.color
		blindInfo.color = nil
	end

	local blind = SMODS.Blind(blindInfo)
	for k_, v_ in pairs(blind) do
		if type(v_) == 'function' then
			blind[k_] = blindInfo[k_]
		end
	end

	SMODS.Atlas({ key = v, atlas_table = "ANIMATION_ATLAS", path = "blinds/" .. v .. ".png", px = 34, py = 34, frames = 21, })
end