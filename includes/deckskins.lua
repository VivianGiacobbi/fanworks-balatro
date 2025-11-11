SMODS.Atlas({ key = 'jojo_deck_lc', path = 'fnwk_jojo_deck_lc.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'jojo_deck_hc', path = 'fnwk_jojo_deck_hc.png', px = 71, py = 95 })

local suits = {'Hearts', 'Diamonds', 'Clubs', 'Spades'}
local ranks = {"Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"}
for _, v in ipairs(suits) do
    SMODS.DeckSkin{
        key = "fnwk_jojo_"..v:lower(),
        suit = v,
        ranks = ranks,
        display_ranks = {"Ace", "Jack", "Queen", "King"},
        palettes = {
            {
                key = 'lc',
                ranks = ranks,
                atlas = 'fnwk_jojo_deck_lc',
                display_ranks = {"Ace", "Jack", "Queen", "King"},
                pos_style = 'deck',
                colour = G.C.SUITS[v],
                suit_icon = {
                    atlas = 'ui_1',
                    pos = 1
                },
                artist = 'CreamSodaCrossroads'
            },
            {
                key = 'hc',
                ranks = ranks,
                atlas = 'fnwk_jojo_deck_hc',
                display_ranks = {"Ace", "Jack", "Queen", "King"},
                pos_style = 'deck',
                colour = G.C.SUITS[v],
                suit_icon = {
                    atlas = 'ui_2',
                    pos = 1
                },
                artist = 'CreamSodaCrossroads'
            },
        },
        loc_txt = {
            ['en-us'] = 'JoJo '..v
        },
        prefix_config = { key = false },
        artist = 'CreamSodaCrossroads'
    }
end