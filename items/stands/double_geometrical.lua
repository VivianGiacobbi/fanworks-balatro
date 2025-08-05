SMODS.Atlas({ key = 'double_geometrical_names', path = "stands/double_geometrical_names.png", px = 71, py = 95})

local consumInfo = {
    name = 'Geometrical Dominator',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'FB5D53DC', 'A34B6EDC' },
        extra = {
            chip_base = 1.5,
            word_colors = {
                'MULT',
                'CHIPS',
                'MONEY',
                'BLUE',
                'RED',
                'GREEN',
                'ORANGE',
                'GOLD',
                'PURPLE',
                'VOUCHER',
                'BOOSTER',
                'ETERNAL',
            }
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'double',
		},
        custom_color = 'double',
    },
    blueprint_compat = true,
}

local function get_unique_words(exclude)
    local words = {}
    if not G.jokers or not G.consumeables then
        return 0, words
    end

    local count = 0
    for _, v in ipairs(G.jokers.cards) do
        if v ~= exclude then
            local name = localize{type = 'name_text', set = v.ability.set, key = v.config.center.key}
            for w in name:gmatch("%S+") do
                if not words[w] then
                    words[w] = true
                    count = count + 1
                end
            end
        end
    end

    for _, v in ipairs(G.consumeables.cards) do
        if v ~= exclude then
            local name = localize{type = 'name_text', set = v.ability.set, key = v.config.center.key}
            for w in name:gmatch("%S+") do 
                if not words[w] then
                    words[w] = true
                    count = count + 1
                end
            end
        end
    end

    return count, words
end

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}

    local main_end = nil
    local num_words, words_list = get_unique_words(card)
    if num_words > 0 then
        local dyn_nodes = {}
        for k, _ in pairs(words_list) do
            local rand_color = pseudorandom_element(card.ability.extra.word_colors, pseudoseed('fnwk_geo_display'))
            dyn_nodes[#dyn_nodes+1] = {string = ' '..k..' ', colour = G.C[rand_color]}
        end

        local nodes = {{
            n=G.UIT.O, config={object = DynaText({
                string = dyn_nodes,
                colours = {G.C.BLACK},
                pop_in_rate = 9999999,
                silent = true,
                random_element = true,
                pop_delay = 0.3,
                scale = 0.32,
                min_cycle_time = 0,
            })}
        }}

        main_end = {
            {n=G.UIT.C, config={align = "bm", padding = 0.05}, nodes={
                {n=G.UIT.C, config={align = "m", colour = G.C.BLACK, r = 0.05, padding = 0.1}, nodes=nodes}
            }}
        }
    end
    

    return {
        vars = { card.ability.extra.chip_base, (math.ceil(card.ability.extra.chip_base^num_words)) },
        main_end = main_end
    }
end

function consumInfo.set_sprites(self, card, front)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

    card.children.center.atlas = G.ASSET_ATLAS['fnwk_double_geometrical_names']
    card.children.center:set_sprite_pos({x = 0, y = 0})
end

function consumInfo.calculate(self, card, context)
    if card.debuff or not context.joker_main then
        return
    end

    local num_words = get_unique_words(card)
    local chips = math.ceil(card.ability.extra.chip_base^num_words)
    local flare_card = context.blueprint_card or card
    return {
        func = function()
            ArrowAPI.stands.flare_aura(flare_card, 0.5)
        end,
        extra = {
            chips = chips,
            card = flare_card
        }
    }
end

return consumInfo