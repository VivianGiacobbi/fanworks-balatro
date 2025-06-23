---------------------------
--------------------------- Initialization blind functions
---------------------------

local ref_blind_init = Blind.init
function Blind:init(X, Y, W, H, extra_source)
	if extra_source then
		Moveable.init(self, X, Y, W, H)
		self.fnwk_extra_blind = extra_source

		self.children = {}
		self.config = {}
		self.states.visible = false
		self.states.collide.can = false
		self.states.drag.can = false
		self.loc_debuff_lines = {'',''}

		if getmetatable(self) == Blind then 
			table.insert(G.I.CARD, self)
		end
		return
	end

	return ref_blind_init(self, X, Y, W, H)
end

function Blind:extra_set_blind(blind, reset, silent)
	if not reset then
		self.config.blind = blind
		self.name = blind.name
		self.debuff = blind.debuff
		self.dollars = G.GAME.blind.dollars
		if self.config.blind.key == 'bl_fnwk_creek' then
			local mult = pseudorandom(pseudoseed('fnwk_creek'), 0, 6) * 0.25 + 1.75
			self.mult = mult / 2
			G.GAME.modifiers.fnwk_hide_blind_score = true
		else
			self.mult = blind.mult / 2
		end
		
		self.disabled = false
		self.discards_sub = nil
		self.hands_sub = nil
		self.boss = not not blind.boss
		self.blind_set = false
		self.triggered = nil
		self.prepped = true
		self:set_text()
		
		-- applying any relative mults
		G.GAME.blind.chips = G.GAME.blind.chips * self.mult
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
		if not G.GAME.blind.boss then
			G.GAME.blind.boss = self.boss
		end

		self.chips = G.GAME.blind.chips
		self.chip_text = G.GAME.blind.chip_text

		if blind.name then
			self:change_colour()
		else
			self:change_colour(G.C.BLACK)
		end
	end

	local old_main_blind = G.GAME.blind
	G.GAME.blind = self
	local obj = self.config.blind
	if not reset and obj.set_blind and type(obj.set_blind) == 'function' then
		obj:set_blind()
	elseif self.name == 'The Eye' and not reset then
		self.hands = {
			["Flush Five"] = false,
			["Flush House"] = false,
			["Five of a Kind"] = false,
			["Straight Flush"] = false,
			["Four of a Kind"] = false,
			["Full House"] = false,
			["Flush"] = false,
			["Straight"] = false,
			["Three of a Kind"] = false,
			["Two Pair"] = false,
			["Pair"] = false,
			["High Card"] = false,
		}
	elseif self.name == 'The Mouth' and not reset then
		self.only_hand = false
	elseif self.name == 'The Fish' and not reset then 
		self.prepped = nil
	elseif self.name == 'The Water' and not reset then 
		self.discards_sub = G.GAME.current_round.discards_left
		ease_discard(-self.discards_sub)
	elseif self.name == 'The Needle' and not reset then 
		self.hands_sub = G.GAME.round_resets.hands - 1
		ease_hands_played(-self.hands_sub)
	elseif self.name == 'The Manacle' and not reset then
		G.hand:change_size(-1)
	elseif self.name == 'Amber Acorn' and not reset and #G.jokers.cards > 0 then
		G.jokers:unhighlight_all()
		for k, v in ipairs(G.jokers.cards) do
			v:flip()
		end
		if #G.jokers.cards > 1 then 
			G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function() 
				G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end })) 
				delay(0.15)
				G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end })) 
				delay(0.15)
				G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1);return true end })) 
				delay(0.5)
			return true end })) 
		end
	end

	--add new debuffs
	for _, v in ipairs(G.playing_cards) do
		if not v.debuffed_by_blind then
			self:debuff_card(v)
		end
	end

	for _, v in ipairs(G.jokers.cards) do
		if not reset and not v.debuffed_by_blind then self:debuff_card(v, true) end
	end	

	G.GAME.blind = old_main_blind
	G.GAME.blind.chips = self.chips
	G.GAME.blind.chip_text = self.chip_text
	G.GAME.blind.dollars = self.dollars
