local jokerInfo = {
	name = 'Wings of Time',
	config = {},
	rarity = 3,
	cost = 10,
	unlocked = false,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	hasSoul = true,
	width = 284,
	height = 380,
	streamer = "vinny",
}

function jokerInfo.check_for_unlock(self, args)
	if args.type == "unlock_epoch" then
		return true
	end
end

function jokerInfo.in_pool(self, args)
	if not G.GAME.pool_flags.wingsoftimeused then
		return true
	end
end

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "guestartist16", set = "Other"}
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_epoch" })
end

function jokerInfo.set_sprites(self, card, _front)
	if card.config.center.discovered or card.bypass_discovery_center then
		card.children.center.scale = {x=self.width,y=self.height}
		card.children.center.scale_mag = math.min(self.width/card.children.center.T.w,self.height/card.children.center.T.h)
		card.children.center:reset()

		card.children.floating_sprite.scale = {x=self.width,y=self.height}
		card.children.floating_sprite.scale_mag = math.min(self.width/card.children.floating_sprite.T.w,self.height/card.children.floating_sprite.T.h)
		card.children.floating_sprite:reset()
	end
end

function jokerInfo.calculate(self, card, context)
	if not context.blueprint_card and context.game_over and G.GAME.chips/G.GAME.blind.chips >= 0.23 then
		G.E_MANAGER:add_event(Event({
			func = function()
				G.hand_text_area.blind_chips:juice_up()
				G.hand_text_area.game_chips:juice_up()
				play_sound('tarot1')
				card:start_dissolve()
				ante_dec = G.GAME.round_resets.ante - 1
				ease_ante(-ante_dec)
				G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
				G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante-ante_dec
				ease_dollars(-G.GAME.dollars, true)
				delayMod = delayMod or 1
				update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3/delayMod}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2/delayMod, func = function()
					play_sound('tarot1')
					card:juice_up(0.8, 0.5)
					G.TAROT_INTERRUPT_PULSE = true
					return true end }))
				update_hand_text({delay = 0}, {mult = '-', StatusText = true})
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9/delayMod, func = function()
					play_sound('tarot1')
					card:juice_up(0.8, 0.5)
					return true end }))
				update_hand_text({delay = 0}, {chips = '-', StatusText = true})
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9/delayMod, func = function()
					play_sound('tarot1')
					card:juice_up(0.8, 0.5)
					G.TAROT_INTERRUPT_PULSE = nil
					return true end }))
				update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='1'})
				delay(1.3/delayMod)
				for k, v in pairs(G.GAME.hands) do
					if v.level > 1 then
						level_up_hand(self, k, true, -G.GAME.hands[k].level + 1)
					end
				end
				update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 1.8}, {mult = 0, chips = 0, handname = '', level = ''})
				G.GAME.pool_flags.wingsoftimeused = true
				return true
			end
		}))
	return {
		message = localize('k_saved_ex'),
		saved = true,
		colour = G.C.RED
	}
	end
end

return jokerInfo