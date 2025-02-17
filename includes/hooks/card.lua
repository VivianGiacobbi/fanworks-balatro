

local base_get_id = Card.get_id
function Card:get_id()
    local id = base_get_id(self)
    if next(find_joker('Bone Crossed Joker')) and (id == 11 or id == 13) then
        return 12
    end
    return id
end
