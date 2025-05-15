---------------------------
--------------------------- Crown of Thorns
---------------------------

local ref_get_id = Card.get_id
function Card:get_id(skip_pmk)
    local id = ref_get_id(self, skip_pmk)
    if not self.debuff and next(SMODS.find_card('j_fnwk_rubicon_crown')) and (id == 11 or id == 13) then
        return 12
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

local ref_set_debuff = Card.set_debuff
function Card:set_debuff(should_debuff)
    -- can't undebuff something if it has any force debuffs applied
	if self.force_debuffs and next(self.force_debuffs) then
        self.debuff = true
        return
    end

    return ref_set_debuff(self, should_debuff)
end

function Card:add_force_debuff(card_source)
    if not self.force_debuffs then self.force_debuffs = {} end
    self.force_debuffs[card_source.ID] = true
    self:set_debuff()
end

function Card:remove_force_debuff(card_source)
    if not self.force_debuffs then return end
    self.force_debuffs[card_source.ID] = false
    self:set_debuff()
end

function Card:reset_force_debuffs()
    self.force_debuffs = nil
    self:set_debuff()
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

    if G.jokers and self.ability.set == 'Joker' then
        SMODS.calculate_context({fnwk_joker_destroyed = true, joker = self})
    end

    return ret
end