end

local ref_blind_set = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
	if self.fnwk_extra_blind then
		if blind or reset then
			return self:extra_set_blind(self.config.blind, reset, silent)
		end

		return
	end

	G.GAME.modifiers.fnwk_hide_blind_score = nil
	local ret = ref_blind_set(self, blind, reset, silent)
	self.main_blind_disabled = nil

	if blind and blind.key == 'bl_fnwk_creek' then
		self.mult = pseudorandom(pseudoseed('fnwk_creek'), 0, 6) * 0.25 + 1.75
		self.chips = get_blind_amount(G.GAME.round_resets.ante)*self.mult*G.GAME.starting_params.ante_scaling
        self.chip_text = number_format(self.chips)
		G.GAME.modifiers.fnwk_hide_blind_score = true
	end
	
	if not (blind or reset) then return ret end

	for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
		if self.config.blind ~= v.config.blind then
			v:extra_set_blind(v.config.blind, reset, silent)
		end
	end

	return ret
end

--- reimplementation because the original has a lot of visuals for "defeat"
--- You can't "defeat" extra blinds except by selling the joker
local ref_blind_defeat = Blind.defeat
function Blind:defeat(silent)
	if not self.fnwk_extra_blind then self.disabled = self.main_blind_disabled end
	local ret = ref_blind_defeat(self, silent)

	-- although this is not recursive, this check still exists for if
	-- defeat gets called by, say, the joker controlling the extra blind when sold
	if not self.fnwk_extra_blind then
		self.disabled = false
		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				v.chips = self.chips
				v.chip_text = number_format(self.chips)
				v.dollars = self.dollars
				G.GAME.blind = v

				for _, val in ipairs(G.jokers.cards) do
					if val.facing == 'back' then val:flip() end
				end
				local obj = v.config.blind
				if obj.defeat and type(obj.defeat) == 'function' then
					obj:defeat()
				elseif v.name == 'Crimson Heart' then
					for _, val in ipairs(G.jokers.cards) do
						val.ability.crimson_heart_chosen = nil
					end
				elseif v.name == 'The Manacle' and not v.disabled then
					G.hand:change_size(1)
				end

				self.chips = v.chips
				self.chip_text = number_format(v.chips)
				self.dollars = v.dollars
				G.GAME.blind = self
			end
		end
	end

	return ret
end

local ref_blind_disable = Blind.disable
function Blind:disable()
	if not self.fnwk_extra_blind then
		local ret = nil
		if not self.main_blind_disabled then
			self.main_blind_disabled = not self.disabled
			ret = ref_blind_disable(self)
		end
		
		if self.main_blind_disabled then self.boss = false end
		self.disabled = false

		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if self.config.blind ~= v.config.blind and not v.disabled then
				v.chips = self.chips
				v.chip_text = number_format(self.chips)
				v.dollars = self.dollars
				G.GAME.blind = v

				ref_blind_disable(v)

				self.chips = v.chips
				self.chip_text = number_format(v.chips)
				self.dollars = v.dollars
				G.GAME.blind = self
			end
		end

		return ret
	end
		
	self.chips = G.GAME.blind.chips
	self.chip_text = number_format(G.GAME.blind.chips)
	self.dollars = G.GAME.blind.dollars
	G.GAME.blind = self

	local ret = ref_blind_disable(self)

	G.GAME.blind.chips = self.chips
	G.GAME.blind.chip_text = number_format(self.chips)
	G.GAME.blind.dollars = self.dollars
	G.GAME.blind = G.GAME.blind

	return ret
end

local ref_blind_type = Blind.get_type
function Blind:get_type()
    if self.fnwk_extra_blind then
		return 'Extra'
	end

	return ref_blind_type(self)
