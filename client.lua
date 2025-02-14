
ESX = nil

local ox_inventory = exports.ox_inventory

local ownedProperties, publicBlipList, privateBlipList, myIdentifier = {}, {}, {}, nil
local HasAlreadyEnteredMarker, LastZone, lastPart, CurrentAction, CurrentActionMsg, CurrentActionData = false, nil, nil,
    nil, '', {}
local currentlySleeping = false
local currentlyWhitelisted = {}
local PlayerData = {}

-- for decorations
ClosestHouse = nil
local homeCache = {}


-- ESX thread
CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Wait(0)
  end
end)

-- Startup event
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  --ESX.TriggerServerCallback('RoJea_property:getmyIdentifier', function(steam)
  myIdentifier = xPlayer.identifier
  ESX.TriggerServerCallback('RoJea_property:getOwnedProperties', function(list)
    ownedProperties = list
    createBlips()
  end)
  --end)
end)


function decorateHouse()
  if ClosestHouse ~= nil then
    if ownedProperties[ClosestHouse] ~= myIdentifier then
      ESX.ShowNotification("~r~Nesate namo savininkas!")
    else
      TriggerServerEvent("RoJea_cmds2:server:decoratingStart")
      TriggerEvent("RoJea_property:global:decorate")
    end
  else
    ESX.ShowNotification("~r~Nesate namo viduje! ~y~Naudokites pagrindiniu iejimu!")
  end
end

-- end, false)
-- TriggerEvent('chat:addSuggestion', '/dekoruoti', 'dekoruoti savo apartamenta', {})


local function UnloadDecorations()
  if ObjectList ~= nil then
    for _, v in pairs(ObjectList) do
      if DoesEntityExist(v.object) then
        DeleteObject(v.object)
      end
    end
  end
end

local function LoadDecorations(house)
  ClosestHouse = house
  UnloadDecorations()
  Wait(500)

  if homeCache[house] == nil then homeCache[house] = {} end

  if homeCache[house].decorations == nil or next(homeCache[house].decorations) == nil then
    ESX.TSC('RoJea_property:getHouseDecorations', function(result)
      if result == nil then
        -- no furniture available
      else
        homeCache[house].decorations = result
        if homeCache[house].decorations ~= nil then
          ObjectList = {}
          for k, _ in pairs(homeCache[house].decorations) do
            if homeCache[house].decorations[k] ~= nil then
              if homeCache[house].decorations[k].object ~= nil then
                if DoesEntityExist(homeCache[house].decorations[k].object) then
                  DeleteObject(homeCache[house].decorations[k].object)
                end
              end
              local modelHash = GetHashKey(homeCache[house].decorations[k].hashname)
              RequestModel(modelHash)
              while not HasModelLoaded(modelHash) do
                Wait(10)
              end
              local decorateObject = CreateObject(modelHash, homeCache[house].decorations[k].x,
                homeCache[house].decorations[k].y, homeCache[house].decorations[k].z, false, false, false)
              FreezeEntityPosition(decorateObject, true)
              SetEntityCoordsNoOffset(decorateObject, homeCache[house].decorations[k].x,
                homeCache[house].decorations[k].y, homeCache[house].decorations[k].z)
              SetEntityRotation(decorateObject, homeCache[house].decorations[k].rotx,
                homeCache[house].decorations[k].roty, homeCache[house].decorations[k].rotz)
              ObjectList[homeCache[house].decorations[k].objectId] = {
                hashname = homeCache[house].decorations[k]
                    .hashname,
                x = homeCache[house].decorations[k].x,
                y = homeCache[house].decorations[k].y,
                z = homeCache
                    [house].decorations[k].z,
                rotx = homeCache[house].decorations[k].rotx,
                roty = homeCache[house]
                    .decorations[k].roty,
                rotz = homeCache[house].decorations[k].rotz,
                object = decorateObject,
                objectId =
                    homeCache[house].decorations[k].objectId
              }
            end
          end
        end
      end
    end, house)
  elseif homeCache[house].decorations ~= nil then
    ObjectList = {}
    for k, _ in pairs(homeCache[house].decorations) do
      if homeCache[house].decorations[k] ~= nil then
        if homeCache[house].decorations[k].object ~= nil then
          if DoesEntityExist(homeCache[house].decorations[k].object) then
            DeleteObject(homeCache[house].decorations[k].object)
          end
        end
        local modelHash = GetHashKey(homeCache[house].decorations[k].hashname)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
          Wait(10)
        end
        local decorateObject = CreateObject(modelHash, homeCache[house].decorations[k].x,
          homeCache[house].decorations[k].y, homeCache[house].decorations[k].z, false, false, false)
        PlaceObjectOnGroundProperly(decorateObject)
        FreezeEntityPosition(decorateObject, true)
        SetEntityCoordsNoOffset(decorateObject, homeCache[house].decorations[k].x, homeCache[house].decorations[k].y,
          homeCache[house].decorations[k].z)
        homeCache[house].decorations[k].object = decorateObject
        SetEntityRotation(decorateObject, homeCache[house].decorations[k].rotx, homeCache[house].decorations[k].roty,
          homeCache[house].decorations[k].rotz)
        ObjectList[homeCache[house].decorations[k].objectId] = {
          hashname = homeCache[house].decorations[k].hashname,
          x =
              homeCache[house].decorations[k].x,
          y = homeCache[house].decorations[k].y,
          z = homeCache[house].decorations[k]
              .z,
          rotx = homeCache[house].decorations[k].rotx,
          roty = homeCache[house].decorations[k].roty,
          rotz = homeCache
              [house].decorations[k].rotz,
          object = decorateObject,
          objectId = homeCache[house].decorations[k].objectId
        }
      end
    end
  end
