---------------------------
--------------------------- Crown of Thorns
---------------------------

local ref_get_id = Card.get_id
function Card:get_id(skip_pmk)
    local id = ref_get_id(self, skip_pmk)

    if next(SMODS.find_card('j_fnwk_rubicon_crown')) and id then
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
--------------------------- Insane in the Brain predict UI
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
function Card:hover(...)
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

    local ret = ref_card_hover(self, ...)

    if (self.config.center.discovered and not G.OVERLAY_MENU) and self.ability.set == 'Booster' then
        SMODS.calculate_context({hovering_booster = true, booster = self})
    end

    return ret
end

local ref_card_stop_hover = Card.stop_hover
function Card:stop_hover(...)
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


    local ret = ref_card_stop_hover(self, ...)
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
function Card:is_face(...)
    if next(SMODS.find_card('j_fnwk_streetlight_teenage')) then
        return false
    end

    return ref_is_face(self, ...)
end





---------------------------
--------------------------- Joker Unlock condition hooks
---------------------------

local ref_set_base = Card.set_base
function Card:set_base(...)
    local old_id = nil
    if self.base then old_id = self.base.id end

    -- base function call
    local ret = ref_set_base(self, ...)

    if self.playing_card then
        G.GAME.fnwk_id = G.GAME.fnwk_id or 1
        self.fnwk_id = G.GAME.fnwk_id
        G.GAME.fnwk_id = G.GAME.fnwk_id + 1
    end

    local args = {...}
    local initial = args[2]
    if self.playing_card and not initial and old_id == 12 and self.base.id == 13 then
        check_for_unlock({type = 'queen_to_king'})
    end

    return ret
end

--- Tallies glass shatters per run for the sake of Square Biz Killer unlock
local ref_shatter = Card.shatter
function Card:shatter(...)
    local ret = ref_shatter(self, ...)
    G.GAME.fnwk_glass_shatters = G.GAME.fnwk_glass_shatters + 1
    check_for_unlock({type = 'run_shattered', total_shattered = G.GAME.fnwk_glass_shatters})
    return ret
end






---------------------------
--------------------------- Tracking for Fanworks Joker
---------------------------

local ref_card_add = Card.add_to_deck
function Card:add_to_deck(...)
    local ret = ref_card_add(self, ...)

    local args = {...}
    local from_debuff = args[1]

    if not from_debuff then
        G.GAME.fnwk_owned_jokers[self.config.center.key] = true
    end

    if not from_debuff and G.GAME.blind then G.GAME.blind:card_added(self) end

    return ret
end

function Card:add_to_deck_disturbia(from_debuff, disturbia)
    if self.fnwk_disturbia_joker and from_debuff and not disturbia then
        return
    end

    return Card.add_to_deck(self, from_debuff)
end

function Card:remove_from_deck_disturbia(from_debuff, disturbia)
    if self.fnwk_disturbia_joker and from_debuff and not disturbia then
        return
    end

    return Card.remove_from_deck(self, from_debuff)
end





---------------------------
--------------------------- Card destruction calc context
---------------------------

local ref_card_dissolve = Card.start_dissolve
function Card:start_dissolve(...)
    if self.fnwk_disturbia_joker then
        return ref_card_dissolve(self.fnwk_disturbia_joker, ...)
    end

    return ref_card_dissolve(self, ...)
end





---------------------------
--------------------------- Ilsa edition effect
---------------------------

local ref_set_edition = Card.set_edition
function Card:set_edition(edition, immediate, silent, delay, ...)
    local valid_ilsa = G.force_ilsa or next(SMODS.find_card('j_fnwk_jspec_ilsa')) or nil
    if not valid_ilsa then
        return ref_set_edition(self, edition, immediate, silent, delay, ...)
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





---------------------------
--------------------------- Insane in the Brain pack modification
---------------------------

local ref_card_open = Card.open
function Card:open(...)
    local ret = ref_card_open(self, ...)

    local insanes = SMODS.find_card('c_fnwk_bluebolt_insane')
    if next(insanes) then
        for _, v in ipairs(insanes) do
            ArrowAPI.stands.flare_aura(v, 0.5)
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
function Card:generate_UIBox_ability_table(...)
    if self.ability.fnwk_disturbia_fake then
        local ret = ref_UAT(self.ability.fnwk_disturbia_fake, ...)
        ret = generate_card_ui(G.P_CENTERS['c_fnwk_streetlight_disturbia'], ret)
        return ret
    end

    return ref_UAT(self, ...)
end

function Card:calculate_dollar_bonus_disturbia(disturbia)
    if self.fnwk_disturbia_joker and not disturbia then
        return
    end

    return Card.calculate_dollar_bonus(self)
end

local ref_card_cost = Card.set_cost
function Card:set_cost(...)
    if self.config.center.key == 'c_fnwk_closer_artificial' or G.GAME.modifiers.fnwk_no_sell then
        self.sell_cost = 0
        self.sell_cost_label = 0
        return
    end

    if self.config.center.key == 'c_fnwk_streetlight_disturbia' and self.ability.extra.target_card then
        self.extra_cost = self.ability.fnwk_disturbia_fake.extra_cost
        self.cost = self.ability.fnwk_disturbia_fake.cost
        self.sell_cost = self.ability.fnwk_disturbia_fake.sell_cost
        self.sell_cost_label = self.ability.fnwk_disturbia_fake.sell_cost_label
    end

    local ret = ref_card_cost(self, ...)
    if self.fnwk_disturbia_joker then
        self.fnwk_disturbia_joker.extra_cost = self.extra_cost
        self.fnwk_disturbia_joker.cost = self.cost
        self.fnwk_disturbia_joker.sell_cost = self.sell_cost
        self.fnwk_disturbia_joker.sell_cost_label = self.sell_cost_label
    elseif self.config.center.key == 'j_fnwk_dark_foxglove' then
        self.sell_cost = self.ability.extra.sell_value + self.ability.extra_value
        self.sell_cost_label = self.sell_cost
    end

    return ret
