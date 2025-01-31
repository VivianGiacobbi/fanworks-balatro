function Card:vic_add_speech_bubble(text_key, align, loc_vars, extra)
    if self.children.speech_bubble then self.children.speech_bubble:remove() end
    self.config.speech_bubble_align = {align=align or 'bm', offset = {x=0,y=0},parent = self}
    self.children.speech_bubble =
    UIBox{
        definition = G.UIDEF.vic_speech_bubble(text_key, loc_vars, extra),
        config = self.config.speech_bubble_align
    }
    self.children.speech_bubble.states.hover.can = false
    self.children.speech_bubble.states.click.can = false
    self.children.speech_bubble:set_role{
        role_type = 'Minor',
        xy_bond = 'Weak',
        r_bond = 'Strong',
        major = self,
    }
    self.children.speech_bubble.states.visible = false
end

function Card:vic_remove_speech_bubble()
    if self.children.speech_bubble then self.children.speech_bubble:remove(); self.children.speech_bubble = nil end
end

function Card:vic_say_stuff(n, not_first, def_speed, voice, playVoice)
    voice = voice or nil
    playVoice = playVoice or 1
    local speed, delayMult = 1, 1
    if not def_speed then
        speed = G.SPEEDFACTOR
    else
        delayMult = G.SPEEDFACTOR
    end
    self.talking = true
    if not not_first then 
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1*delayMult,
            func = function()
                if self.children.speech_bubble then self.children.speech_bubble.states.visible = true end
                self:vic_say_stuff(n, true, def_speed, voice, playVoice)
              return true
            end
        }))
    else
        if n <= 0 then self.talking = false; return end
        local new_said = math.random(1, 11)
        while new_said == self.last_said do 
            new_said = math.random(1, 11)
        end
        self.last_said = new_said
        if not voice then
            play_sound('voice'..math.random(1, 11), speed*(math.random()*0.2+1), 0.5)
        else
            if playVoice == 1 then
                voice:play(1, (G.SETTINGS.SOUND.volume/100.0) * (G.SETTINGS.SOUND.game_sounds_volume/50.0),true);
                playVoice = 2
            end
        end

        self:juice_up()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            blockable = false, blocking = false,
            delay = 0.13*delayMult,
            func = function()
                self:vic_say_stuff(n-1, true, def_speed, voice, playVoice)
            return true
            end
        }), 'tutorial')
    end
end


function tableSlot(speech_key, bubble_side, end_delay)
    return {speech_key = speech_key or 'chad_greeting1', bubble_side=bubble_side or 'bm', end_delay=end_delay or nil}
end

local function readSpeed(inputText)
    local wordsPerSecond = 3
    local wordCount = 0
    for _ in string.gmatch(inputText, "%S+") do wordCount = wordCount + 1 end
    local time = math.ceil(wordCount / wordsPerSecond)
    return time
end

function Card:jokerTalk(messages, index, delay, end_flag, fallback_card)
    local speed = G.SETTINGS.GAMESPEED
    local removed = false
    index = index or 1
    delay = delay or 0.1
    end_flag = end_flag or nil
    fallback_card = fallback_card or nil
    local card = self or fallback_card
    local speech_key = messages[index].speech_key or 'chad_greeting1'
    local bubble_side = messages[index].bubble_side or 'bm'
    local end_delay = messages[index].end_delay or nil
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = delay,
        blocking = false,
        func = function()
            local speech_key = speech_key
            local text = G.localization.misc.quips[speech_key]
            local current_mod = #text*2+1 or 5
            if current_mod < 5 then current_mod = 5 end
            local dynDelay
            if type(end_delay) == 'number' then
                dynDelay = end_delay
            elseif type(end_delay) == 'string' then
                dynDelay = tonumber(end_delay) + (readSpeed(tableToString(text)) + 2)
            else
                dynDelay = readSpeed(tableToString(text)) + 2
            end
            if card.ability.talking then
                local cancelling = false
                for k, v in pairs(card.ability.talking) do
                    if k ~= end_flag and v == true then
                        cancelling = true
                        if not card.ability.cancel then card.ability.cancel = {} end
                        card.ability.cancel[k] = true
                    end
                end
                if cancelling then
                    card:vic_remove_speech_bubble()
                end
            else
                card.ability.talking = {}
            end
            card:vic_add_speech_bubble(speech_key, bubble_side, nil, {text_alignment = "cm"})
            if card then
                card:vic_say_stuff(current_mod, nil, true)
            end
            if end_flag then card.ability.talking[end_flag] = true end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = dynDelay*speed,
                blocking = false,
                blockable = true,
                func = function()
                    if end_flag then card.ability.talking[end_flag] = false end
                    card:vic_remove_speech_bubble()
                    if not card.ability.cancel then card.ability.cancel = {} end
                    if card.role.draw_major.removed == true or card.ARGS.get_major.removed == true then removed = true end
                    if card and not removed and messages[index+1] and ((end_flag and not card.ability.cancel[end_flag]) or (not end_flag)) then
                        card:jokerTalk(messages, index+1, 0, end_flag)
                    else
                        if end_flag and not card.ability.cancel[end_flag] then
                            if end_flag == 'chad_greeting_finished' or
                            end_flag == 'chad_explain_finished' or
                            end_flag == 'chad_showman_finished' then
                                card.ability.quips[end_flag] = true
                                G.SETTINGS.chad[end_flag] = true
                                G:save_settings()
                            else
                                card.ability.quips[end_flag] = true
                            end
                        end
                        if #card.ability.cancel > 0 then
                            for k, v in pairs(card.ability.talking) do
                                if v == true then
                                    card.ability.cancel[k] = false
                                end
                            end
                        end
                    end
                    return true
                end
            }))
            return true
        end
    }))
end

-- simple hook copying most of the start_dissolve function to add an extra joker destroyed hook
Card.start_dissolve = function(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
    local dissolve_time = 0.7*(dissolve_time_fac or 1)
    self.dissolve = 0
    self.dissolve_colours = dissolve_colours
        or {G.C.BLACK, G.C.ORANGE, G.C.RED, G.C.GOLD, G.C.JOKER_GREY}
    if not no_juice then self:juice_up() end
    local childParts = Particles(0, 0, 0,0, {
        timer_type = 'TOTAL',
        timer = 0.01*dissolve_time,
        scale = 0.1,
        speed = 2,
        lifespan = 0.7*dissolve_time,
        attach = self,
        colours = self.dissolve_colours,
        fill = true
    })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay =  0.7*dissolve_time,
        func = (function() childParts:fade(0.3*dissolve_time) return true end)
    }))
    if not silent then 
        G.E_MANAGER:add_event(Event({
            blockable = false,
            func = (function()
                    play_sound('whoosh2', math.random()*0.2 + 0.9,0.5)
                    play_sound('crumple'..math.random(1, 5), math.random()*0.2 + 0.9,0.5)
                return true end)
        }))
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        blockable = false,
        ref_table = self,
        ref_value = 'dissolve',
        ease_to = 1,
        delay =  1*dissolve_time,
        func = (function(t) return t end)
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay =  1.05*dissolve_time,
        func = (function() self:remove() return true end)
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay =  1.051*dissolve_time,
    }))

    if self.ability.set == 'Joker' then
        eval_card(self, {cardarea = G.jokers, joker_destroyed = true, removed = self})
    end
end