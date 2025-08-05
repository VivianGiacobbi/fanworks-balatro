local mod_path = SMODS.current_mod.path
local usable_path = mod_path:match("Mods/[^/]+")
local path_pattern_replace = usable_path:gsub("(%W)","%%%1")  -- shoot me in the foot, why doesn't lua just have a str.replace

local trophiesToLoad = {}

if not fnwk_enabled['enable_Trophies'] then
	G.loadTrophies = false
	return
end


G.loadTrophies = true
for s in ArrowAPi.loading.recursive_file_enumerate(usable_path .. "/achievements/"):gmatch("[^\r\n]+") do
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