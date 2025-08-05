local blindInfo = {
    name = "The Creek",
    boss_colour = HEX('A0DAB2'),
    score_invisible = true,
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 1, max = 10},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'plancks',
		},
        custom_color = 'plancks',
    },
    artist = 'gote',
}

function blindInfo.set_blind(self)
    if G.GAME.blind.arrow_extra_blind then
        local mult = pseudorandom(pseudoseed('fnwk_creek'), 0, 6) * 0.25 + 1.75
		G.GAME.blind.mult = mult / 2
    else
        G.GAME.blind.mult = pseudorandom(pseudoseed('fnwk_creek'), 0, 6) * 0.25 + 1.75
        G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.blind.mult*G.GAME.starting_params.ante_scaling
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
end

return blindInfo