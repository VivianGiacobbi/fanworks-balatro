---------------------------
--------------------------- gpu proxy + current chips from available jokers
---------------------------

local ref_game_update = Game.update
function Game:update(dt)
    local ret = ref_game_update(self, dt)

    if G.GAME.gpu_usage then
        G.GAME.gpu_usage_real = math.min(0.92, math.max(0.1, G.GAME.gpu_usage + (math.random() * 2 - 1) * 0.0009))
        G.GAME.gpu_update_timer = G.GAME.gpu_update_timer + G.real_dt
        if G.GAME.gpu_update_timer > G.GAME.gpu_update_time then
            G.GAME.gpu_usage = G.GAME.gpu_usage_real
            G.GAME.gpu_update_timer = 0
        end
    end

    return ret
end

local function get_gpu_chips()
    local chips = 0
    local gpus = SMODS.find_card('j_fnwk_gpu_joker')
    for _, v in ipairs(gpus) do
        if not v.debuff then
            chips = chips + math.ceil(v.ability.extra.chip_mod * (G.GAME.gpu_usage or 0))
        end
    end

    return chips
end

local ref_card_bonus = Card.get_chip_bonus
function Card:get_chip_bonus()
    local ret = ref_card_bonus(self)

    -- exclude circumstances where nominal chips are not counted
    if not self.ability.extra_enhancement and not (self.ability.effect == 'Stone Card' or self.config.center.replace_base_card) then
        ret = ret + get_gpu_chips()
    end

    return ret
end





---------------------------
--------------------------- custom loc behavior to display applicable GPU chips
---------------------------

local ref_localize = localize
function localize(args, misc_cat)
	if type(args) == 'table' and args.type == 'other' and args.key == 'card_chips' then
        local gpu_chips = get_gpu_chips()
        if gpu_chips > 0 then
            args.key = 'fnwk_card_chips_gpu'
            args.vars[2] = gpu_chips
        end
	end

	return ref_localize(args, misc_cat)
end

G.localization.descriptions.Other.fnwk_card_chips_gpu = {
    text = {
        "{C:chips}+#1#{} {C:dark_edition}(+#2#){} Chips",
    },
}





---------------------------
--------------------------- GPU chip rendering
---------------------------

G.shared_ui_icons = {}
for _, suit in pairs(SMODS.Suits) do
    local atlas = G.ASSET_ATLAS[suit[(G.SETTINGS.colourblind_option and 'hc' or 'lc')..'_ui_atlas']]
    local w_scale = atlas.px / 71 * 0.75
    local h_scale = atlas.py / 95 * 0.75
    G.shared_ui_icons[suit.key] = Sprite(0, 0, G.CARD_W * w_scale, G.CARD_H * h_scale, atlas, suit.ui_pos)
end

local ref_refresh_contrast = G.FUNCS.refresh_contrast_mode
G.FUNCS.refresh_contrast_mode = function()
    local ret = ref_refresh_contrast()
    for k, v in ipairs(G.shared_ui_icons) do
        v.atlas = SMODS.Suits[k][(G.SETTINGS.colourblind_option and 'hc' or 'lc')..'_ui_atlas']
        v:reset()
    end
    return ret
end

SMODS.DrawStep {
    key = 'gpu_front',
    order = 21,
    func = function(self, layer)
        if not self.children.front or not self:should_draw_base_shader() or self.greyed then return end

        local gpu_chips = get_gpu_chips()
        if gpu_chips <= 0 then return end

        if self.ability.delayed or (self.ability.effect ~= 'Stone Card' and not self.config.center.replace_base_card) then
            local icon = G.shared_ui_icons[self.base.suit]
            icon.role.draw_major = self
            local game_seed = G.GAME.pseudorandom.seed or ''
            local hashed_seed = G.GAME.pseudorandom.hashed_seed or 0
            local rot_seed = (pseudohash(self.base.suit..'_rot'..game_seed) + hashed_seed)/2
            local x_seed = (pseudohash(self.base.suit..'_xoff'..game_seed) + hashed_seed)/2
            local y_seed = (pseudohash(self.base.suit..'_yoff'..game_seed) + hashed_seed)/2

            local rots = {}
            math.randomseed(rot_seed)
            for i=1, gpu_chips do
                rots[i] = 0--2 * math.pi * math.random()
            end

            local half_width = self.T.w / 2
            local x_offsets = {}
            math.randomseed(x_seed)
            for i=1, gpu_chips do
                x_offsets[i] = half_width * (math.random() * 2 - 1) * 0.65 + half_width
            end

            local half_height = self.T.w / 2
            local y_offsets = {}
            math.randomseed(y_seed)
            for i=1, gpu_chips do
                y_offsets[i] = half_height * (math.random() * 2 - 1) * 0.65 + half_height
            end

            icon.T.x = self.T.xs
            icon.VT.x = icon.T.x

            icon.T.y = self.T.y
            icon.VT.y = icon.T.y

            icon.T.r = self.T.r
            icon.VT.r = icon.T.r

            for i=1, gpu_chips do
                icon:draw_shader('dissolve', nil, nil, nil, self.children.front, -0.25, rots[i], x_offsets[i], y_offsets[i])
            end
            
        end
    end,
    conditions = { vortex = false, facing = 'front', front_hidden = false },
}





---------------------------
--------------------------- joker implementation
---------------------------

SMODS.Joker({
    key = 'gpu_joker',
    --atlas = 'Joker',
    --pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    config = {
        extra = {
            chip_mod = 20
        }
    },
    loc_txt = {
        ['en-us'] = {
            name = 'GPU Joker',
            text = {
                "Each {C:attention}scoring{} card gives an",
                "additional {C:chips}+#1#{} Chips times the",
                "{C:attention}percentage of your GPU in use{}",
                "{C:inactive}(Currently{} {C:chips}+#2#{} {C:inactive}[{}{C:attention}#3#%{}{C:inactive}] Chips){}"
            },
        },
    },
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chip_mod,
                string.gsub(''..(math.ceil((G.GAME.gpu_usage or 0) * card.ability.extra.chip_mod)), "%.", ""),
                string.gsub(''..(math.ceil((G.GAME.gpu_usage or 0) * 100)), "%.", "")
            }
        }
    end,
})