end

RegisterNetEvent('RoJea_property:sethousedecorations', function(house, decorations)
  if homeCache[house] == nil then homeCache[house] = {} end
  homeCache[house].decorations = decorations
  if ClosestHouse == house then
    LoadDecorations(house)
  end
end)

RegisterNetEvent("RoJea_property:perpert")
AddEventHandler("RoJea_property:perpert", function(room)
  currentlyWhitelisted[room] = true
end)

-- Blip Updating
RegisterNetEvent('RoJea_property:updateBlips')
AddEventHandler('RoJea_property:updateBlips', function(typeS, action, id)
  updateBlips(typeS, action, id)
end)

-- Entering Event
AddEventHandler('RoJea_property:hasEnteredMarker', function(enteredZone, enteredPart)
  if enteredZone == "exiting_marker_property" then
    CurrentAction = 'exit_property'
    CurrentActionMsg = _U('press_to_exit_property', Config.Properties[enteredPart].name)
    CurrentActionData = { propNumber = enteredPart }
  elseif enteredZone == "entering_marker_property" then
    local ownerIdentifier = ownedProperties[enteredPart]
    if DoesBlipExist(publicBlipList[enteredPart]) or PlayerData.rojea then
      -- if Config.Properties[enteredPart].premium and ownerCheck() then
      -- 	CurrentAction = 'enter_property_free'
      -- 	CurrentActionMsg = _U('press_to_buy_property')
      -- 	CurrentActionData = {propNumber = enteredPart}
      -- elseif Config.Properties[enteredPart].premium then
      -- 	CurrentAction = 'enter_property_premium'
      -- 	CurrentActionMsg = _U('cannot_buy_premium')
      -- 	CurrentActionData = {propNumber = enteredPart}
      -- else
      CurrentAction = 'enter_property_free'
      CurrentActionMsg = _U('press_to_buy_property')
      CurrentActionData = { propNumber = enteredPart }
      -- end
    elseif ownedProperties[enteredPart] == myIdentifier then
      CurrentAction = 'enter_property_owner'
      CurrentActionMsg = _U('press_to_enter_property', Config.Properties[enteredPart].name)
      CurrentActionData = { propNumber = enteredPart }
    else
      CurrentAction = 'enter_property_citizen'
      CurrentActionMsg = _U('please_wait_for_owner')
      CurrentActionData = {}
    end
  elseif enteredZone == "actions_marker_property" then
    CurrentAction = 'actions_property'
    CurrentActionMsg = _U('press_to_open_actions')
    CurrentActionData = { propNumber = enteredPart }
    EnteredArmory = true
    TriggerEvent('esx_inventoryhud:forceClose')
    TriggerServerEvent('RoJea_cmds:removeAddSearch', GetPlayerServerId(PlayerId()), "armory", "add", "property")
  end
end)

-- Exiting Event
AddEventHandler('RoJea_property:hasExitedMarker', function(exitedZone, exitedPart)
  if exitedZone == "actions_marker_property" then
    EnteredArmory = false
    TriggerServerEvent('RoJea_cmds:removeAddSearch', GetPlayerServerId(PlayerId()), "armory", "remove", "property")
  end
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
  CurrentActionMsg = ''
  CurrentActionData = {}
end)

