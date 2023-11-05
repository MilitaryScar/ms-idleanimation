local isIdlePlaying = false
local lastActionTime = 0
local idleTimeout = 30000
local maleAnimDicts = {
    "move_m@generic_idles@std",
    "additional_male_anim_dict_1",
    "additional_male_anim_dict_2"
}
local femaleAnimDicts = {
    "move_f@generic_idles@std",
    "additional_female_anim_dict_1",
    "additional_female_anim_dict_2"
}
local interval = 30000  -- Set your desired interval in milliseconds
local currentAnimIndex = 1

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(interval)
        mp.game.invoke('0xF4F2C0D4EE209E20') -- Disable idle camera
        mp.game.invoke('0x9E4CFFF989258472') -- Disable vehicle idle camera
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()

        if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) then
            if IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35) then
                lastActionTime = GetGameTimer()

                if isIdlePlaying then
                    ClearPedTasks(playerPed)
                    isIdlePlaying = false
                end
            end

            if GetGameTimer() - lastActionTime > idleTimeout and not isIdlePlaying then
                local animDicts = IsPedMale(playerPed) and maleAnimDicts or femaleAnimDicts
                local animDict = animDicts[currentAnimIndex]

                RequestAnimDict(animDict)
                if HasAnimDictLoaded(animDict) then
                    TaskPlayAnim(playerPed, animDict, "idle", 8.0, -8, -1, 49, 0, false, false, false)
                    isIdlePlaying = true

                    -- Cycle to the next animation dictionary
                    currentAnimIndex = (currentAnimIndex % #animDicts) + 1
                end
            end
        end
    end
end)
