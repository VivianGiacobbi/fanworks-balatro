local jokerInfo = {
    name = "Cabinet Man",
    config = {
        extra = {
            game_opts = {
                {key = 'Donkey Kong (1986)', fps = 59.94},
                {key = 'Teenage Mutant Ninja Turtles II (1989)', fps = 59.94},
                {key = "Dragon's Lair (E) [no-dim]", fps = 50},
            },
            dollars = 8
        },
        last_music_vol = 0,
        last_sounds_vol = 0,
    },
    rarity = 3,
    cost = 10,
    unlocked = false,
	unlock_condition = {type = 'chip_nova', mod = 100},
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    origin = {
		category = 'fanworks',
		sub_origins = {
			'streetlight',
		},
        custom_color = 'streetlight',
    },
    artist = 'mal',
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.dollars, number_format(G.GAME.round_scores.hand.amt or 0)}}
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
	return { vars = { ArrowAPI.string.count_grammar(self.unlock_condition.mod)} }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then
        return false
	end

    return math.floor(hand_chips*mult) >= G.GAME.blind.chips * self.unlock_condition.mod
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    if G.EMULATOR_RUNNING or from_debuff then
        return
    end

    G.FUNCS:exit_overlay_menu()
    G.EMU.last_music_vol = G.SETTINGS.SOUND.music_volume
    G.SETTINGS.SOUND.music_volume = 0
    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_cabinet_start'), colour = G.C.MONEY, delay = 0.8})
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            G.CONTROLLER.locks.frame = true
            local game = pseudorandom_element(card.ability.extra.game_opts)
            G.EMU:init_video()
            G.EMU:init_audio(44100, 16, 1, game.fps)

            local center = card.children.center
            local scale = G.TILESCALE * G.TILESIZE
            local x_pos = (center.VT.x + center.VT.w / 2) * scale + (center.VT.w * center.VT.scale / 2) * scale
            local y_pos = (center.VT.y + center.VT.h / 2) * scale + (center.VT.h * center.VT.scale / 2) * scale
            local start_pos = {
                x = x_pos,
                y = y_pos,
            }

            G.EMU:start_nes(game.key, card, game.fps, start_pos)
            return true
        end
    }))
end

function jokerInfo.calculate(self, card, context)

    if context.before then
        card.ability.extra.last_high_score = G.GAME.round_scores.hand.amt
    end

    if context.after and hand_chips*mult > card.ability.extra.last_high_score then
        local last_score = card.ability.extra.last_high_score
        card.ability.extra.last_high_score = nil
        if hand_chips*mult > last_score then
            return {
                dollars = card.ability.extra.dollars
            }
        end
    end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if from_debuff then return end

    if G.EMU.running then
        G.EMU:stop_nes()
    end
end

function jokerInfo.update(self, card, dt)
    if not G.EMU.running or G.EMU.control_card ~= card then
        return
    end

    -- early close
    if G.EMU.esc_pressed and G.EMU.game.run_state == 'shutdown' then
        G.EMU.game.run_state = 'shutdown'
        G.EMU.esc_pressed = nil
        G.EMU:stop_nes()

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                G.CONTROLLER.locks.frame = nil
                G.CONTROLLER.locks.frame_set = nil
                G.SETTINGS.SOUND.music_volume = G.EMU.last_music_vol or 50
                card.ability.last_music_vol = nil
                card.ability.game_over_delay = nil
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_cabinet_lose'), colour = G.C.MONEY, delay = 0.8})
                return true
            end
        }))
    end

    if G.EMU.game.run_state == 'shutdown' then
        return
    end

    -- individual win states for games
    if G.EMU.game.id == 'Donkey Kong (1986)' then
        -- forces demo to never start
        G.EMU.nes.cpu.ram[0X0044] = 0
        G.EMU.nes.cpu.ram[0x0058] = 0

        -- level state (1 is stage 1, is stage 3, 0 is title)
        if G.EMU.nes.cpu.ram[0x0053] == 3 then
            G.EMU.game.game_state = 'win'
            card.ability.win_key = 'j_fnwk_streetlight_indulgent'
        elseif G.EMU.nes.cpu.ram[0x0400] == 1 and G.EMU.nes.cpu.ram[0x0096] == 255 then
            G.EMU.game.game_state = 'lose'
        end

    end

    if G.EMU.game.id == "Dragon's Lair (E) [no-dim]" then
        -- setting lives to 3
        if G.EMU.nes.cpu.ram[0x05A6] > 249 and G.EMU.nes.cpu.ram[0x05A6] < 255 then
            G.EMU.nes.cpu.ram[0x05A6] = 249
        end

        -- fast forward through main menu timers
        -- and auto start level
        if G.EMU.nes.cpu.ram[0x05A6] > 249 or G.EMU.nes.cpu.ram[0x05A6] < 246 then
            G.EMU.nes.cpu.ram[0x0027] = 0
            G.EMU.nes.cpu.ram[0x0028] = 1
            G.EMU.nes.cpu.ram[0x032F] = 16
        end

        -- G.EMU.nes.cpu.ram[0x05A9] -- level loading?
        -- G.EMU.nes.cpu.ram[0x05AA] -- level loading?

        if G.EMU.nes.cpu.ram[0x0058] == 32 then
            G.EMU.game.game_state = 'win'
            card.ability.win_key = 'j_fnwk_streetlight_resil'
        end

        if G.EMU.nes.cpu.ram[0x05A6] == 246 and G.EMU.nes.cpu.ram[0x000E] == 12 then
            G.EMU.game.game_state = 'lose'
            card.ability.game_over_delay = 5
        end
    end

    if G.EMU.game.id == 'Teenage Mutant Ninja Turtles II (1989)' then
        -- skip title/character select
        if G.EMU.nes.cpu.ram[0x0018] < 5 then
            G.EMU.nes.cpu.ram[0x0018] = 5
        end

        -- 0 lives
        -- forces selection of Raphael
        G.EMU.nes.cpu.ram[0x004D] = 0
        G.EMU.nes.cpu.ram[0x0033] = 3

        if G.EMU.nes.cpu.ram[0x007E] == 6 and G.EMU.nes.cpu.ram[0x03EA] > 15 then
            G.EMU.game.game_state = 'win'
            card.ability.win_key = 'j_fnwk_streetlight_fledgling'
        elseif G.EMU.nes.cpu.ram[0x003C] == 7 then
            G.EMU.game.game_state = 'lose'
        end
    end

    if G.EMU.game.game_state == 'win' or G.EMU.game.game_state == 'lose' then
        G.EMU.game.run_state = 'shutdown'

        local finish_state = 'k_cabinet_'..G.EMU.game.game_state
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = G.EMU.game.game_state == 'win' and 5 or card.ability.game_over_delay or 8,
            func = function()
                G.CONTROLLER.locks.frame = nil
                G.CONTROLLER.locks.frame_set = nil
                G.SETTINGS.SOUND.music_volume = card.ability.last_music_vol or 50
                card.ability.last_music_vol = nil
                card.ability.game_over_delay = nil
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
                    local newJoker = create_card('Joker', G.jokers, nil, nil, true, nil, card.ability.win_key or 'j_fnwk_streetlight_indulgent', 'fnwk_cabinet')
                    card.ability.win_key = nil
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