-- Key Controls and Help Notifications
CreateThread(function()
  while true do
    Wait(0)
    if CurrentAction ~= nil then
      -- Show Help Notification
      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
      -- Key controls
      if IsControlJustReleased(0, 38) then -- E key
        if CurrentAction == 'enter_property_free' then
          openVisitorMenu(CurrentActionData.propNumber)
        elseif CurrentAction == 'exit_property' then
          teleportUser(PlayerPedId(), Config.Properties[CurrentActionData.propNumber].enter)
          UnloadDecorations(CurrentActionData.propNumber)
          ClosestHouse = nil
        elseif CurrentAction == 'enter_property_owner' then
          teleportUser(PlayerPedId(), Config.Properties[CurrentActionData.propNumber].exit)
          LoadDecorations(CurrentActionData.propNumber)
        elseif CurrentAction == 'actions_property' then
          openPropertyActions(CurrentActionData.propNumber)
        end
        if CurrentAction ~= 'enter_property_citizen' and CurrentAction ~= 'enter_property_premium' then
          CurrentAction = nil
        end
      end
    else
      Wait(500)
    end
  end
end)

-- Control disable thread
CreateThread(function()
  while true do
    Wait(0)
    if currentlySleeping == true then
      DisableAllControlActions(0) -- Disable everything
    end
    if EnteredArmory == true then
      DisableControlAction(0, 289, true) -- Inventory
      DisableControlAction(0, 167, true) -- F6 Key
    end
    if not currentlySleeping and not EnteredArmory then
      Wait(500)
    end
  end
end)

-- Marker Thread
CreateThread(function()
  while true do
    Wait(0)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local isInMarker, letSleep, currentZone, currentPart = false, true, nil, nil
    -- Create Enter Markers
    for k, v in pairs(Config.Properties) do
      local distance = #(playerCoords - v.enter)
      if distance < Config.DrawDistance then
        letSleep = false
        if ownedProperties[k] == myIdentifier then
          DrawMarker(Config.EnterMarker.type, v.enter - Config.EnterMarker.offset, 0.0, 0.0, 0.0,
            Config.EnterMarker.rotation.x, Config.EnterMarker.rotation.y, Config.EnterMarker.rotation.z,
            Config.EnterMarker.scale.x, Config.EnterMarker.scale.y, Config.EnterMarker.scale.z,
            Config.EnterMarker.ownedcolor.r, Config.EnterMarker.ownedcolor.g, Config.EnterMarker.ownedcolor.b,
            Config.EnterMarker.ownedcolor.a, Config.EnterMarker.bobUpDown, Config.EnterMarker.faceCamera, 2, false,
            false, false, false)
        elseif not DoesBlipExist(publicBlipList[k]) then
          DrawMarker(Config.EnterMarker.type, v.enter - Config.EnterMarker.offset, 0.0, 0.0, 0.0,
            Config.EnterMarker.rotation.x, Config.EnterMarker.rotation.y, Config.EnterMarker.rotation.z,
            Config.EnterMarker.scale.x, Config.EnterMarker.scale.y, Config.EnterMarker.scale.z,
            Config.EnterMarker.occupiedcolor.r, Config.EnterMarker.occupiedcolor.g, Config.EnterMarker.occupiedcolor.b,
            Config.EnterMarker.occupiedcolor.a, Config.EnterMarker.bobUpDown, Config.EnterMarker.faceCamera, 2, false,
            false, false, false)
        elseif v.premium then
          DrawMarker(Config.EnterMarker.type, v.enter - Config.EnterMarker.offset, 0.0, 0.0, 0.0,
            Config.EnterMarker.rotation.x, Config.EnterMarker.rotation.y, Config.EnterMarker.rotation.z,
            Config.EnterMarker.scale.x, Config.EnterMarker.scale.y, Config.EnterMarker.scale.z,
            Config.EnterMarker.premiumcolor.r, Config.EnterMarker.premiumcolor.g, Config.EnterMarker.premiumcolor.b,
            Config.EnterMarker.premiumcolor.a, Config.EnterMarker.bobUpDown, Config.EnterMarker.faceCamera, 2, false,
            false, false, false)
        else
          DrawMarker(Config.EnterMarker.type, v.enter - Config.EnterMarker.offset, 0.0, 0.0, 0.0,
            Config.EnterMarker.rotation.x, Config.EnterMarker.rotation.y, Config.EnterMarker.rotation.z,
            Config.EnterMarker.scale.x, Config.EnterMarker.scale.y, Config.EnterMarker.scale.z,
            Config.EnterMarker.color.r, Config.EnterMarker.color.g, Config.EnterMarker.color.b,
            Config.EnterMarker.color.a, Config.EnterMarker.bobUpDown, Config.EnterMarker.faceCamera, 2, false, false,
            false, false)
        end
        if distance < Config.EnterMarker.scale.x then
          isInMarker, currentZone, currentPart = true, 'entering_marker_property', k
        end
      end
    end
    -- Create Exit Markers
    for k, v in pairs(Config.Properties) do
      local distance = #(playerCoords - v.exit)
      if distance < Config.DrawDistance then
        letSleep = false
        DrawMarker(Config.ExitMarker.type, v.exit - Config.ExitMarker.offset, 0.0, 0.0, 0.0,
          Config.ExitMarker.rotation.x, Config.ExitMarker.rotation.y, Config.ExitMarker.rotation.z,
          Config.ExitMarker.scale.x, Config.ExitMarker.scale.y, Config.ExitMarker.scale.z, Config.ExitMarker.color.r,
          Config.ExitMarker.color.g, Config.ExitMarker.color.b, Config.ExitMarker.color.a, Config.ExitMarker.bobUpDown,
          Config.ExitMarker.faceCamera, 2, false, false, false, false)
        if distance < Config.ExitMarker.scale.x then
          isInMarker, currentZone, currentPart = true, 'exiting_marker_property', k
        end
      end
    end
    -- Create Actions Markers
    for k, v in pairs(Config.Properties) do
      local distance = #(playerCoords - v.actions)
      if distance < Config.DrawDistance then
        if ownedProperties[k] == myIdentifier then
          letSleep = false
          DrawMarker(Config.ActionsMarker.type, v.actions - Config.ActionsMarker.offset, 0.0, 0.0, 0.0,
            Config.ActionsMarker.rotation.x, Config.ActionsMarker.rotation.y, Config.ActionsMarker.rotation.z,
            Config.ActionsMarker.scale.x, Config.ActionsMarker.scale.y, Config.ActionsMarker.scale.z,
            Config.ActionsMarker.color.r, Config.ActionsMarker.color.g, Config.ActionsMarker.color.b,
            Config.ActionsMarker.color.a, Config.ActionsMarker.bobUpDown, Config.ActionsMarker.faceCamera, 2, false,
            false, false, false)
          if distance < Config.ActionsMarker.scale.x then
            isInMarker, currentZone, currentPart = true, 'actions_marker_property', k
          end
        end
      end
    end
    -- Events
    if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and (LastZone ~= currentZone or lastPart ~= currentPart)) then
      HasAlreadyEnteredMarker, LastZone = true, currentZone
      LastZone = currentZone
      lastPart = currentPart
      TriggerEvent('RoJea_property:hasEnteredMarker', currentZone, currentPart)
    end

    if not isInMarker and HasAlreadyEnteredMarker then
      HasAlreadyEnteredMarker = false
      TriggerEvent('RoJea_property:hasExitedMarker', LastZone, lastPart)
    end
    -- Sleep
    if letSleep then
      Wait(500)
    end
  end
