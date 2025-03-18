local jokerInfo = {
    key = 'j_fnwk_bluebolt_sexy',
    name = 'Sexy Rust Joker',
	config = {
        extra = {
            base_chips = 69,
            chips_mod = 30,
            women = {
                ['j_lusty_joker'] = true,
                ['j_hack'] = true,
                ['j_blueprint'] = true,
                ['j_brainstorm'] = true,
                ['j_shoot_the_moon'] = true,
                ['j_fnwk_plancks_unsure'] = true,
                ['j_fnwk_rubicon_moonglass'] = true,
                ['j_fnwk_streetlight_fledgling'] = true,
                ['j_fnwk_streetlight_indulgent'] = true,
                ['j_fnwk_streetlight_industrious'] = true,
                ['j_fnwk_streetlight_methodical'] = true,
                ['j_fnwk_rubicon_film'] = true,
                ['j_fnwk_streetlight_resil'] = true,
                ['j_fnwk_bone_destroyer'] = true,
                ['j_fnwk_gotequest_killing'] = true,
                ['j_fnwk_jspec_joepie'] = true,
                ['j_fnwk_jspec_ilsa'] = true,
            },
            trans_women = {
                ['j_drivers_license'] = true,
                ['j_fnwk_rockhard_rebirth'] = true,
            },
            junkies = {
                ['j_fnwk_gotequest_lambiekins'] = 2,
                ['j_egg'] = 1,
                ['j_fnwk_bluebolt_secluded'] = 1,
                ['j_fnwk_bluebolt_tuned'] = 1,
                ['j_fnwk_bluebolt_jokestar'] = 1,
                ['j_fnwk_bluebolt_sexy'] = 1,
                ['j_fnwk_bluebolt_impaired'] = 1,
            }
        }
    },
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'bluebolt'
}

local function find_women(card, key) 
    local junkie = card.ability.extra.junkies[key]
    local t_woman = card.ability.extra.trans_women[key]
    local woman = card.ability.extra.women[key]
    return {junkie = junkie, t_woman = t_woman, woman = woman}
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_mal", set = "Other"}
    if not G.jokers then
        return { vars = {card.ability.extra.base_chips, card.ability.extra.chips_mod, card.ability.extra.base_chips} }
    end

	local count = 0
    for i=1, #G.jokers.cards do
        if G.jokers.cards[i] ~= card then
            local results = find_women(card, G.jokers.cards[i].config.center.key)
            if results.junkie or results.t_woman or results.woman then
                count = count + 1
            end
        end
    end

    sendDebugMessage()

	return { 
        vars = {
            card.ability.extra.base_chips,
            card.ability.extra.chips_mod,
            card.ability.extra.base_chips + card.ability.extra.chips_mod * count
        }
    }
end

function jokerInfo.calculate(self, card, context)
    
    if (context.buying_card and context.card.ability.set == 'Joker') or (context.joker_created and context.card.area == G.jokers) and not context.blueprint then
            
        if context.card == card then
            return
        end

        local results = find_women(card, context.card.config.center.key)
        if not (results.junkie or results.t_woman or results.woman) then
            return
        end

        local speech_key = 'mq'

        -- find specific quotes
        if results.junkie then
            speech_key = speech_key..'_'..context.card.config.center.key
            if results.junkie > 1 then
                speech_key = speech_key..'_'..results.junkie
            end
        end

        -- find trans women quotes
        if results.t_woman then
            speech_key = speech_key..'t_'..math.random(1, 3)
        end

        -- find women quotes
        if results.woman then
            speech_key = speech_key..'_'..math.random(1,19)
        end

        -- maggie says some shit
        card:say_quip(2, nil, true)
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            blockable = false,
            blocking = false,
            func = function()
                card:add_quip(speech_key, 'bm', nil, {text_alignment = "cm"})
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 4.5,
                    blocking = false,
                    func = function()
                        card:remove_quip()
                        return true
                    end
                }))
                return true
            end
        }))
        return
    end
    if not context.cardarea == G.jokers or not context.joker_main or card.debuff then
        return
    end

    if not (context.scoring_name == 'Pair' or context.scoring_name == 'Three of a Kind' or context.scoring_name == 'Four of a Kind') then
        return
    end

    local count = 0
    for i=1, #G.jokers.cards do
        if G.jokers.cards[i] ~= card then
            local results = find_women(card, G.jokers.cards[i].config.center.key)
            if results.junkie or results.t_woman or results.woman then
                count = count + 1
            end
        end
    end

    local total_chips = card.ability.extra.base_chips + card.ability.extra.chips_mod * count
    return {
        message = localize{ type='variable', key='a_chips', vars = {total_chips} },
        chip_mod = total_chips, 
        colour = G.C.CHIPS,
        card = context.blueprint_card or card
    }
end

return jokerInfo