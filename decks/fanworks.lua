local deckInfo = {
    name = 'Fanworks Deck',
    config = {
        extra = 2, 
        vouchers = {
            'v_overstock_norm',
        },
    },
    unlocked = true,
    discovered = true,
}

function deckInfo.loc_vars(self, info_queue, card)
    return {vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}, self.config.extra}}
end

return deckInfo