local ref_loc_colour = loc_colour
function loc_colour(_c, _default)
	ref_loc_colour(_c, _default)
	G.ARGS.LOC_COLOURS.fanworks = G.C.FANWORKS
	return G.ARGS.LOC_COLOURS[_c] or _default or G.C.UI.TEXT_DARK
end

local function is_perfect_square(x)
	local sqrt = math.sqrt(x)
	return sqrt^2 == x
end

function csau_get_fibonacci(hand)
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

function fnwk_psuedoseed_predict(bool)
	G.GAME.pseudorandom.predict_mode = bool or false
	G.GAME.pseudorandom.predicts = {}
	return G.GAME.pseudorandom.predict_mode
end

function fnwk_balance_score(card)
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

G.FUNCS.reset_trophies = function(e)
	local warning_text = e.UIBox:get_UIE_by_ID('warn')
	if warning_text.config.colour ~= G.C.WHITE then
		warning_text:juice_up()
		warning_text.config.colour = G.C.WHITE
		warning_text.config.shadow = true
		e.config.disable_button = true
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06, blockable = false, blocking = false, func = function()
			play_sound('tarot2', 0.76, 0.4);return true end}))
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.35, blockable = false, blocking = false, func = function()
			e.config.disable_button = nil;return true end}))
		play_sound('tarot2', 1, 0.4)
	else
		G.FUNCS.wipe_on()
		for k, v in pairs(SMODS.Achievements) do
			if FnwkStringStartsWith(k, 'ach_fnwk_') then
				G.SETTINGS.ACHIEVEMENTS_EARNED[k] = nil
				G.ACHIEVEMENTS[k].earned = nil
			end
		end
		G:save_settings()
		G.E_MANAGER:add_event(Event({
			delay = 1,
			func = function()
				G.FUNCS.wipe_off()
				return true
			end
		}))
	end
end

function G.FUNCS.fnwk_apply_alts()
	fnwk_enabled = copy_table(fnwk_config)
    for k, v in pairs(G.P_CENTERS) do
		if v.alt_art then
			v.atlas = string.sub(k, 3, #k)..(fnwk_enabled['enableAltArt'] and '_alt' or '')
			sendDebugMessage(v.atlas)
		end
    end
end

function G.FUNCS.fnwk_set_skeptic()
	fnwk_enabled = copy_table(fnwk_config)
end

function G.FUNCS.fnwk_restart()

	local settingsMatch = true
	for k, v in pairs(fnwk_enabled) do
		if v ~= fnwk_config[k] then
			settingsMatch = false
		end
	end
	
	if settingsMatch then
		sendDebugMessage('Settings match')
		SMODS.full_restart = 0
	else
		sendDebugMessage('Settings mismatch, restart required')
		SMODS.full_restart = 1
	end
end

local draw_from_deck_to_handref = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS.draw_from_deck_to_hand(e)
	local hand_limit = e
	if G.GAME.dzrawlin then
		hand_limit = #G.deck.cards + #G.hand.cards
	end
	
	SMODS.calculate_context({pre_draw = true})
	return draw_from_deck_to_handref(hand_limit)
end


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
			table.remove(G.GAME.fnwk_extra_blinds, i)
			return true
		end
	end

	return false
end