local voucherInfo = {
    name = 'Black Parade',
    config = {},
    cost = 10,
    requires = {'v_fnwk_rubicon_kitty'},
    unlocked = false,
    unlock_condition = { type = 'have_edition', edition = 'negative', count = 3 },
    fanwork = 'rubicon'
}

function voucherInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = 'tag_negative', set = 'Tag'}
    info_queue[#info_queue+1] = G.P_CENTERS['e_negative']
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.cream }}
    return { vars = {localize{type = 'name_text', key = 'tag_negative', set = 'Tag'}}}
end

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return { vars = {self.unlock_condition.count, G.P_CENTERS['e_negative'].name}}
end

function voucherInfo.check_for_unlock(self, args)
    if not G.jokers or args.type ~= self.unlock_condition.type then
        return false
    end

    local ed_jokers = 0
    for k, v in ipairs(G.jokers.cards) do
        if v.edition and v.edition[self.unlock_condition.edition] then ed_jokers = ed_jokers + 1 end
    end
    
    return ed_jokers >= self.unlock_condition.count
end

function voucherInfo.calculate(self, card, context)
    if context.cash_out and G.GAME.last_blind and G.GAME.last_blind.boss then
        G.E_MANAGER:add_event(Event({
            delay = 0.4,
            trigger = 'after',
            blocking = 'false',
            func = (function()
                add_tag(Tag('tag_negative'))
                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                return true
            end)
        }))
    end
end

return voucherInfo