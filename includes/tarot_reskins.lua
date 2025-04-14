if not fnwk_enabled['enableTarotSkins'] then
    return
end

-- Tarot Atlas
SMODS.Atlas{
    key = "tarotreskins",
    path = "tarotreskins.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
}

SMODS.Consumable:take_ownership('c_fool', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        local fool_c = G.GAME.last_tarot_planet and G.P_CENTERS[G.GAME.last_tarot_planet] or nil
        local last_tarot_planet = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set} or localize('k_none')
        local colour = (not fool_c or fool_c.name == 'The Fool') and G.C.RED or G.C.GREEN
        local main_end = {
            {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                    {n=G.UIT.T, config={text = ' '..last_tarot_planet..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                }}
            }}
        }
        if not (not fool_c or fool_c.name == 'The Fool') then
            info_queue[#info_queue+1] = fool_c
        end

        info_queue[#info_queue+1] = {key = "artist_fool", set = "Other"}
        return { vars = {last_tarot_planet}, main_end = main_end }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('jspec')
    end
}, true)

SMODS.Consumable:take_ownership('c_magician', { 
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
        info_queue[#info_queue+1] = {key = "artist_magician", set = "Other"}
        return { vars = {card.ability.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv}} }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('asap')
    end
}, true)

SMODS.Consumable:take_ownership('c_high_priestess', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_priestess", set = "Other"}
        return { vars = {card.ability.planets} }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('plancks')
    end
}, true)

SMODS.Consumable:take_ownership('c_empress', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
        info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
        return { vars = {card.ability.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv}} } 
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('sunshine')
    end
}, true)

SMODS.Consumable:take_ownership('c_emperor', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_emperor", set = "Other"}
        return { vars = {card.ability.tarots}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('last')
    end
}, true)

SMODS.Consumable:take_ownership('c_heirophant', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
        info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
        return { vars = {card.ability.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv}} } 
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('moscow')
    end
}, true)

SMODS.Consumable:take_ownership('c_lovers', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
        info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
        return { vars = {card.ability.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv}} }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('gotequest')
    end
}, true)

SMODS.Consumable:take_ownership('c_chariot', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
        info_queue[#info_queue+1] = {key = "artist_chariot", set = "Other"}
        return { vars = {card.ability.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv}} }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('crimson')
    end
}, true)

SMODS.Consumable:take_ownership('c_justice', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
        info_queue[#info_queue+1] = {key = "artist_justice", set = "Other"}
        return { vars = {card.ability.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv}} }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('rubicon')
    end
}, true)

SMODS.Consumable:take_ownership('c_hermit', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_hermit", set = "Other"}
        return { vars = {card.ability.extra}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('city')
    end
}, true)

SMODS.Consumable:take_ownership('c_wheel_of_fortune', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        info_queue[#info_queue+1] = G.P_CENTERS.e_holo
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome 
        info_queue[#info_queue+1] = {key = "artist_wheel", set = "Other"}
        return { vars = {G.GAME.probabilities.normal, card.ability.extra} }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('jojopolis')
    end
}, true)

SMODS.Consumable:take_ownership('c_strength', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
        return { vars = {card.ability.max_highlighted}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('neon')
    end
}, true)

SMODS.Consumable:take_ownership('c_hanged_man', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_hanged", set = "Other"}
        return { vars = {card.ability.max_highlighted}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('lighted')
    end
}, true)

SMODS.Consumable:take_ownership('c_death', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_death", set = "Other"}
        return { vars = {card.ability.max_highlighted}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('rockhard')
    end
}, true)

SMODS.Consumable:take_ownership('c_temperance', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        local _money = 0
        if G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then
                    _money = _money + G.jokers.cards[i].sell_cost
                end
            end
        end
        
        info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
        return { vars = {card.ability.extra, math.min(card.ability.extra, _money)} }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('coi')
    end
}, true)

SMODS.Consumable:take_ownership('c_devil', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
        info_queue[#info_queue+1] = {key = "artist_devil", set = "Other"}
        return { vars = {card.ability.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv}} }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('spirit')
    end
}, true)

SMODS.Consumable:take_ownership('c_tower', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
        info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
        return { vars = {card.ability.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv}} }
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('mania')
    end
}, true)

SMODS.Consumable:take_ownership('c_star', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_star", set = "Other"}
        return { vars = {card.ability.max_highlighted,  localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('culture')
    end
}, true)

SMODS.Consumable:take_ownership('c_moon', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
        return { vars = {card.ability.max_highlighted,  localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('iron')
    end
}, true)

SMODS.Consumable:take_ownership('c_sun', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_sun", set = "Other"}
        return { vars = {card.ability.max_highlighted,  localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('streetlight')
    end
}, true)

SMODS.Consumable:take_ownership('c_judgement', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('industry')
    end
}, true)

SMODS.Consumable:take_ownership('c_world', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_world", set = "Other"}
        return { vars = {card.ability.max_highlighted,  localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('thorny')
    end
}, true)
