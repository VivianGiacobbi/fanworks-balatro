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
        local title = localize('ba_jspec')
        local color = HEX(localize('co_jspec'))
        local text = G.localization.misc.dictionary.te_jspec and HEX(localize('te_jspec')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
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
        local title = localize('ba_asap')
        local color = HEX(localize('co_asap'))
        local text = G.localization.misc.dictionary.te_asap and HEX(localize('te_asap')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)

SMODS.Consumable:take_ownership('c_high_priestess', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_priestess", set = "Other"}
        return { vars = {card.ability.planets} }
    end,
    set_badges = function(self, card, badges)
        local title = localize('ba_plancks')
        local color = HEX(localize('co_plancks'))
        local text = G.localization.misc.dictionary.te_plancks and HEX(localize('te_plancks')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
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
        local title = localize('ba_sunshine')
        local color = HEX(localize('co_sunshine'))
        local text = G.localization.misc.dictionary.te_sunshine and HEX(localize('te_sunshine')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)

SMODS.Consumable:take_ownership('c_emperor', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_emperor", set = "Other"}
        return { vars = {card.ability.tarots}}
    end,
    set_badges = function(self, card, badges)
        local title = localize('ba_last')
        local color = HEX(localize('co_last'))
        local text = G.localization.misc.dictionary.te_last and HEX(localize('te_last')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
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
        local title = localize('ba_moscow')
        local color = HEX(localize('co_moscow'))
        local text = G.localization.misc.dictionary.te_moscow and HEX(localize('te_moscow')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
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
        local title = localize('ba_gotequest')
        local color = HEX(localize('co_gotequest'))
        local text = G.localization.misc.dictionary.te_gotequest and HEX(localize('te_gotequest')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
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
        local title = localize('ba_crimson')
        local color = HEX(localize('co_crimson'))
        local text = G.localization.misc.dictionary.te_crimson and HEX(localize('te_crimson')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
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
        local title = localize('ba_rubicon')
        local color = HEX(localize('co_rubicon'))
        local text = G.localization.misc.dictionary.te_rubicon and HEX(localize('te_rubicon')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)

SMODS.Consumable:take_ownership('c_hermit', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_hermit", set = "Other"}
        return { vars = {card.ability.extra}}
    end,
    set_badges = function(self, card, badges)
        local title = localize('ba_city')
        local color = HEX(localize('co_city'))
        local text = G.localization.misc.dictionary.te_city and HEX(localize('te_city')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
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
        local title = localize('ba_jojopolis')
        local color = HEX(localize('co_jojopolis'))
        local text = G.localization.misc.dictionary.te_jojopolis and HEX(localize('te_jojopolis')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)

SMODS.Consumable:take_ownership('c_strength', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
        return { vars = {card.ability.max_highlighted}}
    end,
    set_badges = function(self, card, badges)
        local title = localize('ba_neon')
        local color = HEX(localize('co_neon'))
        local text = G.localization.misc.dictionary.te_neon and HEX(localize('te_neon')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)

SMODS.Consumable:take_ownership('c_hanged_man', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_hanged", set = "Other"}
        return { vars = {card.ability.max_highlighted}}
    end,
    set_badges = function(self, card, badges)
        local title = localize('ba_lighted')
        local color = HEX(localize('co_lighted'))
        local text = G.localization.misc.dictionary.te_lighted and HEX(localize('te_lighted')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)

SMODS.Consumable:take_ownership('c_death', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_death", set = "Other"}
        return { vars = {card.ability.max_highlighted}}
    end,
    set_badges = function(self, card, badges)
        local title = localize('ba_rockhard')
        local color = HEX(localize('co_rockhard'))
        local text = G.localization.misc.dictionary.te_rockhard and HEX(localize('te_rockhard')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
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
        local title = localize('ba_coi')
        local color = HEX(localize('co_coi'))
        local text = G.localization.misc.dictionary.te_coi and HEX(localize('te_coi')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
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
        local title = localize('ba_spirit')
        local color = HEX(localize('co_spirit'))
        local text = G.localization.misc.dictionary.te_spirit and HEX(localize('te_spirit')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
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
        local title = localize('ba_mania')
        local color = HEX(localize('co_mania'))
        local text = G.localization.misc.dictionary.te_mania and HEX(localize('te_mania')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)

SMODS.Consumable:take_ownership('c_star', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_star", set = "Other"}
        return { vars = {card.ability.max_highlighted,  localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
    set_badges = function(self, card, badges)
        local title = localize('ba_culture')
        local color = HEX(localize('co_culture'))
        local text = G.localization.misc.dictionary.te_culture and HEX(localize('te_culture')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)

SMODS.Consumable:take_ownership('c_moon', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
        return { vars = {card.ability.max_highlighted,  localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
    set_badges = function(self, card, badges)
        local title = localize('ba_iron')
        local color = HEX(localize('co_iron'))
        local text = G.localization.misc.dictionary.te_iron and HEX(localize('te_iron')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)

SMODS.Consumable:take_ownership('c_sun', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_sun", set = "Other"}
        return { vars = {card.ability.max_highlighted,  localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
    set_badges = function(self, card, badges)
        local title = localize('ba_streetlight')
        local color = HEX(localize('co_streetlight'))
        local text = G.localization.misc.dictionary.te_streetlight and HEX(localize('te_streetlight')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)

SMODS.Consumable:take_ownership('c_judgement', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
    end,
    set_badges = function(self, card, badges)
        local title = localize('ba_industry')
        local color = HEX(localize('co_industry'))
        local text = G.localization.misc.dictionary.te_industry and HEX(localize('te_industry')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)

SMODS.Consumable:take_ownership('c_world', {
    atlas = 'fnwk_tarotreskins',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "artist_world", set = "Other"}
        return { vars = {card.ability.max_highlighted,  localize(card.ability.suit_conv, 'suits_plural'), colours = {G.C.SUITS[card.ability.suit_conv]}}}
    end,
    set_badges = function(self, card, badges)
        local title = localize('ba_thorny')
        local color = HEX(localize('co_thorny'))
        local text = G.localization.misc.dictionary.te_thorny and HEX(localize('te_thorny')) or G.C.WHITE
        badges[#badges+1] = create_badge(title, color, text, 1)
    end
}, true)
