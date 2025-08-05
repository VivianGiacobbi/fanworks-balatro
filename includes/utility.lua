function FnwkRandomSuitOrderCall(f, ...)
	local suit_buffer_copy = copy_table(SMODS.Suit.obj_buffer)
    local nominals_list = {}

    for i, v in ipairs(SMODS.Suit.obj_buffer) do
        nominals_list[i] = SMODS.Suits[v].suit_nominal
    end

    -- correctly seeded suit order randomization
    math.randomseed((pseudohash('fnwk_multimedia_shuffle'..(G.GAME.pseudorandom.seed or '')) + (G.GAME.pseudorandom.hashed_seed or 0))/2)
    for i = #suit_buffer_copy, 2, -1 do
		local j = math.random(i)
        local key1 = SMODS.Suit.obj_buffer[i]
        local key2 = SMODS.Suit.obj_buffer[j]
		SMODS.Suit.obj_buffer[i], SMODS.Suit.obj_buffer[j] = key2, key1
	end

    for i, v in ipairs(SMODS.Suit.obj_buffer) do
        SMODS.Suits[v].suit_nominal = nominals_list[i]
    end

    local old_suit_nominals = {}
    for i, v in ipairs(G.I.CARD) do
        if v.playing_card then
            old_suit_nominals[i] = {
                current = v.base.suit_nominal,
                original = v.base.suit_nominal_original
            }
            v.base.suit_nominal = SMODS.Suits[v.base.suit].suit_nominal
            v.base.suit_nominal_original = v.base.suit_nominal
        end
    end

    local ret = {f(...)}

    -- return the old values
    for i, v in ipairs(SMODS.Suit.obj_buffer) do
        SMODS.Suit.obj_buffer[i] = suit_buffer_copy[i]
        SMODS.Suits[SMODS.Suit.obj_buffer[i]].suit_nominal = nominals_list[i]
    end

    for i, v in ipairs(G.I.CARD) do
        if v.playing_card then
            v.base.suit_nominal = old_suit_nominals[i].current
            v.base.suit_nominal_original = old_suit_nominals[i].original
        end
    end

	return unpack(ret)
end