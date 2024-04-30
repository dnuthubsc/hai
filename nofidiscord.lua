function SendMessage(url, message)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["content"] = message
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
    print("Sent")
end

function SendMessageEMBED(url, embed)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["embeds"] = {
            {
                ["title"] = embed.title,
                ["description"] = embed.description,
                ["color"] = embed.color,
                ["fields"] = embed.fields,
                ["footer"] = {
                    ["text"] = embed.footer.text
                }
            }
        }
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
    print("Sent")
end
local player =  game.Players.LocalPlayer
SendMessage(url, "Hello")
local function checkForShiki()
    local shiki = workspace:FindFirstChild("Shiki")
    if shiki then
        local TimeInUnix = os.time()
        local Date = script.Parent
        local stringToFormat = "%I:%M %p"
        local result = os.date(stringToFormat, TimeInUnix)
                local percentStr = workspace.Shiki.OrbSpawn.Feed.ObjectText
            
            SendMessage(url, "Hello")
            
            
            local embed = {
                ["title"] = "dis.cord.gg made this!",
                ["description"] = "fuck this lol",
                ["color"] = 65280,
                ["fields"] = {
                    {
                        ["name"] = "User",
                        ["value"] = player.Name
                    },
                    {
                        ["name"] = "EGG!",
                        ["value"] = percentStr
                    }
                },
                ["footer"] = {
                    ["text"] = result
                }
            }
            SendMessageEMBED(url, embed)
    else
        wait(5)
         print("none")
        checkForShiki()
    end
end

checkForShiki()
