local jokerInfo = {
    key = 'j_fnwk_lighted_square',
	name = 'Square Biz Killer',
	config = {
        extra = {
            hand_size = 5,
        },
    },
	rarity = 2,
	cost = 8,
    unlocked = false,
    unlock_condition = {type = 'run_shattered', total = 4},
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'lighted'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "fnwk_artist_1", set = "Other", vars = { G.fnwk_credits.gote }}
    return { vars = { card.ability.extra.hand_size }}
end

function jokerInfo.locked_loc_vars(self, info_queue, card)
    return { vars = { self.unlock_condition.total }}
end

function jokerInfo.check_for_unlock(self, args)
    if args.type ~= self.unlock_condition.type then return false end

    return args.total_shattered >= self.unlock_condition.total
end

function jokerInfo.calculate(self, card, context)

    if context.blueprint then
        return
    end
    
    if context.destroy_card and not card.debuff and #context.scoring_hand == card.ability.extra.hand_size then
        local destroy = context.scoring_hand[#context.scoring_hand]
        if context.destroy_card ~= destroy then
            return
        end

        return {
            delay = 0.45, 
            remove = true,
        }
    end
end

return jokerInfo