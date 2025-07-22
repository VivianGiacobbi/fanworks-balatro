local blindInfo = {
    name = "The Creek",
    boss_colour = HEX('A0DAB2'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    boss = {min = 2, max = 10},
}

local function set_blind_score_visible(bool)
    local blind_score = G.hand_text_area.blind_chips
    local chip_total = G.hand_text_area.game_chips
    if not bool then
        blind_score.UIT = G.UIT.O
        blind_score.config.object = DynaText({
            string = '?????',
            colours = {G.C.DARK_EDITION},
            bump = true,
            pop_in_rate = 99999999,
            scale = 0.65,
        })
        blind_score.config.ref_table = nil
        blind_score.config.ref_value = nil

        chip_total.UIT = G.UIT.O
        chip_total.config.object = DynaText({
            string = '?????',
            colours = {G.C.DARK_EDITION},
            bump = true,
            pop_in_rate = 99999999,
            scale = 0.65,
        })
        chip_total.config.ref_table = nil
        chip_total.config.ref_value = nil
        chip_total.UIBox:recalculate()

        return
    end

    blind_score.UIT = G.UIT.T
    blind_score.config.ref_table = G.GAME.blind
    blind_score.config.ref_value = 'chip_text'
    if blind_score.config.object then blind_score.config.object:remove() end

    chip_total.UIT = G.UIT.T
    chip_total.config.ref_table = G.GAME
    chip_total.config.ref_value = 'chips_text'
    if chip_total.config.object then chip_total.config.object:remove() end

    blind_score:juice_up()
    chip_total:juice_up()
end

function blindInfo.set_blind(self)
    G.GAME.blind.triggered = true
    set_blind_score_visible(false)
end

function blindInfo.disable(self)
    G.GAME.blind.triggered = false
    set_blind_score_visible(true)
end

function blindInfo.defeat(self)
    G.GAME.blind.triggered = false
    set_blind_score_visible(true)
end

function blindInfo.fnwk_blind_load(self, blindTable)
    G.GAME.blind.triggered = true
    set_blind_score_visible(false)
end

return blindInfo