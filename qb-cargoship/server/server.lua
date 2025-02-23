RegisterCommand('startCargoship', function(source, args, rawCommand)
    local randomLocation = Config.ShipLocations[math.random(#Config.ShipLocations)]
    TriggerClientEvent('qb-cargoship:spawnShip', -1, randomLocation)
    print("Cargo Ship Heist Started!")
    
    Citizen.Wait(Config.PoliceResponseTime * 1000)
    TriggerClientEvent('qb-cargoship:policeAlert', -1)
end, true)

RegisterNetEvent('qb-cargoship:lootContainer')
AddEventHandler('qb-cargoship:lootContainer', function()
    local player = source
    local randomLoot = Config.LootItems[math.random(#Config.LootItems)]
    print("Player", player, "looted", randomLoot)
    -- Add item to player's inventory here
end)
