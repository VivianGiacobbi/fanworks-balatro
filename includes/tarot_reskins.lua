local function force_fool_card()
    if G.consumeables then
        local force_card = nil
        local force_options = {
            c_hanged_man = SMODS.find_card('c_jojobal_steel_civil'),
            c_hermit = SMODS.find_card('c_fnwk_city_dead')
        }
        local low_rank = G.consumeables.config.card_limit
        for k, v in pairs(force_options) do
            if next(v) and v[1].rank <= low_rank then
                low_rank = v[1].rank
                force_card = k
            end
        end

        return force_card
    end

    return nil
end

local skins = fnwk_enabled['enableTarotSkins']
local stands = fnwk_enabled['enableStands']
if skins or stands then
    local build_table = {}
    if skins then 
        build_table.atlas = 'fnwk_tarotreskins'
        build_table.set_badges = function(self, card, badges)
            badges[#badges+1] = FnwkDynamicBadge('jspec')
        end
    end
    if stands then
        build_table.loc_vars = function(self, info_queue, card)
            local fool_c = G.GAME.last_tarot_planet and G.P_CENTERS[G.GAME.last_tarot_planet] or nil

            local force_card = force_fool_card()
            if force_card then fool_c = G.P_CENTERS[force_card] end
            
            -- imported cardsauce logic
            local last_tarot_planet = localize('k_none')
            if fool_c and fool_c.key == 'c_arrow_arrow' then
                last_tarot_planet = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set, vars = { G.GAME.modifiers.max_stands or 1, (card.area.config.collection and localize('k_stand')) or (G.GAME.modifiers.max_stands > 1 and localize('b_stand_cards') or localize('k_stand')) }} or localize('k_none')
            else
                last_tarot_planet = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set} or localize('k_none')
            end

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
    
            return { vars = {last_tarot_planet}, main_end = main_end }
        end

        build_table.use = function(self, card, area, copier)
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    play_sound('timpani')

                    local found_card = force_fool_card()
                    if not found_card then
                        found_card = G.GAME.last_tarot_planet
                    end
                    local fool_c = create_card('Tarot_Planet', G.consumeables, nil, nil, nil, nil, found_card, 'fool')
                    fool_c:add_to_deck()
                    G.consumeables:emplace(fool_c)
                    fool_c:juice_up(0.3, 0.5)
                end
                return true end }))
            delay(0.6)
        end

        build_table.can_use = function(self, card)
            local force_card = force_fool_card()
            if force_card then return true end

            local has_space = #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
            return (has_space and G.GAME.last_tarot_planet and G.GAME.last_tarot_planet ~= 'c_fool')
        end
    end
    SMODS.Consumable:take_ownership('c_fool', build_table, true)
end

if skins or stands then
    local build_table = {}
    if skins then 
        build_table.atlas = 'fnwk_tarotreskins'
        build_table.set_badges = function(self, card, badges)
            badges[#badges+1] = FnwkDynamicBadge('last')
        end
    end

    if stands then
        build_table.loc_vars = function (self, info_queue, card)
            local force_options = {
                c_hermit = next(SMODS.find_card('c_fnwk_city_dead')),
                c_hanged_man = next(SMODS.find_card('c_jojobal_steel_civil'))
            }

            local tarot_count = card.ability.tarots
            for k, v in pairs(force_options) do
                tarot_count = tarot_count - 1
                info_queue[#info_queue+1] = G.P_CENTERS[k]
            end
            tarot_count = math.max(0, tarot_count)
            
            return { 
                vars = { tarot_count },
                key = self.key..(force_options.c_hermit and '_dead' or '')..(force_options.c_hanged_man and '_civil' or '')
            }
        end

        build_table.use = function(self, card, area, copier)
            local force_options = {
                c_hermit = next(SMODS.find_card('c_fnwk_city_dead')),
                c_hanged_man = next(SMODS.find_card('c_jojobal_steel_civil'))
            }

            local tarot_count = card.ability.tarots
            for k, v in pairs(force_options) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        if G.consumeables.config.card_limit > #G.consumeables.cards then
                            play_sound('timpani')
                            local new_tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, k, 'emp')
                            new_tarot:add_to_deck()
                            G.consumeables:emplace(new_tarot)
                            card:juice_up(0.3, 0.5)
                        end
                        return true    
                    end
                }))
                tarot_count = tarot_count - 1
            end

            tarot_count = math.max(0, tarot_count)
            for i = 1, math.min(tarot_count, G.consumeables.config.card_limit - #G.consumeables.cards) do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        if G.consumeables.config.card_limit > #G.consumeables.cards then
                            play_sound('timpani')
                            local new_tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'emp')
                            new_tarot:add_to_deck()
                            G.consumeables:emplace(new_tarot)
                            card:juice_up(0.3, 0.5)
                        end
                        return true    
                    end
                }))
            end
            delay(0.6)
        end
    end

    SMODS.Consumable:take_ownership('c_emperor', build_table, true)
