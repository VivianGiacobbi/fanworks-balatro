---------------------------
--------------------------- Crown of Thorns
---------------------------

local ref_get_id = Card.get_id
function Card:get_id(skip_pmk)
    local id = ref_get_id(self, skip_pmk)
    local crowns = SMODS.find_card('j_fnwk_rubicon_crown')
    local valid_crown = nil
    if next(crowns) then
        for _, v in pairs(crowns) do
            if not v.debuff then valid_crown = true end
        end
    end

    if valid_crown and id then
        local rank = SMODS.Ranks[self.base.value]
        if (id > 0 and rank and rank.face) or next(find_joker("Pareidolia")) then
            return 12
        end
    end
    
    return id
end





---------------------------
--------------------------- Maggie Quips
---------------------------

function Card:add_quip(text_key, align, loc_vars, extra)
    if self.children.quip then 
        self.children.quip:remove()     
    end

    self.children.quip = UIBox{
        definition = G.UIDEF.jok_speech_bubble(text_key, loc_vars, extra),
        config = { align = align or 'bm', offset = { x=0, y=0 }, parent = self}
    }
    self.children.quip:set_role{
        major = self,
        role_type = 'Minor',
        xy_bond = 'Weak',
        r_bond = 'Weak',
    }
    self.children.quip.states.visible = false
end

function Card:remove_quip()
    if self.children.quip then 
        self.children.quip:remove()
        self.children.quip = nil 
    end
end

function Card:say_quip(iter, not_first, def_speed)
    -- cancel this quip once the iteration ends
    if iter <= 0 then 
        self.talking = false
        return 
    end
    
    local speed = (not def_speed and G.SPEEDFACTOR) or 1
    local delay_mult = def_speed and G.SPEEDFACTOR or 1
    self.talking = true

    if not not_first then 
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1 * delay_mult,
            func = function()
                if self.children.quip then 
                    self.children.quip.states.visible = true
                end
                self:say_quip(iter, true, def_speed)
            return true
        end}))
        return
    end

    local new_said = math.random(1, 10)
    if self.last_said and new_said >= self.last_said then
        new_said = new_said + 1
    end
    self.last_said = new_said
    play_sound('voice'..new_said, speed * (math.random() * 0.2 + 1), 0.5)

    self:juice_up()
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        blocking = false,
        delay = 0.13 * delay_mult,
        func = function()
            self:say_quip(iter-1, true, def_speed)
        return true  
    end}), 'tutorial')
end





---------------------------
--------------------------- Skeptic Joker predict UI
---------------------------

--- Creates a UI box appended as a child to the card, self.children.predict_ui
--- @param cardarea CardArea A Balatro cardarea table containing cards to display
--- @param align string Shorthand alignment string ('bm' for bottom middle)
function Card:show_predict_ui(cardarea, align)
    if self.children.predict_ui then 
        self.children.predict_ui:remove()     
    end

    self.children.predict_ui = UIBox{
        definition = G.UIDEF.predict_card_ui(cardarea),
        config = { align = align or 'bm', offset = { x=0, y=0 }, parent = self}
    }
    self.children.predict_ui:set_role{
        major = self,
        role_type = 'Minor',
        xy_bond = 'Weak',
        r_bond = 'Weak',
    }
end

--- Removes the predict_card_ui as a child from this card
function Card:remove_predict_ui()
    if not self.children.predict_ui then 
        return
    end

    self.children.predict_ui:remove()     
    self.children.predict_ui = nil
end

