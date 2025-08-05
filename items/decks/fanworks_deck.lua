local deckInfo = {
    name = 'Fanworks Deck',
    config = {
        extra = 2, 
        vouchers = {
            'v_overstock_norm',
        },
    },
    unlocked = false,
    unlock_condition = {type = 'fnwk_discovered_card', num = 25},
    fanwork = 'fanworks',
    artist = 'gote'
}

function deckInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then
        return false
    end

    local discovered = ArrowAPI.game.check_mod_discoveries('fanworks', self)
    return discovered >= self.unlock_condition.num
end

function deckInfo.loc_vars(self, info_queue, card)
    return {vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}, self.config.extra}}
end

function deckInfo.locked_loc_vars(self, info_queue, card)
    local discovered = ArrowAPI.game.check_mod_discoveries('fanworks', self)
    return {vars = {discovered, self.unlock_condition.num}}
end

function deckInfo.apply(self, back)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.starting_params.fnwk_jokers_rate = G.GAME.starting_params.fnwk_jokers_rate or 1
            G.GAME.starting_params.fnwk_jokers_rate = G.GAME.starting_params.fnwk_jokers_rate * self.config.extra
            return true
        end
    }))
end

return deckInfo