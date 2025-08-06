local consumInfo = {
    name = 'Paperback Writer: REWRITE',
    set = 'Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'AEE4F9DC', '009CFDDC' },
        evolved = true,
        extra = {
            normal_mod = 1,
            chance = 1000
        }
    },
    cost = 4,
    rarity = 'EvolvedRarity',
    alerted = true,
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
    artist = 'piano',
    blueprint_compat = false,
}

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = {SMODS.get_probability_vars(card, card.ability.extra.normal_mod, card.ability.extra.chance, 'fnwk_streetlight_rewrite')} }
end

function consumInfo.calculate(self, card, context)
    if not context.reroll_shop or context.blueprint or card.debuff or context.joker_retrigger then return end

    if SMODS.pseudorandom_probability(card, 'fnwk_streetlight_rewrite', card.ability.extra.normal_mod, card.ability.extra.chance, 'fnwk_streetlight_rewrite') then
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card.ability.fnwk_rewrite_destroyed = true
                card:start_dissolve()
                return true
            end
        }))
    end

    card.ability.extra.normal_mod = card.ability.extra.normal_mod + 1
end



return consumInfo