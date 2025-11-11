SMODS.Atlas({ key = 'gotequest_takyon_alt1', path = 'stands/gotequest_takyon_alt1.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'gotequest_takyon_alt2', path = 'stands/gotequest_takyon_alt2.png', px = 71, py = 95 })
SMODS.Atlas({ key = 'gotequest_takyon_alt3', path = 'stands/gotequest_takyon_alt3.png', px = 71, py = 95 })

local rank_switches = {
    [2] = 0,
    [6] = 1,
    [11] = 2,
    [14] = 3
}

local consumInfo = {
    name = 'Takyon',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'F88888DC', 'F13133DC' },
        extra = {
            current_rank = 2,
            x_mult = 2
        }
    },
    cost = 4,
    rarity = 'StandRarity',
    alerted = true,
    hasSoul = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Vivian Giacobbi',
}

function consumInfo.loc_vars(self, info_queue, card)
    local rank_key = '2'
    for k, v in pairs(SMODS.Ranks) do
        if v.id == card.ability.extra.current_rank then
            rank_key = k
        end
    end
    return { vars = {rank_key, card.ability.extra.x_mult}}
end

function consumInfo.load(self, card, card_table, other_card)
    local rank_pos = 0
    if card_table.ability.extra.current_rank >= 14 then
        rank_pos = 3
    elseif card_table.ability.extra.current_rank >= 11 then
        rank_pos = 2
    elseif card_table.ability.extra.current_rank >= 6 then
        rank_pos = 1
    end

    local key = 'fnwk_gotequest_takyon'..(rank_pos > 0 and ('_alt'..rank_pos) or '')
    self.atlas = key
    card:set_sprites(self)
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and card.ability.extra.fnwk_takyon_this_hand then
        -- in case this is not reset
        card.ability.extra.fnwk_takyon_this_hand = nil
    end

    if context.individual and context.cardarea == G.play
    and context.other_card:get_id() == card.ability.extra.current_rank then
        card.ability.extra.fnwk_takyon_this_hand = true
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            extra = {
                x_mult = card.ability.extra.x_mult,
                card = context.other_card
            }
        }
    end

    if context.after and card.ability.extra.fnwk_takyon_this_hand then
        card.ability.extra.current_rank = (card.ability.extra.current_rank + 1) % SMODS.Rank.max_id.value
        local rank_switch = rank_switches[card.ability.extra.current_rank]
        if rank_switch then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local key = 'fnwk_gotequest_takyon'..(rank_switch > 0 and ('_alt'..rank_switch) or '')
                    self.atlas = key
                    card:set_sprites(self)
                    return true
                end
            }))
        end

        local flare_card = context.blueprint_card or card
        return {
            func = function()
                ArrowAPI.stands.flare_aura(flare_card, 0.5)
            end,
            extra = {
                message = localize{type = 'variable', key = 'a_rank', vars = {1}},
            }
        }
    end
end

return consumInfo