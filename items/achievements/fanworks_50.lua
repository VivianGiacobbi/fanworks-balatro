local vanilla_rarities = {"common", "uncommon", "rare", "legendary"}
local achInfo = {
    rarity = 2,
    config = {rarity = 3},
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {
        vars = {
            localize('k_'..(vanilla_rarities[self.config.rarity] or self.config.rarity)),
            colours = {
                G.C.RARITY[self.config.rarity]
            }
        }
    }
end

function achInfo.unlock_condition(self, args)
    if G.GAME.fnwk_50_ineligible then
        return false
    end

    if args.type == 'fnwk_card_added' then
        if args.card.config.center.rarity ~= self.config.rarity then
            G.GAME.fnwk_50_ineligible = true
            return false
        elseif not G.GAME.fnwk_50_first_rare then
            G.GAME.fnwk_50_first_rare = true
        end
    elseif args.type == 'win_custom' and G.GAME.fnwk_50_first_rare then
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.rarity ~= self.config.rarity then
                return false
            end
        end
        return true
    end
end

return achInfo