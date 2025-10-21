local achInfo = {
    rarity = 3,
    config = {
        voucher = 'v_fnwk_streetlight_binding',
        require_keys = {
            j_fnwk_bluebolt_sexy = true,
            j_fnwk_bluebolt_tuned = true,
            j_fnwk_bluebolt_jokestar = true,
            j_fnwk_bluebolt_impaired = true,
            j_fnwk_bluebolt_secluded = true,
        }
    },
    origin = {
		category = 'fanworks',
		sub_origins = {
			'bluebolt',
		},
        custom_color = 'bluebolt',
    },
}

function achInfo.loc_vars(self)
    return { vars = { localize{type = 'name_text', set = 'Voucher', key = self.config.voucher}}}
end

function achInfo.unlock_condition(self, args)
    if args.type ~= 'fnwk_binding_band' then return false end

    local jokers_map = copy_table(self.config.require_keys)
    for _, v in ipairs(G.jokers.cards) do
        if jokers_map[v.config.center.key] then
            jokers_map[v.config.center.key] = nil
        end
    end

    return not next(jokers_map)
end

return achInfo