local ref_card_hover = Card.hover
function Card:hover()
    if G.fnwk_peppers_hovers then
        for _, v in ipairs(G.fnwk_peppers_hovers) do
            if v then
                v.ability.aura_flare_queued = nil
                v.ability.stand_activated = nil
            end
        end
        
        G.fnwk_peppers_hovers = nil
    end

    if self.ability.set == 'Enhanced' and self.config.center.key ~= 'm_wild' then
        local peppers = SMODS.find_card('c_fnwk_rockhard_peppers')
        if next(peppers) then
            G.fnwk_peppers_hovers = {}
            for i, v in ipairs(peppers) do
                v.ability.aura_flare_queued = true
                G.fnwk_peppers_hovers[i] = v
            end
        end
        
    end

    local ret = ref_card_hover(self)
    if (self.config.center.discovered and not G.OVERLAY_MENU) and self.ability.set == 'Booster' then
        SMODS.calculate_context({hovering_booster = true, booster = self})
    end

    return ret
end

local ref_card_stop_hover = Card.stop_hover
function Card:stop_hover()
    if G.fnwk_peppers_hovers then
        local remove = not G.CONTROLLER.hovering.target
        if not remove then
            local target = G.CONTROLLER.hovering.target
            if not target.is or type(target.is) ~= 'function' or not target:is(Card) then
                remove = true
            end
        end

        if remove then
            for _, v in ipairs(G.fnwk_peppers_hovers) do
                if v then
                    v.ability.aura_flare_queued = nil
                    v.ability.stand_activated = nil
                end
            end
        end
    end
    

    local ret = ref_card_stop_hover(self)
    if (self.config.center.discovered and not G.OVERLAY_MENU) and self.ability.set == "Booster" then
        SMODS.calculate_context({stopped_hovering = true, booster = self})
        return
    end

    return ret
end

function love.focus(f)
    if not f then return end

    if G.fnwk_peppers_hovers then
        for _, v in ipairs(G.fnwk_peppers_hovers) do
            if v then
                v.ability.aura_flare_queued = nil
                v.ability.stand_activated = nil
            end
        end
        
        G.fnwk_peppers_hovers = nil
    end
end





---------------------------
--------------------------- Teenage Ganster and Biased Joker hooks
---------------------------

local ref_is_face = Card.is_face
function Card:is_face(from_boss)
    if next(SMODS.find_card('j_fnwk_streetlight_teenage')) then
        return false
    end

    return ref_is_face(self, from_boss)
end





---------------------------
--------------------------- Joker Unlock condition hooks
---------------------------

local ref_set_base = Card.set_base
function Card:set_base(card, initial, delay_sprites)
    local old_id = nil
    if self.base then old_id = self.base.id end

    -- base function call
    local ret = ref_set_base(self, card, initial, delay_sprites)

    if self.playing_card and not initial and old_id == 12 and self.base.id == 13 then 
        check_for_unlock({type = 'queen_to_king'})
    end

    return ret
end

local ref_sell_card = Card.sell_card
function Card:sell_card()
    local ret = ref_sell_card(self)

    if self.ability.set == 'Joker' then 
        G.GAME.fnwk_patsy_jokers_sold = G.GAME.fnwk_patsy_jokers_sold + 1
        check_for_unlock({type = 'patsy_jokers_sold', amount = G.GAME.fnwk_patsy_jokers_sold})
    end

    return ret
end

--- Tallies glass shatters per run for the sake of Square Biz Killer unlock
local ref_shatter = Card.shatter
function Card:shatter()
    local ret = ref_shatter(self)
    G.GAME.fnwk_glass_shatters = G.GAME.fnwk_glass_shatters + 1
    check_for_unlock({type = 'run_shattered', total_shattered = G.GAME.fnwk_glass_shatters})
    return ret
end






---------------------------
--------------------------- Tracking for Fanworks Joker
---------------------------

local ref_card_add = Card.add_to_deck
function Card:add_to_deck(from_debuff)
    local ret = ref_card_add(self, from_debuff)

    if not from_debuff then
        G.GAME.fnwk_owned_jokers[self.config.center.key] = true
    end

    return ret
end





---------------------------
--------------------------- Joker destruction calc context
---------------------------