end)

local function openStashFoo(room)
  if ox_inventory:openInventory('stash', { id = ("property_" .. room), owner = myIdentifier }) == false then
    ESX.TSC("RoJea_property:registerMyNewStash", function(stat)
      -- try again
      if stat ~= true then return end
      ox_inventory:openInventory('stash', { id = ("property_" .. room), owner = myIdentifier })
    end, room)
  end
end

RegisterNetEvent('RoJea_property:inviteToTheHouse')
AddEventHandler('RoJea_property:inviteToTheHouse', function(roomNumber)
  local playerPed = PlayerPedId()
  local myCoords = GetEntityCoords(playerPed)
  local theDistance = #(myCoords - Config.Properties[roomNumber].enter)
  if theDistance <= Config.EnterMarker.scale.x + 2.8 then -- if <= 4.0
    teleportUser(playerPed, Config.Properties[roomNumber].exit)
    LoadDecorations(roomNumber)
    ESX.ShowNotification(_U('you_were_invited', Config.Properties[roomNumber].name))
  end
end)

RegisterNetEvent('RoJea_property:syncBoughtProperty')
AddEventHandler('RoJea_property:syncBoughtProperty', function(owner, list, room)
  local sourceID = GetPlayerServerId(PlayerId())
  ownedProperties = list
  if owner == sourceID then
    updateBlips("free", "remove", room)
    updateBlips("owned", "add", room)
  else
    updateBlips("free", "remove", room)
  end
end)

RegisterNetEvent('RoJea_property:syncSoldProperty')
AddEventHandler('RoJea_property:syncSoldProperty', function(owner, list, room)
  local sourceID = GetPlayerServerId(PlayerId())
  ownedProperties = list
  if owner == sourceID then
    updateBlips("free", "add", room)
    updateBlips("owned", "remove", room)
  else
    updateBlips("free", "add", room)
  end
end)

