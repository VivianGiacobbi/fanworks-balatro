loc_colour = function(_c, _default)
	G.ARGS.LOC_COLOURS = G.ARGS.LOC_COLOURS or {
	  red = G.C.RED,
	  mult = G.C.MULT,
	  blue = G.C.BLUE,
	  chips = G.C.CHIPS,
	  green = G.C.GREEN,
	  money = G.C.MONEY,
	  gold = G.C.GOLD,
	  attention = G.C.FILTER,
	  purple = G.C.PURPLE,
	  white = G.C.WHITE,
	  inactive = G.C.UI.TEXT_INACTIVE,
	  spades = G.C.SUITS.Spades,
	  hearts = G.C.SUITS.Hearts,
	  clubs = G.C.SUITS.Clubs,
	  diamonds = G.C.SUITS.Diamonds,
	  tarot = G.C.SECONDARY_SET.Tarot,
	  planet = G.C.SECONDARY_SET.Planet,
	  spectral = G.C.SECONDARY_SET.Spectral,
	  edition = G.C.EDITION,
	  dark_edition = G.C.DARK_EDITION,
	  legendary = G.C.RARITY[4],
	  enhanced = G.C.SECONDARY_SET.Enhanced,
	  fanworks = G.C.FANWORKS,
	}
	return G.ARGS.LOC_COLOURS[_c] or _default or G.C.UI.TEXT_DARK
end

local function is_perfect_square(x)
	local sqrt = math.sqrt(x)
	return sqrt^2 == x
end

function get_fibonacci(hand)
	local ret = {}
	if #hand < 5 then return ret end
	local vals = {}
	for i = 1, #hand do
		local value = hand[i].base.nominal
		if hand[i].base.value == 'Ace' then
			value = 1
		elseif SMODS.has_no_rank(hand[i]) then
			value = 0
		end
		
		vals[#vals+1] = value
	end
	table.sort(vals, function(a, b) return a < b end)

	if not vals[1] == 0 and not (is_perfect_square(5 * vals[1]^2 + 4) or is_perfect_square(5 * vals[1]^2 - 4)) then
		return ret
	end

	local sum = 0
	local prev_1 = vals[1]
	local prev_2 = 0
	for i=1, #vals do
		sum = prev_1 + prev_2
		
		if vals[i] ~= sum then
			return ret
		end

		prev_2 = prev_1
		prev_1 = vals[i] == 0 and 1 or vals[i]
	end

	local t = {}
	for i=1, #hand do
		t[#t+1] = hand[i]
	end

	table.insert(ret, t)
	return ret
end

function psuedoseed_predict(bool)
	G.GAME.pseudorandom.predict_mode = bool or false
	G.GAME.pseudorandom.predicts = {}
	return G.GAME.pseudorandom.predict_mode
end

function balance_score(card)
	local tot = hand_chips + mult
    hand_chips = math.floor(tot/2)
    mult = math.floor(tot/2)
    update_hand_text({delay = 0}, {mult = mult, chips = hand_chips})

    G.E_MANAGER:add_event(Event({
        func = (function()
            local text = localize('k_balanced')
			card:juice_up()
            play_sound('gong', 0.94, 0.3)
            play_sound('gong', 0.94*1.5, 0.2)
            play_sound('tarot1', 1.5)
            ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
            ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
            attention_text({
                scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
            })
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blockable = false,
                blocking = false,
                delay =  4.3,
                func = (function() 
                        ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
                        ease_colour(G.C.UI_MULT, G.C.RED, 2)
                    return true
                end)
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blockable = false,
                blocking = false,
                no_delete = true,
                delay =  6.3,
                func = (function() 
                    G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                    G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                    return true
                end)
            }))
            return true
        end)
    }))

    delay(0.6)
end