-- config.lua - Configurations for Cargo Ship Heist
Config = {}

-- Cargo Ship Spawn Locations
Config.ShipLocations = {
    {x = 3000.0, y = -3000.0, z = 0.0},
    {x = 3500.0, y = -3200.0, z = 0.0},
    {x = 4000.0, y = -2800.0, z = 0.0}
}

-- Cargo Ship Spawn Interval (in minutes)
Config.ShipSpawnTime = 30 

-- Security NPCs
Config.Guards = {
    {model = "s_m_m_marine_01", weapon = "WEAPON_CARBINERIFLE"},
    {model = "s_m_m_security_01", weapon = "WEAPON_PISTOL"}
}

-- Loot Table
Config.LootItems = {
    "weapon_assaultrifle",
    "weapon_smg",
    "weapon_advancedrifle",
    "black_money",
    "gold_bar",
    "cocaine_bricks"
}

-- Police Alert Time (seconds before cops arrive)
Config.PoliceResponseTime = 300