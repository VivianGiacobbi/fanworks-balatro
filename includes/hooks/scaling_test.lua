--- table for keys considered valid for scaling
G.valid_scaling_keys = {
	['mult'] = true,
	['h_mult'] = true,
	['h_x_mult'] = true,
	['h_dollars'] = true,
	['p_dollars'] = true,
	['t_mult'] = true,
	['t_chips'] = true,
	['x_mult'] = true,
	['h_chips'] = true,
	['x_chips'] = true,
	['h_x_chips'] = true,
	['h_size'] = true,
	['d_size'] = true,
	['extra_value'] = true,
	['perma_bonus'] = true,
	['perma_x_chips'] = true,
	['perma_mult'] = true,
	['perma_x_mult'] = true,
	['perma_h_chips'] = true,
	['perma_h_mult'] = true,
	['perma_h_x_mult'] = true,
	['perma_p_dollars'] = true,
	['perma_h_dollars'] = true,
	['caino_xmult'] = true,
	['yorick_discards'] = true,
	['invis_rounds'] = true
}

SMODS.skip_scale_message = {}
SMODS.anticipate_scale_message = {}
SMODS.mod_scale_message = {}

--[[
--- Recursively creates proxies of a give table (typically the ability table)
--- Does not create proxies of Object items
--- @param parent table Highest level parent table
--- @param key any key the first child table to construct tree with
--- @param tree table | nil Constructed tree, leave nil when calling this function
--- @return table # Tree table
function recursive_proxies(parent, key, tree)

    -- first pass
	if not tree then
		tree = {}
    else
        -- preserves the reference to the original table
        tree[key..'_orig_table'] = parent
    end   

	for k, v in pairs(parent) do
		if type(v) == 'table' and not (tbl1.is and tlb1:is(Object)) then
			tree[k] = recursive_proxies(v, k, {})
		end
	end

    parent = {}
    setmetatable(parent, {
        __newindex = function (t,k,v)
            if not self.area or G.STAGE ~= G.STAGES.RUN or self.area.config.collection or not G.jokers then
                tree[key..'_orig_table'] = v
                return
            end

            if tree[key..'_orig_table'] == v then return end

            local ret = {}
            for _, joker in ipairs(G.jokers.cards) do
                local eval = eval_card(joker, {joker_scale = self, key = k, old_val = tree[key..'_orig_table'], new_val = joker})

                if eval.jokers then
                    ret.prevent_scale = ret.prevent_scale or eval.jokers.prevent_scale
                    ret.overwrite = eval.jokers.overwrite or ret.overwrite
                    if not ret.prevent_scale and not ret.overwrite then
                        if eval.jokers.scale_add and type(eval.jokers.scale_add) == 'number' and type(tree[key..'_orig_table']) == 'number' then
                            ret.add = (ret.add or 0) + eval.jokers.scale_add
                        end

                        if eval.jokers.scale_mod and type(eval.jokers.scale_mod) == 'number' and type(tree[key..'_orig_table']) == 'number' then
                            ret.mod = (ret.mod or 1) * eval.jokers.scale_mod
                        end

                        if eval.jokers.scale_message then
                            SMODS.anticipate_scale_message[#SMODS.anticipate_scale_message+1] = {
                                respond_card = eval.jokers.card or eval.jokers.message_card or joker,
                                expect_card = self,
                                extra = {
                                    message = eval.jokers.scale_message,
                                    colour = eval.jokers.colour,
                                    delay = eval.jokers.delay
                                }
                            }
                        end
                    end
                end
                
                SMODS.trigger_effects({eval}, joker)
            end

            if ret.prevent_scale then 
                SMODS.skip_scale_message = { card.self }
                return
            end

            SMODS.skip_scale_message = {}

            local new_val = v
            if ret.overwrite then
                new_val = ret.overwrite
            elseif ret.mod then
                local diff = new_val - tree[key..'_orig_table']
                new_val = tree[key..'_orig_table'] + diff * ret.mod
                SMODS.mod_scale_message = { card = self, mod = ret.mod, add = ret.add }
            else
                SMODS.mod_scale_message = {}
            end

            tree[key..'_orig_table'] = new_val
        end,

        __index = function (t,k)
            return tree[key..'_orig_table']
        end
    })

    return parent
end
--]]

