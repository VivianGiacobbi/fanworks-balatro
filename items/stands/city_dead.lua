local consumInfo = {
    name = 'Dead Weight',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'DCFB8CDC', '4CB3D9DC' },
        extra = {
            tarot = 'c_hermit'
        }
    },
    cost = 4,
    rarity = 'arrow_StandRarity',
    hasSoul = true,
    fanwork = 'city',
    blueprint_compat = false,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.jester }}
    return { vars = {G.P_CENTERS[card.ability.extra.tarot].name}}
end

function consumInfo.calculate(self, card, context)
    if context.blueprint or context.joker_retrigger or card.debuff then
        return
    end

    if context.using_consumeable then
        local center_key = context.consumeable.config.center.key
        if center_key == 'c_emperor' or center_key == 'c_fool' then
            G.FUNCS.flare_stand_aura(card, 0.38)
        end
    end
end

return consumInfo