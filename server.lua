ESX = nil

local ownedProperties = {}
local waitingForTrade = {}
local alreadyLate = false

local specialOutfitSlots = {
  ['steam:xxx'] = 999 -- example
}

local clothesListCache = {}

local currentlyWhitelisted = {}

local ox_inventory = exports.ox_inventory

TriggerEvent(
  "esx:getSharedObject",
  function(obj)
    ESX = obj
  end
)

ESX.RSC("RoJea_property:registerMyNewStash", function(source, cb, room)
  local xPlayer = ESX.ply(source)

  MySQL.Async.fetchAll("SELECT * FROM `rojea_property` WHERE `id` = @id LIMIT 1", {
    ["@id"] = room
  }, function(properties)
    if properties[1] then
      if properties[1].identifier == xPlayer.identifier then
        local slots = 50
        local weight = 200
        ox_inventory:RegisterStash("property_" .. room, "Nuosavybes spinta", slots, weight, xPlayer.identifier)
        cb(true)
      else
        cb(false)
      end
    else
      cb(false)
    end
  end)
end)

AddEventHandler("RoJea_cmds:blockInteractions", function()
  alreadyLate = true
end)

AddEventHandler("onMySQLReady", function()
  Wait(7500)
  MySQL.Async.fetchAll("SELECT * FROM `rojea_property`", {}, function(properties)
    if properties then
      --print("collecting owned properties")
      for i = 1, #properties, 1 do
        --print(properties[i].id, properties[i].identifier)
        ownedProperties[properties[i].id] = properties[i].identifier
      end

      --print("done collecting properties")

      TriggerEvent("RoJea_property:sendPropsList", ownedProperties)
    end
  end)
end)

local function ownerCheck(identifiers)
  local idx = "steam:xxxx"
  return identifiers == idx
end

AddEventHandler("RoJea_properties:fetchPropertyList", function(cb)
  cb(Config.Properties)
end)

AddEventHandler("esx:playerLoaded", function(playerSrc, xPlayer)
  for k, v in pairs(ownedProperties) do
    if v == xPlayer.steam and Config.Properties[k].premium then
      if not specialOutfitSlots[xPlayer.steam] then
        specialOutfitSlots[xPlayer.steam] = 5
      end
      break
    end
  end
end)

TriggerEvent("es:addGroupCommand", "clearhouseowner", "superadmin", function(source, args, user)
    local room = tonumber(args[1])
    if room then
      MySQL.Async.fetchAll(
        "SELECT * FROM `rojea_property` WHERE `id` = @id",
        {
          ["@id"] = room
        },
        function(result)
          if result[1] then
            local targIdentf = result[1].identifier
            MySQL.Async.execute(
              "DELETE FROM `rojea_property` WHERE `id` = @id",
              {
                ["@id"] = room
              },
              function(rowsChanged)
                if rowsChanged == 1 then
                  ownedProperties[room] = nil
                  local xPlayer = ESX.GetPlayerFromIdentifier(targIdentf)
                  if xPlayer then
                    TriggerClientEvent("RoJea_property:syncSoldProperty", -1, xPlayer.source, ownedProperties, room)
                  else
                    TriggerClientEvent("RoJea_property:syncSoldProperty", -1, 0, ownedProperties, room)
                  end
                  deletePropertyInventory(room, targIdentf)
                  if source ~= 0 then
                    TriggerClientEvent(
                      "chat:addMessage",
                      source,
                      { args = { "^1SISTEMA", "Sekmingai pašalinote nuosavybes savininka!" } }
                    )
                  else
                    print("[RoJea_property] Sekmingai pašalinote nuosavybes savininka!")
                  end
                  TriggerEvent("RoJea_property:sendPropertyListServer")
                end
              end
            )
          end
        end
      )
    else
      if source ~= 0 then
        TriggerClientEvent("chat:addMessage", source, { args = { "^1SISTEMA", "Neteisingas nuosavybes numeris" } })
      else
        print("[RoJea_property] Neteisingas nuosavybes numeris")
      end
    end
  end,
  function(source, args, user)
    TriggerClientEvent("chat:addMessage", source, { args = { "^1SISTEMA", "Neturite teisiu!" } })
  end,
  { help = "Ištrina nuosavybes savininka", params = { { name = "nuosavybe", help = "nuosavybes numeris" } } }
)


-- NEW STORAGE

RegisterNetEvent("RoJea_property:getHouseStashNewWay", function(room)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local identifiers = xPlayer.steam

  if ownedProperties[room] ~= identifiers then
    -- ban him
  end

  local blackMoney = 0
  local items = {}
  local weapons = {}

  TriggerEvent("esx_addonaccount:getAccount", "property" .. tostring(room) .. "_black_money", identifiers,
    function(account)
      blackMoney = account.money
      TriggerEvent("esx_addoninventory:getInventory", "property" .. tostring(room), identifiers, function(inventory)
        items = inventory.items
        TriggerEvent("esx_datastore:getDataStore", "property" .. tostring(room), identifiers, function(store)
          weapons = store.get("weapons") or {}

          -- CB

          local totalWeight = 0
          for k, v in pairs(items) do
            --print(v.name, v.count, ESX.GetItemWeight(v.name))
            totalWeight = totalWeight + (ESX.GetItemWeight(v.name) * v.count) -- whatever real KG
          end
          for k, v in pairs(weapons) do
            totalWeight = totalWeight + 5 -- each gun weighs 5kg
          end

          -- format weapons correctly
          for i = 1, #weapons, 1 do
            local weapon = weapons[i]

            weapons[i].weaponName = weapon.name
            weapons[i].name = weapon.name
            weapons[i].label = ESX.GetWeaponLabel(weapon.name)
            weapons[i].ammo = weapon.ammo
            weapons[i].components = weapon.components
            weapons[i].tint = weapon.tint or 0
          end

          local cbInventory = {
            blackMoney = blackMoney,
            items = items,
            weapons = weapons,
            weight = totalWeight * 1000,
            cash = 0
          }
          TriggerEvent("RoJea_cmds:global:openStorageInventory", _source, "property_" .. tostring(room),
            "Nuosavybes spinta", Config.MaxStashWeight * 1000, cbInventory)
        end)
      end)
    end)
end)


