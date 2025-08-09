local jokerInfo = {
	name = 'Acerbic Fencer',
	config = {
        extra = {}
    },
	rarity = 1,
	cost = 4,
    unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'double',
		},
        custom_color = 'double',
    },
    artist = 'gote'
}

function jokerInfo.check_for_unlock(self, args)
    if not G.playing_cards then
        return false
    end
    
    if not args or args.type ~= 'queen_to_king' then
        return false
    end

    return true
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.first_hand_drawn then
        local faces = {}
        for _, rank_key in ipairs(SMODS.Rank.obj_buffer) do
            local rank = SMODS.Ranks[rank_key]
            if rank.face then table.insert(faces, rank) end
        end
        local new_face = SMODS.create_card({
            set = "Base",
            area = G.discard,
            rank = pseudorandom_element(faces, 'familiar_create').card_key
        })
        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
        new_face.playing_card = G.playing_card
        table.insert(G.playing_cards, new_face)

        local juice_card = context.blueprint_card or card
        G.E_MANAGER:add_event(Event({
            func = function()
                G.hand:emplace(new_face)
                new_face:start_materialize()
                G.GAME.blind:debuff_card(new_face)
                G.hand:sort()
                juice_card:juice_up()
                return true
            end
        }))
        delay(0.6)
        playing_card_joker_effects({new_face})

        return nil, true
    end
end

return jokerInfo