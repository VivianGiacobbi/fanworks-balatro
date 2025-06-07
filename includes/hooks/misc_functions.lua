---------------------------
--------------------------- Custom localization colors
---------------------------

local ref_loc_colour = loc_colour
function loc_colour(_c, _default)
	ref_loc_colour(_c, _default)
	G.ARGS.LOC_COLOURS.fanworks = G.C.FANWORKS
	G.ARGS.LOC_COLOURS.crystal = G.C.CRYSTAL
	return G.ARGS.LOC_COLOURS[_c] or _default or G.C.UI.TEXT_DARK
end





---------------------------
--------------------------- Fibonacci calculation
---------------------------

local function is_perfect_square(x)
	local sqrt = math.sqrt(x)
	return sqrt^2 == x
end

function jojobal_get_fibonacci(hand)
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





---------------------------
--------------------------- Pseudoseed hooking for prediction
---------------------------

function fnwk_psuedoseed_predict(bool)
	G.GAME.pseudorandom.predict_mode = bool or false
	G.GAME.pseudorandom.predicts = {}
	return G.GAME.pseudorandom.predict_mode
end





---------------------------
--------------------------- utility functions
---------------------------


function fnwk_get_most_played_hand()
	local hand = 'High Card'
	local played = -1;
	local order = 100;
	for k, v in pairs(G.GAME.hands) do
		if v.played > played or (v.played == played and order < v.order) then 
			played = v.played
			hand = k
		end
	end

	return hand, played
end


function fnwk_get_enhanced_tally(enhancement_key)
    local enhance_tally = 0

    if not G.playing_cards then
        return enhance_tally
    end
    if G.playing_cards then 
        for k, v in pairs(G.playing_cards) do
            if (not enhancement_key and v.ability.set == 'Enhanced') or SMODS.has_enhancement(v, enhancement_key) then 
                enhance_tally =  enhance_tally + 1
            end
        end
    end

    return enhance_tally
end





---------------------------
--------------------------- Extra blind helper functions
---------------------------

function fnwk_create_extra_blind(blind_source, blind_type)
	if not G.GAME then return end	

	local new_extra_blind = Blind(0, 0, 0, 0, blind_source)
	if G.GAME.blind.in_blind then
		new_extra_blind:extra_set_blind(blind_type)
	else
		new_extra_blind.config.blind = blind_type
		new_extra_blind.name = blind_type.name
		new_extra_blind.debuff = blind_type.debuff
		new_extra_blind.mult = blind_type.mult / 2
		new_extra_blind.disabled = false
		new_extra_blind.discards_sub = nil
		new_extra_blind.hands_sub = nil
		new_extra_blind.boss = not not blind_type.boss
		new_extra_blind.blind_set = false
		new_extra_blind.triggered = nil
		new_extra_blind.prepped = true
		new_extra_blind:set_text()
	end

	G.GAME.fnwk_extra_blinds[#G.GAME.fnwk_extra_blinds+1] = new_extra_blind
	return new_extra_blind
end

function fnwk_remove_extra_blind(blind_source)
	if not G.GAME then return end

	for i=1, #G.GAME.fnwk_extra_blinds do
		if G.GAME.fnwk_extra_blinds[i].fnwk_extra_blind == blind_source then
			local extra_blind = G.GAME.fnwk_extra_blinds[i]
			table.remove(G.GAME.fnwk_extra_blinds, i)

			if blind_source.ability and type(blind_source.ability) == 'table' then
                blind_source.ability.blind_type = nil
            end
            blind_source.blind_type = nil

			extra_blind:remove()

			return true
		end
	end

	return false
end





---------------------------
--------------------------- Cardsauce transform function
---------------------------

--- Based on code from Ortalab
--- Replaces a card in-place with a card of the specified key
--- @param card Card Balatro card table of the card to replace
--- @param to_key string string key (including prefixes) to replace the given card
function fnwk_transform_card(card, to_key)
	local new_center = G.P_CENTERS[to_key]
	card.children.center = Sprite(card.T.x, card.T.y, G.CARD_W, G.CARD_H, G.ASSET_ATLAS[new_center.atlas], new_center.pos)
	card.children.center.states.hover = card.states.hover
	card.children.center.states.click = card.states.click
	card.children.center.states.drag = card.states.drag
	card.children.center.states.collide.can = false
	card.children.center:set_role({major = card, role_type = 'Glued', draw_major = card})

	if new_center.soul_pos then
		card.children.floating_sprite = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[new_center.atlas], new_center.soul_pos)
		card.children.floating_sprite.role.draw_major = card
		card.children.floating_sprite.states.hover.can = false
		card.children.floating_sprite.states.click.can = false
	end

	card:set_ability(new_center)
	card:add_to_deck()
	card:set_cost()
end





---------------------------
--------------------------- pool modification
---------------------------
local ref_current_pool = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
	local pool, pool_key = ref_current_pool(_type, _rarity, _legendary, _append)
	if G.GAME.starting_params.fnwk_jokers_rate then
		local fnwk_rate = math.ceil(G.GAME.starting_params.fnwk_jokers_rate-1)
		for i, v in ipairs(pool) do
			if FnwkContainsString(v, 'j_fnwk') then
				for j=1, fnwk_rate do
					table.insert(pool, v, i)
				end
			end
		end
	end

	return pool, pool_key
end