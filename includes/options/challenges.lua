local challengesToLoad = {
    'tucker',
}

if not fnwk_enabled['enableChallenges'] then
	return
end

for i, v in ipairs(challengesToLoad) do
	local chalInfo = assert(SMODS.load_file("challenges/" .. v .. ".lua"))()

	chalInfo.key = v

	local chal = SMODS.Challenge(chalInfo)
	for k_, v_ in pairs(chal) do
		if type(v_) == 'function' then
			chal[k_] = chalInfo[k_]
		end
	end
end