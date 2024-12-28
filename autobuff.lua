----------------------
----- [ CONFIG ] -----
----------------------
local Identifier = {
    ["Erwin"] = "erwin";
    ["Wendy"] = "wendy";
    ["Leafa"] = "leafa_evolved";
}
local Delay = _G.Buffer -- Just change this to 15.4 if not working

---------------------------------------
----- [ DO NOT TOUCH THIS PART! ] -----
---------------------------------------
repeat task.wait() until game:IsLoaded()
if game.PlaceId == 8304191830 then return end
repeat task.wait() until workspace:WaitForChild("_waves_started").Value == true

local Player = game:GetService("Players").LocalPlayer
local GameFinished = game:GetService("Workspace"):WaitForChild("_DATA"):WaitForChild("GameFinished")
local Loader = require(game:GetService("ReplicatedStorage").src.Loader)
local ItemInventoryService = Loader.load_client_service(script, "ItemInventoryServiceClient")

for ID, Name in pairs(Identifier) do
    local Start = false;
    for _, UUID in pairs(ItemInventoryService["session"]["collection"]["collection_profile_data"]["equipped_units"]) do
        if ItemInventoryService["session"]["collection"]["collection_profile_data"]["owned_units"][UUID]["unit_id"] == Name then Start = true; break; end;
    end
    if Start then
        task.spawn(function()
            if getgenv().Library then getgenv().Library:Notify("Auto Buff ["..ID.."] Started", 5) else print("Auto Buff ["..ID.."] Started"); end
            repeat
                task.wait()
                if GameFinished.Value then break; end;
                local Container = {}

                for _, Unit in pairs(game:GetService("Workspace"):WaitForChild("_UNITS"):GetChildren()) do
                    if GameFinished.Value then break; end;
                    if Unit:WaitForChild("_stats"):WaitForChild("id").Value ~= Name then continue end;
                    if Unit:WaitForChild("_stats"):WaitForChild("active_attack").Value == "nil" then continue end;
                    if Unit:WaitForChild("_stats"):WaitForChild("player").Value == Player then
                        table.insert(Container, Unit)
                    end
                end

                if #Container == 4 then
                    local Broken = false;
                    while not Broken do
                        task.wait()
                        for Idx = 1, 4 do
                            if GameFinished.Value then Broken = true; break; end;
                            if #Container < 4 then Broken = true; break; end;
                            if Container[Idx].Parent ~= game:GetService("Workspace"):WaitForChild("_UNITS") then Broken = true; break; end;
                            pcall(function() game:GetService("ReplicatedStorage")["endpoints"]["client_to_server"]["use_active_attack"]:InvokeServer(Container[Idx]) end)
                            task.wait(Delay)
                        end
                    end
                end
            until GameFinished.Value
            if getgenv().Library then getgenv().Library:Notify("Auto Buff ["..ID.."] Ended", 5) else print("Auto Buff ["..ID.."] Ended"); end
        end)
    end
end