RegisterNetEvent("esx_inventoryhud:global:putToStorage", function(typee, name, count, max, itemLabel, currentDisplayType)
  local _source = source
  if string.find(currentDisplayType, "property_") then
    local propertyNum = string.gsub(currentDisplayType, "property_", "")
    if not tonumber(propertyNum) then return end
    propertyNum = tonumber(propertyNum)

    putToItemStorPriv(_source, typee, name, count, max, currentDisplayType, propertyNum)
  end
end)

RegisterNetEvent("esx_inventoryhud:global:getFromStorage",
  function(abc, typee, name, count, max, currentDisplayType, weaponAppendix)
    local _source = source
    if string.find(currentDisplayType, "property_") then
      local propertyNum = string.gsub(currentDisplayType, "property_", "")
      if not tonumber(propertyNum) then return end
      propertyNum = tonumber(propertyNum)

      getFromItemStorPriv(_source, typee, name, count, max, currentDisplayType, propertyNum, weaponAppendix)
    end
  end)

-- local function matchComps(first, second)
--   if #first ~= #second then return false end -- not same size arrays
--   for k,v in pairs(first) do
--     local foundOne = false
--     for k2,v2 in pairs(second) do
--       if v==v2 then
--         foundOne = true
--         break
--       end
--     end
--     if foundOne == false then return false end -- some component missing
--   end
--   return true -- all match
-- end