local ref_card_dissolve = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
    local ret = ref_card_dissolve(self, dissolve_colours, silent, dissolve_time_fac, no_juice)

    if self.area then
        SMODS.calculate_context({fnwk_card_removed = true, card = self})
    end

    return ret
end





---------------------------
--------------------------- Joker destruction calc context
---------------------------

local ref_set_edition = Card.set_edition
function Card:set_edition(edition, immediate, silent, delay)
    if not next(SMODS.find_card('j_fnwk_jspec_ilsa')) then
        return ref_set_edition(self, edition, immediate, silent, delay)
    end

    SMODS.enh_cache:write(self, nil)
	-- Check to see if negative is being removed and reduce card_limit accordingly
	if (self.added_to_deck or self.joker_added_to_deck_but_debuffed or (self.area == G.hand and not self.debuff)) and self.edition and self.edition.card_limit then
		if self.ability.consumeable and self.area == G.consumeables then
			G.consumeables.config.card_limit = G.consumeables.config.card_limit - self.edition.card_limit
		elseif self.ability.set == 'Joker' and self.area == G.jokers then
			G.jokers.config.card_limit = G.jokers.config.card_limit - self.edition.card_limit
		elseif self.area == G.hand then
			if G.hand.config.real_card_limit then
				G.hand.config.real_card_limit = G.hand.config.real_card_limit - self.edition.card_limit
			end
			G.hand.config.card_limit = G.hand.config.card_limit - self.edition.card_limit
		end
	end

	local old_edition = self.edition and self.edition.key
	if old_edition then
		self.ignore_base_shader[old_edition] = nil
		self.ignore_shadow[old_edition] = nil

		local on_old_edition_removed = G.P_CENTERS[old_edition] and G.P_CENTERS[old_edition].on_remove
		if type(on_old_edition_removed) == "function" then
			on_old_edition_removed(self)
		end
	end

	local edition_type = nil
	if type(edition) == 'string' then
		assert(string.sub(edition, 1, 2) == 'e_', ("Edition \"%s\" is missing \"e_\" prefix."):format(edition))
		edition_type = string.sub(edition, 3)
	elseif type(edition) == 'table' then
		if edition.type then
			edition_type = edition.type
		else
			for k, v in pairs(edition) do
				if v then
					assert(not edition_type, "Tried to apply more than one edition.")
					edition_type = k
				end
			end
		end
	end

	if not edition_type or edition_type == 'base' then
		if self.edition == nil then -- early exit
			return
		end
		self.edition = nil -- remove edition from card
		self:set_cost()
		if not silent then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = not immediate and 0.2 or 0,
				blockable = not immediate,
				func = function()
					self:juice_up(1, 0.5)
					play_sound('whoosh2', 1.2, 0.6)
					return true
				end
			}))
		end
		return
	end

    self.edition = {}
    self.edition.others = {}
    local all_types = {[edition_type] = true}
    all_types['holo'] = true
    all_types['foil'] = true
    all_types['polychrome'] = true

    for ed_key, _ in pairs(all_types) do
        local get_edition = G.P_CENTERS['e_' .. ed_key]
        local edition_table = {}
        for k, v in pairs(get_edition.config) do
            if type(v) == 'table' then
                edition_table[k] = copy_table(v)
            else
                edition_table[k] = v
            end

            if k == 'card_limit' and (self.added_to_deck or self.joker_added_to_deck_but_debuffed or (self.area == G.hand and not self.debuff)) and G.jokers and G.consumeables then
                if self.ability.consumeable then
                    G.consumeables.config.card_limit = G.consumeables.config.card_limit + v
                elseif self.ability.set == 'Joker' then
                    G.jokers.config.card_limit = G.jokers.config.card_limit + v
                elseif self.area == G.hand then
                    local is_in_pack = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.config.center.draw_hand))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            if G.hand.config.real_card_limit then
                                G.hand.config.real_card_limit = G.hand.config.real_card_limit + v
                            end
                            G.hand.config.card_limit = G.hand.config.card_limit + v
                            if not is_in_pack and G.GAME.blind.in_blind then
                                G.FUNCS.draw_from_deck_to_hand(v)
                            end
                            return true
                        end
                    }))
                end
            end
        end

        if ed_key == edition_type then
            local on_edition_applied = get_edition.on_apply
            if type(on_edition_applied) == "function" then
                on_edition_applied(self)
            end

            self.edition[ed_key] = true
            self.edition.type = ed_key
            local key = 'e_' .. ed_key
            self.edition.key = key
            if get_edition.override_base_shader or get_edition.disable_base_shader then
                self.ignore_base_shader[key] = true
            end
            if get_edition.no_shadow or get_edition.disable_shadow then
                self.ignore_shadow[key] = true
            end
            for k, v in pairs(edition_table) do
                self.edition[k] = v
            end
        else 
            local other_edition = {
                [ed_key] = true,
                type = ed_key,
                key = 'e_' .. ed_key
            }
            for k, v in pairs(edition_table) do
                other_edition[k] = v
            end
            self.edition.others[#self.edition.others+1] = other_edition
        end
    end

    if next(self.edition.others) == nil then
        self.edition.others = nil
    end

	if self.area and self.area == G.jokers then
		if self.edition then
			if not G.P_CENTERS['e_' .. (self.edition.type)].discovered then
				discover_card(G.P_CENTERS['e_' .. (self.edition.type)])
			end
		else
			if not G.P_CENTERS['e_base'].discovered then
				discover_card(G.P_CENTERS['e_base'])
			end
		end
	end

	if self.edition and not silent then
		local ed = G.P_CENTERS['e_' .. (self.edition.type)]
		G.CONTROLLER.locks.edition = true
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = not immediate and 0.2 or 0,
			blockable = not immediate,
			func = function()
				if self.edition then
					self:juice_up(1, 0.5)
					play_sound(ed.sound.sound, ed.sound.per, ed.sound.vol)
				end
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.1,
			func = function()
				G.CONTROLLER.locks.edition = false
				return true
			end
		}))
	end

	if delay then
		self.delay_edition = true
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				self.delay_edition = nil
				return true
			end
		}))
	end

	if G.jokers and self.area == G.jokers then
		check_for_unlock({ type = 'modify_jokers' })
	end

	self:set_cost()
