local achInfo = {
    rarity = 3,
    config = {key = 'j_fnwk_gotequest_pair', hits = 2},
    origin = {
		category = 'fanworks',
		sub_origins = {
			'gotequest',
		},
        custom_color = 'gotequest',
    },
}

function achInfo.loc_vars(self)
    return {
        vars = {
            G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '?????',
            self.config.hits
        }
    }
end


function achInfo.unlock_condition(self, args)
    if args.type == 'fnwk_pair_activate' then
        G.GAME.fnwk_pair_consec_hits = (G.GAME.fnwk_pair_consec_hits or 0) + 1
        if G.GAME.fnwk_pair_consec_hits >= self.config.hits then
            return true
        end
    end

    if args.type == 'round_win' then
        G.GAME.fnwk_pair_consec_hits = nil
    end
end

return achInfo