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
	fanwork = 'rubicon',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_cream", set = "Other"}

    if G.GAME and not G.GAME.infidel_suits then
        reset_infidel()
    end

    local suits = {}
    for k, v in pairs(G.GAME.infidel_suits) do
        suits[#suits+1] = k
    end

	return {  vars = { suits[1],suits[2], colours = {G.C.SUITS[suits[1]], G.C.SUITS[suits[2]]}} }
end

return jokerInfo