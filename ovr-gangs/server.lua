QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent("ovr-gangs:registerGang")
AddEventHandler("ovr-gangs:registerGang", function(gangName, gangTag)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local price = Config.GangCreationPrice

    if not Player then return end
    if Player.PlayerData.money["bank"] >= price then
        Player.Functions.RemoveMoney("bank", price)

        MySQL.Async.execute("INSERT INTO gangs (name, tag, leader) VALUES (@name, @tag, @leader)", {
            ['@name'] = gangName,
            ['@tag'] = gangTag,
            ['@leader'] = Player.PlayerData.citizenid
        }, function()
            TriggerClientEvent("QBCore:Notify", src, "Gang Registered: " .. gangName, "success")
        end)
    else
        TriggerClientEvent("QBCore:Notify", src, "Not enough money!", "error")
    end
end)
