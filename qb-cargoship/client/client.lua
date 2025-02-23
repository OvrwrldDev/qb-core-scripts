RegisterNetEvent("qb-cargoship:spawnShip")
AddEventHandler("qb-cargoship:spawnShip", function(location)
    local ship = CreateObject(GetHashKey("prop_cargo_ship"), location.x, location.y, location.z, true, true, false)
    SetEntityHeading(ship, 90.0)
    FreezeEntityPosition(ship, true)
    print("Cargo Ship Spawned at:", location.x, location.y, location.z)
end)

RegisterNetEvent("qb-cargoship:spawnGuards")
AddEventHandler("qb-cargoship:spawnGuards", function(guards)
    for _, guard in pairs(guards) do
        local ped = CreatePed(4, GetHashKey(guard.model), guard.x, guard.y, guard.z, 0.0, true, true)
        GiveWeaponToPed(ped, GetHashKey(guard.weapon), 255, false, true)
        TaskCombatPed(ped, GetPlayerPed(-1), 0, 16)
    end
end)

RegisterNetEvent("qb-cargoship:policeAlert")
AddEventHandler("qb-cargoship:policeAlert", function()
    TriggerEvent("police:notify", "Cargo ship heist in progress!")
end)