function getFromItemStorPriv(source, typee, item, count, max, baseNameR, room, appendix)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(_source)
  local identifiers = xPlayer.steam
  -- if ownedProperties[room] ~= identifiers then
  --   -- ban him
  --   return
  -- end

  if typee == "item_standard" then
    TriggerEvent(
      "esx_addoninventory:getInventory",
      "property" .. tostring(room),
      identifiers,
      function(inventory)
        local inventoryItem = inventory.getItem(item)
        -- print("opop")
        if count > 0 and inventoryItem.count >= count then
          if xPlayer.canCarryItem(item, count) then
            inventory.removeItem(item, count)
            xPlayer.addInventoryItem(item, count)
            xPlayer.showNotification(_U("you_have_withdrawn", count, inventoryItem.label))
            TriggerEvent(
              "RoJea_transfers:propertyThingsAction",
              source,
              GetPlayerName(source),
              identifiers,
              Config.Properties[room].name,
              "withdraw",
              item,
              count,
              "x"
            )

            local blackMoney = 0
            local items = {}
            local weapons = {}

            TriggerEvent("esx_addonaccount:getAccount", "property" .. tostring(room) .. "_black_money", identifiers,
              function(account)
                blackMoney = account.money
                -- TriggerEvent("esx_addoninventory:getInventory", "property" .. tostring(room), identifiers, function(inventory)
                items = inventory.getItems()
                TriggerEvent("esx_datastore:getDataStore", "property" .. tostring(room), identifiers, function(store)
                  weapons = store.get("weapons") or {}

                  -- CB

                  local totalWeight = 0
                  for k, v in pairs(items) do
                    totalWeight = totalWeight + (ESX.GetItemWeight(v.name) * v.count) -- whatever real KG
                  end
                  for k, v in pairs(weapons) do
                    totalWeight = totalWeight + 5 -- each gun weighs 5kg
                  end

                  -- format weapons correctly
                  for i = 1, #weapons, 1 do
                    local weapon = weapons[i]

                    weapons[i].weaponName = weapon.name
                    weapons[i].name = weapon.name
                    weapons[i].label = ESX.GetWeaponLabel(weapon.name)
                    weapons[i].ammo = weapon.ammo
                    weapons[i].components = weapon.components
                    weapons[i].tint = weapon.tint or 0
                  end


                  local cbInventory = {
                    blackMoney = blackMoney,
                    items = items,
                    weapons = weapons,
                    weight = totalWeight * 1000,
                    cash = 0
                  }
                  TriggerEvent("RoJea_cmds:global:refreshStorageInventory", source, baseNameR, "Nuosavybes spinta",
                    Config.MaxStashWeight * 1000, cbInventory)
                end)
                -- end)
              end)
          else
            xPlayer.showNotification(_U("you_cannot_hold"))
          end
        else
          xPlayer.showNotification(_U("theres_not_enough_in_property"))
        end
      end
    )
  elseif typee == "item_account" then
    TriggerEvent(
      "esx_addonaccount:getAccount",
      "property" .. tostring(room) .. "_" .. item,
      identifiers,
      function(account)
        local roomAccountMoney = account.money
        if roomAccountMoney >= count then
          account.removeMoney(count)
          xPlayer.addAccountMoney(item, count)
          TriggerEvent(
            "RoJea_transfers:propertyThingsAction",
            source,
            GetPlayerName(source),
            identifiers,
            Config.Properties[room].name,
            "withdraw",
            "Nešvarių pinigų",
            count,
            "$"
          )


          local blackMoney = 0
          local items = {}
          local weapons = {}

          -- TriggerEvent("esx_addonaccount:getAccount", "property" .. tostring(room) .. "_black_money", identifiers, function(account)
          -- blackMoney = account.money
          blackMoney = account.getMoney()
          TriggerEvent("esx_addoninventory:getInventory", "property" .. tostring(room), identifiers, function(inventory)
            items = inventory.items
            TriggerEvent("esx_datastore:getDataStore", "property" .. tostring(room), identifiers, function(store)
              weapons = store.get("weapons") or {}

              -- CB

              local totalWeight = 0
              for k, v in pairs(items) do
                totalWeight = totalWeight + (ESX.GetItemWeight(v.name) * v.count) -- whatever real KG
              end
              for k, v in pairs(weapons) do
                totalWeight = totalWeight + 5 -- each gun weighs 5kg
              end


              -- format weapons correctly
              for i = 1, #weapons, 1 do
                local weapon = weapons[i]

                weapons[i].weaponName = weapon.name
                weapons[i].name = weapon.name
                weapons[i].label = ESX.GetWeaponLabel(weapon.name)
                weapons[i].ammo = weapon.ammo
                weapons[i].components = weapon.components
                weapons[i].tint = weapon.tint or 0
              end


              local cbInventory = {
                blackMoney = blackMoney,
                items = items,
                weapons = weapons,
                weight = totalWeight * 1000,
                cash = 0
              }
              TriggerEvent("RoJea_cmds:global:refreshStorageInventory", source, baseNameR, "Nuosavybes spinta",
                Config.MaxStashWeight * 1000, cbInventory)
            end)
          end)
          -- end)
        else
          xPlayer.showNotification(_U("inv_sum_invalid"))
        end
      end
    )
  elseif typee == "item_weapon" then
    local weaponNum, hasweapon = xPlayer.getWeapon(item)
    if not hasweapon then
      TriggerEvent(
        "esx_datastore:getDataStore",
        "property" .. tostring(room),
        identifiers,
        function(store)
          local storeWeapons = store.get("weapons") or {}
          local weaponName = nil
          local ammo, components, tint
          local foundWeap = false


          for i = 1, #storeWeapons, 1 do
            if storeWeapons[i].name == item and storeWeapons[i].ammo == appendix.ammo then
              weaponName = storeWeapons[i].name
              ammo = storeWeapons[i].ammo
              components = storeWeapons[i].components
              tint = storeWeapons[i].tint
              foundWeap = true
              table.remove(storeWeapons, i)
              break
            end
          end
          if foundWeap then
            store.set("weapons", storeWeapons)
            xPlayer.addWeapon(weaponName, ammo)
            if components and next(components) then
              for _, v in pairs(components) do
                xPlayer.addWeaponComponent(weaponName, v)
              end
            end
            if tint ~= 0 then
              xPlayer.setWeaponTint(weaponName, tint)
            end
            TriggerEvent(
              "RoJea_transfers:propertyThingsAction",
              source,
              GetPlayerName(source),
              identifiers,
              Config.Properties[room].name,
              "withdraw",
              weaponName,
              1,
              "x"
            )


            local blackMoney = 0
            local items = {}
            local weapons = {}

            TriggerEvent("esx_addonaccount:getAccount", "property" .. tostring(room) .. "_black_money", identifiers,
              function(account)
                blackMoney = account.money
                TriggerEvent("esx_addoninventory:getInventory", "property" .. tostring(room), identifiers,
                  function(inventory)
                    items = inventory.items
                    -- TriggerEvent("esx_datastore:getDataStore", "property" .. tostring(room), identifiers, function(store)
                    -- weapons = store.get("weapons") or {}
                    weapons = storeWeapons

                    -- CB

                    local totalWeight = 0
                    for k, v in pairs(items) do
                      totalWeight = totalWeight + (ESX.GetItemWeight(v.name) * v.count) -- whatever real KG
                    end
                    for k, v in pairs(weapons) do
                      totalWeight = totalWeight + 5 -- each gun weighs 5kg
                    end


                    -- format weapons correctly
                    for i = 1, #weapons, 1 do
                      local weapon = weapons[i]

                      weapons[i].weaponName = weapon.name
                      weapons[i].name = weapon.name
                      weapons[i].label = ESX.GetWeaponLabel(weapon.name)
                      weapons[i].ammo = weapon.ammo
                      weapons[i].components = weapon.components
                      weapons[i].tint = weapon.tint or 0
                    end


                    local cbInventory = {
                      blackMoney = blackMoney,
                      items = items,
                      weapons = weapons,
                      weight = totalWeight * 1000,
                      cash = 0
                    }
                    TriggerEvent("RoJea_cmds:global:refreshStorageInventory", source, baseNameR, "Nuosavybes spinta",
                      Config.MaxStashWeight * 1000, cbInventory)
                  end)
                -- end)
              end)
          end
        end
      )
    else
      xPlayer.showNotification('Jau turite ši ginkla!')
    end
  else
    -- wrong type
    return
  end
end

