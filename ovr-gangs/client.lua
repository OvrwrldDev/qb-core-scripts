-- client.lua
QBCore = exports['qb-core']:GetCoreObject()

local gangNPC = vector3(-267.94, -963.48, 31.22) -- Set NPC location

CreateThread(function()
    RequestModel(GetHashKey("s_m_m_armoured_01")) -- NPC Model
    while not HasModelLoaded(GetHashKey("s_m_m_armoured_01")) do
        Wait(1)
    end

    local npc = CreatePed(4, GetHashKey("s_m_m_armoured_01"), gangNPC.x, gangNPC.y, gangNPC.z - 1.0, 180.0, false, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)

    exports['qb-target']:AddTargetEntity(npc, {
        options = {
            {
                type = "client",
                event = "ovr-gangs:openMenu",
                icon = "fas fa-users",
                label = "Register a Gang",
            },
        },
        distance = 2.0
    })
end)

RegisterNetEvent("ovr-gangs:openMenu", function()
    local menu = {
        {
            header = "Gang Registration",
            isMenuHeader = true
        },
        {
            header = "Register a New Gang",
            txt = "Choose a gang name",
            params = {
                event = "ovr-gangs:registerGangMenu"
            }
        },
        {
            header = "Close Menu",
            txt = "Exit",
            params = {
                event = "qb-menu:closeMenu"
            }
        }
    }
    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent("ovr-gangs:registerGangMenu", function()
    local input = exports['qb-input']:ShowInput({
        header = "Gang Registration",
        submitText = "Next",
        inputs = {
            { type = "text", name = "gang_name", text = "Enter Gang Name" }
        }
    })
    
    if input and input.gang_name ~= "" then
        RegisterNetEvent("ovr-gangs:registerGangTagMenu", function()
            local tagInput = exports['qb-input']:ShowInput({
                header = "Gang Tag (Optional)",
                submitText = "Confirm",
                inputs = {
                    { type = "text", name = "gang_tag", text = "Enter Gang Tag (or leave blank)" }
                }
            })
            
            local gangTag = tagInput and tagInput.gang_tag ~= "" and tagInput.gang_tag or nil
            TriggerServerEvent("ovr-gangs:registerGang", input.gang_name, gangTag)
        end)
        
        TriggerEvent("ovr-gangs:registerGangTagMenu")
    else
        QBCore.Functions.Notify("Gang name is required!", "error")
    end
end)

-- Keybind to open gang management menu (Only for gang leaders)
RegisterKeyMapping('gangmenu', 'Open Gang Management', 'keyboard', 'F6')
RegisterCommand('gangmenu', function()
    QBCore.Functions.TriggerCallback('ovr-gangs:checkGangLeader', function(isLeader)
        if isLeader then
            local menu = {
                {
                    header = "Gang Management",
                    isMenuHeader = true
                },
                {
                    header = "Invite Member",
                    txt = "Invite a player using their CID",
                    params = {
                        event = "ovr-gangs:inviteMember"
                    }
                },
                {
                    header = "Close Menu",
                    txt = "Exit",
                    params = {
                        event = "qb-menu:closeMenu"
                    }
                }
            }
            exports['qb-menu']:openMenu(menu)
        else
            QBCore.Functions.Notify("You are not a gang leader!", "error")
        end
    end)
end)

RegisterNetEvent("ovr-gangs:inviteMember", function()
    local input = exports['qb-input']:ShowInput({
        header = "Invite Gang Member",
        submitText = "Invite",
        inputs = {
            { type = "text", name = "cid", text = "Enter Player CID" }
        }
    })
    
    if input and input.cid ~= "" then
        TriggerServerEvent("ovr-gangs:invitePlayer", input.cid)
    else
        QBCore.Functions.Notify("CID is required!", "error")
    end
end)
