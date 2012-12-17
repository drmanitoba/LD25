return { version = "1.1", luaversion = "5.1", orientation = "orthogonal", width = 14, height = 16, tilewidth = 54, tileheight = 54, properties = {}, tilesets = { { name = "Cars", firstgid = 1, tilewidth = 54, tileheight = 108, spacing = 1, margin = 0, image = "cars.png", imagewidth = 164, imageheight = 108, properties = {}, tiles = { { id = 0, properties = { ["name"] = "RedCar" } }, { id = 1, properties = { ["name"] = "BlueCar" } }, { id = 2, properties = { ["name"] = "GreenCar" } } } }, { name = "Tiles", firstgid = 4, tilewidth = 54, tileheight = 54, spacing = 0, margin = 0, image = "tiles.png", imagewidth = 378, imageheight = 108, properties = {}, tiles = {} }, { name = "Player", firstgid = 18, tilewidth = 54, tileheight = 54, spacing = 0, margin = 0, image = "maid.png", imagewidth = 108, imageheight = 54, properties = {}, tiles = { { id = 0, properties = { ["_the"] = "player", ["name"] = "Player" } } } } }, layers = { { type = "tilelayer", name = "map", x = 0, y = 0, width = 14, height = 16, visible = true, opacity = 1, properties = {}, encoding = "lua", data = { 5, 6, 13, 7, 8, 13, 9, 16, 13, 7, 8, 13, 6, 10, 5, 13, 13, 14, 15, 13, 9, 16, 13, 14, 15, 13, 13, 4, 5, 13, 13, 7, 8, 13, 9, 16, 13, 7, 8, 13, 13, 4, 11, 6, 13, 14, 15, 13, 9, 16, 13, 14, 15, 13, 6, 10, 5, 13, 13, 7, 8, 13, 9, 16, 13, 7, 8, 13, 13, 4, 5, 13, 13, 14, 15, 13, 9, 16, 13, 14, 15, 13, 13, 4, 11, 6, 13, 7, 8, 13, 9, 16, 13, 7, 8, 13, 6, 10, 5, 13, 13, 14, 15, 13, 9, 16, 13, 14, 15, 13, 13, 4, 5, 13, 13, 7, 8, 13, 9, 16, 13, 7, 8, 13, 13, 4, 11, 6, 13, 14, 15, 13, 9, 16, 13, 14, 15, 13, 6, 10, 5, 13, 13, 7, 8, 13, 9, 16, 13, 7, 8, 13, 13, 4, 5, 13, 13, 14, 15, 13, 9, 16, 13, 14, 15, 13, 13, 4, 11, 6, 13, 7, 8, 13, 9, 16, 13, 7, 8, 13, 6, 10, 5, 13, 13, 14, 15, 13, 9, 16, 13, 14, 15, 13, 13, 4, 5, 13, 13, 7, 8, 13, 9, 16, 13, 7, 8, 13, 13, 4, 11, 6, 13, 14, 15, 13, 9, 16, 13, 14, 15, 13, 6, 4 } }, { type = "objectgroup", name = "player", visible = true, opacity = 1, properties = {}, objects = { { name = "", type = "", x = 378, y = 432, width = 0, height = 0, gid = 18, properties = {} } } } } }