function putToItemStorPriv(source, typeR, item, count, max_, baseNameR, room)
  local max = max_ / 1000
  local xPlayer = ESX.GetPlayerFromId(source)
  local identifiers = xPlayer.steam
  if typeR == "item_standard" then
    local playerItemCount = xPlayer.getInventoryItem(item).count
    if playerItemCount >= count and count > 0 then
      TriggerEvent(
        "esx_addoninventory:getInventory",
        "property" .. tostring(room),
        identifiers,
        function(inventory)
          TriggerEvent("esx_datastore:getDataStore", "property" .. tostring(room), identifiers, function(store)
            weapons = store.get("weapons") or {}


            local totalWeight = 0
            for k, v in pairs(inventory.getItems()) do
              totalWeight = totalWeight + (ESX.GetItemWeight(v.name) * v.count) -- whatever real KG
            end
            for k, v in pairs(weapons) do
              totalWeight = totalWeight + 5 -- each gun weighs 5kg
            end
            -- print(totalWeight+ESX.GetItemWeight(item)*count, max)
            if totalWeight + ESX.GetItemWeight(item) * count > max then
              return xPlayer.notif("Nera laisvos vietos!")
            end

            xPlayer.removeInventoryItem(item, count)
            inventory.addItem(item, count)
            xPlayer.showNotification(_U("you_have_deposited", count, inventory.getItem(item).label))
            TriggerEvent(
              "RoJea_transfers:propertyThingsAction",
              source,
              GetPlayerName(source),
              identifiers,
              Config.Properties[room].name,
              "deposit",
              item,
              count,
              "x"
            )

            local blackMoney = 0
            local items = {}


            TriggerEvent("esx_addonaccount:getAccount", "property" .. tostring(room) .. "_black_money", identifiers,
              function(account)
                blackMoney = account.money
                -- TriggerEvent("esx_addoninventory:getInventory", "property" .. tostring(room), identifiers, function(inventory)
                items = inventory.getItems()


                -- CB

                totalWeight = 0
                for k, v in pairs(items) do
                  totalWeight = totalWeight + (ESX.GetItemWeight(v.name) * v.count) -- whatever real KG
                end
                for k, v in pairs(weapons) do
                  totalWeight = totalWeight + 5 -- each gun weighs 5kg
                end


                -- format weapons correctly
                for i = 1, #weapons, 1 do
                  local weapon = weapons[i]

                  weapons[i].weaponName = weapon.name
                  weapons[i].name = weapon.name
                  weapons[i].label = ESX.GetWeaponLabel(weapon.name)
                  weapons[i].ammo = weapon.ammo
                  weapons[i].components = weapon.components
                  weapons[i].tint = weapon.tint or 0
                end


                local cbInventory = {
                  blackMoney = blackMoney,
                  items = items,
                  weapons = weapons,
                  weight = totalWeight * 1000,
                  cash = 0
                }
                TriggerEvent("RoJea_cmds:global:refreshStorageInventory", source, baseNameR, "Nuosavybes spinta",
                  Config.MaxStashWeight * 1000, cbInventory)


                -- end)
              end)
          end)
        end
      )
    else
      xPlayer.showNotification("Neteisingas kiekis!")
    end
  elseif typeR == "item_weapon" then
    if not xPlayer.hasWeapon(item) then
      return xPlayer.notif("Nebeturite šio ginklo!")
    end
    TriggerEvent(
      "esx_datastore:getDataStore",
      "property" .. tostring(room),
      identifiers,
      function(store)
        local storeWeapons = store.get("weapons") or {}

        -- save attachments
        local weaponNum, hasweapon = xPlayer.getWeapon(item)
        local loadout = xPlayer.getLoadout()
        local weaponObj = loadout[weaponNum]

        local weapComps = weaponObj.components or {}
        local tint = weaponObj.tint or 0

        table.insert(storeWeapons, {
          name = item,
          ammo = count,
          components = weapComps,
          tint = tint
        })
        store.set("weapons", storeWeapons)
        xPlayer.removeWeapon(item)
        TriggerEvent(
          "RoJea_transfers:propertyThingsAction",
          source,
          GetPlayerName(source),
          identifiers,
          Config.Properties[room].name,
          "deposit",
          item,
          1,
          "x"
        )

        local blackMoney = 0
        local items = {}
        local weapons = {}

        TriggerEvent("esx_addonaccount:getAccount", "property" .. tostring(room) .. "_black_money", identifiers,
          function(account)
            blackMoney = account.money
            TriggerEvent("esx_addoninventory:getInventory", "property" .. tostring(room), identifiers,
              function(inventory)
                items = inventory.items
                -- TriggerEvent("esx_datastore:getDataStore", "property" .. tostring(room), identifiers, function(store)
                -- weapons = store.get("weapons") or {}
                weapons = storeWeapons

                -- CB

                local totalWeight = 0
                for k, v in pairs(items) do
                  totalWeight = totalWeight + (ESX.GetItemWeight(v.name) * v.count) -- whatever real KG
                end
                for k, v in pairs(weapons) do
                  totalWeight = totalWeight + 5 -- each gun weighs 5kg
                end


                -- format weapons correctly
                for i = 1, #weapons, 1 do
                  local weapon = weapons[i]

                  weapons[i].weaponName = weapon.name
                  weapons[i].name = weapon.name
                  weapons[i].label = ESX.GetWeaponLabel(weapon.name)
                  weapons[i].ammo = weapon.ammo
                  weapons[i].components = weapon.components
                  weapons[i].tint = weapon.tint or 0
                end

                local cbInventory = {
                  blackMoney = blackMoney,
                  items = items,
                  weapons = weapons,
                  weight = totalWeight * 1000,
                  cash = 0
                }
                TriggerEvent("RoJea_cmds:global:refreshStorageInventory", source, baseNameR, "Nuosavybes spinta",
                  Config.MaxStashWeight * 1000, cbInventory)
              end)
            -- end)
          end)
      end
    )
  elseif typeR == "item_account" then
    local playerAccountMoney = xPlayer.getAccount(item).money
    if playerAccountMoney >= count and count > 0 then
      xPlayer.removeAccountMoney(item, count)
      TriggerEvent(
        "esx_addonaccount:getAccount",
        "property" .. tostring(room) .. "_" .. item,
        identifiers,
        function(account)
          account.addMoney(count)

          TriggerEvent(
            "RoJea_transfers:propertyThingsAction",
            source,
            GetPlayerName(source),
            identifiers,
            Config.Properties[room].name,
            "deposit",
            "Nešvarių pinigų",
            count,
            "$"
          )

          local blackMoney = 0
          local items = {}
          local weapons = {}

          -- TriggerEvent("esx_addonaccount:getAccount", "property" .. tostring(room) .. "_black_money", identifiers, function(account)
          -- blackMoney = account.money
          blackMoney = account.getMoney()
          TriggerEvent("esx_addoninventory:getInventory", "property" .. tostring(room), identifiers, function(inventory)
            items = inventory.items
            TriggerEvent("esx_datastore:getDataStore", "property" .. tostring(room), identifiers, function(store)
              weapons = store.get("weapons") or {}

              -- CB

              local totalWeight = 0
              for k, v in pairs(items) do
                totalWeight = totalWeight + (ESX.GetItemWeight(v.name) * v.count) -- whatever real KG
              end
              for k, v in pairs(weapons) do
                totalWeight = totalWeight + 5 -- each gun weighs 5kg
              end


              -- format weapons correctly
              for i = 1, #weapons, 1 do
                local weapon = weapons[i]

                weapons[i].weaponName = weapon.name
                weapons[i].name = weapon.name
                weapons[i].label = ESX.GetWeaponLabel(weapon.name)
                weapons[i].ammo = weapon.ammo
                weapons[i].components = weapon.components
                weapons[i].tint = weapon.tint or 0
              end

              local cbInventory = {
                blackMoney = blackMoney,
                items = items,
                weapons = weapons,
                weight = totalWeight * 1000,
                cash = 0
              }
              TriggerEvent("RoJea_cmds:global:refreshStorageInventory", source, baseNameR, "Nuosavybes spinta",
                Config.MaxStashWeight * 1000, cbInventory)
            end)
          end)
        end
      )
      -- end)
    else
      xPlayer.showNotification("Neteisinga suma!")
    end
  else
    -- wrong type?
    return
  end
