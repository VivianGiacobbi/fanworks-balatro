local achInfo = {
    rarity = 1,
    hidden_text = true,
    origin = 'fanworks',
}

function achInfo.unlock_condition(self, args)
    return args.type == 'fanworks_gyahoo'
end

return achInfo