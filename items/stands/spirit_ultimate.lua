local consumInfo = {
    name = 'Ultimate Showdown of Ultimate Destiny',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'F4C275DC' },
        extra = {
            base_retriggers = 1,
            retrigger_mod = 0
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'spirit',
    in_progress = true,
    requires_stands = true,
}

local function recursive_flare_table(count)

end

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    local first_grammar = FnwkCountGrammar(card.ability.extra.base_retriggers + card.ability.extra.base_retriggers * card.ability.extra.retrigger_mod)
    local second_grammar = ''
    if FnwkContainsString(first_grammar, ' times') then
        first_grammar = string.sub(first_grammar, 1, #first_grammar - 6)
        second_grammar = ' times'
    end
    return { 
        vars = {
            first_grammar,
            second_grammar,
            card.ability.extra.base_retriggers
        } 
    }
end

function consumInfo.calculate(self, card, context)
    if context.fnwk_joker_destroyed and context.joker ~= card then
        local name = string.lower(context.joker.config.center.name)
        if FnwkContainsString(name, 'jokestar') then
            card.ability.extra.retrigger_mod = card.ability.extra.retrigger_mod + 1
            return {
                message = localize('k_upgrade_ex'),
            }
        end
    end

    if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_lucky') then
        local reps = card.ability.extra.base_retriggers + card.ability.extra.base_retriggers * card.ability.extra.retrigger_mod
        local gold_count = 0
        for _, v in ipairs(G.hand.cards) do
            if SMODS.has_enhancement(v, 'm_gold') then gold_count = gold_count + 1 end
        end

        if gold_count > 0 then
            local flare_func = function()
                G.FUNCS.csau_flare_stand_aura(card, 0.38)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blocking = false,
                    func = function()
                        card:juice_up()
                        return true
                    end 
                }))
            end

            local return_table = {
                func = flare_func,
                message = localize('k_again_ex'),
                repetitions = 1,
                card = context.other_card,
            }

            local recurse_table = return_table
            for i=1, (gold_count * reps) - 1 do
                recurse_table.extra = {
                    func = flare_func,
                    message = localize('k_again_ex'),
                    repetitions = 1,
                    card = context.other_card,
                }

                recurse_table = recurse_table.extra
            end

            return return_table
        end     
    end
end

return consumInfo