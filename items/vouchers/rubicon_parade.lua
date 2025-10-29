local voucherInfo = {
    name = 'Black Parade',
    config = {},
    cost = 10,
    requires = {'v_fnwk_rubicon_kitty'},
    unlocked = false,
    unlock_condition = { edition = 'negative', count = 3 },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'rubicon',
		},
        custom_color = 'rubicon',
    },
	artist = 'cream'
}

function voucherInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = 'tag_negative', set = 'Tag'}
    info_queue[#info_queue+1] = G.P_CENTERS['e_negative']
    return { vars = {localize{type = 'name_text', key = 'tag_negative', set = 'Tag'}}}
end

function voucherInfo.locked_loc_vars(self, info_queue, card)
    return { vars = {self.unlock_condition.count, G.P_CENTERS['e_negative'].name}}
end

function voucherInfo.check_for_unlock(self, args)
    if args.type ~= 'modify_jokers' and args.type ~= 'fnwk_card_added' then return false end

    local ed_jokers = 0
    for _, v in ipairs(G.jokers.cards) do
        if v.edition and v.edition[self.unlock_condition.edition] then ed_jokers = ed_jokers + 1 end
    end

    return ed_jokers >= self.unlock_condition.count
end

function voucherInfo.calculate(self, card, context)
    if context.round_eval and G.GAME.blind:get_type() == 'Boss' then
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