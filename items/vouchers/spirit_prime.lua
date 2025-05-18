local voucherInfo = {
    name = 'Type Prime',
    config = {
        extra = 2
    },
    cost = 10,
    requires = {'v_fnwk_spirit_binary'},
    unlocked = false,
    unlock_condition = { type = 'win_deck', deck = 'b_csau_disc' },
    fanwork = 'sunshine'
}

function voucherInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra * 2}}
end

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return { vars = {self.unlock_condition.deck}}
end

function voucherInfo.check_for_unlock(self, args)
	return (args.type == "win_deck" and get_deck_win_stake(self.unlock_condition.deck))
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