end





---------------------------
--------------------------- Visual Blind Functions
---------------------------

local ref_blind_colour = Blind.change_colour
function Blind:change_colour(blind_col)
	if self.fnwk_extra_blind then return end

	return ref_blind_colour(self, blind_col)
end

local ref_alert_debuff = Blind.alert_debuff
function Blind:alert_debuff(first)
	if self.config.blind.key == 'bl_fnwk_final_moe' then return end

	if not self.fnwk_extra_blind and self.main_blind_disabled then
		self.block_play = nil
		return
	end

	return ref_alert_debuff(self, first)
end

local ref_debuff_text = Blind.get_loc_debuff_text
function Blind:get_loc_debuff_text()
	if self.fnwk_extra_blind then
		local old_main_blind = G.GAME.blind
		G.GAME.blind = self
		local ret = ref_debuff_text(self)
		G.GAME.blind = old_main_blind
		return ret
	end

	return ref_debuff_text(self)
end

local ref_blind_wiggle = Blind.wiggle
function Blind:wiggle()
	if self.fnwk_extra_blind then 
		card_eval_status_text(
			self.fnwk_extra_blind,
			'extra',
			nil, nil, nil,
			{
				message = self.disabled and localize('k_disabled_ex') or self.loc_name,
				colour = self.disabled and G.C.FILTER or get_blind_main_colour(self.config.blind.key),
				delay = 0.8
			})
			play_sound('generic1')
		return
	end

	return ref_blind_wiggle(self)
end

local ref_blind_juice = Blind.juice_up
function Blind:juice_up(_a, _b)
	if self.fnwk_extra_blind then 
		card_eval_status_text(
		self.fnwk_extra_blind,
		'extra',
		nil, nil, nil,
		{
			message = self.disabled and localize('k_disabled_ex') or self.loc_name,
			colour = self.disabled and G.C.FILTER or get_blind_main_colour(self.config.blind.key),
			delay = 0.8
		})
		play_sound('generic1')
		return
	end

	return ref_blind_juice(self, _a, _b)
end

local ref_blind_hover = Blind.hover
function Blind:hover()
	if self.fnwk_extra_blind then return end
	return ref_blind_hover(self)
end

local ref_blind_stop_hover = Blind.stop_hover
function Blind:stop_hover()
    if self.fnwk_extra_blind then return end
	return ref_blind_stop_hover(self)
end

local ref_blind_draw = Blind.draw
function Blind:draw()
	if self.fnwk_extra_blind then return end
	return ref_blind_draw(self)
end

local ref_blind_move = Blind.move
function Blind:move(dt)
	if self.fnwk_extra_blind then return end
	return ref_blind_move(self, dt)
end

local ref_blind_dims = Blind.change_dim
function Blind:change_dim(w, h)
	if self.fnwk_extra_blind then return end
	return ref_blind_dims(self, w, h)
end




---------------------------
--------------------------- Debuff functions
---------------------------

--- press_play() main functionality is handled with a lovely patch
local ref_blind_play = Blind.press_play
function Blind:press_play()
	if not self.fnwk_extra_blind then
		self.disabled = self.main_blind_disabled
		self.main_play_loop = true
		return ref_blind_play(self)
	end
	
	local old_main_blind = G.GAME.blind
	self.chips = old_main_blind.chips
	self.chip_text = number_format(old_main_blind.chips)
	self.dollars = old_main_blind.dollars
	G.GAME.blind = self

	local ret = ref_blind_play(self)

	old_main_blind.chips = self.chips
	old_main_blind.chip_text = number_format(self.chips)
	old_main_blind.dollars = self.dollars
	G.GAME.blind = old_main_blind

	if ret then 
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				attention_text({
					text = self.disabled and localize('k_disabled_ex') or self.loc_name,
					scale = 1, 
					hold = 0.45,
					backdrop_colour = self.disabled and G.C.FILTER or get_blind_main_colour(self.config.blind.key),
					align = 'bm',
					major = self.fnwk_extra_blind,
					offset = {x = 0, y = 0.05*self.fnwk_extra_blind.T.h}
				})
				self.fnwk_extra_blind:juice_up()
				play_sound('generic1', (0.9 + 0.2*math.random())*0.2 + 0.8, 1)
				return true
			end
		}))
	end

	return ret
