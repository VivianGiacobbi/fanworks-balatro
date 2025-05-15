local voucherInfo = {
    name = 'Totality',
    config = {
        extra = 2
    },
    cost = 10,
    requires = {'v_fnwk_sunshine_rapture'},
    unlocked = false,
    unlock_condition = { type = 'modify_jokers', rare_count = 5 },
    fanwork = 'sunshine'
}

function voucherInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra * 2}}
end

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return { vars = {self.unlock_condition.rare_count}}
end

function voucherInfo.check_for_unlock(self, args)
    if not G.jokers or args.type ~= self.unlock_condition.type then
        return false
    end

    local rare_jokers = 0
    for k, v in ipairs(G.jokers.cards) do
        if v.config.center.rarity == 3 then rare_jokers = rare_jokers + 1 end
    end
    
    return rare_jokers >= self.unlock_condition.rare_count
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.fnwk_rapture_mod = (G.GAME.fnwk_rapture_mod or 1) * card.ability.extra
            return true
        end)
    }))
end

return voucherInfo