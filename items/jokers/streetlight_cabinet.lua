
local jokerInfo = {
    name = "Cabinet Man",
    config = {},
    rarity = 3,
    cost = 10,
    unlocked = false,
	unlock_condition = {type = 'chip_nova', mod = 100},
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    fanwork = 'streetlight',
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.mal }}
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
	return { vars = { FnwkCountGrammar(self.unlock_condition.mod)} }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then
        return false
	end

    return math.floor(hand_chips*mult) >= G.GAME.blind.chips * self.unlock_condition.mod
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    if G.EMULATOR_RUNNING then
        return
    end

    G.FUNCS:exit_overlay_menu()
    G.SETTINGS.SOUND.music_volume = 0
    G.SETTINGS.SOUND.game_sounds_volume = 100
    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_cabinet_start'), colour = G.C.MONEY, delay = 0.8})
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            G.CONTROLLER.locks.frame = true
            G.EMU:init_video()
            G.EMU:init_audio()
        
            local center = card.children.center
            local scale = G.TILESCALE * G.TILESIZE
            local x_pos = (center.VT.x + center.VT.w / 2) * scale + (center.VT.w * center.VT.scale / 2) * scale
            local y_pos = (center.VT.y + center.VT.h / 2) * scale + (center.VT.h * center.VT.scale / 2) * scale
            local start_pos = {
                x = x_pos,
                y = y_pos,
            }
            
            G.EMU:start_nes('dk', card, start_pos)
            return true 
        end 
    }))
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if G.EMU.running then
        G.EMU:stop_nes()
    end
end

function jokerInfo.update(self, card, dt)
    if not G.EMU.running or G.EMU.control_card ~= card then
        return 
    end

    if G.EMU.game.run_state == 'shutdown' then
        return
    end
    
    -- individual win states for games
    if G.EMU.game.id == 'dk' then
        -- forces demo to never start
        G.EMU.nes.cpu.ram[0X0044] = 0
        G.EMU.nes.cpu.ram[0x0058] = 0

        -- level state (1 is stage 1, is stage 3, 0 is title)
        if G.EMU.nes.cpu.ram[0x0053] == 3 then
            G.EMU.game.game_state = 'win'
        end
        if G.EMU.nes.cpu.ram[0x0400] == 1 and G.EMU.nes.cpu.ram[0x0096] == 255 then
            G.EMU.game.game_state = 'lose'
        end
        
    end
       
    if G.EMU.game.id == 'dl' then

    end

    if G.EMU.game.id == 'tmnt' then

    end

    if G.EMU.game.game_state == 'win' or G.EMU.game.game_state == 'lose' then
        G.EMU.game.run_state = 'shutdown'
    end

    if G.EMU.game.game_state == 'win' or G.EMU.game.game_state == 'lose' then
        local finish_state = 'k_cabinet_'..G.EMU.game.game_state
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = G.EMU.game.game_state == 'win' and 5 or 8,
            func = function()
                G.CONTROLLER.locks.frame = nil
                G.CONTROLLER.locks.frame_set = nil
                G.EMU:stop_nes()
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize(finish_state), colour = G.C.MONEY, delay = 0.8})
                return true 
            end 
        }))
        if G.EMU.game.game_state == 'win' then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                    local newJoker = create_card('Joker', G.jokers, nil, 2, true, nil, 'j_fnwk_streetlight_indulgent', 'resilient')
                    newJoker:add_to_deck()
                    G.jokers:emplace(newJoker)
                    newJoker:start_materialize()
                    G.GAME.joker_buffer = 0
                    return true 
                end 
            }))
        end

        G.EMU.game.game_state = 'none'
    end
end

return jokerInfo