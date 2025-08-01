local deckInfo = {
    name = 'Arcane Deck',
    config = {
        select_limit = 1,
        stand_limit_mod = -1,
        consumable_slot = -1
    },
    unlocked = false,
    unlock_condition = {type = 'use_consumable', set = 'Tarot', num = 22},
    fanwork = 'gotequest',
    artist = 'winter'
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
            self.config.stand_limit_mod,
            self.config.consumable_slot
        }
    }
end

function deckInfo.apply(self, back)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.modifiers.consumable_selection_mod = (G.GAME.modifiers.consumable_selection_mod or 0) + back.effect.config.select_limit
            G.GAME.modifiers.max_stands = math.max(0, (G.GAME.modifiers.max_stands or 1) - back.effect.config.stand_limit_mod)
            return true
        end
    }))
end

return deckInfo