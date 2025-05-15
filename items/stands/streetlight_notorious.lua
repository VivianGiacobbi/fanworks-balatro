local consumInfo = {
    name = 'NOTORIOUS',
    set = 'csau_Stand',
    config = {
        -- stand_mask = true,
        aura_colors = { 'FFFFFFDC', 'DCDCDCDC' },
        extra = {
            x_mult = 5,
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'streetlight',
    in_progress = true,
    requires_stands = true,
}

local function no_face_cards()
    if not G.playing_cards then return false end

    for _, v in ipairs(G.playing_cards) do
        if v:is_face() then return false end
    end

    return true
end

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.x_mult} }
end

function consumInfo.calculate(self, card, context)
    if not context.joker_main or not no_face_cards() then return end

    return {
        func = function()
            G.FUNCS.csau_flare_stand_aura(card, 0.5)
        end,
        extra = {
            x_mult = card.ability.extra.x_mult
        }
    }
end

return consumInfo