ESX = nil

Citizen.CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end

	PlayerData = ESX.GetPlayerData()

end)

local takingover = false
local carea = nil
local sleep = 1000
local neari = nil
local draw = false

Citizen.CreateThread(function()
a = nil

	while true do	
		for i in pairs(Config.areas) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1))
			local dis = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.areas[i].x, Config.areas[i].y, Config.areas[i].z)

			if dis <= 20.0 then
				a = i	
				draw = true
				sleep = 1
			end
			
			
		end

		if draw then
			neari = a
			local plyCoords = GetEntityCoords(GetPlayerPed(-1))
			local dis = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.areas[neari].x, Config.areas[neari].y, Config.areas[neari].z)
			
			DrawMarker(27, Config.areas[neari].x, Config.areas[neari].y, Config.areas[neari].z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 5.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)	
			if dis <= 4 and IsControlJustReleased(0, 38) then
				open(neari)
			end
			if dis > 20.0 then
				draw = false
				sleep = 1000
			end
		end

		if takingover then
			ESX.Game.Utils.DrawText3D(coords, math.floor(procent*100+0.5) .. "%", 1.0)

			local plyCoords = GetEntityCoords(GetPlayerPed(-1))
			local dis = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.areas[carea].x, Config.areas[carea].y, Config.areas[carea].z)
			
			if dis >= 20 then
				takingover = false
				TriggerEvent('esx:showNotification', 'Du gick för långt bort')
			end
		end
		
		

		Citizen.Wait(sleep)
	end

end)

Citizen.CreateThread(function()
	while true do
		local year, month, day, hour, minute, second = GetLocalTime()
		local dag = GetClockDayOfWeek()
	
		
		
		
		if hour == "22" and minute == "59" and second == "59" and dag == 0 then
			TriggerServerEvent('advance_gangarea:setreward')
		end
		
		Citizen.Wait(1000)
		
	end

end)

function open(area)
	carea = area
	ESX.TriggerServerCallback('advance_gangarea:fetchowner', function(cb)
		owner = cb[1].owner
		
		
		
		if owner == nil then
			owner = "Ingen"
		end
		
		local elements = {
			{label = "Ägare: " .. owner, value = 'owner'},
			--{label = "Ta över område", value = 'start'},
			--{label = "Hämta belöning", value = 'get'},
			
		}
		if takingover then
			table.insert(elements, {
				["label"] = "Sluta ta över område", ["value"] = 'stop'
			})
		else
			if PlayerData.job.name == owner then
				table.insert(elements, {
					["label"] = "Hämta belöning", ["value"] = 'get'
				})
			else
				table.insert(elements, {
					["label"] = "Ta över område", ["value"] = 'start'
				})
			end
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'menu',
			{
				title    = "Område " .. area,
				align    = "center",
				elements = elements

			},
			function(data, menu)

				if data.current.value == 'start' then
					menu.close()
					takeover(area, owner, PlayerData.job.name)
					
				end
				if data.current.value == 'get' then
					menu.close()
					
				end

				if data.current.value == 'stop' then
					menu.close()
					takingover = false
				end

			end, function(data, menu)
				menu.close()
		end)
	end, area)

end

function takeover(area, owner, newowner)
	local i = 1
	local message = "Någon tar över erat område!"
	
	coords = Config.areas[area]
	procent = 0
	
	--TriggerEvent('esx_phone:onMessage', source, message, message, coords, "Granne", owner)
	--TriggerServerEvent('esx_phone:send', owner, "Granne: ", true, false)

	takingover = true
	while i <= Config.timer and takingover do
		procent = i/Config.timer
			
		Citizen.Wait(1000)
		i = i + 1
		
	end
	if takingover then
		tookover(area, newowner)
	end
		
	
	takingover = false
	
end

function tookover(area, newowner)
	TriggerEvent('esx:showNotification', 'Området är nu ditt')
	TriggerServerEvent('advance_gangarea:takeover', area, newowner)

end

