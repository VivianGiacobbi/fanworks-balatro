SMODS.Shader({ key = 'basic', path = 'basic.fs' })
SMODS.Shader({ key = 'glow', path = 'glow.fs' })
SMODS.Shader({ key = 'neon_flash', path = 'neon_flash.fs' })
SMODS.Atlas({ key = "screen", path = "screen.png", px = 1920, py = 1080})
SMODS.Shader({ key = 'water_mask', path = 'water.fs' })
SMODS.Shader({ key = 'bloom', path = 'bloom.fs' })
SMODS.Shader({ key = 'boney_bottom', path = 'boney_bottom.fs' })
SMODS.Shader({ key = 'boney_top', path = 'boney_top.fs' })
SMODS.Shader({ key = 'speed_lines', path = 'speed_lines.fs' })
SMODS.Shader({ key = 'mod_background', path = 'mod_background.fs'})
SMODS.Shader({ key = 'rotten_graft', path = 'rotten_graft.fs'})
SMODS.Shader({ key = 'stand_notorious', path = 'stand_notorious.fs'})
SMODS.Shader({ key = 'stand_disturbia', path = 'stand_disturbia.fs'})
SMODS.Shader({ key = 'stand_insane', path = 'stand_insane.fs'})

SMODS.DrawStep {
    key = 'revived',
    order = 23,
    func = function(self)
        if self.ability.make_vortex and (self.config.center.discovered or self.bypass_discovery_center) then
            self.children.center:draw_shader('booster', nil, self.ARGS.send_to_shader)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.DrawStep {
    key = 'water_shader',
    order = 23,
    func = function(self)
        if (self.config.center.discovered or self.bypass_discovery_center) and self.ability.water_time and self.ability.water_atlas then
            local cursor_pos = {}
            cursor_pos[1] = self.tilt_var and self.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
            cursor_pos[2] = self.tilt_var and self.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
            local screen_scale = G.TILESCALE*G.TILESIZE*(self.children.center.mouse_damping or 1)*G.CANV_SCALE
            local shader_args = {}
            local hovering = (self.hover_tilt or 0)
        
            shader_args[1] = { name = 'time', val = self.ability.water_time}
            shader_args[2] = { name = 'water', val = G.ASSET_ATLAS[self.ability.water_atlas].image}
            shader_args[3] = { name = 'mouse_screen_pos', val = cursor_pos }
            shader_args[4] = { name = 'screen_scale', val = screen_scale }
            shader_args[5] = { name = 'hovering', val = hovering }
            self.children.center:draw_shader('fnwk_water_mask', nil, shader_args, false, nil, nil, nil, nil, nil, true)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.DrawStep {
    key = 'glow_shader',
    order = 24,
    func = function(self)
        if (self.config.center.discovered or self.bypass_discovery_center) and self.ability.glow then
            local cursor_pos = {}
            cursor_pos[1] = self.tilt_var and self.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
            cursor_pos[2] = self.tilt_var and self.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
            local screen_scale = G.TILESCALE*G.TILESIZE*(self.children.center.mouse_damping or 1)*G.CANV_SCALE
            local shader_args = {}
            local hovering = (self.hover_tilt or 0)
            shader_args[1] = { name = 'glow_intensity', val = self.ability.glow }
            shader_args[2] = { name = 'mouse_screen_pos', val = cursor_pos }
            shader_args[3] = { name = 'screen_scale', val = screen_scale }
            shader_args[4] = { name = 'hovering', val = hovering }
            self.children.center:draw_shader('fnwk_glow', nil, shader_args, false, nil, nil, nil, nil, nil, true)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

local ref_shadow_ds = SMODS.DrawSteps.shadow.func
SMODS.DrawStep:take_ownership('shadow', {
    func = function(self)
        if self.config.center.key ~= 'c_fnwk_streetlight_notorious' then
            return ref_shadow_ds(self)
        end

        self.ARGS.send_to_shader = self.ARGS.send_to_shader or {}
        self.ARGS.send_to_shader[1] = math.min(self.VT.r*3, 1) + math.sin(G.TIMERS.REAL/28) + 1 + (self.juice and self.juice.r*20 or 0) + self.tilt_var.amt
        self.ARGS.send_to_shader[2] = G.TIMERS.REAL

        for _, v in pairs(self.children) do
            v.VT.scale = self.VT.scale
        end

        local scale_mod = 0.07 + 0.02*math.sin(1.8*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
        local rotate_mod = 0.05*math.sin(1.219*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2

        local stand_scale_mod = 0
        G.SHADERS['fnwk_stand_notorious']:send("scale_mod",scale_mod)
        G.SHADERS['fnwk_stand_notorious']:send("rotate_mod",rotate_mod)
        G.SHADERS['fnwk_stand_notorious']:send("output_scale",1+stand_scale_mod)

        if not self.no_shadow and G.SETTINGS.GRAPHICS.shadows == 'On' and self:should_draw_shadow() then
            self.shadow_height = self.states.drag.is and 0.35 or 0.1
            
            if self.sprite_facing == 'front' then
                self.children.noto_layer:draw_shader('fnwk_stand_notorious', self.shadow_height)
            else 
                self.children.back:draw_shader('dissolve', self.shadow_height)
            end
        end
    end,
}, true)

-- prevent late drawing centers from drawing twice
SMODS.DrawStep:take_ownership('center', {
    func = function(self, layer)
        --Draw the main part of the card
        if (self.edition and self.edition.negative and not self.delay_edition) or (self.ability.name == 'Antimatter' and (self.config.center.discovered or self.bypass_discovery_center)) then
            self.children.center:draw_shader('negative', nil, self.ARGS.send_to_shader)
        elseif not self:should_draw_base_shader() then
            -- Don't render base dissolve shader.
        elseif self.config.center.key == 'c_fnwk_streetlight_notorious' and self.children.noto_layer then
            self.children.noto_layer:draw_shader('fnwk_stand_notorious', nil, nil, nil, self.children.center)
        elseif self.config.center.key == 'c_fnwk_bluebolt_insane' then
            local hue_mod = math.rad(G.TIMERS.REAL % 1 * 360)
            G.SHADERS['fnwk_stand_insane']:send('hue_mod', hue_mod)
            self.children.center:draw_shader('fnwk_stand_insane')
        elseif not self.greyed then
            self.children.center:draw_shader('dissolve')
        end

         --If the card is not yet discovered
        if not self.config.center.discovered and (self.ability.consumeable or self.config.center.unlocked) and not self.config.center.demo and not self.bypass_discovery_center then
            local shared_sprite = (self.ability.set == 'Edition' or self.ability.set == 'Joker') and G.shared_undiscovered_joker or G.shared_undiscovered_tarot
            local scale_mod = -0.05 + 0.05*math.sin(1.8*G.TIMERS.REAL)
            local rotate_mod = 0.03*math.sin(1.219*G.TIMERS.REAL)

            shared_sprite.role.draw_major = self
            if (self.config.center.undiscovered and not self.config.center.undiscovered.no_overlay) or not( SMODS.UndiscoveredSprites[self.ability.set] and SMODS.UndiscoveredSprites[self.ability.set].no_overlay) then 
                shared_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod)
            else
                if SMODS.UndiscoveredSprites[self.ability.set] and SMODS.UndiscoveredSprites[self.ability.set].overlay_sprite then
                    SMODS.UndiscoveredSprites[self.ability.set].overlay_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                end
            end
        end

        if self.ability.name == 'Invisible Joker' and (self.config.center.discovered or self.bypass_discovery_center) then
            if self:should_draw_base_shader() then
                self.children.center:draw_shader('voucher', nil, self.ARGS.send_to_shader)
            end
        end

        if self.late_center_draw then
            return
        end

        local center = self.config.center
        if center.draw and type(center.draw) == 'function' then
            center:draw(self, layer)
        end
    end,
})

SMODS.DrawStep {
    key = 'late_center_draw',
    order = 22,
    func = function(self, layer)
        if not self.late_center_draw then
            return
        end

        local center = self.config.center
        if center.draw and type(center.draw) == 'function' then
            center:draw(self, layer)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

local old_seal_ds = SMODS.DrawSteps.seal.func
SMODS.DrawStep:take_ownership('seal', {
    func = function(self, layer)
        if self.delay_seal then return end

        return old_seal_ds(self, layer)
    end
}, true)

---[[
local disturb_corners = {
    top_left = {0.0, 0.37},
    top_right = {0.704, 0.37},
    bottom_left = {0.0, 1.075},
    bottom_right = {0.704, 1.075}
}
---]]

if not SMODS.DrawSteps.arrow_stand_mask then return end
local old_stand_ds = SMODS.DrawSteps.arrow_stand_mask.func
SMODS.DrawStep:take_ownership('arrow_stand_mask', {
    func = function(self, layer)
        local key = self.config.center.key
        if key == 'c_fnwk_streetlight_notorious' then return end

        if key ~= 'c_fnwk_bone_king_farewell'
        and (key ~= 'c_fnwk_streetlight_disturbia' or not self.ability.fnwk_disturbia_fake) then           
            return old_stand_ds(self, layer)
        end

        if self.config.center.discovered or self.bypass_discovery_center then
            local scale_mod = 0.07 + 0.02*math.sin(1.8*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod = 0.05*math.sin(1.219*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2

            if key == 'c_fnwk_bone_king_farewell' then
                G.SHADERS['arrow_stand_mask']:send("scale_mod",scale_mod)
                G.SHADERS['arrow_stand_mask']:send("rotate_mod",rotate_mod)
                G.SHADERS['arrow_stand_mask']:send("output_scale", 1)
                G.SHADERS['arrow_stand_mask']:send("vertex_scale_mod", self.config.center.config.vertex_scale_mod or 1.0)
                
                self.children.floating_sprite:draw_shader('arrow_stand_mask')
            elseif self.ability.fnwk_disturbia_fake then
                local fake = self.ability.fnwk_disturbia_fake
                G.SHADERS['fnwk_stand_disturbia']:send("scale_mod",scale_mod)
                G.SHADERS['fnwk_stand_disturbia']:send("rotate_mod",rotate_mod)
                G.SHADERS['fnwk_stand_disturbia']:send("output_scale", 1)
                -- set perspective transform vals
                for k, v in pairs(disturb_corners) do
                    G.SHADERS['fnwk_stand_disturbia']:send(k, v)
                end
                G.SHADERS['fnwk_stand_disturbia']:send("base_image", G.ASSET_ATLAS[fake.config.center.atlas or 'Joker'].image)
                G.SHADERS['fnwk_stand_disturbia']:send("base_texture_details", fake.children.center:get_pos_pixel())
                G.SHADERS['fnwk_stand_disturbia']:send("base_image_details", fake.children.center:get_image_dims())

                self.children.floating_sprite:draw_shader('fnwk_stand_disturbia', nil, nil, nil, self.children.center)
            end

            if self.edition then
                for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                    if v.apply_to_float then
                        if self.edition[v.key:sub(3)] then
                            self.children.floating_sprite:draw_shader(v.shader, nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                        end
                    end
                end
            end
        end
    end,
}, true)