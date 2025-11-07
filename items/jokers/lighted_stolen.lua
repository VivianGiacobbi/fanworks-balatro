local jokerInfo = {
	name = 'Stolen Solvent', -- set to stolen solvent after inheriting photograph's effects
	config = {
		extra = {
			chance = 3,
			remaining = 5,
			remain_mod = 1
		}
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	origin = {
		category = 'fanworks',
		sub_origins = {
			'lighted',
		},
        custom_color = 'lighted',
    },
	artist = 'BarrierTrio/Gote',
	programmer = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'fnwk_lighted_ge')
	return { vars = {num, dom, card.ability.extra.remaining}}
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
	if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

   	card.T.h = card.T.h/1.2
end

function jokerInfo.set_sprites(self, card, front)
	if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

	card.children.center.scale.y = card.children.center.scale.y/1.2
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint or card.debuff then return end

	if (context.individual and context.cardarea == G.play) and not context.other_card.debuff then
		local other_card = context.other_card
		if not other_card:is_face() or other_card.seal or card.ability.extra.remaining <= 0 then
			return
		end

		if SMODS.pseudorandom_probability(card, 'fnwk_lighted_ge', 1, card.ability.extra.chance, 'fnwk_lighted_ge') then
			if not next(SMODS.find_card('j_csau_bunji')) then
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "remaining",
					scalar_value = "remain_mod",
					operation = "-",
					no_message = true,
				})
			end
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.8,
				blocking = false,
				func = function()
					other_card:set_seal(SMODS.poll_seal({guaranteed = true, type_key = 'wereputtingslursinbalatro'}))
					other_card:juice_up()
					return true
				end
			}))

			return {
				message = localize('k_stolen'),
				message_card = card,
			}
		end
	end


	if context.after and card.ability.extra.remaining <= 0 then
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('tarot1')
				card.T.r = -0.2
				card:juice_up(0.3, 0.4)
				card.states.drag.is = true
				card.children.center.pinch.x = true
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.3,
					blockable = false,
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
			colour = G.C.FILTER,
			message_card = card
		}
	end
end

return jokerInfo