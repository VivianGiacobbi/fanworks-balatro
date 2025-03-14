local voucherInfo = {
    name = 'Black Parade',
    config = {},
    cost = 10,
    requires = {'v_fnwk_rubicon_kitty'},
    fanwork = 'rubicon'
}

function voucherInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = 'tag_negative', set = 'Tag'}
    info_queue[#info_queue+1] = G.P_CENTERS['e_negative']
    info_queue[#info_queue+1] = {key = "artist_cream", set = "Other"}
    return { vars = {localize{type = 'name_text', key = 'tag_negative', set = 'Tag'}}}
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