ESX                           = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
      end
end)


Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do
		local sleepThread = 500
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local dstCheck = GetDistanceBetweenCoords(pedCoords, Config.sedye["x"], Config.sedye["y"], Config.sedye["z"], true)
		if dstCheck <= 5.0 then
			sleepThread = 5
			local text = "Sedye"
			if dstCheck <= 0.8 then
				text = "Sedyeyi çıkartmak için [~g~E~s~] Tuşuna bas."
				if IsControlJustPressed(0, 38) then
					LoadModel('v_med_bed2')
					local wheelchair = CreateObject(GetHashKey('v_med_bed2'), vector3(320.2149, -590.866, 42.283), true)
				end
			end
			ESX.Game.Utils.DrawText3D(Config.sedye, text, 0.6)
		end
		if dstCheck >= 7.0 then
			Citizen.Wait(4000)
		else
			Citizen.Wait(5)
		end
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do
		local sleepThread = 500
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local dstCheck = GetDistanceBetweenCoords(pedCoords, Config.sedyesil["x"], Config.sedyesil["y"], Config.sedyesil["z"], true)
		if dstCheck <= 5.0 then
			sleepThread = 5
			local text = "Sedye Sil"
			if dstCheck <= 0.8 then
				text = "Sedyeyi silmek için [~g~G~s~] Tuşuna bas."
				if IsControlJustPressed(0, 47) then
					local wheelchair = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 10.0, GetHashKey('v_med_bed2'))

					if DoesEntityExist(wheelchair) then
						DeleteEntity(wheelchair)
					end
				end
			end
			ESX.Game.Utils.DrawText3D(Config.sedyesil, text, 0.6)
		end
		if dstCheck >= 7.0 then
			Citizen.Wait(4000)
		else 
			Citizen.Wait(5)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		local sleep = 500

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local closestObject = GetClosestObjectOfType(pedCoords, 3.0, GetHashKey("v_med_bed2"), false)

		if DoesEntityExist(closestObject) then
			sleep = 5

			local wheelChairCoords = GetEntityCoords(closestObject)
			local wheelChairForward = GetEntityForwardVector(closestObject)
			local wheelChairY = GetEntityForwardY(closestObject)
			
			local sitCoords = (wheelChairCoords + wheelChairForward * - 1.0)
			local pickupCoords = (wheelChairCoords + wheelChairForward * 1.2)
			local sagoturCoords = (wheelChairCoords + wheelChairForward * - 0.5)
			local soloturCoords = (wheelChairCoords + wheelChairForward * - 0.1)
			local dikyatCoords = (wheelChairCoords + wheelChairForward * 0.8 + wheelChairY * -0.2)

			if GetDistanceBetweenCoords(pedCoords, sitCoords, true) <= 2.0 then
				ESX.ShowHelpNotification('[~g~E~s~] ile sedye menüsünü aç.')
				if IsControlJustPressed(0, 38) then
					OpenActionMenuInteraction(closestObject)
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

function OpenActionMenuInteraction(closestObject)

	local elements = {}

	table.insert(elements, {label = ('Sedyeyi Taşı'), value = 'sedyeyi_tasi'})
	table.insert(elements, {label = ('Yat'), value = 'normal_yat'})
	table.insert(elements, {label = ('Sağa Otur'), value = 'saga_otur'})
	table.insert(elements, {label = ('Sola Otur'), value = 'sola_otur'})
	table.insert(elements, {label = ('Dik Yat'), value = 'dik_yat'})
	table.insert(elements, {label = ('Menüyü kapat'), value = 'exit'})
  
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'action_menu',
		{
			title    = ('Waleron RolePlay'),
			align    = 'top-left',
			elements = elements
		},
    function(data, menu)

		local player, distance = ESX.Game.GetClosestPlayer()

		ESX.UI.Menu.CloseAll()

		if data.current.value == 'sedyeyi_tasi' then
			exports['mythic_notify']:SendAlert('inform', 'Sedyeyi taşıyorsun.', 4000)
			PickUp(closestObject)
			menu.close()
		elseif data.current.value == 'normal_yat' then
			
			Yat(closestObject)
			menu.close()
		elseif data.current.value == 'saga_otur' then
			
			Sagotur(closestObject)
			menu.close()
		elseif data.current.value == 'sola_otur' then
			
			Solotur(closestObject)
			menu.close()
		elseif data.current.value == 'dik_yat' then
			
			Dikyat(closestObject)
			menu.close()
		end
  end)
end

