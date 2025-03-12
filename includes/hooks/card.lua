local base_get_id = Card.get_id
function Card:get_id()
    local id = base_get_id(self)
    if next(SMODS.find_card('j_fnwk_rubicon_bone')) and (id == 11 or id == 13) then
        return 12
    end
    return id
end

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

function Card:remove_predict_ui()
    if not self.children.predict_ui then 
        return
    end

    self.children.predict_ui:remove()     
    self.children.predict_ui = nil
end

local ref_card_hover = Card.hover
function Card:hover()
    ref_card_hover(self)
    if self.ability.set == 'Booster' then
        SMODS.calculate_context({hovering_booster = true, booster = self})
    end
end

local ref_card_stop_hover = Card.stop_hover
function Card:stop_hover()
    ref_card_stop_hover(self)
    if self.ability.set == "Booster" then
        SMODS.calculate_context({stopped_hovering = true, booster = self})
        return
    end
end

function SMODS.calculate_quantum_editions(card, effects, context)
    if not card.edition then
        return
    end

    context.extra_edition = true
    local extra_editions = SMODS.get_quantum_editions(card)
    if #extra_editions < 1 then
        return
    end
    local old_edition = copy_table(card.edition)

    
    for i, v in ipairs(extra_editions) do
        if G.P_CENTERS[v.key] then
            
            card.edition = v
            local eval = {edition = card:calculate_edition(context)}
            if eval then
                effects[#effects+1] = eval
            end
        end
    end
    
    card.edition = old_edition
    context.extra_edition = nil
end

function SMODS.get_quantum_editions(card)
    if card.edition.others and next(card.edition.others) then
        local extras = copy_table(card.edition.others)
        return extras
    end
    return {}
end