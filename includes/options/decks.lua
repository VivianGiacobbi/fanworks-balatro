local decksToLoad = {
    -- 'vine',
}

if not fnwk_enabled['enableDecks'] then
	return
end

for i, v in ipairs(decksToLoad) do
	local deckInfo = assert(SMODS.load_file("decks/" .. v .. ".lua"))()

	deckInfo.key = v
	deckInfo.atlas = v
	deckInfo.pos = { x = 0, y = 0 }
	if deckInfo.hasSoul then
		deckInfo.pos = { x = 1, y = 0 }
		deckInfo.soul_pos = { x = 2, y = 0 }
	end

	local deck = SMODS.Back(deckInfo)
	for k_, v_ in pairs(deck) do
		if type(v_) == 'function' then
			deck[k_] = deckInfo[k_]
		end
	end

	SMODS.Atlas({ key = v, path ="decks/" .. v .. ".png", px = deck.width or 71, py = deck.height or  95 })
end

-- need a better way to use this code, which is originally code used for the disc deck