end

--- modify_hand() main functionality is taken care of within a lovely patch
local ref_blind_modify = Blind.modify_hand
function Blind:modify_hand(cards, poker_hands, text, mult, hand_chips, scoring_hand)
	if not self.fnwk_extra_blind then 
		self.disabled = self.main_blind_disabled
		local main_ret, main_chips, main_modded = ref_blind_modify(self, cards, poker_hands, text, mult, hand_chips, scoring_hand)
		if not self.main_play_loop then
			self.disabled = false
		end
		return main_ret, main_chips, main_modded
	end

	local old_main_blind = G.GAME.blind
	self.chips = old_main_blind.chips
	self.chip_text = number_format(old_main_blind.chips)
	self.dollars = old_main_blind.dollars
	G.GAME.blind = self
	
	local mult_ret, chips_ret, modded_ret = ref_blind_modify(self, cards, poker_hands, text, mult, hand_chips, scoring_hand)
	
	old_main_blind.chips = self.chips
	old_main_blind.chip_text = number_format(self.chips)
	old_main_blind.dollars = self.dollars
	G.GAME.blind = old_main_blind

	if ((self.config.blind.modify_hand and type(self.config.blind.modify_hand) == 'function')
	or self.config.blind.name == 'The Flint') then
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				attention_text({
					text = self.disabled and localize('k_disabled_ex') or self.loc_name,
					scale = 1, 
					hold = 0.45,
					backdrop_colour = self.disabled and G.C.FILTER or get_blind_main_colour(self.config.blind.key),
					align = 'bm',
					major = self.fnwk_extra_blind,
					offset = {x = 0, y = 0.05*self.fnwk_extra_blind.T.h}
				})
				self.fnwk_extra_blind:juice_up()
				play_sound('generic1', (0.9 + 0.2*math.random())*0.2 + 0.8, 1)
				return true
			end
		}))
	end

	return mult_ret, chips_ret, modded_ret
end

local ref_blind_hand = Blind.debuff_hand
function Blind:debuff_hand(cards, hand, handname, check)
	if not self.fnwk_extra_blind then self.disabled = self.main_blind_disabled end
	local ret = ref_blind_hand(self, cards, hand, handname, check)
	local extra_ret = nil

	if not self.fnwk_extra_blind then
		if not self.main_play_loop then
			self.disabled = false
		end

		local old_text = SMODS.debuff_text
		local old_source = SMODS.hand_debuff_source
		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				v.chips = self.chips
				v.chip_text = number_format(self.chips)
				v.dollars = self.dollars
				G.GAME.blind = v				

				local v_ret = ref_blind_hand(v, cards, hand, handname, check)

				if v_ret then
					v.fnwk_extra_boss_throw_hand = true
				end

				if not extra_ret and v_ret then
					extra_ret = v_ret 
				end

				self.chips = v.chips
				self.chip_text = number_format(v.chips)
				self.dollars = v.dollars
				G.GAME.blind = self
			end
		end

		-- these are reset to always prioritize a debuff from the main blind
		if old_text then SMODS.debuff_text = old_text end
		if old_source then SMODS.hand_debuff_source = old_source end
	end

	return (ret or extra_ret), (extra_ret and not ret)
end


