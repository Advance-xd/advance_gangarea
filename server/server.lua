ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('advance_gangarea:fetchowner', function(source, callback, area)
    MySQL.Async.fetchAll('SELECT * FROM gang_area WHERE ID = @ID', {['@ID'] = area}, function(result)

        
        callback(result)
    end)
    
end)

RegisterServerEvent("advance_gangarea:takeover")
AddEventHandler("advance_gangarea:takeover", function(area, owner)
    MySQL.Async.execute('UPDATE gang_area SET owner = @owner WHERE ID = @area', 
        {
            ["@owner"] = owner,
            ["@area"] = area,
        }
    )
end)


RegisterServerEvent("advance_gangarea:setreward")
AddEventHandler("advance_gangarea:setreward", function()
    MySQL.Async.execute('UPDATE gang_area SET reward = "1"', 
        {
        }
    )
end)
