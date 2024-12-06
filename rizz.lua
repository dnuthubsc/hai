_G.rizzthemgyaties = true

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LPlayer = Players.LocalPlayer
local Character = LPlayer.Character
local Backpack = LPlayer.Backpack
local PlayerGui = LPlayer.PlayerGui

local ServerStats = ReplicatedStorage:WaitForChild("world")
local Remotes = {
    ["Equip"] = PlayerGui:WaitForChild("hud").safezone.backpack.events.equip,
    ["ChangeSetting"] = PlayerGui:WaitForChild("hud").safezone.menu.menu_safezone.ChangeSetting,
    ["EquipRod"] = ReplicatedStorage:WaitForChild("events").equiprod,
    ["ReelFinished"] = ReplicatedStorage:WaitForChild("events").reelfinished,
    ["SellAll"] = ReplicatedStorage:WaitForChild("events").selleverything,
    ["Purchase"] = ReplicatedStorage:WaitForChild("events").purchase,
    ["ActivateNuke"] = ReplicatedStorage:WaitForChild("packages").Net["RE/Nuke"]
}
local Items = {
    ["Aurora Totem"] = 10000,
    ["Sundial Totem"] = 10000,
    ["Nuke"] = 500
} -- Items to give yourself (Name, Quantity)

local function SimulateButtonPress(Button : Instance) : nil
    pcall(function()
        Button.Size = UDim2.new(1001, 0, 1001, 0)
        Button.BackgroundTransparency = 1
        
        VirtualUser:Button1Down(Vector2.new(1, 1))
        task.wait()
        VirtualUser:Button1Up(Vector2.new(1, 1))
    end)
end

local function GetServerStat(Stat : string) : any
    return ServerStats:WaitForChild(Stat).Value
end

local LastNuke = 0
local function DoNuke(Force : boolean) : boolean
    if Force or (LastNuke + 1800 <= os.time()) then -- 1800
        LastNuke = os.time()
        Remotes["ActivateNuke"]:FireServer()
        return true
    end
    
    return false
end

local function DoSundial(Force : boolean) : boolean
    Remotes["Equip"]:FireServer(Backpack:FindFirstChild("Sundial Totem"))
    task.wait(0.1)
    VirtualUser:Button1Down(Vector2.new(1, 1))
    
    return true
end

local function DoAurora() : boolean
    if GetServerStat("luck_Luck") < 7 then
        if GetServerStat("cycle") == "Day" then
            DoSundial()
            repeat task.wait(0.1) until GetServerStat("cycle") == "Night"
            task.wait(1)
        end
    
        Remotes["Equip"]:FireServer(Backpack:FindFirstChild("Aurora Totem"))
        task.wait(0.1)
        VirtualUser:Button1Down(Vector2.new(1, 1))
        return true
    end
    
    return false
end

local function DoStuff() : nil
    DoAurora()
    DoNuke()
end

local function PurchaseExploit() : nil
    for Item, Quantity in pairs(Items) do
        Remotes["Purchase"]:FireServer(Item, "Item", nil, Quantity)
        print("Got", Item)
    end
end

Remotes["ChangeSetting"]:FireServer("brightness", true)
PurchaseExploit()
task.wait(0.1)

while _G.rizzthemgyatie do
    CatchFish()
    task.wait()
end
