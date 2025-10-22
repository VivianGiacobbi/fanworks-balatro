SMODS.Atlas({ key = 'jojo_deck_lc', path = 'fnwk_jojo_deck_lc.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'jojo_deck_hc', path = 'fnwk_jojo_deck_hc.png', px = 71, py = 95 })

local suits = {'Hearts', 'Diamonds', 'Clubs', 'Spades'}
local faces = {"Jack", "Queen", "King"}
for _, v in ipairs(suits) do
    SMODS.DeckSkin{
        key = "fnwk_jojo_"..v:lower(),
        suit = v,
        ranks = faces,
        display_ranks = faces,
        palettes = {
            {
                key = 'lc',
                ranks = faces,
                atlas = 'fnwk_jojo_deck_lc',
                display_ranks = faces,
                pos_style = 'deck',
                colour = G.C.SUITS[v],
                suit_icon = {
                    atlas = 'ui_1',
                    pos = 1
                },
            },
            {
                key = 'hc',
                ranks = faces,
                atlas = 'fnwk_jojo_deck_hc',
                display_ranks = faces,
                pos_style = 'deck',
                colour = G.C.SUITS[v],
                suit_icon = {
                    atlas = 'ui_2',
                    pos = 1
                },
            },
        },
        loc_txt = {
            ['en-us'] = 'JoJo '..v
        },
        prefix_config = { key = false },
    }
end