end

-- NEW STORAGE

TriggerEvent("es:addGroupCommand", "giveimporthouse", "superadmin", function(source, args, user)
    local targetId = tonumber(args[1])
    local targetRoom = tonumber(args[2])
    if not currentlyWhitelisted[targetId] then
      currentlyWhitelisted[targetId] = {}
      currentlyWhitelisted[targetId][targetRoom] = true
    else
      currentlyWhitelisted[targetId][targetRoom] = true
    end
    TriggerClientEvent("RoJea_property:perpert", targetId, targetRoom)
    if source ~= 0 then
      TriggerClientEvent("chat:addMessage", source, { args = { "^1SISTEMA", "Veiksmas sekmingas!" } })
    else
      print("[RoJea_cmds] Sekmingas veiksmas!")
    end
  end, function(source, args, user)
    TriggerClientEvent("chat:addMessage", source, { args = { "^1SISTEMA", "Neturite teisiu!" } })
  end,
  { help = "Leidžia pirkti importine nuosavybe", params = { { name = "id", help = "žmogaus id" }, { name = "nuosavybe", help = "nuosavybes numeris" } } })

AddEventHandler("RoJea_property:clearHouseOwner", function(room)
  if room then
    MySQL.Async.fetchAll(
      "SELECT * FROM `rojea_property` WHERE `id` = @id",
      {
        ["@id"] = room
      },
      function(result)
        if result[1] then
          local targIdentf = result[1].identifier
          MySQL.Async.execute(
            "DELETE FROM `rojea_property` WHERE `id` = @id",
            {
              ["@id"] = room
            },
            function(rowsChanged)
              if rowsChanged == 1 then
                ownedProperties[room] = nil
                local xPlayer = ESX.GetPlayerFromIdentifier(targIdentf)
                if xPlayer then
                  TriggerClientEvent("RoJea_property:syncSoldProperty", -1, xPlayer.source, ownedProperties, room)
                else
                  TriggerClientEvent("RoJea_property:syncSoldProperty", -1, 0, ownedProperties, room)
                end
                deletePropertyInventory(room, targIdentf)
                TriggerClientEvent(
                  "chat:addMessage",
                  source,
                  { args = { "^1SISTEMA", "Sekmingai pašalinote nuosavybes savininka!" } }
                )
                TriggerEvent("RoJea_property:sendPropertyListServer")
              end
            end
          )
        end
      end
    )
  else
    TriggerClientEvent("chat:addMessage", source, { args = { "^1SISTEMA", "Neteisingas nuosavybes numeris" } })
  end
end)

