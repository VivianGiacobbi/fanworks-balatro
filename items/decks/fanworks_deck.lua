local deckInfo = {
    name = 'Fanworks Deck',
    config = {
        extra = 2, 
        vouchers = {
            'v_overstock_norm',
        },
    },
    unlocked = false,
    unlock_condition = {num = 25},
    discovered = true,
    fanwork = 'fanworks',
}

function deckInfo.check_for_unlock(self, args)
    local discovered = FnwkCheckFanworksDiscoveries(self)
    return discovered >= self.unlock_condition.num
end

function deckInfo.loc_vars(self, info_queue, card)
    return {vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}, self.config.extra}}
end

function deckInfo.locked_loc_vars(self, info_queue, card)
    local discovered = FnwkCheckFanworksDiscoveries(self)
    return {vars = {discovered, self.unlock_condition.num}}
end

deckInfo.apply = function(self, back)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.starting_params.fnwk_jokers_rate = G.GAME.starting_params.fnwk_jokers_rate or 1
            G.GAME.starting_params.fnwk_jokers_rate = G.GAME.starting_params.fnwk_jokers_rate * self.config.extra
            return true
        end
    }))
end

return deckInfo