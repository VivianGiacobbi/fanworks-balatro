local jokerInfo = {
	name = 'The Firewalker',
	config = {
        extra = {
            joker_opts = { 'j_popcorn', 'j_ice_cream'}
        }
    },
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'double',
		},
        custom_color = 'double',
    },
    artist = 'durandal'
}

function jokerInfo.calculate(self, card, context)
    if context.after and hand_chips*mult > G.GAME.blind.chips then
        G.E_MANAGER:add_event(Event({
            func = function()
                card:juice_up()
                play_sound('generic1')
                local new_card = SMODS.add_card({key = pseudorandom_element(card.ability.extra.joker_opts), area = G.jokers, edition = 'e_negative'})
                new_card:start_materialize()
                return true
            end
        }))
        end
    end
return jokerInfo