end

local ref_card_open = Card.open
function Card:open()
    local insanes = nil
    if self.ability.set == 'Booster' and self.ability.extra and type(self.ability.extra) ~= 'table' then
        local card_mod = G.P_CENTERS['c_fnwk_bluebolt_insane'].config.extra.card_mod
        insanes = SMODS.find_card('c_fnwk_bluebolt_insane')
        self.ability.extra = self.ability.extra * card_mod^#insanes
    end

    local ret = ref_card_open(self)

    if insanes then
        for _, v in ipairs(insanes) do
            G.FUNCS.flare_stand_aura(v, 0.5)
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    v:juice_up()
                    play_sound('generic1')
                    attention_text({
                        text = localize('k_insane'),
                        scale = 1,
                        hold = 0.5,
                        backdrop_colour = G.C.STAND,
                        align = 'bm',
                        major = v,
                        offset = {x = 0, y = 0.05*v.T.h}
                    })
                    return true
                end
            }))
        end
    end

    return ret
end





---------------------------
--------------------------- Disturbia joker interjection
---------------------------

local ref_UAT = Card.generate_UIBox_ability_table
function Card:generate_UIBox_ability_table(vars_only)
    if self.ability.fnwk_disturbia_fake then
        local ret = ref_UAT(self.ability.fnwk_disturbia_fake, vars_only)
        return generate_card_ui(G.P_CENTERS['c_fnwk_streetlight_disturbia'], ret)
    end

    return ref_UAT(self, vars_only)
end