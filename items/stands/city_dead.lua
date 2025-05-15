local consumInfo = {
    name = 'Dead Weight',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'DCFB8CDC', '4CB3D9DC' },
        extra = {
            tarot = 'c_hermit'
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'city',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {G.P_CENTERS[card.ability.extra.tarot].name}}
end

function consumInfo.calculate(self, card, context)
    if context.using_consumeable and not card.debuff then
        local center_key = context.consumeable.config.center.key
        if center_key == 'c_emperor' or center_key == 'c_fool' then
            G.FUNCS.csau_flare_stand_aura(card, 0.38)
        end
    end
end

return consumInfo