end

local queer = fnwk_enabled['enableQueer']
if skins or queer then
    local build_table = {
        generate_ui = 0
    }

    if queer then
        build_table.loc_txt = {
            ['en-us'] = {
                name = "The Wheel of Fortune",
                text = {
                    "{C:green}#1# in #2#{} chance to add",
                    "{C:dark_edition}Foil{}, {C:dark_edition}Holographic{}, or",
                    "{C:dark_edition}Queer{} edition to",
                    "a random {C:attention}Joker"
                }
            }
        }
    end

    if skins then
        build_table.atlas = 'fnwk_tarotreskins'
        build_table.set_badges = function(self, card, badges)
            badges[#badges+1] = FnwkDynamicBadge('jojopolis')
        end
    end

    SMODS.Consumable:take_ownership('c_wheel_of_fortune', build_table, true)
end

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

SMODS.Consumable:take_ownership('c_magician', { 
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('asap')
    end
}, true)

SMODS.Consumable:take_ownership('c_high_priestess', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('plancks')
    end
}, true)

SMODS.Consumable:take_ownership('c_empress', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('sunshine')
    end
}, true)

SMODS.Consumable:take_ownership('c_heirophant', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('moscow')
    end
}, true)

SMODS.Consumable:take_ownership('c_lovers', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('gotequest')
    end
}, true)

SMODS.Consumable:take_ownership('c_chariot', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('crimson')
    end
}, true)

SMODS.Consumable:take_ownership('c_justice', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('rubicon')
    end
}, true)

SMODS.Consumable:take_ownership('c_hermit', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('city')
    end
}, true)

SMODS.Consumable:take_ownership('c_strength', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('neon')
    end
}, true)

SMODS.Consumable:take_ownership('c_hanged_man', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('lighted')
    end
}, true)

SMODS.Consumable:take_ownership('c_death', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('rockhard')
    end
}, true)

SMODS.Consumable:take_ownership('c_temperance', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('coi')
    end
}, true)

SMODS.Consumable:take_ownership('c_devil', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('spirit')
    end
}, true)

SMODS.Consumable:take_ownership('c_tower', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('mania')
    end
}, true)

SMODS.Consumable:take_ownership('c_star', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('culture')
    end
}, true)

SMODS.Consumable:take_ownership('c_moon', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('iron')
    end
}, true)

SMODS.Consumable:take_ownership('c_sun', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('streetlight')
    end
}, true)

SMODS.Consumable:take_ownership('c_judgement', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('industry')
    end
}, true)

SMODS.Consumable:take_ownership('c_world', {
    atlas = 'fnwk_tarotreskins',
    set_badges = function(self, card, badges)
        badges[#badges+1] = FnwkDynamicBadge('thorny')
    end
}, true)

if AltTexture and TexturePack then

    AltTexture({
        key = 'tarot',
        set = 'Tarot',
        path = 'tarotreskins.png',
        loc_txt = {
            name = 'Tarot'
        },
        original_sheet = true
    })

    TexturePack{
        key = 'fnwk',
        textures = {
            'fnwk_tarot',
        },
        loc_txt = {
            name = 'Fanworks Malverk Compatibility',
            text = {
                "Enables the Fanworks reskins of the",
                "Tarot cards to work with Malverk!",
            }
        }
    }

end