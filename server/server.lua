ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('advance_gangarea:fetchowner', function(source, callback, area)
    MySQL.Async.fetchAll('SELECT * FROM gang_area WHERE ID = @ID', {['@ID'] = area}, function(result)

    --MySQL.Async.fetchAll('SELECT * FROM gang_area WHERE ID = @ID', {
    --    ['@ID'] = area,
    --}, function(result)
        
        print(result)
        callback(result)
    end)
    
end)