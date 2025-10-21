local achInfo = {
    rarity = 1,
    config = {key = 'j_fnwk_fanworks_jogarc'},
    hidden_text = true,
    origin = 'fanworks',
}

function achInfo.loc_vars(self)
    return {
        vars = {
            G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '?????',
        }
    }
end

function achInfo.unlock_condition(self, args)
    return args.type == 'fanworks_gyahoo'
end

return achInfo