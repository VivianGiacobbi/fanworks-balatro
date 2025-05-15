local deckInfo = {
    name = 'ACT Deck',
    config = {},
    discovered = true,
}

function deckInfo.apply(self, back)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.starting_params.fnwk_act_rarity = true
            return true
        end
    }))
end

return deckInfo