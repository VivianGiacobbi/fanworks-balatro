local achInfo = {
    rarity = 1,
    config = {
        ranks = {
            ['Ace'] = true,
            ['2'] = true,
            ['3'] = true,
            ['5'] = true,
            ['8'] = true
        }
    },
    origin = 'fanworks',
}

function achInfo.unlock_condition(self, args)
    if args.type ~= 'hand_contents' or next(SMODS.find_mod('jojobal')) then return false end

    local rank_map = copy_table(self.config.ranks)

    for _, v in ipairs(args.cards) do
        rank_map[v.base.value] = nil
    end

    return not next(rank_map)
end

return achInfo