RegisterNetEvent("RoJea_property:invitePlayers")
AddEventHandler(
  "RoJea_property:invitePlayers",
  function(place)
    TriggerClientEvent("RoJea_property:inviteToTheHouse", -1, place)
  end
)

RegisterNetEvent("RoJea_property:savedecorations", function(house, decorations)
  local _source = source
  local xPlayer = ESX.ply(_source)

  if ownedProperties[house] ~= xPlayer.identifier then
    -- not the owner
    xPlayer.notif("~r~Jums nepriklauso ši nuosavybe!")
    return
  end

  MySQL.Async.execute('UPDATE rojea_property SET furniture = @furniture WHERE id = @id', {
    ["@furniture"] = json.encode(decorations),
    ["@id"] = house
  }, function(rowsChanged)
    TriggerClientEvent('RoJea_property:sethousedecorations', -1, house, decorations)
  end)
end)

ESX.RSC('RoJea_property:buyFurniture', function(source, cb, homeId, price)
  local xPlayer = ESX.ply(source)
  if ownedProperties[homeId] ~= xPlayer.identifier then
    -- not the owner
    xPlayer.notif("~r~Jums nepriklauso ši nuosavybe!")
    return cb(false)
  end
  if xPlayer.getMoney() >= price then
    xPlayer.removeMoney(price)
    cb(true)
  else
    xPlayer.notif("~r~Neturite pakankamai pinigu!")
    cb(false)
  end
end)

ESX.RSC('RoJea_property:getHouseDecorations', function(source, cb, homeId)
  MySQL.Async.fetch("SELECT furniture FROM rojea_property WHERE id = @id", {
    ["@id"] = homeId
  }, function(res)
    if res[1] and res[1].furniture ~= nil then
      cb(json.decode(res[1].furniture))
    else
      cb(nil)
    end
  end)
end)

ESX.RegisterServerCallback('esx_clotheshop:checkPropertyClothing', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local alreadyOwned = 0
  for k, v in pairs(ownedProperties) do
    if v == xPlayer.identifier then
      alreadyOwned = alreadyOwned + 1
    end
  end
  if alreadyOwned == 0 then return cb(false) end
  local clothesLimit = specialOutfitSlots[xPlayer.steam] or Config.ClothesLimit
  MySQL.Async.fetchAll("SELECT * FROM `rojea_property_clothing` WHERE `identifier` = @identifier", {
    ['@identifier'] = xPlayer.steam
  }, function(clothes)
    local clothesList = {}
    if type(clothes) == "table" and clothes[1] and json.decode(clothes[1].clothes) then
      clothesList = json.decode(
        clothes[1].clothes)
    end
    clothesListCache[xPlayer.steam] = clothesList
    if #clothesList < clothesLimit then
      cb(true)
    else
      cb('limit')
    end
  end)
end)

ESX.RegisterServerCallback("RoJea_property:fetchMyClothesList", function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local elements = {}
  MySQL.Async.fetchAll("SELECT * FROM `rojea_property_clothing` WHERE `identifier` = @identifier", {
    ['@identifier'] = xPlayer.steam
  }, function(clothes)
    local clothesList = clothes[1] and json.decode(clothes[1].clothes) or {}
    if next(clothesList) then
      for _, v in pairs(clothesList) do
        table.insert(elements, {
          label = v.title,
          value = v.clothes
        })
      end
      -- table.insert(elements, {
      --   label = '<span style="color: red;">Išvalyti drabužiu spinta</span>',
      --   value = 'clear'
      -- })
    else
      elements = clothesList
    end
    cb(elements)
  end)
end)

ESX.RegisterServerCallback("RoJea_property:cleanPropertyClothes", function(source, cb, title)
  local xPlayer = ESX.GetPlayerFromId(source)
  local alreadyOwned = 0
  for k, v in pairs(ownedProperties) do
    if v == xPlayer.identifier then
      alreadyOwned = alreadyOwned + 1
    end
  end
  if alreadyOwned ~= 0 then
    -- delete specific
    MySQL.Async.fetchAll("SELECT * FROM `rojea_property_clothing` WHERE `identifier` = @identifier", {
      ['@identifier'] = xPlayer.steam
    }, function(clothes)
      local clothesList = clothes[1] and json.decode(clothes[1].clothes) or {}
      local foundIndex
      if next(clothesList) then
        for k, v in pairs(clothesList) do
          if v.title == title then
            foundIndex = k
            break
          end
        end
      end
      if foundIndex then
        table.remove(clothesList, foundIndex)

        if next(clothesList) then -- still left
          MySQL.Async.execute(
            "UPDATE `rojea_property_clothing` SET `clothes` = @clothes WHERE `identifier` = @identifier", {
              ["@clothes"] = json.encode(clothesList),
              ["@identifier"] = xPlayer.steam
            }, function(rowsChanged)
            end)
        else -- delete whole entry
          MySQL.Async.execute("DELETE FROM `rojea_property_clothing` WHERE `identifier` = @identifier", {
            ["@identifier"] = xPlayer.steam
          }, function(rowsChanged)
          end)
        end

        cb(true)
      else
        cb(false)
      end
    end)
  else
    -- ban him
    cb(false)
  end
end)

