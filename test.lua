-- manage reload manual replacement
update = function(self, card, dt)
	if type(card.ability.current_area) ~= 'table' then
		card.ability.current_area = card.area
	end

	if not card.area or (card.area ~= G.jokers) then
		card.ability.current_area = nil
		return
	end
	
	local joker_idx = 1
    if not card.ability.current_cards then card.ability.current_cards = {} end
	local area_changed = #card.area.cards ~= #card.ability.current_cards

    for i, v in ipairs(card.area.cards) do
		if v == card then
            joker_idx = i
            if area_changed then
                break
            end
        end

		if not area_changed and v.ID ~= card.ability.current_cards[i] then
			area_changed = true
		end
	end
	
	-- don't do potentially expensive sprite creation if nothing has changed
	if not area_changed and card.ability.current_area == card.area and joker_idx == card.ability.last_index then
		return
	end

    -- your code here

    card.ability.current_cards = {}
    for _, v in ipairs(card.ability.current_area.cards) do
        card.ability.current_cards[#card.ability.current_cards+1] = v.ID
    end

	card.ability.current_area = card.area
	card.ability.last_index = joker_idx
end

local ref_card_update = Card.update
function Card:update(dt)
    local ret = ref_card_update(self, dt)

    if type(self.ability.current_area) ~= 'table' then
		self.ability.current_area = self.area
	end

	if not self.area then
		self.ability.current_area = nil
		return
	end
	
	local joker_idx = 1
    if not self.ability.current_cards then self.ability.current_cards = {} end
	local size_changed = #self.area.cards ~= #self.ability.current_cards
    local order_changed = false

    for i, v in ipairs(self.area.cards) do
		if v == self then
            joker_idx = i
            if order_changed then
                return
            end
        end

		if not order_changed and v.ID ~= self.ability.current_cards[i] then
			order_changed = true
		end
	end
	
	-- don't do potentially expensive sprite creation if nothing has changed
	if not size_changed and not order_changed and self.ability.current_area == self.area and joker_idx == self.ability.last_index then
		return
	end

    local eval = eval_card(self, {card_pos_changed = true, new_pos = joker_idx, order_changed = true, size_changed = true})
    SMODS.trigger_effects({eval}, self)

    self.ability.current_cards = {}
    for _, v in ipairs(self.ability.current_area.cards) do
        self.ability.current_area.cards[#self.ability.current_area.cards+1] = v.ID
    end

	self.ability.current_area = self.area
	self.ability.last_index = joker_idx

    return ret
end