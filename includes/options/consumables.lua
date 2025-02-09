local consumablesToLoad = {
    --[[
    --Spectral
    'quixotic',
    'protojoker',
    --]]
}

if not fnwk_enabled['enableConsumables'] then
    return
end

-- Load Consumables
for i, v in ipairs(consumablesToLoad) do
    loadConsumable(v)
end