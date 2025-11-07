local deckInfo = {
    name = 'ACT Deck',
    config = {},
    unlocked = false,
    unlock_condition = { type = 'win_deck', deck = 'b_fnwk_fanworks_deck', stake = 6 },
    discovered = true,
    artist = 'Vivian Giacobbi',
    programmer = 'Vivian Giacobbi',
}

function deckInfo.locked_loc_vars(self, info_queue, card)
    local other_name = localize('k_unknown')
    if G.P_CENTERS[self.unlock_condition.deck].unlocked then
        other_name = localize{type = 'name_text', key = self.unlock_condition.deck, set = 'Back'}
    end
    return {
        vars = {
            other_name,
            localize{type = 'name_text', key = SMODS.stake_from_index(self.unlock_condition.stake), set = 'Stake'},
            colours = {get_stake_col(self.unlock_condition.stake)}
        }
    }
end

function deckInfo.check_for_unlock(self, args)
	return (args.type == self.unlock_condition.type and get_deck_win_stake(self.unlock_condition.deck) >= self.unlock_condition.stake)
end

function deckInfo.apply(self, back)
    G.GAME.starting_params.fnwk_act_rarity = true
end

return deckInfo