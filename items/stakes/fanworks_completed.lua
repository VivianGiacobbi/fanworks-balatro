local stakeInfo = {
    applied_stakes = {'gold'},
    unlocked = false,
    shiny = true,
    colour = G.C.BLACK,
    above_stake = 'gold',
}

function stakeInfo.modifiers()
    -- remove the gold/orange/black stake ones in favor of a centralized fnwk one
    G.GAME.modifiers.enable_eternals_in_shop = nil
    G.GAME.modifiers.enable_perishables_in_shop = nil
    G.GAME.modifiers.enable_rentals_in_shop = nil

    G.GAME.modifiers.fnwk_completed_stakes_in_shop = true
end

return stakeInfo