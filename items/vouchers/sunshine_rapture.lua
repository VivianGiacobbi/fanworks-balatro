local ref_uncommon_weight = SMODS.Rarities.Uncommon.get_weight
SMODS.Rarity:take_ownership('Uncommon', {
    get_weight = function(self, weight, object_type)
        local ret = ref_uncommon_weight(self, weight, object_type)
        return ret * (G.GAME.fnwk_rapture_mod or 1)
    end,
}, true)

local ref_rare_weight = SMODS.Rarities.Rare.get_weight
SMODS.Rarity:take_ownership('Rare', {
    get_weight = function(self, weight, object_type)
        local ret = ref_rare_weight(self, weight, object_type)
        return ret * (G.GAME.fnwk_rapture_mod or 1)
    end,
}, true)

local voucherInfo = {
    name = 'Rapture',
    config = {
        extra = 2
    },
    cost = 10,
    fanwork = 'sunshine'
}

function voucherInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra}}
end

function voucherInfo.redeem(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.GAME.fnwk_rapture_mod = (G.GAME.fnwk_rapture_mod or 1) * card.ability.extra
            return true
        end)
    }))
end

return voucherInfo