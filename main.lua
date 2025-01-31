--- STEAMODDED HEADER
--- MOD_NAME: Fanworks
--- MOD_ID: Fanworks
--- MOD_AUTHOR: [BarrierTrio/Gote & TheWinterComet]
--- MOD_DESCRIPTION: A mod inspired by the JoJo's Bizarre Fanworks Discord Server!
--- BADGE_COLOUR: 32A852
--- DISPLAY_NAME: Fanworks
--- PREFIX: fnwk
--- VERSION: 1.3.2
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-1317a]

local mod_path = SMODS.current_mod.path
local usable_path = mod_path:match("Mods/[^/]+")
local path_pattern_replace = usable_path:gsub("(%W)","%%%1")  -- shoot me in the foot, why doesn't lua just have a str.replace
fnwk_config = SMODS.current_mod.config
fnwk_enabled = copy_table(fnwk_config)

local hook_list = {
	"card",
	"UI_definitions",
}

function recursiveEnumerate(folder)
	local fileTree = ""
	for _, file in ipairs(love.filesystem.getDirectoryItems(folder)) do
		local path = folder .. "/" .. file
		local info = love.filesystem.getInfo(path)
		fileTree = fileTree .. "\n" .. path .. (info.type == "directory" and " (DIR)" or "")
		if info.type == "directory" then
			fileTree = fileTree .. recursiveEnumerate(path)
		end
	end
	return fileTree
end

