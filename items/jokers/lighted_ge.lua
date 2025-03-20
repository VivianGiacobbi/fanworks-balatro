local jokerInfo = {
	name = 'Gypsy Eyes',
	config = {
		extra = {
			cardsRemaining = 5
		}
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	height = 80,
	width = 71,
	fanwork = 'lighted'
}


function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
	return {vars = { card.ability.extra.cardsRemaining } }
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
	if context.cardarea == G.jokers and context.before and not card.debuff and not context.blueprint then
		local seal = {
			[1] = "Gold",
			[2] = "Red",
			[3] = "Blue",
			[4] = "Purple",
		}
		local activate = false
		for k, v in ipairs(context.scoring_hand) do
			if v:is_face() and not v.seal and (pseudorandom('ge') < G.GAME.probabilities.normal / 3) then
				activate = true
				G.E_MANAGER:add_event(Event({
					func = function()
						v:juice_up()
						v:set_seal(seal[pseudorandom('wereputtingslursinbalatro', 1, 4)], nil, true)
						return true
					end
				}))
			end
		end
		if activate then
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_ge'), colour = G.C.MONEY})
			if not next(SMODS.find_card('j_csau_bunji')) then
				card.ability.extra.cardsRemaining = card.ability.extra.cardsRemaining - 1
			end
		end

		if card.ability.extra.cardsRemaining <= 0 then 
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound('tarot1')
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
						func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
							return true
						end
					}))
					return true
				end
			}))
			return {
				message = localize('k_drank_ex'),
				colour = G.C.MONEY
			}
		end
	end
end



return jokerInfo
	
