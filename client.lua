local isIdlePlaying = false
local lastActionTime = 0
local idleTimeout = 30000

setInterval(() => {
    mp.game.invoke('0xF4F2C0D4EE209E20'); // Disable idle camera
    mp.game.invoke('0x9E4CFFF989258472'); // Disable vehicle idle camera
}, 28000);

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
            if IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35) then

                lastActionTime = GetGameTimer()
            end
            
            if GetGameTimer() - lastActionTime > idleTimeout then
                if not isIdlePlaying then
                    RequestAnimDict("move_m@generic_idles@std")
                    if HasAnimDictLoaded("move_m@generic_idles@std") then
                        TaskPlayAnim(playerPed, "move_m@generic_idles@std", "idle", 8.0, -8, -1, 49, 0, false, false, false)
                        isIdlePlaying = true
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
            if IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35) then

                lastActionTime = GetGameTimer()
            end
            
            if GetGameTimer() - lastActionTime > idleTimeout then
                if not isIdlePlaying then
                    RequestAnimDict("move_f@generic_idles@std")
                    if HasAnimDictLoaded("move_f@generic_idles@std") then
                        TaskPlayAnim(playerPed, "move_f@generic_idles@std", "idle", 8.0, -8, -1, 49, 0, false, false, false)
                        isIdlePlaying = true
                    end
                end
            end
        end
    end
end)
