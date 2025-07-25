local jokerInfo = {
    name = "Random Stand",
    set = 'Stand',
    config = {},
    rarity = 1,
    cost = 1,
    no_mod_badges = true,
    no_collection = true,
    no_doe = true,
    discovered = true,
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    width = 100,
	height = 95,
}

function jokerInfo.set_card_type_badge(self, card, badges)
    badges = nil
end

function jokerInfo.in_pool(self, args)
    return false
end

function jokerInfo.set_sprites(self, card, front)
    card.T.w = card.T.w * (self.width/71)
    card.T.h = card.T.h * (self.height/95)
end

return jokerInfo