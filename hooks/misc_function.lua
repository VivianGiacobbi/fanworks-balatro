--[[
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
--]]