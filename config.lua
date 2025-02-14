Config = {}

Config.Locale = 'lt'
Config.DrawDistance = 100.0

Config.MaxProperties = 2
Config.SellPercentage = 25

Config.MaxStashWeight = 1000 -- 500L stash weight

Config.ClothesLimit = 3
Config.ClothingPrice = 5000

Config.FreePropertyBlip = {
  sprite = 369,
  display = 4,
  size = 0.7,
  color = 0,
  range = true
}

Config.PremiumPropertyBlip = {
  sprite = 475,
  size = 0.8,
  color = 60,
}

Config.OwnedPropertyBlip = {
  sprite = 475,
  display = 4,
  size = 1.0,
  color = 12,
  range = true
}

Config.EnterMarker = {
  type = 0,
  scale = {
    x = 1.2,
    y = 1.2,
    z = 1.2
  },
  ownedcolor = {
    r = 0,
    g = 150,
    b = 150,
    a = 100
  },
  color = {
    r = 237,
    g = 234,
    b = 76,
    a = 100
  },
  occupiedcolor = {
    r = 247,
    g = 45,
    b = 72,
    a = 100
  },
  premiumcolor = {
    r = 240,
    g = 48,
    b = 227,
    a = 170
  },
  bobUpDown = true,
  faceCamera = false,
  rotation = {
    x = 0.0,
    y = 0.0,
    z = 0.0
  },
  offset = vector3(0.0, 0.0, 0.0)
}

Config.ExitMarker = {
  type = 6,
  scale = {
    x = 1.2,
    y = 1.2,
    z = 1.2
  },
  color = {
    r = 118,
    g = 245,
    b = 76,
    a = 100
  },
  bobUpDown = false,
  faceCamera = true,
  rotation = {
    x = -90.0,
    y = 0.0,
    z = 0.0
  },
  offset = vector3(0.0, 0.0, 0.985)
}

Config.ActionsMarker = {
  type = 1,
  scale = {
    x = 1.0,
    y = 1.0,
    z = 1.0
  },
  color = {
    r = 22,
    g = 133,
    b = 245,
    a = 180
  },
  bobUpDown = false,
  faceCamera = false,
  rotation = {
    x = 0.0,
    y = 0.0,
    z = 0.0
  },
  offset = vector3(0.0, 0.0, 0.985)
}
