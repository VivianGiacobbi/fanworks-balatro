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
}

function deckInfo.check_for_unlock(self, args)
    local discovered = CheckFanworksDiscoveries(self)
    return discovered >= self.unlock_condition.num
end

function deckInfo.loc_vars(self, info_queue, card)
    return {vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}, self.config.extra}}
end

function deckInfo.locked_loc_vars(self, info_queue, card)
    local discovered = CheckFanworksDiscoveries(self)
    return {vars = {discovered, self.unlock_condition.num}}
end

return deckInfo