ESX.RegisterServerCallback('esx_clotheshop:tryBuyingPropertyClothing', function(source, cb, clothes, title)
  local xPlayer = ESX.GetPlayerFromId(source)
  local steam = xPlayer.steam
  local thePrice = Config.ClothingPrice
  local alreadyOwned = 0
  for k, v in pairs(ownedProperties) do
    if v == steam then
      alreadyOwned = alreadyOwned + 1
    end
  end
  local clothesLimit = specialOutfitSlots[steam] or Config.ClothesLimit
  if alreadyOwned == 0 or not clothesListCache[steam] or #clothesListCache[steam] >= clothesLimit then
    -- ban him

    return cb(false)
  end
  if xPlayer.getMoney() < thePrice then
    cb(false)
  else
    xPlayer.removeMoney(thePrice)
    local locClothes = {
      title = title,
      clothes = clothes
    }
    table.insert(clothesListCache[steam], locClothes)
    if #clothesListCache[steam] == 1 then
      MySQL.Async.execute("INSERT INTO `rojea_property_clothing` (identifier, clothes) VALUES (@identifier, @clothes)", {
        ["@identifier"] = steam,
        ["@clothes"] = json.encode(clothesListCache[steam])
      }, function(rowsChanged)
        cb(true)
      end)
    else
      MySQL.Async.execute("UPDATE `rojea_property_clothing` SET `clothes` = @clothes WHERE `identifier` = @identifier", {
        ["@clothes"] = json.encode(clothesListCache[steam]),
        ["@identifier"] = steam
      }, function(rowsChanged)
        cb(true)
      end)
    end
  end
end)

ESX.RegisterServerCallback(
  "RoJea_property:getMyPropertyList",
  function(source, cb)
    local steam
    for k, v in pairs(GetPlayerIdentifiers(source)) do
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        steam = v
        break
      end
    end
    local myProperties = {}
    for k, v in pairs(ownedProperties) do
      if v == steam then
        table.insert(myProperties, k)
      end
    end
    cb(myProperties)
  end
)

ESX.RegisterServerCallback(
  "RoJea_property:getOwnedProperties",
  function(source, cb)
    cb(ownedProperties)
  end
)

ESX.RegisterServerCallback(
  "RoJea_property:tryBuyingProperty",
  function(source, cb, number, target)
    local identifier
    for k, v in pairs(GetPlayerIdentifiers(target or source)) do
      if string.sub(v, 1, string.len("steam:")) == "steam:" then
        identifier = v
        break
      end
    end

    local xPlayer = ESX.GetPlayerFromId(source)

    local xTarget
    if target then
      xTarget = ESX.GetPlayerFromId(target)
      if not waitingForTrade[xTarget.src] or waitingForTrade[xTarget.src] ~= number then
        -- ban him
        return cb("failed")
      else
        waitingForTrade[xTarget.src] = nil
      end
    elseif Config.Properties[number].premium then
      if not xPlayer.rojea then
        if currentlyWhitelisted[source] and currentlyWhitelisted[source][number] then
          -- he's good
          --currentlyWhitelisted[source][number] = nil
        else
          -- ban him
          
          return cb("failed")
        end
      end
    end

    local price = target and 0 or Config.Properties[number].price
    if target or xPlayer.getMoney() >= price then
      local alreadyOwned = 0
      for k, v in pairs(ownedProperties) do
        if v == identifier then
          alreadyOwned = alreadyOwned + 1
        end
      end
      if alreadyOwned < Config.MaxProperties or ownerCheck(identifier) or Config.Properties[number].premium then
        MySQL.Async.execute(
          "INSERT INTO `rojea_property` (id, identifier, premium) VALUES (@id, @identifier, @premium)",
          {
            ["@id"] = number,
            ["@identifier"] = identifier,
            ["@premium"] = Config.Properties[number].premium and 1 or 0
          },
          function(rowsChanged)
            if rowsChanged == 1 then
              if price ~= 0 then
                xPlayer.removeMoney(price)
              end
              if not target then
                TriggerEvent(
                  "RoJea_transfers:propertyAction",
                  "buy",
                  (target or source),
                  GetPlayerName((target or source)),
                  identifier,
                  Config.Properties[number].name,
                  price
                )
              else
                TriggerEvent(
                  "RoJea_transfers:propertyAction",
                  "trade",
                  xPlayer.src,
                  xPlayer.name,
                  xPlayer.steam,
                  xTarget.src,
                  xTarget.name,
                  xTarget.steam,
                  Config.Properties[number].name,
                  Config.Properties[number].price
                )
              end
              ownedProperties[number] = identifier
              TriggerEvent("RoJea_property:newBoughtProperty", identifier, number)
              TriggerClientEvent("RoJea_property:syncBoughtProperty", -1, (target or source), ownedProperties, number)
              TriggerEvent("RoJea_property:sendPropertyListServer")
              if target then
                TriggerClientEvent(
                  "esx:showNotification",
                  target,
                  _U("you_got_from_trade", Config.Properties[number].name)
                )
              end
              cb(price)
            else
              cb("failed")
            end
          end
        )
      else
        cb("maxprops")
      end
    elseif xPlayer.getAccount("bank").money >= price then
      local alreadyOwned = 0
      for k, v in pairs(ownedProperties) do
        if v == identifier then
          alreadyOwned = alreadyOwned + 1
        end
      end
      if alreadyOwned < Config.MaxProperties or ownerCheck(identifier) then
        MySQL.Async.execute(
          "INSERT INTO `rojea_property` (id, identifier, premium) VALUES (@id, @identifier, @premium)",
          {
            ["@id"] = number,
            ["@identifier"] = identifier,
            ["@premium"] = Config.Properties[number].premium and 1 or 0
          },
          function(rowsChanged)
            if rowsChanged == 1 then
              xPlayer.removeAccountMoney("bank", price)
              TriggerEvent(
                "RoJea_transfers:propertyAction",
                "buy",
                source,
                GetPlayerName(source),
                identifier,
                Config.Properties[number].name,
                price
              )
              ownedProperties[number] = identifier
              TriggerEvent("RoJea_property:newBoughtProperty", identifier, number)
              TriggerClientEvent("RoJea_property:syncBoughtProperty", -1, source, ownedProperties, number)
              TriggerEvent("RoJea_property:sendPropertyListServer")
              cb(price)
            else
              cb("failed")
            end
          end
        )
      else
        cb("maxprops")
      end
    else
      cb("nomoney")
    end
  end
)

