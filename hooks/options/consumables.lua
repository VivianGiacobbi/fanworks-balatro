local consumablesToLoad = {
    --[[
    --Spectral
    'quixotic',
    'protojoker',
    --]]
}

if fnwk_enabled['enableConsumables'] then

    -- Load Consumables
    for i, v in ipairs(consumablesToLoad) do
        loadConsumable(v)
    end
end