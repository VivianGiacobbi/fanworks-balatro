local deckInfo = {
    name = 'Arcane Deck',
    config = {
        select_limit = 1,
        consumable_slot = -1
    },
    unlocked = false,
    unlock_condition = {type = 'use_consumable', set = 'Tarot', num = 22},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
    artist = 'Vivian Giacobbi',
    programmer = 'Vivian Giacobbi',
}

function deckInfo.check_for_unlock(self, args)
    if not G.GAME or args.type ~= self.unlock_condition.type then
        return false
    end

    local tally = 0
    for _, v in pairs(G.GAME.consumeable_usage) do
        if v.set == self.unlock_condition.set then
            tally = tally + 1
            if tally >= self.unlock_condition.num then return true end
        end
    end
end

function deckInfo.locked_loc_vars(self, info_queue, card)
    return {
        vars = {
            self.unlock_condition.num,
            localize('b_tarot_cards'),
            colours = {
                G.C.SECONDARY_SET.Tarot
            }
        }
    }
end

function deckInfo.loc_vars(self, info_queue, card)
    return {
        vars = {
            self.config.select_limit,
            self.config.consumable_slot
        }
    }
end

function deckInfo.apply(self, back)
    ArrowAPI.game.consumable_selection_mod(back.effect.config.select_limit)
end

return deckInfo