end


local ref_card_eor = Card.get_end_of_round_effect
function Card:get_end_of_round_effect(...)
    if self.config.center.key == 'm_gold' and self:get_h_dollars() > 5 then
        check_for_unlock({type = 'fnwk_streetlight_daddy'})
    end

    local togethers = SMODS.find_card('c_fnwk_jspec_miracle_together')
    if self.seal ~= 'Blue' or not next(togethers) then
        local ret = ref_card_eor(self, ...)
        if ret.effect then
            check_for_unlock({type = 'fnwk_seal_planet'})
        end

        return ret
    end

    local old_extra = self.extra_enhancement
    self.extra_enhancement = self.extra_enhancement or true
    local ret = ref_card_eor(self, ...)
    self.extra_enhancement = old_extra

    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

    for _, v in ipairs(togethers) do
        ArrowAPI.stands.flare_aura(v, 0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                v:juice_up()
                return true
            end
        }))
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.0,
        func = (function()
            if G.GAME.last_hand_played then
                local _planet = 0
                for _, v in pairs(G.P_CENTER_POOLS.Planet) do
                    if v.config.hand_type == G.GAME.last_hand_played then
                        _planet = v.key
                    end
                end
                if _planet == 0 then _planet = nil end
                local new_planet = create_card('Planet' ,G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
                new_planet:set_edition({negative = true}, true)
                new_planet:add_to_deck()
                G.consumeables:emplace(new_planet)
                G.GAME.consumeable_buffer = 0
            end
            return true
        end)}))
    card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
    ret.effect = true

    if ret.effect then
        check_for_unlock({type = 'fnwk_seal_planet'})
    end

    return ret
end





---------------------------
--------------------------- Rot boss effect
---------------------------


local ref_card_canuse = Card.can_use_consumeable
function Card:can_use_consumeable(...)
    local args = {...}

    if not args[1] --[[ skip check --]] and G.GAME.modifiers.fnwk_no_consumeables then
        return false
    end

    return ref_card_canuse(self, ...)
end





---------------------------
--------------------------- Manga boss effect
---------------------------

local ref_card_bonus = Card.get_chip_bonus
function Card:get_chip_bonus(...)
    if G.GAME.modifiers.fnwk_no_rank_chips then
        local old_nom = self.base.nominal
        self.base.nominal = 0
        local ret = ref_card_bonus(self, ...)
        self.base.nominal = old_nom
        return ret
    end

    return ref_card_bonus(self, ...)
end





---------------------------
--------------------------- Work/Application blind tracking
---------------------------

local ref_card_save = Card.save
function Card:save(...)
    local ret = ref_card_save(self, ...)
    ret.fnwk_work_submitted = self.fnwk_work_submitted
    ret.fnwk_id = self.fnwk_id
    return ret
end

local ref_card_load = Card.load
function Card:load(...)
    local ret = ref_card_load(self, ...)

    local args = {...}
    local cardTable = args[1]
    self.fnwk_work_submitted = cardTable.fnwk_work_submitted
    self.fnwk_id = cardTable.fnwk_id
    return ret
end





---------------------------
--------------------------- Arcane Deck unlock
---------------------------

local ref_card_use = Card.use_consumeable
function Card:use_consumeable(...)
    local ret = ref_card_use(self, ...)
    check_for_unlock({type = 'use_consumable', consumable = self})
    return ret
end



local ref_card_update = Card.update
function Card:update(dt)
    local ret = ref_card_update(self, dt)

    if not self.area then
        self.hfpx_current_area = nil
        return
    elseif self.area and not self.hfpx_current_area then
        self.hfpx_current_area = self.area
        self.hfpx_current_cards = {}
    end

    local joker_idx = 1
    local size_changed = #self.area.cards ~= #self.hfpx_current_cards
    local order_changed = false

    for i, v in ipairs(self.area.cards) do
        if v == self then
            joker_idx = i
            if order_changed then
                break
            end
        end

        if not order_changed and v.ID ~= self.hfpx_current_cards[i] then
            order_changed = true
        end
    end

    -- don't do potentially expensive sprite creation if nothing has changed
    if not size_changed and not order_changed and self.hfpx_current_area == self.area and joker_idx == self.hfpx_last_index then
        return
    end

    local eval = eval_card(self, {card_pos_changed = true, new_pos = joker_idx, order_changed = true, size_changed = true})
    SMODS.trigger_effects({eval}, self)

    self.hfpx_current_area = self.area
    self.hfpx_current_cards = {}
    for i = 1, #self.area.cards do
        self.hfpx_current_cards[i] = self.area.cards[i].ID
    end
    self.hfpx_last_index = joker_idx

    return ret
end

local ref_card_click = Card.click
function Card:click()
    if self.config and self.config.center and self.config.center.key == 'c_fnwk_redrising_invisible' then
        if self.config.center.unlocked then
            return ref_card_click(self)
        end

        unlock_card(self.config.center)
        discover_card(self.config.center)
        self:set_sprites(self.config.center)
        self:juice_up()
        play_sound('polychrome1')
        check_for_unlock({type = 'redrising_found'})
    end

    return ref_card_click(self)
end