---------------------------
--------------------------- Set ability/extra table proxies using metatable fun
---------------------------

function Card:set_ability_proxy()
    self.ability_ref = nil
    if not self.ability.set == 'Joker' or self.config.center.config.prevent_proxy then
        return
    end

    local ability_orig = self.ability
    local extra_orig = type(self.ability.extra) == 'table' and self.ability.extra or nil

    self.ability_ref = {
        ability = ability_orig,
        extra = extra_orig
    }

    self.ability = {}
    if extra_orig then
        self.ability.extra = {}
        setmetatable(self.ability.extra, {
            __newindex = function (t,k,v)
                if not self.area or G.STAGE ~= G.STAGES.RUN or self.area.config.collection or not G.jokers then
                    extra_orig[k] = v
                    return
                end

                if extra_orig[k] == v then return end

                local ret = {}
                for _, joker in ipairs(G.jokers.cards) do
                    local eval = eval_card(joker, {joker_scale = self, key = k, old_val = extra_orig[k], new_val = joker, extra = true})

                    if eval.jokers then
                        ret.prevent_scale = ret.prevent_scale or eval.jokers.prevent_scale
                        ret.overwrite = eval.jokers.overwrite or ret.overwrite
                        if not ret.prevent_scale and not ret.overwrite then
                            if eval.jokers.scale_add and type(eval.jokers.scale_add) == 'number' and type(extra_orig[k]) == 'number' then
                                ret.add = (ret.add or 0) + eval.jokers.scale_add
                            end

                            if eval.jokers.scale_mod and type(eval.jokers.scale_mod) == 'number' and type(extra_orig[k]) == 'number' then
                                ret.mod = (ret.mod or 1) * eval.jokers.scale_mod
                            end

                            if eval.jokers.scale_message then
                                SMODS.anticipate_scale_message[#SMODS.anticipate_scale_message+1] = {
                                    respond_card = eval.jokers.card or eval.jokers.message_card or joker,
                                    expect_card = self,
                                    extra = {
                                        message = eval.jokers.scale_message,
                                        colour = eval.jokers.colour,
                                        delay = eval.jokers.delay
                                    }
                                }
                            end
                        end
                    end
                    
                    SMODS.trigger_effects({eval}, joker)
                end

                if ret.prevent_scale then 
                    SMODS.skip_scale_message = { card.self }
                    return
                end

                SMODS.skip_scale_message = {}

                local new_val = v
                if ret.overwrite then
                    new_val = ret.overwrite
                elseif ret.mod then
                    local diff = new_val - extra_orig[k]
                    new_val = extra_orig[k] + diff * ret.mod
                    SMODS.mod_scale_message = { card = self, mod = ret.mod, add = ret.add }
                else
                    SMODS.mod_scale_message = {}
                end

                extra_orig[k] = new_val
            end,

            __index = function (t,k)
                return extra_orig[k]
            end
        })
    end

    setmetatable(self.ability, {
        __newindex = function (t,k,v)
            if not self.area or G.STAGE ~= G.STAGES.RUN or self.area.config.collection or not G.jokers or (k == 'extra' and type(ability_orig[k]) == 'table') or not G.valid_scaling_keys[k] then
                ability_orig[k] = v
                return
            end

            if ability_orig[k] == v then return end

            local ret = {}
            for _, joker in ipairs(G.jokers.cards) do
                local eval = eval_card(joker, {joker_scale = self, key = k, old_val = ability_orig[k], new_val = joker})

                if eval.jokers then
                    ret.prevent_scale = ret.prevent_scale or eval.jokers.prevent_scale
                    if not ret.prevent_scale then
                        ret.overwrite = eval.jokers.overwrite or ret.overwrite

                        if eval.jokers.scale_add and type(eval.jokers.scale_add) == 'number' and type(ability_orig[k]) == 'number' then
                            ret.add = (ret.add or 0) + eval.jokers.scale_add
                        end

                        if eval.jokers.scale_mod and type(eval.jokers.scale_mod) == 'number' and type(ability_orig[k]) == 'number' then
                            ret.mod = (ret.mod or 1) * eval.jokers.scale_mod
                        end

                        if eval.jokers.scale_message then
                            SMODS.anticipate_scale_message[#SMODS.anticipate_scale_message+1] = {
                                respond_card = eval.jokers.card or eval.jokers.message_card or joker,
                                expect_card = self,
                                extra = {
                                    message = eval.jokers.scale_message,
                                    colour = eval.jokers.colour,
                                    delay = eval.jokers.delay
                                }
                            }
                        end
                    end
                end

                SMODS.trigger_effects({eval}, joker)
            end

            if ret.prevent_scale then
                SMODS.skip_scale_message = { card = self }
                return
            end

            SMODS.skip_scale_message = {}

            local new_val = v
            if ret.overwrite then
                new_val = ret.overwrite
             elseif ret.mod or ret.add then
                local diff = new_val - extra_orig[k]
                new_val = extra_orig[k] + diff * (ret.mod or 1) + (ret.add or 0)
                SMODS.mod_scale_message = { card = self, mod = ret.mod, add = ret.add }
            else
                SMODS.mod_scale_message = {}
            end

            ability_orig[k] = new_val
        end,

        __index = function (t,k)
            return ability_orig[k]
        end
    })
