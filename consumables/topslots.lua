local consumInfo = {
    name = 'Top Slots - Spotting The Best',
    key = 'topslots',
    set = "VHS",
    cost = 4,
    alerted = true,
    activation = false,
    config = {
        extra = {
            prob_base = 3,
            dollars = 20,
            prob_double = 6,
            double = 2,
            prob_triple = 8,
            triple = 3,
        },
        activated = false,
        slide_move = 0,
        slide_out_delay = 0,
        destroy = false,
    },
}

local slide_out = 8.25
local slide_mod = 0.25
local slide_out_delay = 1

function consumInfo.loc_vars(self, info_queue, card)
    return { vars = { G.GAME.probabilities.normal, card.ability.extra.prob_base, card.ability.extra.dollars, card.ability.extra.prob_double, card.ability.extra.prob_triple } }
end

function consumInfo.calculate(self, card, context)
    if context.setting_blind then
        local e = {config = {ref_table = card}}
        G.E_MANAGER:add_event(Event({func = function()
            G.FUNCS.use_card(e, true)
            return true
        end }))
    end
end

function consumInfo.use(self, card, area, copier)
    if pseudorandom('ILOST') < G.GAME.probabilities.normal / card.ability.extra.prob_base then
        local gamble_money = card.ability.extra.dollars
        if pseudorandom('READYOURMACHINES') < G.GAME.probabilities.normal / card.ability.extra.prob_double then
            gamble_money = gamble_money * card.ability.extra.double
        end
        if pseudorandom('NOCONTROLOVERTHAT') < G.GAME.probabilities.normal / card.ability.extra.prob_triple then
            gamble_money = gamble_money * card.ability.extra.triple
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            attention_text({
                text = localize('$')..gamble_money,
                scale = 1.3,
                hold = 1.4,
                major = card,
                backdrop_colour = G.C.MONEY,
                align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                silent = true
            })
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            ease_dollars(gamble_money, true)
            return true end }))
    else
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            attention_text({
                text = localize('k_nope_ex'),
                scale = 1.3,
                hold = 1.4,
                major = card,
                backdrop_colour = G.C.MONEY,
                align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                silent = true
            })
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                play_sound('tarot2', 0.76, 0.4);return true end}))
            play_sound('tarot2', 1, 0.4)
            card:juice_up(0.3, 0.5)
            return true end }))
    end
    delay(0.6)
end

function consumInfo.can_use(self, card)
    return false
end

local mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path:match("Mods/[^/]+")..'/'

mod['c_fnwk_'..consumInfo.key..'_tape'] = love.graphics.newImage(mod_path..'assets/1x/consumables/'..(consumInfo.tapeKey or 'blackspine')..'.png')
mod['c_fnwk_'..consumInfo.key..'_sleeve'] = love.graphics.newImage(mod_path..'assets/1x/consumables/'..consumInfo.key..'.png')

local setupTapeCanvas = function(self, card, tape, sleeve)
    card.children.center.video = love.graphics.newCanvas(self.width or 71, self.height or 95)
    card.children.center.video:renderTo(function()
        love.graphics.clear(1,1,1,0)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(mod[card.config.center.key..'_tape'], ((self.width or 71)/2)+card.ability.slide_move, (self.height or 95)/2,0,1,1,71/2,95/2)
        love.graphics.draw(mod[card.config.center.key..'_sleeve'],((self.width or 71)/2)-card.ability.slide_move,(self.height or 95)/2,0,1,1,71/2,95/2)
    end)
end

function consumInfo.draw(self,card,layer)
    if card.area and card.area.config.collection and not self.discovered then
        return
    end

    love.graphics.push('all')
    love.graphics.reset()
    if not card.children.center.video then
        setupTapeCanvas(self, card, mod[card.config.center.key..'_tape'], mod[card.config.center.key..'_sleeve'])
    end

    if card.ability.activated and card.ability.slide_move < slide_out then
        if card.ability.slide_out_delay < slide_out_delay then
            card.ability.slide_out_delay = card.ability.slide_out_delay + slide_mod
        else
            card.ability.slide_move = card.ability.slide_move + slide_mod
        end
    elseif not card.ability.activated and card.ability.slide_move > 0 then
        card.ability.slide_out_delay = 0
        card.ability.slide_move = card.ability.slide_move - slide_mod
    end

    card.children.center.video:renderTo(function()
        love.graphics.clear(1,1,1,0)
        love.graphics.draw(mod[card.config.center.key..'_tape'], ((self.width or 71)/2)+card.ability.slide_move, (self.height or 95)/2,0,1,1,71/2,95/2)
        love.graphics.draw(mod[card.config.center.key..'_sleeve'],((self.width or 71)/2)-card.ability.slide_move,(self.height or 95)/2,0,1,1,71/2,95/2)
    end)
    love.graphics.pop()
end

return consumInfo