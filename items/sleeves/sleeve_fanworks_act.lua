local sleeveInfo = {
    name = 'Act Sleeve',
    unlocked = false,
    unlock_condition = { deck = 'b_fnwk_fanworks_act', stake = "stake_gold" },
}

function sleeveInfo.loc_vars(self, info_queue)
    return { key = self.key .. (self.get_current_deck_key() == 'b_fnwk_fanworks_act' and '_alt' or '')}
end

function sleeveInfo.apply(self, sleeve)
    G.GAME.starting_params.fnwk_act_rarity = true
    if self.get_current_deck_key() == 'b_fnwk_fanworks_act' then
        G.GAME.starting_params.fnwk_act_force_legend = true
        for _, v in ipairs(G.P_JOKER_RARITY_POOLS[4]) do
            G.GAME.banned_keys[v] = true
        end
    end
    CardSleeves.Sleeve.apply(sleeve)
end

return sleeveInfo