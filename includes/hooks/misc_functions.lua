loc_colour = function(_c, _default)
	G.ARGS.LOC_COLOURS = G.ARGS.LOC_COLOURS or {
	  red = G.C.RED,
	  mult = G.C.MULT,
	  blue = G.C.BLUE,
	  chips = G.C.CHIPS,
	  green = G.C.GREEN,
	  money = G.C.MONEY,
	  gold = G.C.GOLD,
	  attention = G.C.FILTER,
	  purple = G.C.PURPLE,
	  white = G.C.WHITE,
	  inactive = G.C.UI.TEXT_INACTIVE,
	  spades = G.C.SUITS.Spades,
	  hearts = G.C.SUITS.Hearts,
	  clubs = G.C.SUITS.Clubs,
	  diamonds = G.C.SUITS.Diamonds,
	  tarot = G.C.SECONDARY_SET.Tarot,
	  planet = G.C.SECONDARY_SET.Planet,
	  spectral = G.C.SECONDARY_SET.Spectral,
	  edition = G.C.EDITION,
	  dark_edition = G.C.DARK_EDITION,
	  legendary = G.C.RARITY[4],
	  enhanced = G.C.SECONDARY_SET.Enhanced,
	  fanworks = G.C.FANWORKS,
	}
	return G.ARGS.LOC_COLOURS[_c] or _default or G.C.UI.TEXT_DARK
end