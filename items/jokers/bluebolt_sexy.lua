local jokerInfo = {
    key = 'j_fnwk_bluebolt_sexy',
    name = 'Sexy Rust Joker',
	config = {
        extra = {
            base_chips = 69,
            chips_mod = 30,
        }
    },
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'bluebolt'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_mal", set = "Other"}
    if not G.jokers then
        return { vars = {card.ability.extra.base_chips, 0, card.ability.extra.chips_mod } }
    end

	local count = 0
    for i=1, #G.jokers.cards do
        if G.jokers.cards[i] ~= card then
            local results = FnwkFindWomen(G.jokers.cards[i].config.center.key)
            if results.junkie or results.trans or results.cis then
                count = count + 1
            end
        end
    end

	return { 
        vars = {
            card.ability.extra.base_chips + card.ability.extra.chips_mod * count,
            count,
            card.ability.extra.chips_mod,
        }
    }
end

function jokerInfo.calculate(self, card, context)
    
    if context.card_added and context.card.area == G.jokers and not context.blueprint then 
        if context.card == card then
            return
        end

        local results = FnwkFindWomen(context.card.config.center.key)
        if not (results.junkie or results.trans or results.cis) then
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
        if results.trans then
            speech_key = speech_key..'t_'..math.random(1, 3)
        end

        -- find women quotes
        if results.cis then
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
            local results = FnwkFindWomen(G.jokers.cards[i].config.center.key)
            if results.junkie or results.trans or results.cis then
                count = count + 1
            end
        end
    end

    local total_chips = card.ability.extra.base_chips + card.ability.extra.chips_mod * count
    return {
        chips = total_chips,
    }
end

return jokerInfo