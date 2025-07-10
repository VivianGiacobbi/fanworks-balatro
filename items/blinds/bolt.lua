local blindInfo = {
    name = "The Bolt",
    boss_colour = HEX('6FD0F2'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 1, max = 10},
}

function blindInfo.set_blind(self)
    fnwk_set_blind_proxies()
end

function blindInfo.disable(self)
    fnwk_reset_blind_proxies()
end

function blindInfo.fnwk_card_added(self, card)
    fnwk_single_blind_proxy(card)
end

function blindInfo.defeat(self)
    fnwk_reset_blind_proxies()
end

function blindInfo.fnwk_blind_load(self)
    fnwk_set_blind_proxies()
end

return blindInfo