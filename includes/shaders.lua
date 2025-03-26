SMODS.Shader({ key = 'basic', path = 'basic.fs' })
SMODS.Shader({ key = 'glow', path = 'glow.fs' })
SMODS.Shader({ key = 'neon_flash', path = 'neon_flash.fs' })
SMODS.Atlas({ key = "screen", path = "screen.png", px = 1920, py = 1080})
SMODS.Shader({ key = 'water_mask', path = 'water.fs' })
SMODS.Shader({ key = 'bloom', path = 'bloom.fs' })
SMODS.Shader({ key = 'boney_bottom', path = 'boney_bottom.fs' })
SMODS.Shader({ key = 'boney_top', path = 'boney_top.fs' })
SMODS.Shader({ key = 'speed_lines', path = 'speed_lines.fs' })

SMODS.Shader({
    key = 'holo',
    path = 'mod_holo.fs',
    prefix_config = false
})

SMODS.Shader({
    key = 'polychrome',
    path = 'mod_polychrome.fs',
    prefix_config = false
})

SMODS.Shader({
    key = 'negative',
    path = 'mod_negative.fs',
    prefix_config = false
})


SMODS.DrawStep {
    key = 'revived',
    order = 11,
    func = function(self)
        if self.ability.make_vortex and (self.config.center.discovered or self.bypass_discovery_center) then
            self.children.center:draw_shader('booster', nil, self.ARGS.send_to_shader)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.DrawStep {
    key = 'water_shader',
    order = 11,
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
    order = 11,
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
