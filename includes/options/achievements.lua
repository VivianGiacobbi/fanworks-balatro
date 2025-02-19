local trophiesToLoad = {}

if not fnwk_enabled['enableTrophies'] then
	G.loadTrophies = false
	return
end


G.loadTrophies = true
for s in RecursiveEnumerate(usable_path .. "/achievements/"):gmatch("[^\r\n]+") do
	trophiesToLoad[#trophiesToLoad + 1] = s:gsub(path_pattern_replace .. "/achievements/", "")
end

for i, v in ipairs(trophiesToLoad) do
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
	if StringEndsWith(G.SETTINGS.CUSTOM_DECK.Collabs.Clubs, 'vineshroom') or G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_PC" or G.SETTINGS.CUSTOM_DECK.Collabs.Clubs == "collab_WF" then
		check_for_unlock({ type = "skin_vineshroom" })
	end
end

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
			if StringStartsWith(k, 'ach_fnwk_') then
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