local consumablesToLoad = {
    --Spectral
    'spec_stonemask',
}

if not fnwk_enabled['enableConsumables'] then
    return
end

-- Load Consumables
for i, v in ipairs(consumablesToLoad) do
    LoadConsumable(v)
end