local skin_files = {}
for s in recursiveEnumerate(usable_path .. "/assets/1x/skins/"):gmatch("[^\r\n]+") do
	skin_files[#skin_files + 1] = s:gsub(path_pattern_replace .. "/assets/1x/skins/", "")
end

local deck_skins = {}
for _, file in ipairs(skin_files) do
	deck_skins[#deck_skins + 1] = file:sub(2, -5)
end

local collab_files = {}
for s in recursiveEnumerate(usable_path .. "/assets/1x/collabs/"):gmatch("[^\r\n]+") do
	if s:match("%.png$") then
		collab_files[#collab_files + 1] = s:gsub(path_pattern_replace .. "/assets/1x/collabs/", "")
	end
end

local collab_skins = {}
for _, file in ipairs(collab_files) do
	collab_skins[#collab_skins + 1] = file:sub(2, -5)
end

for _, hook in ipairs(hook_list) do
	local init, error = NFS.load(SMODS.current_mod.path .. "hooks/" .. hook ..".lua")
	if error then sendErrorMessage("[Fanworks] Failed to load "..hook.." with error "..error) else
		local data = init()
		sendDebugMessage("[Fanworks] Loaded hook: " .. hook)
	end
end

local conf_fanworks = {
	jokersToLoad = {
		-- Common
		'twoface',
		'newjoker',
		'depressedbrother',
		'pivot',
		'fisheye',
		'diaper',
		'speen',
		'pacman',
		'besomeone',
		'disguy',
		'roche',
		'reyn',
		'emmanuel',
		'gnorts',
		'chad',

		'purple',
		'garbagehand',
		-- Uncommon
		'meat',
		'greyjoker',
		'veryexpensivejoker',
		'roger',
		'cousinsclub',
		'anotherlight',
		'sohappy',
		'code',
		'werewolves',
		'maskedjoker',
		'dontmind',
		'kerosene',
		'businesstrading',

		'red',
		'fate',
		'miracle',
		'chromedup',
		-- Rare
		'thisiscrack',
		'deathcard',
		'hell',
		'odio',
		-- Common (Locked)
		'speedjoker',
		'disturbedjoker',

		-- Uncommon (Locked)
		'shrimp',
		'muppet',
		-- Rare (Locked)
		'charity',
		'supper',
		'pepsecret',

		'greenneedle',
		'wingsoftime',
		'kings',
		-- Legendary
		'vincenzo',
		'quarterdumb',

		-- Update 1.2
		'fantabulous',
		'grand',
		'ten',
		'beginners',
		'joeycastle',
		'voice',
		'rotten',
		'rapture',
		'villains',
		'killjester',

		-- Update 1.3
		'crudeoil',
		'grannycream',
		'bjbros',
		'koffing',
		'drippy',
		'sts',
		'meteor',
		'dud',
		'frich',
		'bunji',
		'tetris',

		-- fanworks
		'streetlit_resil',
		'theaquarium',
	},
	consumablesToLoad = {
		--Spectral
		'quixotic',
		'protojoker',
	},
	vhsToLoad = {
	},
	standsToLoad = {
	},
	packsToLoad = {
	},
	decksToLoad = {
		'vine',
	},
	challengesToLoad = {
		'tucker',
	},
	blindsToLoad = {
		'hog',
		'tray',
		'vod',
		'finger',
		'mochamike',
	},
	trophiesToLoad = {}
}

local twoPointO = false

if twoPointO then
	conf_fanworks.vhsToLoad = {
		'blackspine',
		'doubledown',
		'topslots',
		'donbeveridge',
		'tbone',
	}
	conf_fanworks.standsToLoad = {
		'moodyblues',
		'tohth',
	}
	conf_fanworks.consumablesToLoad[#conf_fanworks.consumablesToLoad+1] = 'arrow'
	conf_fanworks.jokersToLoad[#conf_fanworks.jokersToLoad+1] = 'tetris'
	conf_fanworks.decksToLoad[#conf_fanworks.decksToLoad+1] = 'wheel'
	conf_fanworks.packsToLoad = {
		'analog1',
		'analog2',
		'analog3',
		'analog4',
	}
end

local start = Game.start_run
function Game:start_run(args)
	start(self, args)
	if G.GAME.selected_back.effect.center.key == "b_fnwk_disc" then
		G.GAME.unlimited_stands = true
	end
	G.GAME.max_stands = G.GAME.modifiers.max_stands or 1
end

G.foodjokers = {
	'j_gros_michel',
	'j_ice_cream',
	'j_cavendish',
	'j_turtle_bean',
	'j_popcorn',
	'j_ramen',
	'j_selzer',
	'j_diet_cola',
	'j_fnwk_meat',
	'j_fnwk_fantabulous',
	'j_fnwk_crudeoil',
	'j_fnwk_grannycream',
}

function G.FUNCS.is_food(key)
	for i, k in ipairs(G.foodjokers) do
		if k == key then
			return true
		end
	end
	return false
end

G.loadTrophies = true
if fnwk_enabled['enableTrophies'] then
	for s in recursiveEnumerate(usable_path .. "/achievements/"):gmatch("[^\r\n]+") do
		conf_fanworks.trophiesToLoad[#conf_fanworks.trophiesToLoad + 1] = s:gsub(path_pattern_replace .. "/achievements/", "")
	end
else
	G.loadTrophies = false
end

-- Talisman compat
to_big = to_big or function(num)
	return num
end

-- unused
function getCardPosition(card)
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i] == card then
			return i
		end
	end
	return nil
end

function containsKey(table, key)
	return table[key] ~= nil
end

function starts_with(str, start)
	return string.sub(str, 1, #start) == start
end

function ends_with(str, ending)
	return string.sub(str, -#ending) == ending
end

function send(message, level)
	level = level or 'debug'
	if level == 'debug' then
		if type(message) == 'table' then
			sendDebugMessage(tprint(message))
		else
			sendDebugMessage(message)
		end
	elseif level == 'info' then
		if type(message) == 'table' then
			sendInfoMessage(tprint(message))
		else
			sendInfoMessage(message)
		end
	elseif level == 'error' then
		if type(message) == 'table' then
			sendErrorMessage(tprint(message))
		else
			sendErrorMessage(message)
		end
	end
end

function containsString(str, substring)
	local lowerStr = string.lower(str)
	local lowerSubstring = string.lower(substring)
	return string.find(lowerStr, lowerSubstring, 1, true) ~= nil
end

function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

local draw_from_deck_to_handref = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS.draw_from_deck_to_hand(self, e)
	draw_from_deck_to_handref(self, e)
	if G.GAME.fnwk_dj_drawextra then
		draw_card(G.deck, G.hand, 100, 'up', true)
		G.GAME.fnwk_dj_drawextra = false
	end
	if G.GAME.fnwk_sj_drawextra then
		draw_card(G.deck, G.hand, 100, 'up', true)
		G.GAME.fnwk_sj_drawextra = false
	end
	if G.GAME.fnwk_stss_drawthreeextra and G.GAME.fnwk_stss_drawthreeextra > 0 then
		for i = 1, G.GAME.fnwk_stss_drawthreeextra do
			for i = 1, 3 do
				draw_card(G.deck, G.hand, 100, 'up', true)
			end
			G.GAME.fnwk_stss_drawthreeextra = G.GAME.fnwk_stss_drawthreeextra - 1
		end
	end
end

function SMODS.current_mod.reset_game_globals(run_start)
	G.GAME.current_round.choicevoice = { suit = 'Clubs' }
	local valid_choicevoice_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then
			valid_choicevoice_cards[#valid_choicevoice_cards+1] = v
		end
	end
	if valid_choicevoice_cards[1] then
		local randCard = pseudorandom_element(valid_choicevoice_cards, pseudoseed('marrriooOOO'..G.GAME.round_resets.ante))
		G.GAME.current_round.choicevoice.suit = randCard.base.suit
		G.GAME.current_round.choicevoice.rank = randCard.base.value
		G.GAME.current_round.choicevoice.id = randCard.base.id
	end
	G.GAME.current_round.joeycastle = { suit = 'Clubs' }
	local valid_joeycastle_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then
			valid_joeycastle_cards[#valid_joeycastle_cards+1] = v
		end
	end
	if valid_joeycastle_cards[1] then
		local randCard = pseudorandom_element(valid_joeycastle_cards, pseudoseed('fent'..G.GAME.round_resets.ante))
		G.GAME.current_round.joeycastle.suit = randCard.base.suit
	end
end

local get_straight_ref = get_straight
function get_straight(hand)
	local base = get_straight_ref(hand)
	local results = {}
	local vals = {}
	local verified = {}
	local can_loop = next(find_joker('Rekoj Gnorts'))
	local target = next(find_joker('Four Fingers')) and 4 or 5
	local skip_var = next(find_joker('Shortcut'))
	local skipped = false
	if not(can_loop) or #hand < target then
		G.GAME.gnortstraight = false
		return base
	else
		local hand_ref = {}
		for k, v in pairs(hand) do
			table.insert(hand_ref, v)
		end
		table.sort(hand_ref, function(a,b) return a:get_id() < b:get_id() end)
		local ranks = {}
		local _next = nil
		local val = 0
		for k, v in pairs(G.P_CARDS) do
			if (ranks[v.pos.x+1] == nil) then
				ranks[v.pos.x+1] = v.value
			end
		end
		while val < #hand_ref*2 do
			local i = val%#hand_ref + 1
			local id = hand_ref[i]:get_id()-1
			val = val + 1
			if _next == nil then
				table.insert(results,hand_ref[i])
				_next = ranks[id%#ranks+1]
				skipped = false
			else
				if (ranks[id] == _next) then

					table.insert(results,hand_ref[i])
					_next = ranks[id%#ranks+1]
					skipped = false
				elseif skip_var and not skipped then
					_next = ranks[id%#ranks+1]
					skipped = true
				else
					_next = nil
					val = val-1
					results = {}
					skipped = false
				end
			end
			if (#results == target) then
				table.sort(hand, function(a,b) return a.T.x < b.T.x end)
				table.sort(results, function(a,b) return a.T.x < b.T.x end)
				return {results}
			elseif _next ~= nil then

			end
		end
	end

	return {}
end

local G_FUNCS_can_buy_and_use_ref=G.FUNCS.can_buy_and_use
G.FUNCS.can_buy_and_use = function(e)
	G_FUNCS_can_buy_and_use_ref(e)
	if e.config.ref_table.ability.set=='VHS' then
		e.UIBox.states.visible = false
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

-- Modified Code from Malverk
local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	if card.ability.set == "VHS" then
		if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then --Add a use button
			local use
			local spacer = {n=G.UIT.R, config={minh = 0.8}}
			local pull = {n=G.UIT.R, config={minh = 0.55}}
			use = {n=G.UIT.R, config={align = 'cm'}, nodes={
				{n=G.UIT.C, config={align = "cm"}, nodes={
					{n=G.UIT.C, config={align = "bm", maxw = G.CARD_W * 0.65, shadow = true, padding = 0.1, r=0.08, minw = 0.5 * G.CARD_W, minh = 0.8, hover = true, colour = G.C.RED, button = "use_card", func = "can_reserve_card", ref_table = card, activate = true}, nodes={
						{n=G.UIT.T, config={text = localize('b_activate'), colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
					}}
				}}
			}}
			if not card.config.center.unpausable then
				pull = {n=G.UIT.R, config={align = 'cr', minw = 1.7*G.CARD_W}, nodes={
					{n=G.UIT.R, config={minh = 0.65}},
					{n=G.UIT.R, nodes = {
						{n=G.UIT.C, config={minw = G.CARD_W, minh = 0.8, colour = G.C.IMPORTANT, r = 0.1, align = 'cr', shadow = true, padding = 0.1, hover = true, button = "use_card", func = "can_reserve_card", ref_table = card, pull = true}, nodes = {
							{n=G.UIT.T, config={text = localize('b_pull'), colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
						}}
					}}
				}}
			end
			spacer = {n=G.UIT.R, config={minh = 0.7}}
			local t = {n=G.UIT.ROOT, config = {align = 'cm', padding = 0, colour = G.C.CLEAR}, nodes={
				{n=G.UIT.C, config={align = 'cm'}, nodes={
					pull,
					spacer,
					use
				}},
			}}
			return t
		end
	end
	return G_UIDEF_use_and_sell_buttons_ref(card)
end

--Modified Code from Betmma's Vouchers
G.FUNCS.can_reserve_card = function(e)
	if #G.consumeables.cards < G.consumeables.config.card_limit then
		if not e.config.colour == G.C.IMPORTANT then
			e.config.colour = G.C.RED
		end
		if (e.config.ref_table.config.center.activation and e.config.activate) or e.config.pull then
			e.config.button = "reserve_card"
		else
			e.config.button = "use_card"
		end
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end
G.FUNCS.reserve_card = function(e)
	local c1 = e.config.ref_table
	if e.config.activate then
		G.FUNCS.tape_activate(c1)
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.1,
		func = function()
			c1.area:remove_card(c1)
			c1:add_to_deck()
			if c1.children.price then
				c1.children.price:remove()
			end
			c1.children.price = nil
			if c1.children.buy_button then
				c1.children.buy_button:remove()
			end
			c1.children.buy_button = nil
			remove_nils(c1.children)
			G.consumeables:emplace(c1)
			G.GAME.pack_choices = G.GAME.pack_choices - 1
			if G.GAME.pack_choices <= 0 then
				G.FUNCS.end_consumeable(nil, delay_fac)
			end
			return true
		end,
	}))
end

SMODS.Atlas({ key = 'fnwk_undiscovered', path ="undiscovered.png", px = 71, py = 95 })

if twoPointO and #conf_fanworks.vhsToLoad > 0 then
	G.C.VHS = HEX('a2615e')

	SMODS.ConsumableType{
		key = "VHS",
		primary_colour = G.C.VHS,
		secondary_colour = G.C.VHS,
		collection_rows = { 8, 8 },
		shop_rate = 1,
		loc_txt = {},
		default = "c_fnwk_blackspine",
		can_stack = false,
		can_divide = false,
	}

	SMODS.UndiscoveredSprite{
		key = "VHS",
		atlas = "fnwk_undiscovered",
		pos = { x = 0, y = 0 }
	}

	G.FUNCS.tape_activate = function(card)
		if not card.config.center.activation then return end
		if card.ability.activated then
			card.ability.activated = false
			play_sound('fnwk_vhsclose', 0.9 + math.random()*0.1, 0.4)
		else
			card.ability.tape_move = 9
			card.ability.sleeve_move = -9
			card.ability.activated = true
			play_sound('fnwk_vhsopen', 0.9 + math.random()*0.1, 0.4)
		end
	end

	G.FUNCS.destroy_tape = function(card, delay, ach, silent)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = delay,
			func = function()
				if not silent then
					play_sound('tarot1')
				end
				card.T.r = -0.2
				card:juice_up(0.3, 0.4)
				card.states.drag.is = true
				card.children.center.pinch.x = true
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
											 func = function()
												 G.consumeables:remove_card(card)
												 card:remove()
												 card = nil
												 return true
											 end
				}))
				if ach then
					check_for_unlock({ type = ach })
				end
				return true
			end
		}))
	end
end

if twoPointO and #conf_fanworks.standsToLoad > 0 then
	G.C.Stand = HEX('b85f8e')
	SMODS.ConsumableType{
		key = "Stand",
		primary_colour = G.C.Stand,
		secondary_colour = G.C.Stand,
		collection_rows = { 8, 8 },
		shop_rate = 0,
		loc_txt = {},
		default = "c_fnwk_blackspine",
		can_stack = false,
		can_divide = false,
	}

	SMODS.UndiscoveredSprite{
		key = "Stand",
		atlas = "fnwk_undiscovered",
		pos = { x = 0, y = 0 }
	}
end

-- Load Jokers
for i, v in ipairs(conf_fanworks.jokersToLoad) do
	local jokerInfo = assert(SMODS.load_file("jokers/" .. v .. ".lua"))()
	local enabled = false
	if jokerInfo.streamer then
		if ((jokerInfo.streamer == 'vinny' or 'othervinny') and fnwk_enabled['enableVinkers'])
				or (jokerInfo.streamer == 'joel' and fnwk_enabled['enableJoelkers'])
				or ((jokerInfo.streamer == 'other' or 'othervinny') and fnwk_enabled['enableOtherJokers']) then
			enabled = true
		end
	end
	if enabled then
		jokerInfo.key = v
		jokerInfo.atlas = v
		local atlasKey = v
		if jokerInfo.texture then
			atlasKey = jokerInfo.texture
			jokerInfo.atlas = jokerInfo.texture
		end
		jokerInfo.pos = { x = 0, y = 0 }
		if jokerInfo.hasSoul then
			jokerInfo.pos = { x = 1, y = 0 }
			jokerInfo.soul_pos = { x = 2, y = 0 }
		end

		local joker = SMODS.Joker(jokerInfo)
		for k_, v_ in pairs(joker) do
			if type(v_) == 'function' then
				joker[k_] = jokerInfo[k_]
			end
		end

		SMODS.Atlas({ key = atlasKey, path ="jokers/" .. atlasKey .. ".png", px = jokerInfo.width or 71, py = jokerInfo.height or  95 })
	end
end

local loadConsumable = function(v)
	local consumInfo = assert(SMODS.load_file("consumables/" .. v .. ".lua"))()

	if (consumInfo.set == "Spectral" and fnwk_enabled['enableSpectrals']) or (consumInfo.set == "VHS") or (consumInfo.set == "Stand") or (consumInfo.set == "Tarot") then
		consumInfo.key = consumInfo.key or v
		consumInfo.atlas = v

		consumInfo.pos = { x = 0, y = 0 }
		if consumInfo.hasSoul then
			consumInfo.pos = { x = 1, y = 0 }
			consumInfo.soul_pos = { x = 2, y = 0 }
		end

		local consum = SMODS.Consumable(consumInfo)
		for k_, v_ in pairs(consum) do
			if type(v_) == 'function' then
				consum[k_] = consumInfo[k_]
			end
		end

		SMODS.Atlas({ key = v, path ="consumables/" .. v .. ".png", px = consum.width or 71, py = consum.height or  95 })
	end
end

-- Load Consumables
for i, v in ipairs(conf_fanworks.consumablesToLoad) do
	loadConsumable(v)
end
for i, v in ipairs(conf_fanworks.vhsToLoad) do
	loadConsumable(v)
end
for i, v in ipairs(conf_fanworks.standsToLoad) do
	loadConsumable(v)
end

for i, v in ipairs(conf_fanworks.packsToLoad) do
	local packInfo = assert(SMODS.load_file("packs/" .. v .. ".lua"))()

	packInfo.key = v
	packInfo.atlas = v

	packInfo.pos = { x = 0, y = 0 }

	local pack = SMODS.Booster(packInfo)
	for k_, v_ in pairs(pack) do
		if type(v_) == 'function' then
			pack[k_] = packInfo[k_]
		end
	end

	SMODS.Atlas({ key = v, path ="packs/" .. v .. ".png", px = pack.width or 71, py = pack.height or  95 })
end


if fnwk_enabled['enableDecks'] then
	for i, v in ipairs(conf_fanworks.decksToLoad) do
		local deckInfo = assert(SMODS.load_file("decks/" .. v .. ".lua"))()

		deckInfo.key = v
		deckInfo.atlas = v
		deckInfo.pos = { x = 0, y = 0 }
		if deckInfo.hasSoul then
			deckInfo.pos = { x = 1, y = 0 }
			deckInfo.soul_pos = { x = 2, y = 0 }
		end

		local deck = SMODS.Back(deckInfo)
		for k_, v_ in pairs(deck) do
			if type(v_) == 'function' then
				deck[k_] = deckInfo[k_]
			end
		end

		SMODS.Atlas({ key = v, path ="decks/" .. v .. ".png", px = deck.width or 71, py = deck.height or  95 })
	end
end
if fnwk_enabled['enableChallenges'] then
	for i, v in ipairs(conf_fanworks.challengesToLoad) do
		local chalInfo = assert(SMODS.load_file("challenges/" .. v .. ".lua"))()

		chalInfo.key = v

		local chal = SMODS.Challenge(chalInfo)
		for k_, v_ in pairs(chal) do
			if type(v_) == 'function' then
				chal[k_] = chalInfo[k_]
			end
		end
	end
end
if fnwk_enabled['enableBosses'] then
	for i, v in ipairs(conf_fanworks.blindsToLoad) do
		local blindInfo = assert(SMODS.load_file("blinds/" .. v .. ".lua"))()

		blindInfo.key = v
		blindInfo.atlas = v
		if blindInfo.color then
			blindInfo.boss_colour = blindInfo.color
			blindInfo.color = nil
		end

		local blind = SMODS.Blind(blindInfo)
		for k_, v_ in pairs(blind) do
			if type(v_) == 'function' then
				blind[k_] = blindInfo[k_]
			end
		end

		SMODS.Atlas({ key = v, atlas_table = "ANIMATION_ATLAS", path = "blinds/" .. v .. ".png", px = 34, py = 34, frames = 21, })
	end
end
for i, v in ipairs(conf_fanworks.trophiesToLoad) do
	local trophyInfo = assert(SMODS.load_file("achievements/" .. v))()

	trophyInfo.key = v:sub(2, -5)
	trophyInfo.atlas = 'fnwk_achievements'
	if trophyInfo.rarity then
		if trophyInfo.rarity == 1 then
			trophyInfo.pos = { x = 1, y = 0 }
		elseif trophyInfo.rarity == 2 then
			trophyInfo.pos = { x = 2, y = 0 }
		elseif trophyInfo.rarity == 3 then
			trophyInfo.pos = { x = 3, y = 0 }
		elseif trophyInfo.rarity == 4 then
			trophyInfo.pos = { x = 4, y = 0 }
		end
	end

	SMODS.Achievement(trophyInfo)
end

SMODS.Atlas({ key = 'fnwk_achievements', path = "fnwk_achievements.png", px = 66, py = 66})

local card_drawRef = Card.draw
function Card.draw(self, layer)
	local obj = self.config.center
	if obj.draw and type(obj.draw) == 'function' then
		obj:draw(self, layer)
	end
	card_drawRef(self, layer)
end

function deepcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepcopy(orig_key)] = deepcopy(orig_value)
		end
		setmetatable(copy, deepcopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

math.randomseed(os.time())
function externalPsuedorandom(chance, total)
	if total <= 0 then return false end
	local randomNumber = math.random(1, total)
	return randomNumber <= chance
end

ach_checklists = {
	band = {
		4,
		'the_band',
		{
			'Be Someone Forever',
			'Garbage Hand',
			'Another Light',
			'Kerosene',
			'Vincenzo',
			'Quarterdumb'
		},
	},
	high = {
		2,
		'high_one',
		{
			'Be Someone Forever',
			'Pivyot',
			'Meat',
			"Don't Mind If I Do",
		},
	},
	ff7 = {
		3,
		'triple_seven',
		{
			'Motorcyclist Joker',
			'No No No No No No No No No No No',
			'Meteor',
		}
	}
}

function ach_jokercheck(card, table)
	local counter = 0
	for i, name in ipairs(table[3]) do
		if next(find_joker(name)) or card.name == name then
			counter = counter + 1
		end
	end
	if counter >= table[1] then
		check_for_unlock({ type = table[2] })
	end
end

function G.FUNCS.ach_pepsecretunlock(text)
	for k, v in pairs(SMODS.PokerHands) do
		if k == text then
			if v.visible == false then
				check_for_unlock({ type = "unlock_pep" })
			end
		end
	end
end

function G.FUNCS.ach_characters_check()
	if G.SETTINGS.CUSTOM_DECK.Collabs.Spades == "collab_CYP" and
	   G.SETTINGS.CUSTOM_DECK.Collabs.Hearts == "collab_TBoI" and
	   G.SETTINGS.CUSTOM_DECK.Collabs.Diamonds == "collab_SV" and
	   G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_STS" then
		check_for_unlock({ type = "skin_characters" })
	end
end

function G.FUNCS.ach_vineshroom_check()
	if ends_with(G.SETTINGS.CUSTOM_DECK.Collabs.Clubs, 'vineshroom') or G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_PC" or G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_WF" then
		check_for_unlock({ type = "skin_vineshroom" })
	end
end

if fnwk_enabled['enableSkins'] then
	for suit, color in pairs(G.C.SUITS) do
		local c
		if suit == "Hearts" then c = HEX("e14e62")
		elseif suit == "Diamonds" then c = HEX("3c56a4")
		elseif suit == "Clubs" then c = HEX("4dac84")
		elseif suit == "Spades" then c = HEX("8d619a")
		end
		SMODS.Suits[suit].keep_base_colours = false
		SMODS.Suits[suit].lc_colour = c
		SMODS.Suits[suit].hc_colour = c
		if G.VANILLA_COLLABS then
			G.VANILLA_COLLABS.lc_colours[suit] = c
			G.VANILLA_COLLABS.hc_colours[suit] = c
		end
		G.C.SO_1[suit] = c
		G.C.SO_2[suit] = c
	end
end

G.TITLE_SCREEN_CARD = G.P_CARDS.C_A

function G.FUNCS.title_screen_card(self, SC_scale)
	return Card(self.title_top.T.x, self.title_top.T.y, 1.2*G.CARD_W*SC_scale, 1.2*G.CARD_H*SC_scale, G.P_CARDS.S_A, G.P_CENTERS.c_base)
end

function G.FUNCS.center_splash_screen_card(SC_scale)
	return Card(G.ROOM.T.w/2 - SC_scale*G.CARD_W/2, 10. + G.ROOM.T.h/2 - SC_scale*G.CARD_H/2, SC_scale*G.CARD_W, SC_scale*G.CARD_H, G.P_CARDS.empty, G.P_CENTERS['j_joker'])
end

function G.FUNCS.splash_screen_card(card_pos, card_size)
	return Card(  card_pos.x + G.ROOM.T.w/2 - G.CARD_W*card_size/2,
			card_pos.y + G.ROOM.T.h/2 - G.CARD_H*card_size/2,
			card_size*G.CARD_W, card_size*G.CARD_H, pseudorandom_element(G.P_CARDS), G.P_CENTERS.c_base)
end

mgt = {"m", "e", "t", "a", "l", "g", "e", "a", "r", "t", "a", "c", "o"}
mgt_num = 1

local main_menuRef = Game.main_menu
function Game:main_menu(change_context)
	main_menuRef(self, change_context)

	if fnwk_enabled['enableChallenges'] then
		fnwk_tucker_addBanned()
	end

end

-- Mod Icon in Mods tab
SMODS.Atlas({
	key = "modicon",
	path = "fnwk_icon.png",
	px = 32,
	py = 32
}):register()

-- Tarot Atlas
SMODS.Atlas{
	key = "tarotreskins",
	path = "tarotreskins.png",
	px = 71,
	py = 95,
	atlas_table = "ASSET_ATLAS"
}
SMODS.Atlas{
	key = 'alt_color_jokers',
	path = "colorjokers.png",
	px = 71,
	py = 95,
	atlas_table = "ASSET_ATLAS",
}

if AltTexture and TexturePack then
	AltTexture({
		key = 'jokers',
		set = 'Joker',
		path = 'colorjokers.png',
		loc_txt = {
			name = 'Jokers'
		},
		keys = {
			'j_gluttenous_joker',
			'j_greedy_joker',
			'j_lusty_joker',
			'j_wrathful_joker',
			'j_onyx_agate',
			'j_rough_gem'
		},
		original_sheet = true
	})

	AltTexture({
		key = 'tarot',
		set = 'Tarot',
		path = 'tarotreskins.png',
		loc_txt = {
			name = 'Tarot'
		},
		keys = {
			'c_hermit',
			'c_moon',
		},
		original_sheet = true
	})

	TexturePack{
		key = 'fnwk',
		textures = {
			'fnwk_jokers',
			'fnwk_tarot',
		},
		loc_txt = {
			name = 'Fanworks Malverk Compatibility',
			text = {
				"Enables the Fanworks reskins of the Suit Color",
				"Jokers + 2 Tarot cards to work with Malverk!",
			}
		}
	}
end

if fnwk_enabled['enableTarotSkins'] then
	SMODS.Consumable:take_ownership('moon', {
		atlas = 'fnwk_tarotreskins'
	}, true)
	SMODS.Consumable:take_ownership('hermit', {
		atlas = 'fnwk_tarotreskins'
	}, true)
end

if fnwk_enabled['enableSkins'] then
	-- Base Deck Textures
	for i = 1, 2 do
		SMODS.Atlas {
			key = "cards_"..i,
			path = "BaseDeck.png",
			px = 71,
			py = 95,
			prefix_config = { key = false }
		}
		SMODS.Atlas {
			key = "ui_"..i,
			path = "ui_assets.png",
			px = 18,
			py = 18,
			prefix_config = { key = false }
		}
		SMODS.Atlas {
			key = "ui_",
			path = "ui_assets.png",
			px = 18,
			py = 18,
			prefix_config = { key = false }
		}
	end

	SMODS.Joker:take_ownership('greedy_joker', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('lusty_joker', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('wrathful_joker', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('gluttenous_joker', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)

	SMODS.Joker:take_ownership('onyx_agate', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)
	SMODS.Joker:take_ownership('rough_gem', {
		atlas = 'fnwk_alt_color_jokers'
	}, true)

	-- Skin Atlases
	for _, skin in ipairs(deck_skins) do
		SMODS.Atlas{
			key = skin,
			path = "skins/"..skin..".png",
			px = 71,
			py = 95,
			atlas_table = "ASSET_ATLAS"
		}
	end

	-- Collab Atlases
	for _, skin in ipairs(collab_skins) do
		SMODS.Atlas{
			key = skin,
			path = "collabs/"..skin..".png",
			px = 71,
			py = 95,
			atlas_table = "ASSET_ATLAS",
		}
	end

	-- Characters Replacements
	SMODS.DeckSkin:take_ownership('collab_AU',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "fnwk_h_characters",
		hc_atlas = "fnwk_h_characters"
	})
	SMODS.DeckSkin:take_ownership('collab_TW',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "fnwk_s_characters",
		hc_atlas = "fnwk_s_characters"
	})
	SMODS.DeckSkin:take_ownership('collab_VS',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "fnwk_c_characters",
		hc_atlas = "fnwk_c_characters"
	})
	SMODS.DeckSkin:take_ownership('collab_DTD',{
		loc_txt = {
			["en-us"] = "Characters"
		},
		lc_atlas = "fnwk_d_characters",
		hc_atlas = "fnwk_d_characters"
	})

	-- The Mascots, Classics, Wildcards, and Confidants
	SMODS.DeckSkin:take_ownership('collab_TBoI',{
		loc_txt = {
			["en-us"] = "The Wildcards"
		},
		lc_atlas = "fnwk_h_wildcards",
		hc_atlas = "fnwk_h_wildcards"
	})
	SMODS.DeckSkin:take_ownership('collab_CYP',{
		loc_txt = {
			["en-us"] = "The Confidants"
		},
		lc_atlas = "fnwk_s_confidants",
		hc_atlas = "fnwk_s_confidants"
	})
	SMODS.DeckSkin:take_ownership('collab_STS',{
		loc_txt = {
			["en-us"] = "The Mascots"
		},
		lc_atlas = "fnwk_c_mascots",
		hc_atlas = "fnwk_c_mascots"
	})
	SMODS.DeckSkin:take_ownership('collab_SV',{
		loc_txt = {
			["en-us"] = "The Classics"
		},
		lc_atlas = "fnwk_d_classics",
		hc_atlas = "fnwk_d_classics"
	})

	-- Vineshroom
	SMODS.DeckSkin:take_ownership('collab_PC',{
		ranks =  {"Ace"},
		loc_txt = {
			["en-us"] = "Vineshroom"
		},
		lc_atlas = "c_vineshroom",
		hc_atlas = "c_vineshroom"
	})

	-- Deck Skins: Clubs
	SMODS.DeckSkin:take_ownership('collab_WF',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_characters_VS",
		hc_atlas = "c_characters_VS",
		loc_txt = {
			["en-us"] = "Characters [VS]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_mascots_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_mascots_VS",
		hc_atlas = "c_mascots_VS",
		loc_txt = {
			["en-us"] = "The Mascots [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_VS_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_VS_DS",
		hc_atlas = "c_collab_VS_DS",
		loc_txt = {
			["en-us"] = "Vampire Survivors [DS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_STS_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_STS_DS",
		loc_txt = {
			["en-us"] = "Slay The Spire [DS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_PC_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "c_collab_PC_DS",
		loc_txt = {
			["en-us"] = "Potion Craft [DS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_WF_DS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "c_collab_WF_DS",
		loc_txt = {
			["en-us"] = "Warframe [DS]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_c_collab_VS_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_VS_VS",
		loc_txt = {
			["en-us"] = "Vampire Survivors [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_STS_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_STS_VS",
		loc_txt = {
			["en-us"] = "Slay The Spire [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_PC_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_PC_VS",
		loc_txt = {
			["en-us"] = "Potion Craft [VS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_WF_vineshroom",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_WF_VS",
		loc_txt = {
			["en-us"] = "Warframe [VS]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_c_collab_VS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_VS",
		loc_txt = {
			["en-us"] = "Vampire Survivors"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_STS",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_STS",
		loc_txt = {
			["en-us"] = "Slay The Spire"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_PC",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_PC",
		loc_txt = {
			["en-us"] = "Potion Craft"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_collab_WF",
		suit = "Clubs",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "c_collab_WF",
		loc_txt = {
			["en-us"] = "Warframe"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_c_shroomless",
		suit = "Clubs",
		ranks =  {"Ace"},
		lc_atlas = "c_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}

	-- Deck Skins: Hearts
	SMODS.DeckSkin:take_ownership('collab_CL',{
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "h_poops",
		hc_atlas = "h_poops",
		loc_txt = {
			["en-us"] = "The Poops"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin:take_ownership('collab_D2',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_AU_ES",
		hc_atlas = "h_collab_AU_ES",
		loc_txt = {
			["en-us"] = "Among Us [ES]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_h_collab_TBoI_ES",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "h_collab_TBoI_ES",
		hc_atlas = "h_collab_TBoI_ES",
		loc_txt = {
			["en-us"] = "The Binding of Isaac [ES]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_CL_ES",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "h_collab_CL_ES",
		loc_txt = {
			["en-us"] = "Cult of the Lamb [ES]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_D2_ES",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "h_collab_D2_ES",
		loc_txt = {
			["en-us"] = "Divinity Original Sin 2 [ES]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_h_collab_AU",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_AU",
		loc_txt = {
			["en-us"] = "Among Us"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_TBoI",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_TBoI",
		loc_txt = {
			["en-us"] = "The Binding of Isaac"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_CL",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_CL",
		loc_txt = {
			["en-us"] = "Cult of the Lamb"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_h_collab_D2",
		suit = "Hearts",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "h_collab_D2",
		loc_txt = {
			["en-us"] = "Divinity Original Sin 2"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_h_shroomless",
		suit = "Hearts",
		ranks =  {"Ace"},
		lc_atlas = "h_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}

	-- Deck Skins: Spades
	SMODS.DeckSkin:take_ownership('collab_SK',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_TW_TC",
		hc_atlas = "s_collab_TW_TC",
		loc_txt = {
			["en-us"] = "The Witcher [TC]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin:take_ownership('collab_DS',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_CYP_TC",
		hc_atlas = "s_collab_CYP_TC",
		loc_txt = {
			["en-us"] = "Cyberpunk 2077 [TC]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_s_collab_SK_TC",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "s_collab_SK_TC",
		loc_txt = {
			["en-us"] = "Shovel Knight [TC]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_DS_TC",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "s_collab_DS_TC",
		loc_txt = {
			["en-us"] = "Don't Starve [TC]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_s_collab_TW",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_TW",
		loc_txt = {
			["en-us"] = "The Witcher"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_CYP",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_CYP",
		loc_txt = {
			["en-us"] = "Cyberpunk 2077"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_SK",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_SK",
		loc_txt = {
			["en-us"] = "Shovel Knight"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_s_collab_DS",
		suit = "Spades",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "s_collab_DS",
		loc_txt = {
			["en-us"] = "Don't Starve"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_s_shroomless",
		suit = "Spades",
		ranks =  {"Ace"},
		lc_atlas = "s_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}

	-- Deck Skins: Diamonds
	SMODS.DeckSkin:take_ownership('collab_EG',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_DTD_FS",
		hc_atlas = "d_collab_DTD_FS",
		loc_txt = {
			["en-us"] = "Dave The Diver [FS]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin:take_ownership('collab_XR',{
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_SV_FS",
		hc_atlas = "d_collab_SV_FS",
		loc_txt = {
			["en-us"] = "Stardew Valley [FS]"
		},
		posStyle = "ranks"
	})
	SMODS.DeckSkin{
		key = "ds_d_collab_EG_FS",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "d_collab_EG_FS",
		loc_txt = {
			["en-us"] = "Enter the Gungeon [FS]"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_XR_FS",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King'},
		lc_atlas = "d_collab_XR_FS",
		loc_txt = {
			["en-us"] = "1000xRESIST [FS]"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_d_collab_DTD",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_DTD",
		loc_txt = {
			["en-us"] = "Dave The Diver"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_SV",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_SV",
		loc_txt = {
			["en-us"] = "Stardew Valley"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_EG",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_EG",
		loc_txt = {
			["en-us"] = "Enter the Gungeon"
		},
		posStyle = "ranks"
	}
	SMODS.DeckSkin{
		key = "ds_d_collab_XR",
		suit = "Diamonds",
		ranks =  {'Jack', 'Queen', 'King', 'Ace'},
		lc_atlas = "d_collab_XR",
		loc_txt = {
			["en-us"] = "1000xRESIST"
		},
		posStyle = "ranks"
	}

	SMODS.DeckSkin{
		key = "ds_d_shroomless",
		suit = "Diamonds",
		ranks =  {"Ace"},
		lc_atlas = "d_shroomless",
		loc_txt = {
			["en-us"] = "Default"
		},
		posStyle = "collab"
	}
end

SMODS.Sound({
	key = "vhsopen",
	path = "vhsopen.ogg",
})

SMODS.Sound({
	key = "vhsclose",
	path = "vhsclose.ogg",
})

G.FUNCS.reset_trophies = function(e)
	local warning_text = e.UIBox:get_UIE_by_ID('warn')
	if warning_text.config.colour ~= G.C.WHITE then
		warning_text:juice_up()
		warning_text.config.colour = G.C.WHITE
		warning_text.config.shadow = true
		e.config.disable_button = true
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06, blockable = false, blocking = false, func = function()
			play_sound('tarot2', 0.76, 0.4);return true end}))
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.35, blockable = false, blocking = false, func = function()
			e.config.disable_button = nil;return true end}))
		play_sound('tarot2', 1, 0.4)
	else
		G.FUNCS.wipe_on()
		for k, v in pairs(SMODS.Achievements) do
			if starts_with(k, 'ach_fnwk_') then
				G.SETTINGS.ACHIEVEMENTS_EARNED[k] = nil
				G.ACHIEVEMENTS[k].earned = nil
			end
		end
		G:save_settings()
		G.E_MANAGER:add_event(Event({
			delay = 1,
			func = function()
				G.FUNCS.wipe_off()
				return true
			end
		}))
	end
end

local function config_matching()
	for k, v in pairs(fnwk_enabled) do
		if v ~= fnwk_config[k] then
			return false
		end
	end
	return true
end

function G.FUNCS.fnwk_restart()
	if config_matching() then
		send("SETTINGS MATCH :)")
		SMODS.full_restart = 0
	else
		send("SETTINGS DONT MATCH!")
		SMODS.full_restart = 1
	end
end

local text_scale = 0.9
local fnwkConfigTabs = function() return {
	{
		label = localize("b_options"),
		chosen = true,
		tab_definition_function = function()
			local fnwk_opts = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {
				{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
					{n=G.UIT.T, config={text = localize("b_options"), scale = text_scale*0.9, colour = G.C.GREEN, shadow = true}},
				}},
				--[[{n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
					{n=G.UIT.T, config={text = localize("vs_options_sub"), scale = text_scale*0.5, colour = G.C.GREEN, shadow = true}},
				}},]]--
			}}
			if localize("vs_options_muteWega") then
				fnwk_opts.nodes[#fnwk_opts.nodes+1] = {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
					{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
						create_toggle({n=G.UIT.T, label = localize("vs_options_muteWega"), ref_table = fnwk_config, ref_value = 'muteWega' })
					}},
					{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
						{n=G.UIT.T, config={text = localize("vs_options_muteWega_desc"), scale = text_scale*0.35, colour = G.C.JOKER_GREY, shadow = true}}
					}},
				}}
			end
			if localize("vs_options_resetTrophies_r") then
				fnwk_opts.nodes[#fnwk_opts.nodes+1] = {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
					{n=G.UIT.R, config={align = "cm", minw = 0.5, maxw = 2, minh = 0.6, padding = 0, r = 0.1, hover = true, colour = G.C.RED, button = "reset_trophies", shadow = true, focus_args = {nav = 'wide'}}, nodes={
						{n=G.UIT.T, config={text = localize("vs_options_resetTrophies_r"), scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT}}
					}},
					{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
						{n=G.UIT.T, config={text = localize("vs_options_resetTrophies_desc"), scale = text_scale*0.35, colour = G.C.JOKER_GREY, shadow = true}}
					}},
				}}
			end
			fnwk_opts.nodes[#fnwk_opts.nodes+1] = {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
				{n=G.UIT.T, config={id = 'warn', text = localize('ph_click_confirm'), scale = 0.4, colour = G.C.CLEAR}}
			}}
			return {
				n = G.UIT.ROOT,
				config = {
					emboss = 0.05,
					minh = 6,
					r = 0.1,
					minw = 10,
					align = "cm",
					padding = 0.05,
					colour = G.C.BLACK,
				},
				nodes = {
					fnwk_opts
				}
			}
		end
	}
} end

SMODS.current_mod.extra_tabs = fnwkConfigTabs


SMODS.current_mod.config_tab = function()
	local ordered_config = {
		'enableVinkers',
		'enableJoelkers',
		'enableOtherJokers',
		'enableSpectrals',
		'enableBosses',
		'enableDecks',
		'enableSkins',
		'enableChallenges',
		'enableTrophies',
		'enableTarotSkins',
	}
	local left_settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }
	local right_settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }
	for i, k in ipairs(ordered_config) do
		if #right_settings.nodes < #left_settings.nodes then
			right_settings.nodes[#right_settings.nodes + 1] = create_toggle({ label = localize("vs_options_"..ordered_config[i]), ref_table = fnwk_config, ref_value = ordered_config[i], callback = G.FUNCS.fnwk_restart})
		else
			left_settings.nodes[#left_settings.nodes + 1] = create_toggle({ label = localize("vs_options_"..ordered_config[i]), ref_table = fnwk_config, ref_value = ordered_config[i], callback = G.FUNCS.fnwk_restart})
		end
	end
	local fnwk_config_ui = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { left_settings, right_settings } }
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			minh = 6,
			r = 0.1,
			minw = 10,
			align = "cm",
			padding = 0.05,
			colour = G.C.BLACK,
		},
		nodes = {
			fnwk_config_ui
		}
	}
end

vs_credit_1 = "BarrierTrio/Gote"
vs_credit_2 = "DPS2004"
vs_credit_3 = "SagaciousCejai"
vs_credit_4 = "Nether"
vs_credit_5 = "Mysthaps"
vs_credit_6 = "Numbuh214"
vs_credit_7 = "Aurelius7309"
vs_credit_8 = "Austin L. Matthews"
vs_credit_8_tag = "(AmtraxVA)"
vs_credit_9 = "Lyman"
vs_credit_9_from = "(JankJonklers)"
vs_credit_10 = "Akai"
vs_credit_10_from = "(Balatrostuck)"
vs_credit_5_from = "(LobotomyCorp)"
vs_credit_12 = "Victin"
vs_credit_12_from = "(Victin's Collection)"
vs_credit_13 = "Keku"
vs_credit_14 = "Gappie"
vs_credit_15 = "Arthur Effgus"
vs_credit_16 = "FenixSeraph"
vs_credit_17 = "WhimsyCherry"
vs_credit_18 = "Global-Trance"
vs_credit_19 = "Lyzerus"
vs_credit_20 = "Bassclefff"
vs_credit_20_tag = "(bassclefff.bandcamp.com)"
vs_credit_21 = "fradavovan"
vs_credit_22 = "Greeeg"
vs_credit_23 = "CheesyDraws"
vs_credit_24 = "Jazz_Jen"
vs_credit_25 = "BardVergil"
vs_credit_26 = "GuffNFluff"
vs_credit_27 = "sinewuui"
vs_credit_28 = "Swizik"
vs_credit_29 = "Burdrehnar"
vs_credit_30 = "Crisppyboat"
vs_credit_31 = "Alli"
vs_credit_32 = "Lyman"
vs_credit_st1 = "tortoise"
vs_credit_st2 = "Protokyuuu"
vs_credit_st3 = "ShrineFox"
vs_credit_st4 = "cyrobolic"
vs_credit_st5 = "ReconBox"
vs_credit_st6 = "SinCityAssassin"

local header_scale = 1.1
local bonus_padding = 1.15
local support_padding = 0.015
local artist_size = 0.43

SMODS.current_mod.credits_tab = function()
	chosen = true
	return {n=G.UIT.ROOT, config={align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.1, emboss = 0.05, minh = 6, minw = 10}, nodes={
		{n = G.UIT.C, config = { align = "tm", padding = 0.2 }, nodes = {
			{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
				{n=G.UIT.T, config={text = localize("b_credits"), scale = text_scale*1.2, colour = G.C.GREEN, shadow = true}},
			}},
			{n=G.UIT.R, config={align = "cm", padding = 0.05,outline_colour = G.C.GREEN, r = 0.1, outline = 1}, nodes= {
				{n=G.UIT.C, config={align = "tm", padding = 0.1, r = 0.1}, nodes={
					{n=G.UIT.C, config={align = "tm", padding = 0}, nodes={
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = localize('vs_credits1'), scale = header_scale * 0.5, colour = G.C.GOLD, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = vs_credit_1, scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = vs_credit_13, scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.4, colour = G.C.CLEAR, shadow = true}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = localize('vs_credits7'), scale = header_scale * 0.6, colour = G.C.RED, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = vs_credit_20, scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = vs_credit_20_tag, scale = text_scale*0.45, colour = G.C.JOKER_GREY, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.05, colour = G.C.CLEAR, shadow = true}},
								}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.4, colour = G.C.CLEAR, shadow = true}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = G.SETTINGS.roche and localize('vs_credits4') or "?????", scale = header_scale*0.6, colour = G.C.BLUE, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = G.SETTINGS.roche and vs_credit_8 or "?????", scale = text_scale*0.55, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = G.SETTINGS.roche and vs_credit_8_tag or "?????", scale = text_scale*0.45, colour = G.C.JOKER_GREY, shadow = true}},
								}},
							}},
						}},
					}},
				}},
				{n=G.UIT.C, config={align = "tm", padding = 0.1, r = 0.1}, nodes= {
					{ n = G.UIT.C, config = { align = "tm", padding = 0.1 * bonus_padding, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1 }, nodes = {
						{ n = G.UIT.R, config = { align = "cm", padding = 0 }, nodes = {
							{ n = G.UIT.T, config = { text = localize('vs_credits2'), scale = header_scale * 0.6, colour = HEX('f75294'), shadow = true } },
						} },
						{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
							{n=G.UIT.C, config={align = "tl", padding = 0}, nodes={
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_1, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_3, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_13, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_14, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_15, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_16, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_17, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_18, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_19, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_25, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_26, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_24, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_27, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_21, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
							}},
							{n=G.UIT.C, config={align = "tl", padding = 0}, nodes={
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_22, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_23, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_10, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_28, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_29, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_30, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_31, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
								{ n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = {
									{ n = G.UIT.T, config = { text = vs_credit_32, scale = text_scale * artist_size, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
								} },
							}}
						}},
					} },
				}},
				{n=G.UIT.C, config={align = "tm", padding = 0.1, r = 0.1}, nodes= {
					{ n = G.UIT.C, config = { align = "tm", padding = 0, r = 0.1, }, nodes = {
						{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
							{n=G.UIT.C, config={align = "tl", padding = 0.1*bonus_padding,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = localize('vs_credits3'), scale = header_scale*0.6, colour = G.C.ORANGE, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_1, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_2, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_4, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_5, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_6, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_7, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_13, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}},
							}},
							{n=G.UIT.C, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
								{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.3, colour = G.C.CLEAR, vert = true, shadow = true}},
								}},
							}},
							{n=G.UIT.C, config={align = "tl", padding = 0.1*bonus_padding,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
									{n=G.UIT.T, config={text = localize('vs_credits5'), scale = header_scale*0.55, colour = G.C.PURPLE, shadow = true}},
								}},
								{n=G.UIT.R, config={align = "cm", padding = 0}, nodes= {
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_9, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_9_from, scale = text_scale*0.375, colour = G.C.JOKER_GREY, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_10, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_10_from, scale = text_scale*0.375, colour = G.C.JOKER_GREY, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_5, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_5_from, scale = text_scale*0.375, colour = G.C.JOKER_GREY, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_12, scale = text_scale*0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = support_padding}, nodes={
										{n=G.UIT.T, config={text = vs_credit_12_from, scale = text_scale*0.375, colour = G.C.JOKER_GREY, shadow = true}},
									}},
								}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.3, colour = G.C.CLEAR, shadow = true}},
							}},
						}},
						{n=G.UIT.R, config={align = "tm", padding = 0.1,outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1}, nodes={
							{n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
								{n=G.UIT.T, config={text = localize('vs_credits6'), scale = header_scale*0.55, colour = G.C.GREEN, shadow = true}},
							}},
							{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
								{n=G.UIT.C, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_st1, scale = text_scale*0.36, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_st3, scale = text_scale*0.36, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_st5, scale = text_scale*0.36, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}},
								{n=G.UIT.C, config={align = "tm", padding = 0,outline_colour = G.C.CLEAR, r = 0.1, outline = 1}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = "SEPARATOR LMAO", scale = text_scale*0.15, colour = G.C.CLEAR, shadow = true}},
									}},
								}},
								{n=G.UIT.C, config={align = "tm", padding = 0}, nodes={
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_st2, scale = text_scale*0.36, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_st4, scale = text_scale*0.36, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
									{n=G.UIT.R, config={align = "tm", padding = 0}, nodes={
										{n=G.UIT.T, config={text = vs_credit_st6, scale = text_scale*0.36, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
									}},
								}}
							}},
						}},
					}},
				}},
			}}
		}}
	}}
end
