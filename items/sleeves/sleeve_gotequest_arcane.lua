local sleeveInfo = {
    name = 'Fanworks Sleeve',
    config = { select_limit = 1, stand_limit_mod = 1, },
    unlocked = false,
    unlock_condition = { deck = "b_fnwk_fanworks_deck", stake = "stake_green" },
}

sleeveInfo.apply = function(self, sleeve)
    ArrowAPI.game.consumable_selection_mod(self.config.select_limit)
    G.GAME.modifiers.max_stands = math.max(0, (G.GAME.modifiers.max_stands or 1) - self.config.stand_limit_mod)
    CardSleeves.Sleeve.apply(sleeve)
end

return sleeveInfo