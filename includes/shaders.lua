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

SMODS.Atlas({ key = "test_chip", path = "test_chip.png", px = 34, py = 34})
SMODS.Shader({ key = 'rotten_graft', path = 'rotten_graft.fs'})

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

-- prevent late drawing centers from drawing twice
SMODS.DrawStep:take_ownership('center', {
    func = function(self, layer)
        --Draw the main part of the card
        if (self.edition and self.edition.negative and not self.delay_edition) or (self.ability.name == 'Antimatter' and (self.config.center.discovered or self.bypass_discovery_center)) then
            self.children.center:draw_shader('negative', nil, self.ARGS.send_to_shader)
        elseif not self:should_draw_base_shader() then
            -- Don't render base dissolve shader.
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