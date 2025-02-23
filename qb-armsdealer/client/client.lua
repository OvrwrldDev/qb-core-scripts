local dealerNPC = nil
local dealerBlip = nil

-- Black Market Shop
local shopItems = {
    {label = "Pistol", item = "weapon_pistol", price = 3000},
    {label = "Combat Pistol", item = "weapon_combatpistol", price = 5000},
    {label = "SNS Pistol", item = "weapon_snspistol", price = 2500},
    {label = "Heavy Revolver", item = "weapon_revolver", price = 7000},
    {label = "Mini SMG", item = "weapon_minismg", price = 8000},
    {label = "SMG", item = "weapon_smg", price = 12000},
    {label = "Combat PDW", item = "weapon_combatpdw", price = 14000},
    {label = "Assault Rifle", item = "weapon_assaultrifle", price = 25000},
    {label = "Carbine Rifle", item = "weapon_carbinerifle", price = 30000},
    {label = "Pump Shotgun", item = "weapon_pumpshotgun", price = 10000},
    {label = "Bullpup Shotgun", item = "weapon_bullpupshotgun", price = 12000},
    {label = "Sniper Rifle", item = "weapon_sniperrifle", price = 40000},
    {label = "Knife", item = "weapon_knife", price = 500},
    {label = "Machete", item = "weapon_machete", price = 1500},
    {label = "Molotov", item = "weapon_molotov", price = 2000},
    {label = "Grenade", item = "weapon_grenade", price = 3000},
    {label = "Silencer", item = "weapon_suppressor", price = 2000},
    {label = "Extended Mag", item = "weapon_extendedclip", price = 1500},
    {label = "Flashlight", item = "weapon_flashlight", price = 1000}
}

-- Update dealer location
RegisterNetEvent("qb-armsdealer:updateLocation", function(coords)
    if dealerNPC then DeleteEntity(dealerNPC) end
    if dealerBlip then RemoveBlip(dealerBlip) end

    -- Spawn NPC
    RequestModel(GetHashKey("a_m_m_soucent_01"))
    while not HasModelLoaded("a_m_m_soucent_01") do
        Wait(10)
    end

    dealerNPC = CreatePed(4, ("a_m_m_soucent_01"), coords.x, coords.y, coords.z - 1.0, 0.0, false, true)
    SetEntityInvincible(dealerNPC, true)
    FreezeEntityPosition(dealerNPC, true)
    SetBlockingOfNonTemporaryEvents(dealerNPC, true)

    -- Add Blip
    dealerBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(dealerBlip, 110)
    SetBlipScale(dealerBlip, 0.8)
    SetBlipColour(dealerBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Black Market Dealer")
    EndTextCommandSetBlipName(dealerBlip)

    -- QB-Target Interaction
    exports['qb-target']:AddTargetEntity(dealerNPC, {
        options = {
            {
                event = "qb-armsdealer:openShop",
                icon = "fas fa-gun",
                label = "Buy Illegal Weapons",
            }
        },
        distance = 2.5
    })
end)

-- Open Black Market Shop
RegisterNetEvent("qb-armsdealer:openShop", function()
    local elements = {
        {
            header = "Black Market Dealer",
            isMenuHeader = true
        }
    }
    for _, v in pairs(shopItems) do
        table.insert(elements, {
            header = v.label .. " - $" .. v.price,
            txt = "Purchase " .. v.label,
            params = {
                event = "qb-armsdealer:attemptPurchase",
                args = {
                    item = v.item,
                    price = v.price
                }
            }
        })
    end

    -- Open Menu (qb-menu)
    exports['qb-menu']:openMenu(elements)
end)

-- Attempt to buy a weapon
RegisterNetEvent("qb-armsdealer:attemptPurchase", function(data)
    local weapon = data.item
    local price = data.price
    TriggerServerEvent("qb-armsdealer:buyWeapon", weapon, price)
end)

-- Police Alert for Illegal Purchases
RegisterNetEvent("qb-armsdealer:policeAlert", function(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Illegal Arms Dealer Activity")
    EndTextCommandSetBlipName(blip)

    -- Remove Blip After 2 Minutes
    Wait(120000)
    RemoveBlip(blip)
end)

-- Sync Dealer Location on Spawn
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("qb-armsdealer:syncDealer")
end)