local ref_blind_drawn = Blind.drawn_to_hand
function Blind:drawn_to_hand()
	if not self.fnwk_extra_blind then self.disabled = self.main_blind_disabled end
	local ret = ref_blind_drawn(self)

	if not self.fnwk_extra_blind then
		self.disabled = false
		self.main_play_loop = nil
		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				v.chips = self.chips
				v.chip_text = number_format(self.chips)
				v.dollars = self.dollars
				G.GAME.blind = v

				ref_blind_drawn(v)

				self.chips = v.chips
				self.chip_text = number_format(v.chips)
				self.dollars = v.dollars
				G.GAME.blind = self
			end
		end
		G.GAME.blind = self
	end

	return ret
end

local ref_blind_flipped = Blind.stay_flipped
function Blind:stay_flipped(area, card, from_area)
	if not self.fnwk_extra_blind then self.disabled = self.main_blind_disabled end
	local ret = ref_blind_flipped(self, area, card, from_area)

	if not self.fnwk_extra_blind then
		if not self.main_play_loop then
			self.disabled = false
		end

		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				v.chips = self.chips
				v.chip_text = number_format(self.chips)
				v.dollars = self.dollars
				G.GAME.blind = v

				local extra_ret = ref_blind_flipped(v, area, card, from_area)

				if not ret and extra_ret and extra_ret == true then
					ret = extra_ret 
				end

				self.chips = v.chips
				self.chip_text = number_format(v.chips)
				self.dollars = v.dollars
				G.GAME.blind = self
			end
		end
	end

	return ret
end

local ref_blind_debuff = Blind.debuff_card
function Blind:debuff_card(card, from_blind)
	if not self.fnwk_extra_blind then self.disabled = self.main_blind_disabled end
	local ret = ref_blind_debuff(self, card, from_blind)

	if not self.fnwk_extra_blind then
		self.disabled = false
		if not card.debuffed_by_blind then
			for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
				if self.config.blind ~= v.config.blind then
					v.chips = self.chips
					v.chip_text = number_format(self.chips)
					v.dollars = self.dollars
					G.GAME.blind = v

					ref_blind_debuff(v, card, from_blind)

					self.chips = v.chips
					self.chip_text = number_format(v.chips)
					self.dollars = v.dollars
					G.GAME.blind = self

					if card.debuffed_by_blind then
						break
					end
				end
			end
		end
	end

	return ret
end





---------------------------
--------------------------- Saving and Loading Functions
---------------------------

--- this feels like it's going to get me killed
local ref_blind_save = Blind.save
function Blind:save()
	local ret = ref_blind_save(self)

	ret.main_blind_disabled = self.main_blind_disabled
	if self.fnwk_extra_blind then
		ret.fnwk_extra_blind = self.fnwk_extra_blind:is(Blind) and self.fnwk_extra_blind.config.blind.key or self.fnwk_extra_blind.unique_val
		ret.dollars = nil
	end

	return ret
end

local ref_blind_load = Blind.load
function Blind:load(blindTable)
	if not self.fnwk_extra_blind then
		local ret = ref_blind_load(self, blindTable)
			
		local obj = self.config.blind
		if self.in_blind and obj.fnwk_blind_load and type(obj.fnwk_blind_load) == 'function' then
			obj:fnwk_blind_load()
		end

		return ret
	end

	self.config.blind = G.P_BLINDS[blindTable.config_blind] or {}  
    self.name = blindTable.name
    self.debuff = blindTable.debuff
    self.mult = blindTable.mult
    self.disabled = blindTable.disabled
	self.main_blind_disabled = blindTable.main_blind_disabled
    self.discards_sub = blindTable.discards_sub
    self.hands_sub = blindTable.hands_sub
    self.boss = blindTable.boss
    self.hands = blindTable.hands
    self.only_hand = blindTable.only_hand
    self.triggered = blindTable.triggered

	self:set_text()
end





---------------------------
--------------------------- Check for card added behavior
---------------------------

function Blind:fnwk_card_added(card)
	local obj = self.config.blind
	if obj.fnwk_card_added and type(obj.fnwk_card_added) == 'function' then
        obj:fnwk_card_added(card)
	end
end