function sleep()
  currentlySleeping = true
  exports['progressBar']:drawBar(10000, _U('sleeping'), nil, { color = "#34ebc3" })
  DoScreenFadeOut(2000)
  Wait(10000)
  DoScreenFadeIn(1000)
  TriggerEvent('esx_status:add', 'sleep', 1000000)
  ESX.ShowNotification(_U('successfully_slept'))
  currentlySleeping = false
end

function openPropertyActions(room)
  local sellingPrice = math.floor(Config.Properties[room].price / 100 * Config.SellPercentage)
  local elements = {
    { label = _U('invite_to_property'), value = 'invite' },

    -- {label = _U('put_item'), value = 'deposit'},
    -- {label = _U('get_item'), value = 'withdraw'},
    { label = _U('sleep'),              value = 'sleep' },
    { label = _U('clothes'),            value = 'clothes' }
  }



  table.insert(elements, { label = "Atidaryti daiktine", value = 'openStash' })
  table.insert(elements, { label = "Pirkti baldus 🛋️", value = 'decorate' })

  if not Config.Properties[room].premium or ownerCheck() then
    table.insert(elements, { label = _U('sell_property', sellingPrice), value = 'sell' })
  end
  if not Config.Properties[room].premium or ownerCheck() then
    -- if ownerCheck() then
    table.insert(elements, { label = _U('trade_property', sellingPrice), value = 'trade' })
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_actions', {
    title = _U('property_action_title'),
    align = 'top-right',
    elements = elements
  }, function(data, menu)
    if data.current.value == 'invite' then
      menu.close()
      TriggerServerEvent('RoJea_property:invitePlayers', room)
      ESX.ShowNotification(_U('successfully_invited'))
    elseif data.current.value == "decorate" then
      menu.close()
      decorateHouse()
    elseif data.current.value == 'deposit' then
      menu.close()
      OpenDepositMenu(room)
    elseif data.current.value == 'withdraw' then
      menu.close()
      OpenWithdrawMenu(room)
    elseif data.current.value == "openStash" then
      menu.close()
      -- TriggerServerEvent("RoJea_property:getHouseStashNewWay", room)
      openStashFoo(room)
    elseif data.current.value == 'sleep' then
      menu.close()
      sleep()
    elseif data.current.value == 'sell' then
      menu.close()
      OpenSellConfirmationMenu(room, sellingPrice)
    elseif data.current.value == 'trade' then
      menu.close()
      OpenTradePropertyMenu(room)
    elseif data.current.value == 'clothes' then
      menu.close()
      OpenClothingMenu(room)
    end
  end, function(data, menu)
    menu.close()
  end)
end

function OpenClothingMenu()
  ESX.TriggerServerCallback("RoJea_property:fetchMyClothesList", function(stats)
    if next(stats) then
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_clothes_list', {
        title = _U('clothes'),
        align = 'top-right',
        elements = stats
      }, function(data, menu)
        menu.close()
        if data.current.value ~= 'clear' then
          local elements2 = {
            { label = "Apsirengti outfita",          value = "outfit" },
            { label = "Ištrinti pasirinkta outfita", value = "clear" }
          }
          ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_clothes_list_submenu', {
            title = 'Pasirinkite veiksma',
            align = 'center',
            elements = elements2
          }, function(data2, menu2)
            menu2.close()
            if data2.current.value == "outfit" then
              -- apply skin
              TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerEvent('skinchanger:loadClothes', skin, data.current.value, function(loaded)
                  TriggerEvent('skinchanger:getSkin', function(myNewSkin)
                    TriggerServerEvent('esx_skin:save', myNewSkin)
                  end)
                end)
              end)
            else
              ESX.TriggerServerCallback("RoJea_property:cleanPropertyClothes", function(stat)
                if stat then
                  ESX.ShowNotification('~g~Sekmingai išvalete drabužiu spinta!')
                else
                  ESX.ShowNotification('~r~Ivyko klaida!')
                end
              end, data.current.label)
            end
          end, function(data2, menu2)
            menu2.close()
          end)
        end
      end, function(data, menu)
        menu.close()
      end)
    else
      ESX.ShowNotification('~r~Neturite išsisaugoje jokiu rubu! ~y~Apsilankykite drabužiu parduotuveje!')
    end
  end)
end

