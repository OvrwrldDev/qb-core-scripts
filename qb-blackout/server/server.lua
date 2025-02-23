---@diagnostic disable-next-line: undefined-global
local QBCore = exports['qb-core']:GetCoreObject()

local blackoutActive = false

RegisterCommand("blackout", function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player and Player.PlayerData.job.name == "admin" then
        blackoutActive = not blackoutActive
---@diagnostic disable-next-line: undefined-global
        TriggerClientEvent("qb-blackout:toggle", -1, blackoutActive)
        TriggerClientEvent('QBCore:Notify', src, "Blackout " .. (blackoutActive and "enabled" or "disabled"), "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "You do not have permission to use this command!", "error")
    end
end, false)

RegisterNetEvent("qb-blackout:sync", function()
    local src = source
    TriggerClientEvent("qb-blackout:toggle", src, blackoutActive)
end)

-- Script for admins to do /blackout to cause a blackout in the server