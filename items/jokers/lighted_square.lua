local jokerInfo = {
	name = 'Square Biz Killer',
	config = {
        extra = {
            hand_size = 5,
        },
    },
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = true,
	perishable = true,
	fanwork = 'lighted'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
    return { vars = {card.ability.extra.hand_size}}
end

function jokerInfo.calculate(self, card, context)

    if context.blueprint then
        return
    end
    
    if context.destroy_card and not card.debuff and #context.full_hand == card.ability.extra.hand_size then
        local destroy = context.full_hand[#context.full_hand]
        if context.cardarea == G.play then
            if context.destroy_card ~= destroy then
                return
            end
            
            return {
                delay = 0.45, 
                remove = true,
            }
        elseif context.cardarea == 'unscored' then
            if context.destroy_card ~= destroy then
                return
            end           

            return {
                delay = 0.45, 
                remove = true,
            }
        end        
    end
end

return jokerInfo