function OpenTradePropertyMenu(room)
  ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'trade_property_menu', {
    title = _U('target_id')
  }, function(data, menu)
    local targetId = tonumber(data.value)
    if targetId == nil then
      ESX.ShowNotification(_U('invalid_person'))
    else
      menu.close()
      ESX.TriggerServerCallback('RoJea_property:sellProperty', function(callbackStatus)
        if not callbackStatus then return ESX.ShowNotification('Neturite perdavimo sutarties!') end
        if callbackStatus == "traded" then
          ESX.TriggerServerCallback('RoJea_property:tryBuyingProperty', function(canBuy)
            if canBuy == 'failed' then
              ESX.ShowNotification(_U('failed_buy_try_again'))
            elseif type(canBuy) == 'number' then
              ESX.ShowNotification(_U('successful_trade', Config.Properties[room].name, tostring(targetId)))
            end
          end, room, targetId)
        elseif callbackStatus == 'failed' then
          ESX.ShowNotification(_U('failed_sell_try_again'))
        elseif callbackStatus == 'targetLimit' then
          ESX.ShowNotification(_U('target_limit'))
        elseif callbackStatus == 'nonexist' then
          ESX.ShowNotification(_U('player_not_exist'))
        elseif callbackStatus == 'self' then
          ESX.ShowNotification(_U('cant_give_self'))
        end
      end, room, '', targetId)
    end
  end, function(data, menu)
    menu.close()
  end)
end

function OpenSellConfirmationMenu(room, sellingPrice)
  local roomName = Config.Properties[room].name
  local elements = {
    { label = _U('yes_price', tostring(sellingPrice)), value = 'yes' },
    { label = _U('no'),                                value = 'no' }
  }
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_sell_confirmation', {
    title = _U('sell_confirmation_title', roomName, tostring(sellingPrice)),
    align = 'top-right',
    elements = elements
  }, function(data, menu)
    if data.current.value == 'yes' then
      menu.close()
      ESX.TriggerServerCallback('RoJea_property:sellProperty', function(sellStatus)
        if type(sellStatus) == 'number' then
          ESX.ShowNotification(_U('successfully_sold', roomName, sellStatus))
        elseif sellStatus == 'failed' then
          ESX.ShowNotification(_U('failed_sell_try_again'))
        end
      end, room, sellingPrice, nil)
    elseif data.current.value == 'no' then
      menu.close()
      openPropertyActions(room)
    end
  end, function(data, menu)
    menu.close()
    openPropertyActions(room)
  end)
end

function OpenBuyConfirmationMenu(room, propertyPrice)
  local propName = Config.Properties[room].name
  local elements = {
    { label = _U('yes_buy_price', tostring(propertyPrice)), value = 'yes' },
    { label = _U('no'),                                     value = 'no' }
  }
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_buy_confirmation', {
    title = _U('buy_confirmation_title', propName, tostring(propertyPrice)),
    align = 'top-right',
    elements = elements
  }, function(data, menu)
    if data.current.value == 'yes' then
      menu.close()
      ESX.TriggerServerCallback('RoJea_property:tryBuyingProperty', function(canBuy)
        if canBuy == 'failed' then
          ESX.ShowNotification(_U('failed_buy_try_again'))
        elseif canBuy == 'nomoney' then
          ESX.ShowNotification(_U('not_enough_money'))
        elseif canBuy == 'maxprops' then
          ESX.ShowNotification(_U('max_props', tostring(Config.MaxProperties)))
        elseif type(canBuy) == 'number' then
          ESX.ShowNotification(_U('bought_property', propName, canBuy))
        end
      end, room)
    elseif data.current.value == 'no' then
      menu.close()
      openVisitorMenu(room)
    end
  end, function(data, menu)
    menu.close()
    openVisitorMenu(room)
  end)
end

