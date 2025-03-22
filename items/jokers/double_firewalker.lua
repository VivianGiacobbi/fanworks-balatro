local jokerInfo = {
	name = 'The Firewalker',
	config = {
        extra = {
        }
    },
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'double'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
end

local options = { 'j_popcorn', 'j_ice_cream'}

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.final_scoring_step then
        if hand_chips*mult > G.GAME.blind.chips then
            G.E_MANAGER:add_event(Event({
                SMODS.add_card({key = pseudorandom_element(options), area = G.jokers, edition = 'e_negative'}),
        }))
            end
        end
    end
return jokerInfo