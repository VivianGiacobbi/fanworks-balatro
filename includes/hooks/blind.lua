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
		sendDebugMessage(self.config.blind.key)
		self.name = blind.name
		self.debuff = blind.debuff
		self.mult = blind.mult / 2
		self.disabled = false
		self.discards_sub = nil
		self.hands_sub = nil
		self.boss = not not blind.boss
		self.blind_set = false
		self.triggered = nil
		self.prepped = true
		self:set_text()
		
		-- applying any relative mults
		if G.GAME.blind then
			G.GAME.blind.chips = G.GAME.blind.chips * self.mult
			G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
		end	

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
end

local ref_blind_set = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
	if self.fnwk_extra_blind and (blind or reset) then
		return self:extra_set_blind(self.config.blind, reset, silent)
	end

	local ret = ref_blind_set(self, blind, reset, silent)
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
	local ret = ref_blind_defeat(self, silent)

	-- although this is not recursive, this check still exists for if
	-- defeat gets called by, say, the joker controlling the extra blind when sold
	if not self.fnwk_extra_blind then
		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if self.config.blind ~= v.config.blind then
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
			end
		end
		G.GAME.blind = self
	end

	return ret
end

local ref_blind_disable = Blind.disable
function Blind:disable()
	local ret = ref_blind_disable(self)

	if not self.fnwk_extra_blind then
		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				G.GAME.blind = v
				ref_blind_disable(v)
			end
		end
		G.GAME.blind = self
	end

	return ret
end



---------------------------
--------------------------- Visual Blind Functions
---------------------------

local ref_blind_colour = Blind.change_colour
function Blind:change_colour(blind_col)
	if self.fnwk_extra_blind then return end

	return ref_blind_colour(self, blind_col)
end

local ref_debuff_text = Blind.get_loc_debuff_text
function Blind:get_loc_debuff_text()
	if next(SMODS.find_card('c_fnwk_sunshine_downward')) then
        local most_played = fnwk_get_most_played_hand()
        local loc_text = localize(most_played, 'poker_hands')
        return localize{type='variable',key='downward_warn_text',vars={loc_text}}
	end

	local old_main_blind = G.GAME.blind
	if self.fnwk_extra_blind then 
		G.GAME.blind = self
	end

	local ret = ref_debuff_text(self)
	G.GAME.blind = old_main_blind
    
	return ret
end

local ref_blind_wiggle = Blind.wiggle
function Blind:wiggle()
	if self.fnwk_extra_blind then 
		sendDebugMessage('wiggle')
		card_eval_status_text(
		self.fnwk_extra_blind,
		'extra',
		nil, nil, nil,
		{
			message = self.loc_name,
			colour = get_blind_main_colour(self.config.blind.key)
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
			message = self.loc_name,
			colour = get_blind_main_colour(self.config.blind.key)
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
	local old_main_blind = G.GAME.blind
	if self.fnwk_extra_blind then 
		G.GAME.blind = self
	end
		
	local ret = ref_blind_play(self)
	G.GAME.blind = old_main_blind

	if ret and self.fnwk_extra_blind then 
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				attention_text({
					text = self.loc_name,
					scale = 1, 
					hold = 0.45,
					backdrop_colour = get_blind_main_colour(self.config.blind.key),
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
	local old_main_blind = G.GAME.blind
	if self.fnwk_extra_blind then 
		G.GAME.blind = self
	end
	
	local mult_ret, chips_ret, modded_ret = ref_blind_modify(self, cards, poker_hands, text, mult, hand_chips, scoring_hand)
	G.GAME.blind = old_main_blind

	if self.fnwk_extra_blind and 
	((self.config.blind.modify_hand and type(self.config.blind.modify_hand) == 'function')
	or self.config.blind.name == 'The Flint') then
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				attention_text({
					text = self.loc_name,
					scale = 1, 
					hold = 0.45,
					backdrop_colour = get_blind_main_colour(self.config.blind.key),
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
	if next(SMODS.find_card('c_fnwk_sunshine_downward')) then
        local most_played = fnwk_get_most_played_hand()
		if handname ~= most_played then
			return true
		end		
	end 

	local ret = ref_blind_hand(self, cards, hand, handname, check)
	local extra_ret = nil

	if not self.fnwk_extra_blind then
		local old_text = SMODS.debuff_text
		local old_source = SMODS.hand_debuff_source
		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				G.GAME.blind = v
				local v_ret = ref_blind_hand(v, cards, hand, handname, check)

				if v_ret then
					v.fnwk_extra_boss_throw_hand = true
				end

				if not extra_ret and v_ret then
					extra_ret = v_ret 
				end
			end
		end
		G.GAME.blind = self

		-- these are reset to always prioritize a debuff from the main blind
		if old_text then SMODS.debuff_text = old_text end
		if old_source then SMODS.hand_debuff_source = old_source end
	end

	return (ret or extra_ret), (extra_ret and not ret)
end


local ref_blind_drawn = Blind.drawn_to_hand
function Blind:drawn_to_hand()
	local ret = ref_blind_drawn(self)

	if not self.fnwk_extra_blind then
		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				G.GAME.blind = v
				ref_blind_drawn(v)
			end
		end
		G.GAME.blind = self
	end

	return ret
end

local ref_blind_flipped = Blind.stay_flipped
function Blind:stay_flipped(area, card, from_area)
	local ret = ref_blind_flipped(self, area, card, from_area)

	if not self.fnwk_extra_blind then
		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				G.GAME.blind = v
				local extra_ret = ref_blind_flipped(v, area, card, from_area)

				if not ret and extra_ret and extra_ret == true then
					ret = extra_ret 
				end
			end
		end
		G.GAME.blind = self
	end

	return ret
end

local ref_blind_debuff = Blind.debuff_card
function Blind:debuff_card(card, from_blind)
	local ret = ref_blind_debuff(self, card, from_blind)

	if not self.fnwk_extra_blind and not card.debuffed_by_blind then		
		for _, v in ipairs(G.GAME.fnwk_extra_blinds) do
			if self.config.blind ~= v.config.blind then
				G.GAME.blind = v
				ref_blind_debuff(v, card, from_blind)

				if card.debuffed_by_blind then
					break
				end
			end
		end
		G.GAME.blind = self
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

	if self.fnwk_extra_blind then
		ret.fnwk_extra_blind = self.fnwk_extra_blind.unique_val
		ret.dollars = nil
	end

	return ret
end

local ref_blind_load = Blind.load
function Blind:load(blindTable)
	if not self.fnwk_extra_blind then
		return ref_blind_load(self, blindTable)
	end

	self.config.blind = G.P_BLINDS[blindTable.config_blind] or {}  
    self.name = blindTable.name
    self.debuff = blindTable.debuff
    self.mult = blindTable.mult
    self.disabled = blindTable.disabled
    self.discards_sub = blindTable.discards_sub
    self.hands_sub = blindTable.hands_sub
    self.boss = blindTable.boss
    self.hands = blindTable.hands
    self.only_hand = blindTable.only_hand
    self.triggered = blindTable.triggered

	self:set_text()
end