local jokerInfo = {
	name = 'Investigative Jokestar',
	config = {
		extra = {
			mult = 20,
			chips = 100
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable = true,
	fanwork = 'stalk'
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artist_gote", set = "Other"}
	return { vars = {card.ability.extra.mult, card.ability.extra.chips}}
end

local function check_secret(name)
	for i, k in ipairs(G.fnwk_secret_hands) do
		if k == name then
			return true
		end
	end
end

local function hasPlayedSecret()
	for k, v in ipairs(G.handlist) do
		if G.GAME.hands[v].visible and check_secret(k) then
			return true
		end
	end
end

function jokerInfo.in_pool(self, args)
	if hasPlayedSecret() then
		return true
	end
end

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	G.fnwk_secret_hands = {}
	for k, v in pairs(SMODS.PokerHands) do
		if not v.visible then
			G.fnwk_secret_hands[#G.fnwk_secret_hands + 1] = k
		end
	end
	return ret
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers and not card.debuff then
		local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(context.scoring_hand)
		if check_secret(text) then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.mult,
				card = card
			}
		end
	end
end

return jokerInfo