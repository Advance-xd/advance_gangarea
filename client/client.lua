ESX = nil

Citizen.CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end

end)
  
function fetchowner(area)
	
	ESX.TriggerServerCallback('advance_gangarea:fetchowner', function(cb)
		local owner = cb
		
		
	end, area)

	
end



Citizen.CreateThread(function()
	while true do
		for i in pairs(Config.areas) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1))
			local dis = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.areas[i].x, Config.areas[i].y, Config.areas[i].z)

			if dis <= 20.0 then
				DrawMarker(27, Config.areas[i].x, Config.areas[i].y, Config.areas[i].z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 5.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
				if dis <= 4 and IsControlJustReleased(0, 38) then
					open(i)
				end

			end

			
			
			
		end
		Citizen.Wait(1)
	end

end)

function open(area)
	owner = nil
	ESX.TriggerServerCallback('advance_gangarea:fetchowner', function(cb)
		owner = cb[1].owner
		print(owner)
		
		
	end, area)

	if owner == nil then
		owner = "Ingen"
	end
	
	local elements = {
		{label = "Ägare: " .. owner, value = 'owner'},
		{label = "Ta över område", value = 'start'},
		{label = "Hämta belöning", value = 'get'},
		
	}

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'menu',
		{
			title    = "Område " .. area,
			align    = "center",
			elements = elements

		},
		function(data, menu)

			if data.current.value == 'start' then
				trytakeover(area)
				menu.close()
			end
			if data.current.value == 'get' then
				menu.close()
			end

		end, function(data, menu)
			menu.close()
	end)

end