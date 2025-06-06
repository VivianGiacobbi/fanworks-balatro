SMODS.Atlas({ key = 'bone_king_farewell_overlay', path = 'stands/bone_king_farewell_overlay.png', px = 237, py = 95 })


local consumInfo = {
    key = 'c_fnwk_bone_king_farewell',
    name = 'Farewell to Kings',
    set = 'Stand',
    config = {
        stand_mask = true,
        aura_colors = { 'CBD4E7DC', 'FD5F55DC' },
        evolved = true,
        extra = {
            blind_mod = 0.5
        }
    },
    cost = 4,
    rarity = 'arrow_EvolvedRarity',
    vertex_scale_mod = 71/474,
    soul_pos = {x = 2, y = 0},
    fanwork = 'bone',
    in_progress = true,
    blueprint_compat = true,
    dependencies = {'ArrowAPI'},
}

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "incomplete", set = "Other"}
    return { vars = {card.ability.extra.blind_mod * 100}}
end

function consumInfo.set_sprites(self, card, initial, delay_sprites)
    card.ignore_base_shader = card.ignore_base_shader or {}
    card.ignore_base_shader['fnwk_farewell'] = true
    
    local atlas = G.ASSET_ATLAS['fnwk_bone_king_farewell_overlay']
    local w_scale = atlas.px / 71

    local w = card.T.w * w_scale
    local h = card.T.h
    local x_off = (w - card.T.w) / 2
	local y_off = (h - card.T.h) / 2
    local role = {
        role_type = 'Minor',
        major = card,
        offset = { x = -x_off, y = -y_off },
        xy_bond = 'Strong',
        wh_bond = 'Weak',
        r_bond = 'Strong',
        scale_bond = 'Weak',
        draw_major = card
    }

    card.children.bone_king_base = Sprite(card.T.x - x_off, card.T.y - y_off, w, h, atlas, {x = 1, y = 0})
    card.children.bone_king_base:set_role(role)
    card.children.bone_king_base.custom_draw = true

    if card.children.floating_sprite then 
        card.children.floating_sprite:remove()
        card.children.floating_sprite = nil
    end

    card.children.floating_sprite = Sprite(card.T.x - x_off, card.T.y - y_off, w, h, atlas, {x = 2, y = 0})
    card.children.floating_sprite:set_role({
        role_type = 'Minor',
        major = card,
        offset = { x = -x_off, y = -y_off },
        xy_bond = 'Strong',
        wh_bond = 'Weak',
        r_bond = 'Strong',
        scale_bond = 'Weak',
        draw_major = card
    })
    card.children.floating_sprite.states.hover.can = false
    card.children.floating_sprite.states.click.can = false
end

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if not context.blueprint and not context.joker_retrigger and context.destroy_card and context.cardarea == G.play then
        local scoring  = SMODS.in_scoring(context.destroy_card, context.scoring_hand)
        local steel = SMODS.has_enhancement(context.destroy_card, 'm_steel')
        local king = context.destroy_card:get_id() == 13

        if scoring and steel and king then
            context.destroy_card.fnwk_removed_by_farewell = true
            return {
                remove = true
            }
        end
    end

    if context.fnwk_card_destroyed and context.removed.fnwk_removed_by_farewell then
        local flare_card = context.blueprint_card or card
        return {
            func = function()
                G.FUNCS.flare_stand_aura(flare_card, 0.5)
            end,
            extra = {
                message = localize('k_farewell'),
                sound = 'slice1',
                delay = 0,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            G.GAME.blind.chips = math.floor(G.GAME.blind.chips * card.ability.extra.blind_mod)
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                            G.hand_text_area.blind_chips:juice_up()
                            return true 
                        end 
                    }))
                    delay(1)
                end
            }
        }
    end
end

function consumInfo.draw(self, card, layer)
    if not card.config.center.discovered and (G.OVERLAY_MENU or G.STAGE == G.STAGES.MAIN_MENU) then
        return
    end

    G.SHADERS['fnwk_basic']:send("vertex_scale_mod", card.config.center.vertex_scale_mod)
    card.children.bone_king_base:draw_shader('fnwk_basic')
end

return consumInfo