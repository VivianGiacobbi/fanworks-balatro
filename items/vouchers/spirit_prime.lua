local voucherInfo = {
    name = 'Type Prime',
    config = {
        extra = {
            key = 'c_fnwk_closer_artificial'
        }
    },
    cost = 10,
    requires = {'v_fnwk_spirit_binary'},
    unlocked = false,
    unlock_condition = { type = 'fnwk_win_deck', deck = 'b_fnwk_fanworks_deck', stake = 8 },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'spirit',
		},
        custom_color = 'spirit',
    },
}

function voucherInfo.loc_vars(self, info_queue, card)
    return { vars = {localize{type = 'name_text', key = card.ability.extra.key, set = 'Stand'}}}
end

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return {
        vars = {
            localize{type = 'name_text', key = self.unlock_condition.deck, set = 'Back'},
            localize{type = 'name_text', key = SMODS.stake_from_index(self.unlock_condition.stake), set = 'Stake'},
            colours = {get_stake_col(self.unlock_condition.stake)}
        }
    }
end

function voucherInfo.check_for_unlock(self, args)
	return (args.type == self.unlock_condition.type and get_deck_win_stake(self.unlock_condition.deck) >= self.unlock_condition.stake)
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            SMODS.add_card({set = 'Stand', area = G.consumeables, no_edition = true, key = card.ability.extra.key})
            return true
        end)
    }))
end

return voucherInfo