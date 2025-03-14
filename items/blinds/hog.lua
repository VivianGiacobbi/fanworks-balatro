local blindInfo = {
    name = "The Hog",
    color = HEX('a11f1f'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    debuff = {},
    boss = {min = 3, max = 10}
}

function blindInfo.recalc_debuff(self, card, from_blind)
    if not self.disabled and card.area ~= G.jokers then
        if card:is_face() then
            if pseudorandom(pseudoseed('hog')) < G.GAME.probabilities.normal/4 then
                return true
            end
        end
    end
end

function blindInfo.loc_vars(self)
    return {vars = {G.GAME.probabilities.normal} }
end
function blindInfo.collection_loc_vars(self)
    return {vars = {G.GAME.probabilities.normal} }
end

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_hog" })
end

function blindInfo.press_play(self)
    local destroy = false
    G.E_MANAGER:add_event(Event({
        func = function()
            for i, v in ipairs(G.play.cards) do
                if v.debuff and pseudorandom(pseudoseed('hogstrike')) < G.GAME.probabilities.normal/2 then
                    destroy = true
                    if v.ability.name == 'Glass Card' then
                        v:shatter()
                    else
                        v:start_dissolve(nil, i == #G.play.cards)
                    end
                end
            end
            return true
        end
    }))
    if destroy then
        G.GAME.blind:wiggle()
    end
    return destroy
end

return blindInfo