end

function Card:remove_ability_proxy()
    if not self.ability_ref then return end

    self.ability = self.ability_ref.ability
    setmetatable(self.ability, nil)
    if type(self.ability_ref.extra) == 'table' then
        self.ability.extra = self.ability_ref.extra
        setmetatable(self.ability.extra, nil)
    end

    self.ability_ref = nil
end





---------------------------
--------------------------- Manage proxies on save/load
---------------------------

local ref_set_ability = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
    self:remove_ability_proxy()
    local ret = ref_set_ability(self, center, initial, delay_sprites)
    self:set_ability_proxy()
    return ret
end

local ref_card_load = Card.load
function Card:load(cardTable, other_card)
    local ret = ref_card_load(self, cardTable, other_card)
    self:set_ability_proxy()
    return ret
end

local ref_card_save = Card.save
function Card:save()
    self:remove_ability_proxy()
    local ret = ref_card_save(self)
    self:set_ability_proxy()
    return ret
end





---------------------------
--------------------------- Skip/modify scale messaging
---------------------------

local ref_card_text = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
    if SMODS.skip_scale_message.card == card then
        return
    end

    SMODS.skip_scale_message = {}
    if SMODS.mod_scale_message.card == card then
        if amt then
            amt = amt * (SMODS.mod_scale_message.mod or 1) + (SMODS.mod_scale_message.add or 0)
        elseif extra and extra.message then
            local msg = extra.message
            local sign, sign_end = string.find(msg, '^[+-X]?')
            local sign_sub = ''
            if sign then
                sign_sub = string.sub(msg, sign, sign_end)
                msg = string.gsub(msg, sign_sub, '')
            end

            local num, num_end = string.find(msg, '[%d,.]+')
            if num then
                local num_sub = string.sub(msg, num, num_end)
                local to_num = tonumber(num_sub)
                if to_num then
                    to_num = to_num * (SMODS.mod_scale_message.mod or 1) + (SMODS.mod_scale_message.add or 0)
                    msg = string.gsub(msg, num_sub, tostring(to_num))
                end
            end

            extra.message = sign_sub..msg
        end
    else
        SMODS.mod_scale_message = {}
    end

    local ret = ref_card_text(card, eval_type, amt, percent, dir, extra)

    if SMODS.anticipate_scale_message[1] and SMODS.anticipate_scale_message[1].expect_card == card then
        ref_card_text(SMODS.anticipate_scale_message[1].respond_card, 'extra', nil, percent, nil, SMODS.anticipate_scale_message[1].extra)
        table.remove(SMODS.anticipate_scale_message, 1)
    end

    return ret