function OpenDepositMenu(room)
  ESX.TriggerServerCallback('RoJea_property:getOwnerInventory', function(inventory)
    local elements = {}

    if inventory.blackMoney > 0 then
      table.insert(elements, {
        label = _U('dirty_money_label', ESX.Math.GroupDigits(inventory.blackMoney)),
        type  = 'item_account',
        value = 'black_money'
      })
    end

    for i = 1, #inventory.items, 1 do
      local item = inventory.items[i]

      if item.count > 0 then
        table.insert(elements, {
          label = item.label .. ' x' .. math.floor(item.count),
          type  = 'item_standard',
          value = item.name
        })
      end
    end

    for i = 1, #inventory.weapons, 1 do
      local weapon = inventory.weapons[i]
      if weapon then
        table.insert(elements, {
          label      = weapon.label .. ' [' .. weapon.ammo .. ' kulkos]',
          type       = 'item_weapon',
          value      = weapon.name,
          ammo       = weapon.ammo or 0,
          components = weapon.components or {},
          tint       = weapon.tint or 0
        })
      end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_inventory', {
      title = _U('your_inventory'),
      align = 'top-right',
      elements = elements
    }, function(data, menu)
      if data.current.type == 'item_weapon' then
        menu.close()
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'player_inventory_weapon_amount', {
          title = 'Iveskite kieki'
        }, function(data2, menu2)
          local quantity = tonumber(data2.value)
          if quantity == 1 then
            menu2.close()
            TriggerServerEvent('RoJea_property:putInventoryItem', room, data.current.type, data.current.value,
              data.current.ammo, data.current.components, data.current.tint)
            ESX.SetTimeout(1500, function()
              OpenDepositMenu(room)
            end)
          else
            ESX.notif("Neteisinga reiksme!")
          end
        end, function(data2, menu2)
          menu2.close()
        end)
      else
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'player_inventory_amount', {
          title = _U('inv_amount')
        }, function(data2, menu2)
          local quantity = tonumber(data2.value)
          if quantity == nil then
            ESX.ShowNotification(_U('inv_amount_invalid'))
          else
            menu2.close()
            TriggerServerEvent('RoJea_property:putInventoryItem', room, data.current.type, data.current.value,
              tonumber(data2.value))
            ESX.SetTimeout(1500, function()
              OpenDepositMenu(room)
            end)
          end
        end, function(data2, menu2)
          menu2.close()
        end)
      end
    end, function(data, menu)
      menu.close()
      openPropertyActions(room)
    end)
  end)
end

function OpenWithdrawMenu(room)
  ESX.TriggerServerCallback('RoJea_property:getMyPropertyInventory', function(inventory)
    local elements = {}

    if inventory.blackMoney > 0 then
      table.insert(elements, {
        label = _U('dirty_money_label', ESX.Math.GroupDigits(inventory.blackMoney)),
        type = 'item_account',
        value = 'black_money'
      })
    end

    for i = 1, #inventory.items, 1 do
      local item = inventory.items[i]

      if item.count > 0 and item.label then
        table.insert(elements, {
          label = item.label .. ' x' .. math.floor(item.count),
          type = 'item_standard',
          value = item.name
        })
      end
    end

    for i = 1, #inventory.weapons, 1 do
      local weapon = inventory.weapons[i]

      table.insert(elements, {
        label = ESX.GetWeaponLabel(weapon.name) .. ' [' .. weapon.ammo .. ' kulkos]',
        type  = 'item_weapon',
        value = weapon.name
      })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_inventory', {
      title    = _U('property_inventory'),
      align    = 'top-right',
      elements = elements
    }, function(data, menu)
      if data.current.type == 'item_weapon' then
        menu.close()

        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'player_inventory_weapon_amount_withdraw', {
          title = 'Iveskite kieki'
        }, function(data2, menu2)
          local quantity = tonumber(data2.value)
          if quantity == 1 then
            menu2.close()
            TriggerServerEvent('RoJea_property:getInventoryItem', room, data.current.type, data.current.value)
            ESX.SetTimeout(1500, function()
              OpenWithdrawMenu(room)
            end)
          else
            ESX.notif("Neteisinga reiksme!")
          end
        end, function(data2, menu2)
          menu2.close()
        end)
      else
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'property_inventory_amount', {
          title = _U('inv_amount')
        }, function(data2, menu2)
          local quantity = tonumber(data2.value)
          if quantity == nil then
            ESX.ShowNotification(_U('inv_amount_invalid'))
          else
            menu2.close()

            TriggerServerEvent('RoJea_property:getInventoryItem', room, data.current.type, data.current.value, quantity)
            ESX.SetTimeout(1500, function()
              OpenWithdrawMenu(room)
            end)
          end
        end, function(data2, menu2)
          menu2.close()
        end)
      end
    end, function(data, menu)
      menu.close()
      openPropertyActions(room)
    end)
  end, room)
end

function ownerCheck()
  local ownerIdx = "steam:xxx"
  return myIdentifier == ownerIdx
end

function openVisitorMenu(room)
  local propertyPrice = Config.Properties[room].price
  local propertyName = Config.Properties[room].name
  local elements = {
    { label = _U('visit_property'), value = 'visit' }
  }
  if (Config.Properties[room].premium and ownerCheck()) or (not Config.Properties[room].premium) or (currentlyWhitelisted[room]) then
    table.insert(elements, { label = _U('buy_property', propertyPrice), value = 'buy' })
  elseif Config.Properties[room].premium then
    table.insert(elements, { label = _U('buy_property_premium'), value = 'placeholder' })
  end
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'property_buy', {
    title = _U('property_title', Config.Properties[room].name),
    align = 'top-right',
    elements = elements
  }, function(data, menu)
    if data.current.value == 'buy' then
      menu.close()
      OpenBuyConfirmationMenu(room, propertyPrice)
    elseif data.current.value == 'visit' then
      menu.close()
      teleportUser(PlayerPedId(), Config.Properties[room].exit)
      LoadDecorations(room)
    end
  end, function(data, menu)
    menu.close()
  end)