ESX.RegisterServerCallback(
  "RoJea_property:sellProperty",
  function(source, cb, property, rawPrice, targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = rawPrice
    if not price or price == '' then
      price = "traded"
      
    end

    local identifiers = xPlayer.steam

    local realPrice = math.floor(Config.Properties[property].price / 100 * Config.SellPercentage)

    if price ~= "traded" and realPrice ~= price then
      -- ban him
      return cb()
    end

    if price == "traded" then
      if not targetId or not GetPlayerName(targetId) then
        return cb("nonexist")
      elseif targetId == xPlayer.src then
        return cb("self")
      end
    end

    local xTarget

    if not ownedProperties[property] or ownedProperties[property] ~= identifiers then
      -- ban him
      return cb()
    end

    local item = xPlayer.getInventoryItem("housecontract")
    if price == "traded" then
      xTarget = ESX.GetPlayerFromId(targetId)
      if not item or not item.count or item.count <= 0 then
        return cb()
      else
        local alreadyOwned = 0
        for k, v in pairs(ownedProperties) do
          if v == xTarget.identifier then
            alreadyOwned = alreadyOwned + 1
          end
        end
        if alreadyOwned + 1 >= Config.MaxProperties then
          if not Config.Properties[property].premium then
            return cb('targetLimit')
          end
        end
      end
    end
    MySQL.Async.execute(
      "DELETE FROM `rojea_property` WHERE `id` = @id",
      {
        ["@id"] = property
      },
      function(rowsChanged)
        if rowsChanged == 1 then
          deletePropertyInventory(property, playerIdentifier)
          if price ~= "traded" then
            xPlayer.addAccountMoney("bank", price)
            TriggerEvent(
              "RoJea_transfers:propertyAction",
              "sell",
              source,
              GetPlayerName(source),
              identifiers,
              Config.Properties[property].name,
              price
            )
          else
            xPlayer.removeInventoryItem("housecontract", 1)
            waitingForTrade[targetId] = property
          end
          ownedProperties[property] = nil
          TriggerClientEvent("RoJea_property:syncSoldProperty", -1, source, ownedProperties, property)
          TriggerEvent("RoJea_property:sendPropertyListServer")
          cb(price)
        else
          cb("failed")
        end
      end
    )
  end
)

ESX.RegisterServerCallback(
  "RoJea_property:getOwnerInventory",
  function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local blackMoney = xPlayer.getAccount("black_money").money
    local items = xPlayer.inventory
    cb({ blackMoney = blackMoney, items = items, weapons = xPlayer.getLoadout() })
  end
)

ESX.RegisterServerCallback(
  "RoJea_property:getMyPropertyInventory",
  function(source, cb, room)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifiers = xPlayer.steam

    if ownedProperties[room] ~= identifiers then
      -- ban him
      return cb()
    end

    local blackMoney = 0
    local items = {}
    local weapons = {}

    TriggerEvent(
      "esx_addonaccount:getAccount",
      "property" .. tostring(room) .. "_black_money",
      identifiers,
      function(account)
        blackMoney = account.money
      end
    )

    TriggerEvent(
      "esx_addoninventory:getInventory",
      "property" .. tostring(room),
      identifiers,
      function(inventory)
        items = inventory.items
      end
    )

    TriggerEvent(
      "esx_datastore:getDataStore",
      "property" .. tostring(room),
      identifiers,
      function(store)
        weapons = store.get("weapons") or {}
      end
    )

    cb({ blackMoney = blackMoney, items = items, weapons = weapons })
  end
)

function deletePropertyInventory(room, identifiers)
  TriggerEvent(
    "esx_datastore:getDataStore",
    "property" .. tostring(room),
    identifiers,
    function(store)
      store.set("weapons", {})
    end
  )
  TriggerEvent(
    "esx_addoninventory:getInventory",
    "property" .. tostring(room),
    identifiers,
    function(inventory)
      if inventory then
        local theItems = inventory.items
        for i = 1, #theItems, 1 do
          local name = theItems[i].name
          local count = theItems[i].count
          inventory.removeItem(name, count)
        end
      end
    end
  )
  TriggerEvent(
    "esx_addonaccount:getAccount",
    "property" .. tostring(room) .. "_black_money",
    identifiers,
    function(account)
      if account then
        account.setMoney(0)
      end
    end
  )
end
