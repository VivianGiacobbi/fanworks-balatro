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
	fanwork = 'double',
    in_progress = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.durandal }}
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.after then
        if hand_chips*mult > G.GAME.blind.chips then
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
    end
return jokerInfo