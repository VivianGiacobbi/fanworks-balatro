local jokerInfo = {
	name = 'Infidel Jokestar',
	config = {
        extra = 3
    },
	rarity = 2,
	cost = 7,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'rubicon',
		},
        custom_color = 'rubicon',
    },
	artist = 'CreamSodaCrossroads',
	programmer = 'Vivian Giacobbi',
}

function jokerInfo.loc_vars(self, info_queue, card)
    if not G.GAME or not G.GAME.fnwk_infidel_suits then
        return {  vars = { 'Clubs', 'Spades', colours = {G.C.SUITS['Clubs'], G.C.SUITS['Spades']}} }
    end

    local suits = {}
    for k, v in pairs(G.GAME.fnwk_infidel_suits) do
		if k ~= 'main_suit' then
			suits[#suits+1] = k
		end
    end

	return {  vars = { suits[1], suits[2], colours = {G.C.SUITS[suits[1]], G.C.SUITS[suits[2]]}} }
end

return jokerInfo