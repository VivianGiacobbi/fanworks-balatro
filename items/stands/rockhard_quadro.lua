local consumInfo = {
	name = 'Quadrophenia',
    set = 'csau_Stand',
    config = {
        stand_mask = true,
        aura_colors = { '6A62D2DC', 'B64038DC' },
        extra = {
            hand = 'Four of a Kind',
            tarots = {'c_hanged_man', 'c_death'}
        }
    },
    cost = 4,
    rarity = 'csau_StandRarity',
    alerted = true,
    hasSoul = true,
    fanwork = 'rockhard',
    in_progress = true,
    requires_stands = true,
}

function consumInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.m_wild
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cringe }}
    return { 
        vars = {
            G.P_CENTERS[card.ability.extra.tarots[1]].name,
            G.P_CENTERS[card.ability.extra.tarots[2]].name,
            card.ability.extra.hand,
            colours = {
                G.C.SECONDARY_SET.Tarot,
                G.C.SECONDARY_SET.Tarot,
            }
        }
    }
end

function consumInfo.calculate(self, card, context)

end

return consumInfo