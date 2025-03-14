
function SMODS.calculate_quantum_editions(card, effects, context)
    if not card.edition then
        return
    end

    context.extra_edition = true
    local extra_editions = SMODS.get_quantum_editions(card)
    if #extra_editions < 1 then
        return
    end
    local old_edition = copy_table(card.edition)

    
    for i, v in ipairs(extra_editions) do
        if G.P_CENTERS[v.key] then
            
            card.edition = v
            local eval = {edition = card:calculate_edition(context)}
            if eval then
                effects[#effects+1] = eval
            end
        end
    end
    
    card.edition = old_edition
    context.extra_edition = nil
end

function SMODS.get_quantum_editions(card)
    if card.edition.others and next(card.edition.others) then
        local extras = copy_table(card.edition.others)
        return extras
    end
    return {}
end