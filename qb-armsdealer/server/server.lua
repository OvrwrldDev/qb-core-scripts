local QBCore = exports['qb-core']:GetCoreObject()

-- List of possible dealer locations
local dealerLocations = {
    vector3(123.4, -302.5, 50.2),
    vector3(-420.2, 600.1, 30.6),
    vector3(2500.5, -1300.8, 48.0),
    vector3(-1200.3, -800.2, 12.5)
}

local currentDealer = dealerLocations[math.random(#dealerLocations)]
local dealerActive = true

-- Move dealer every 2 hours
CreateThread(function()
    while true do
        Wait(7200000) -- 2 hours (in millieseconds)
        currentDealer = dealerLocations[math.random(#dealerLocations)]
        TriggerClientEvent("qb-armsdealer:updateLocation", -1, currentDealer)
    end
end)

-- Lines 3 - 21 are config lines

-- Handle weapon purchase
RegisterNetEvent("qb-armsdealer:buyWeapon", function(weapon, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if Player.Functions.RemoveMoney("cash", price) then
        Player.Functions.AddItem(weapon, 1)
        TriggerClientEvent('QBCore:Notify', src, ("You bought a %s"):format(weapon), "success")

        -- Track illegal purchases
        local purchases = Player.PlayerData.metadata["illegal_purchases"] or 0
        purchases = purchases + 1
        Player.Functions.SetMetaData("illegal_purchases", purchases)

        -- Alert police if too many purchases
        if purchases >= 3 then
            local police = QBCore.Functions.GetPlayersByJob("police")
            for _, officerId in pairs(police) do
                TriggerClientEvent("qb-armsdealer:policeAlert", officerId, GetEntityCoords(GetPlayerPed(src)))
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Not enough cash!", "error")
    end
end)

-- Sync dealer location for new players
RegisterNetEvent("qb-armsdealer:syncDealer", function()
    local src = source
    TriggerClientEvent("qb-armsdealer:updateLocation", src, currentDealer)
end)