end

function teleportUser(target, coords)
  coords = coords + vector3(0.0, 0.0, 0.25)
  ESX.Game.Teleport(target, coords, function()
  end)
end

function createBlips()
  for k, v in pairs(Config.Properties) do
    if ownedProperties[k] == nil then
      local premiumObj = Config.Properties[k].premium
      if not Config.Properties[k].secretBlip then
        publicBlipList[k] = AddBlipForCoord(v.enter)
        SetBlipSprite(publicBlipList[k],
          premiumObj and Config.PremiumPropertyBlip.sprite or Config.FreePropertyBlip.sprite)
        SetBlipDisplay(publicBlipList[k], Config.FreePropertyBlip.display)
        SetBlipScale(publicBlipList[k], premiumObj and Config.PremiumPropertyBlip.size or Config.FreePropertyBlip.size)
        SetBlipColour(publicBlipList[k],
          premiumObj and Config.PremiumPropertyBlip.color or Config.FreePropertyBlip.color)
        SetBlipAsShortRange(publicBlipList[k], Config.FreePropertyBlip.range)
        if premiumObj then
          BeginTextCommandSetBlipName('STRING')
          AddTextComponentString(_U('free_property_premium'))
          EndTextCommandSetBlipName(publicBlipList[k])
        end
        -- BeginTextCommandSetBlipName('STRING')
        -- AddTextComponentString(premiumObj and _U('free_property_premium') or _U('free_property'))
        -- EndTextCommandSetBlipName(publicBlipList[k])
      end
    elseif ownedProperties[k] == myIdentifier then
      privateBlipList[k] = AddBlipForCoord(Config.Properties[k].enter)
      SetBlipSprite(privateBlipList[k], Config.OwnedPropertyBlip.sprite)
      SetBlipDisplay(privateBlipList[k], Config.OwnedPropertyBlip.display)
      SetBlipScale(privateBlipList[k], Config.OwnedPropertyBlip.size)
      SetBlipColour(privateBlipList[k], Config.OwnedPropertyBlip.color)
      SetBlipAsShortRange(privateBlipList[k], Config.OwnedPropertyBlip.range)
      BeginTextCommandSetBlipName('STRING')
      AddTextComponentString(_U('owned_property'))
      EndTextCommandSetBlipName(privateBlipList[k])
    end
  end
end

function updateBlips(type, action, id)
  if action == "remove" then
    if type == "free" then
      RemoveBlip(publicBlipList[id])
    elseif type == "owned" then
      RemoveBlip(privateBlipList[id])
    end
  elseif action == "add" then
    if type == "free" then
      local premiumObj = Config.Properties[id].premium
      publicBlipList[id] = AddBlipForCoord(Config.Properties[id].enter)
      SetBlipSprite(publicBlipList[id],
        premiumObj and Config.PremiumPropertyBlip.sprite or Config.FreePropertyBlip.sprite)
      SetBlipDisplay(publicBlipList[id], Config.FreePropertyBlip.display)
      SetBlipScale(publicBlipList[id], premiumObj and Config.PremiumPropertyBlip.size or Config.FreePropertyBlip.size)
      SetBlipColour(publicBlipList[id],
        premiumObj and Config.PremiumPropertyBlip.color or Config.FreePropertyBlip.color)
      SetBlipAsShortRange(publicBlipList[id], Config.FreePropertyBlip.range)
      -- BeginTextCommandSetBlipName('STRING')
      -- AddTextComponentString(_U('free_property'))
      -- EndTextCommandSetBlipName(publicBlipList[id])
    elseif type == "owned" then
      privateBlipList[id] = AddBlipForCoord(Config.Properties[id].enter)
      SetBlipSprite(privateBlipList[id], Config.OwnedPropertyBlip.sprite)
      SetBlipDisplay(privateBlipList[id], Config.OwnedPropertyBlip.display)
      SetBlipScale(privateBlipList[id], Config.OwnedPropertyBlip.size)
      SetBlipColour(privateBlipList[id], Config.OwnedPropertyBlip.color)
      SetBlipAsShortRange(privateBlipList[id], Config.OwnedPropertyBlip.range)
      BeginTextCommandSetBlipName('STRING')
      AddTextComponentString(_U('owned_property'))
      EndTextCommandSetBlipName(privateBlipList[id])
    end
  end
end