end

local valid_message_keys = {
    ['p_dollars'] = true,
    ['dollars'] = true,
    ['h_dollars'] = true,
    ['mult'] = true,
    ['h_mult'] = true,
    ['mult_mod'] = true,
    ['chips'] = true,
    ['h_chips'] = true,
    ['chip_mod'] = true,
    ['x_chips'] = true,
    ['xchips'] = true,
    ['Xchip_mod'] = true,
    ['x_mult'] = true,
    ['xmult'] = true,
    ['Xmult'] = true,
    ['x_mult_mod'] = true,
    ['Xmult_mod'] = true,
    ['swap'] = true,
    ['balance'] = true,
    ['level_up'] = true
}

local ref_indv_effect = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    if not next(SMODS.skip_scale_message) and not next(SMODS.mod_scale_message) then
        return ref_indv_effect(effect, scored_card, key, amount, from_edition)
    end

    local old_card = effect.card
    local key_valid = false
    for k, _ in pairs(effect) do
        if valid_message_keys[k] then
            key_valid = true
            break
        end
    end
    
    if next(SMODS.skip_scale_message) and not key_valid and (not effect.card or (effect.card and not effect.card.playing_card)) then
        -- prevents a card from ticking when the message is passed up
        effect.card = nil
    elseif key_valid then
        SMODS.mod_scale_message = {}
        SMODS.skip_scale_message = {}
    end

    local ret = ref_indv_effect(effect, scored_card, key, amount, from_edition)
    SMODS.anticipate_scale_message = {}
    effect.card = old_card
    return ret
end





---------------------------
--------------------------- Jokers to implement these features
---------------------------

SMODS.Atlas({ key = 'scalers', path = "jokers/scalers.png", px = 71, py = 95, prefix_config = false })

SMODS.Joker({
	name = 'Increment Scaler',
    key = 'scaler_inc',
    prefix_config = false,
    atlas = 'scalers',
    pos = { x = 0, y = 0},
    loc_txt = {
        ['en-us'] = {
            name = 'Scale Incrementer',
            text = {
                "This Joker gains {C:mult}+#1#{} Mult",
                "when another Joker {C:attention}scales{}",
                "{C:inactive}(Currently{} {C:mult}+#2#{} {C:inactive}Mult){}"
            }
        }
    },
	config = {
        extra =  {
            mult = 0,
            mult_mod = 2
        },
        prevent_proxy = true,
    },
	rarity = 1,
	cost = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_mod, card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end

        if context.joker_scale then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            return {
                scale_message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        end
    end
})


SMODS.Joker({
	name = 'Mod Scaler',
    key = 'scaler_mod',
    prefix_config = false,
    atlas = 'scalers',
    pos = { x = 1, y = 0},
    loc_txt = {
        ['en-us'] = {
            name = 'Scale Modder',
            text = {
                "{C:attention}Doubles{} Joker {C:attention}scaling{}"
            }
        }
    },
	config = {
        extra =  {
            mod = 2,
        },
        prevent_proxy = true,
    },
	rarity = 1,
	cost = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
    calculate = function(self, card, context)
    if context.blueprint then return end
    
        if context.joker_scale then
            return {
                scale_mod = card.ability.extra.mod
            }
        end
    end
})

SMODS.Joker({
	name = 'Prevent Scaler',
	key = 'scaler_prevent',
    prefix_config = false,
    atlas = 'scalers',
    pos = { x = 2, y = 0},
    loc_txt = {
        ['en-us'] = {
            name = 'Scale Preventer',
            text = {
                "{C:attention}Prevents{} Joker {C:attention}scaling{}"
            }
        }
    },
	config = {
        prevent_proxy = true,
    },
	rarity = 1,
	cost = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,

	calculate = function(self, card, context)
	if context.blueprint then return end
		if context.joker_scale then
			return {
				prevent_scale = true
			}
		end
	end,
})