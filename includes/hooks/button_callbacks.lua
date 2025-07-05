local ref_reroll_shop = G.FUNCS.reroll_shop
G.FUNCS.reroll_shop = function(e)
    local paperbacks = SMODS.find_card('c_fnwk_streetlight_paperback')
    local rewrites = SMODS.find_card('c_fnwk_streetlight_paperback_rewrite')
    if G.GAME.current_round.fnwk_paperback_rerolls > 0 or (next(rewrites) and not rewrites[1].ability.fnwk_rewrite_destroyed) then
        local juice_cards = next(rewrites) and rewrites or {paperbacks[G.GAME.current_round.fnwk_paperback_rerolls]}
        for _, v in ipairs(juice_cards) do
            G.FUNCS.flare_stand_aura(v, 0.5)
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    v:juice_up()
                    return true
                end
            }))
            attention_text({
                text = localize('k_brienne'),
                scale = 1,
                hold = 0.35,
                backdrop_colour = G.C.STAND,
                align = 'bm',
                major = v,
                offset = {x = 0, y = 0.05*v.T.h}
            })
        end
        
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()

                for i = #G.shop_booster.cards, 1, -1 do
                    local c = G.shop_booster:remove_card(G.shop_booster.cards[i])
                    c:remove()
                    c = nil
                end

                for i = #G.shop_vouchers.cards, 1, -1 do
                    local c = G.shop_vouchers:remove_card(G.shop_vouchers.cards[i])
                    G.GAME.current_round.voucher.spawn[c.config.center.key] = false
                    c:remove()
                    c = nil
                end

                G.GAME.current_round.fnwk_paperback_rerolls = G.GAME.current_round.fnwk_paperback_rerolls - 1
                if G.GAME.current_round.fnwk_paperback_rerolls <= 0 then
                    G.GAME.current_round.fnwk_paperback_rerolls = 0
                end
                
                G.GAME.current_round.used_packs = {}
                for i=1, G.GAME.starting_params.boosters_in_shop + (G.GAME.modifiers.extra_boosters or 0) do
                    G.GAME.current_round.used_packs[i] = get_pack('shop_pack').key

                    local new_booster = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                    G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[G.GAME.current_round.used_packs[i]], {bypass_discovery_center = true, bypass_discovery_ui = true})
                    create_shop_card_ui(new_booster, 'Booster', G.shop_booster)
                    new_booster.ability.booster_pos = i
                    new_booster:start_materialize()
                    G.shop_booster:emplace(new_booster)
                end


                G.GAME.current_round.voucher = SMODS.get_next_vouchers()

                for _, key in ipairs(G.GAME.current_round.voucher or {}) do
                    if G.P_CENTERS[key] and G.GAME.current_round.voucher.spawn[key] then
                        SMODS.add_voucher_to_shop(key)
                    end
                end

                return true
            end
        }))
    end

    local ret = ref_reroll_shop(e)
    check_for_unlock({type = 'fnwk_shop_rerolled', amt = G.GAME.round_scores.times_rerolled.amt})
    return ret
end





---------------------------
--------------------------- Shout Behavior
---------------------------

local ref_check_buy_space = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    local shouts = SMODS.find_card('c_fnwk_jspec_shout')
    if not next(shouts) or card.ability.set ~= 'Joker' or card.ability.eternal then
        
        return ref_check_buy_space(card)
    end

    for _, v in ipairs(shouts) do
        if not v.debuff then
            return true
        end
    end

    return ref_check_buy_space(card)
end





---------------------------
--------------------------- Farewell to Kings evolution sprites
---------------------------

local ref_transform_card = G.FUNCS.transform_card
G.FUNCS.transform_card = function(card, to_key, evolve)
    if to_key == 'c_fnwk_bone_king_farewell' then
        local center = G.P_CENTERS[to_key]
        local old_soul_pos = center.soul_pos
        center.soul_pos = nil
        local ret = ref_transform_card(card, to_key, evolve)
        center.soul_pos = old_soul_pos
        return ret
    end

    return ref_transform_card(card, to_key, evolve)
end





---------------------------
--------------------------- Update debuff text for bosses
---------------------------
G.FUNCS.update_blind_debuff_text = function(e)
    if not e.config.object then return end

    local new_str = SMODS.debuff_text or G.GAME.blind:get_loc_debuff_text()
    if not new_str then return end
    
    if new_str ~= e.config.object.config.string[1].string then
        e.config.object.config.string[1].string = new_str
        e.config.object.start_pop_in = true
        e.config.object:update_text(true)
        e.UIBox:recalculate()
    end
end





---------------------------
--------------------------- Update debuff text for bosses
---------------------------
local ref_can_reroll = G.FUNCS.can_reroll
G.FUNCS.can_reroll = function(e)
    if not G.GAME.starting_params.fnwk_only_free_rerolls then
        return ref_can_reroll(e)
    end

    if G.GAME.current_round.free_rerolls <= 0 then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.GREEN
        e.config.button = 'reroll_shop'
    end
end



---------------------------
--------------------------- Main Menu UI callbacks
---------------------------

--[[
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
--]]

function G.FUNCS.fnwk_apply_alts()
	fnwk_enabled = copy_table(fnwk_config)
    for k, v in pairs(G.P_CENTERS) do
		if v.alt_art then
			v.atlas = string.sub(k, 3, #k)..(fnwk_enabled['enableAltArt'] and '_alt' or '')
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

function G.FUNCS.fnwk_start_rom(e)
	local rom = e.config.choice

	G.FUNCS:exit_overlay_menu()
    G.SETTINGS.SOUND.music_volume = 0
    G.SETTINGS.SOUND.game_sounds_volume = 100
    G.CONTROLLER.locks.frame = true

	G.EMU:init_video()
	G.EMU:init_audio()

	local start_pos = {
		x = 0,
		y = 0,
	}
	
	G.EMU:start_nes(rom, nil, nil, start_pos)
end





---------------------------
--------------------------- Challenge functions
---------------------------

local ref_challenge_desc = G.UIDEF.challenge_description_tab
function G.UIDEF.challenge_description_tab(args)
	args = args or {}

	if args._tab == 'Restrictions' then
		local challenge = G.CHALLENGES[args._id]
		if challenge.restrictions then
            if challenge.restrictions.banned_cards and type(challenge.restrictions.banned_cards) == 'function' then
                challenge.restrictions.banned_cards = challenge.restrictions.banned_cards()
            end

            if challenge.restrictions.banned_tags and type(challenge.restrictions.banned_tags) == 'function' then
                challenge.restrictions.banned_tags = challenge.restrictions.banned_tags()
            end

            if challenge.restrictions.banned_other and type(challenge.restrictions.banned_other) == 'function' then
                challenge.restrictions.banned_other = challenge.restrictions.banned_other()
            end
        end
	end

	return ref_challenge_desc(args)
end