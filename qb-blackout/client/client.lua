local blackout = false

RegisterNetEvent("qb-blackout:toggle", function(state)
    blackout = state
    SetArtificialLightsState(blackout)
    SetArtificialLightsStateAffectsVehicles(not blackout)

    if blackout then
        SetTimecycleModifier("NG_blackout")
        SetBlackout(true)
    else
        ClearTimecycleModifier()
        SetBlackout(false)
    end
end)

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("qb-blackout:sync")
end)

-- Script for admins to do /blackout to cause a blackout in the server