Sit = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
			return
		end
	end

	LoadAnim("missfinale_c2leadinoutfin_c_int")

	AttachEntityToEntity(PlayerPedId(), wheelchairObject, 0, 0, 0.0, 0.4, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(wheelchairObject)

	while IsEntityAttachedToEntity(PlayerPedId(), wheelchairObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 3) then
			TaskPlayAnim(PlayerPedId(), 'missfinale_c2leadinoutfin_c_int', '_leadin_loop2_lester', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlPressed(0, 32) then
			local x, y, z  = table.unpack(GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * -0.02)
			SetEntityCoords(wheelchairObject, x,y,z)
			PlaceObjectOnGroundProperly(wheelchairObject)
		end

		if IsControlPressed(1,  34) then
			heading = heading + 0.4

			if heading > 360 then
				heading = 0
			end

			SetEntityHeading(wheelchairObject,  heading)
		end

		if IsControlPressed(1,  9) then
			heading = heading - 0.4

			if heading < 0 then
				heading = 360
			end

			SetEntityHeading(wheelchairObject,  heading)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

Dikyat = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'timetable@amanda@drunk@base', 'base', 3) then
			return
		end
	end

	LoadAnim("timetable@amanda@drunk@base")

	AttachEntityToEntity(PlayerPedId(), wheelchairObject, 0, 0, 0.9, 1.4, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(wheelchairObject)

	while IsEntityAttachedToEntity(PlayerPedId(), wheelchairObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'timetable@amanda@drunk@base', 'base', 3) then
			TaskPlayAnim(PlayerPedId(), 'timetable@amanda@drunk@base', 'base', 8.0, 8.0, -1, 69, 1, false, false, false)
		end
		
		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

Sagotur = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 3) then
			return
		end
	end

	LoadAnim("amb@prop_human_seat_chair_mp@male@generic@base")

	AttachEntityToEntity(PlayerPedId(), wheelchairObject, 0, -0.2, 0.0, 0.4, 0.0, 0.0, 90.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(wheelchairObject)

	while IsEntityAttachedToEntity(PlayerPedId(), wheelchairObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 3) then
			TaskPlayAnim(PlayerPedId(), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

Solotur = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 3) then
			return
		end
	end

	LoadAnim("amb@prop_human_seat_chair_mp@male@generic@base")

	AttachEntityToEntity(PlayerPedId(), wheelchairObject, 0, 0.2, 0.0, 0.4, 0.0, 0.0, 270.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(wheelchairObject)

	while IsEntityAttachedToEntity(PlayerPedId(), wheelchairObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 3) then
			TaskPlayAnim(PlayerPedId(), 'amb@prop_human_seat_chair_mp@male@generic@base', 'base', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

Yat = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@gangops@morgue@table@', 'body_search', 3) then
			return
		end
	end

	LoadAnim("anim@gangops@morgue@table@")

	AttachEntityToEntity(PlayerPedId(), wheelchairObject, 0, 0, 0.0, 1.4, 0.0, 0.0, 180.0, 0.0, false, false, false, false, 2, true)

	local heading = GetEntityHeading(wheelchairObject)

	while IsEntityAttachedToEntity(PlayerPedId(), wheelchairObject) do
		Citizen.Wait(5)

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(PlayerPedId(), true, true)
		end

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@gangops@morgue@table@', 'body_search', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@gangops@morgue@table@', 'body_search', 8.0, 8.0, -1, 69, 1, false, false, false)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(PlayerPedId(), true, true)

			local x, y, z = table.unpack(GetEntityCoords(wheelchairObject) + GetEntityForwardVector(wheelchairObject) * - 0.7)

			SetEntityCoords(PlayerPedId(), x,y,z)
		end
	end
end

PickUp = function(wheelchairObject)
	local closestPlayer, closestPlayerDist = GetClosestPlayer()

	if closestPlayer ~= nil and closestPlayerDist <= 1.5 then
		if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'anim@heists@box_carry@', 'idle', 3) then
			ShowNotification("Somebody is already driving the wheelchair!")
			return
		end
	end

	NetworkRequestControlOfEntity(wheelchairObject)

	LoadAnim("anim@heists@box_carry@")

	AttachEntityToEntity(wheelchairObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.00, -1.10, -1.0, 195.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)

	while IsEntityAttachedToEntity(wheelchairObject, PlayerPedId()) do
		Citizen.Wait(5)

		if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
			TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsPedDeadOrDying(PlayerPedId()) then
			DetachEntity(wheelchairObject, true, true)
		end

		if IsControlJustPressed(0, 73) then
			DetachEntity(wheelchairObject, true, true)
		end
	end
end

DrawText3Ds = function(coords, text, scale)
	local x,y,z = coords.x, coords.y, coords.z
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 215)

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 370

	DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.025, 41, 11, 41, 100)
end

GetPlayers = function()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

GetClosestPlayer = function()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	
	return closestPlayer, closestDistance
end

LoadAnim = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		
		Citizen.Wait(1)
	end
end

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		
		Citizen.Wait(1)
	end
end

ShowNotification = function(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentSubstringWebsite(msg)
	DrawNotification(false, true)
end