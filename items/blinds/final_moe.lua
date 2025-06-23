local blindInfo = {
    name = "Multicolor MOE",
    color = SMODS.Gradients['fnwk_moe'],
    pos = {x = 0, y = 0},
    dollars = 8,
    mult = 1,
    vars = {},
    boss = {min = 1, max = 10, showdown = true},
}

local function get_moe_bosses(num_bosses)
    local bosses_used = copy_table(G.GAME.bosses_used)
    local chosen_bosses = {}

    for i=1, num_bosses do
        local eligible_bosses = {}

        for k, v in pairs(G.P_BLINDS) do
            if v.boss and not v.boss.showdown then
                if v.in_pool and type(v.in_pool) == 'function' then
                    local res = v:in_pool()
                    eligible_bosses[k] = res and true or nil
                else
                    eligible_bosses[k] = true
                end
            end
        end

        for k, v in pairs(G.GAME.banned_keys) do
            if eligible_bosses[k] then eligible_bosses[k] = nil end
        end

        local min_use = 100
        for k, v in pairs(bosses_used) do
            if eligible_bosses[k] then
                eligible_bosses[k] = v
                if eligible_bosses[k] <= min_use then 
                    min_use = eligible_bosses[k]
                end
            end
        end

        for k, _ in pairs(eligible_bosses) do
            if eligible_bosses[k] then
                if eligible_bosses[k] > min_use then 
                    eligible_bosses[k] = nil
                end
            end
        end
        local _, boss = pseudorandom_element(eligible_bosses, pseudoseed('boss'))
        bosses_used[boss] = bosses_used[boss] + 1
        chosen_bosses[#chosen_bosses+1] = boss
    end
    
    return chosen_bosses
end

local function moe_debuff_text(blind, string, first)
    if G.GAME.blind.disabled or G.GAME.blind.main_blind_disabled then G.GAME.blind.block_play = nil; return true end
    if first then play_sound('whoosh1', 0.55, 0.62) end
    for i = 1, 4 do
        local wait_time = (0.1*(i-1))
        G.E_MANAGER:add_event(Event({
            blockable = false,
            blocking = false,
            trigger = 'after',
            delay = G.SETTINGS.GAMESPEED*wait_time,
            func = function()
                if i == 1 then blind:juice_up() end
                if first then play_sound('cancel', 0.7 + 0.05*i, 0.7) end
                return true
            end
        }))  
    end
    local hold_time = G.SETTINGS.GAMESPEED * 1.2
    attention_text({ scale = 0.7, text = string, maxw = 12, hold = hold_time, align = 'cm', offset = {x = 0,y = -1}, major = G.play })
end

function blindInfo.loc_vars(self)
    if not G.GAME.blind.fnwk_moe_bosses then
        return {vars = {3} }
    end
    
    loc_descs = {}
    for _, blind_key in ipairs(G.GAME.blind.fnwk_moe_bosses) do
        local obj = G.P_BLINDS[blind_key]
        local loc_vars = blind_key == 'bl_ox' and {localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands')}
        local target = {type = 'raw_descriptions', key = blind_key, set = 'Blind', vars = loc_vars or obj.vars}

        if obj.loc_vars and type(obj.loc_vars) == 'function' then
            local res = obj:loc_vars() or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
        end

        local loc_target = localize(target)
        if loc_target then
            local debuff_text = ''
            for k, v in ipairs(loc_target) do
                debuff_text = debuff_text..v..(k <= #loc_target and ' ' or '')
            end
            loc_descs[#loc_descs+1] = debuff_text
        end
        
    end

    return { vars = loc_descs, key = G.GAME.blind.config.blind.key..'_alt'}
end

function blindInfo.collection_loc_vars(self)
    return { vars = {3}}
end

function blindInfo.get_loc_debuff_text(self)
    return nil
end

function blindInfo.set_blind(self)
    G.GAME.blind.fnwk_moe_bosses = get_moe_bosses(3)
    G.GAME.blind:set_text()

    G.GAME.blind.block_play = true
    local delay = 0
    for i, v in ipairs(G.GAME.blind.fnwk_moe_bosses) do
        local extra_blind = fnwk_create_extra_blind(G.GAME.blind, G.P_BLINDS[v], true)
        delay = delay + (i > 1 and 3.5 or 0)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            blocking = false,
            delay = delay,
            func = function()
                moe_debuff_text(G.GAME.blind, extra_blind:get_loc_debuff_text(), true)
                return true
            end
        }))
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blocking = false,
        delay = delay + 1,
        func = function()
            G.GAME.blind.block_play = nil
            if G.buttons then
                local _buttons = G.buttons:get_UIE_by_ID('play_button')
                _buttons.disable_button = nil
            end
            return true
        end
    }))
end

function blindInfo.defeat(self)
    fnwk_remove_extra_blinds(G.GAME.blind)
end

function blindInfo.fnwk_post_blind_load(self)
    local extra_bosses = {}
    for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
		if v.fnwk_extra_blind == G.GAME.blind then
			extra_bosses[#extra_bosses+1] = v.config.blind.key
		end
	end
    G.GAME.blind.fnwk_moe_bosses = #extra_bosses > 0 and extra_bosses or nil
    G.GAME.blind:set_text()
end

return blindInfo