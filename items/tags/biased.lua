local tagInfo = {
    name = 'Biased Tag',
    config = {type = 'store_joker_create'},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
    artist = 'gote'
}

function tagInfo.apply(self, tag, context)
    if context.type == self.config.type and context.area == G.shop_jokers then
        local women_in_possession = {}
        local women_count = 0
        for _, v in ipairs(G.jokers.cards) do
            local results = G.fnwk_women.get_from_key(v.key)
            if (results.girl or results.trans or results.woman) and not women_in_possession[v.config.center.key] then
                women_count = women_count + 1
                women_in_possession[v.config.center.key] = true
            end
        end

        if #G.P_CENTER_POOLS['fnwk_women'] > women_count then 
            local new_woman = create_card('fnwk_women', context.area, nil, nil, nil, nil, nil, 'fnwk_biased_tag')
            create_shop_card_ui(new_woman, 'Joker', context.area)
            new_woman.states.visible = false
            tag:yep('+', G.C.RED, function()
                new_woman:start_materialize()
                new_woman.ability.couponed = true
                new_woman:set_cost()
                return true
            end)
            tag.triggered = true
            check_for_unlock({type = 'fnwk_biased_woman', new_card = new_woman})
            return new_woman
        else
            tag:nope()
            tag.triggered = true
            return nil
        end
    end
end

return tagInfo