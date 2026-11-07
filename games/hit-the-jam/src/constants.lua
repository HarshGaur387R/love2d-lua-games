VIRTUAL_WIDTH = 360
VIRTUAL_HEIGHT = 640
ARROW_HEIGHT = 123
ARROW_WIDTH = 123

DRAG_HEIGHT = 63
DRAG_WIDTH = 65

DRAG_TAIL_HEIGHT = 5
DRAG_TAIL_WIDTH = 65

DRAG_FILLER_HEIGHT = 60 -- this helps to fill the gap between drag bar and arrow

NOTE_LANE_X_CORD = {
    left = 3,
    down = 96.8,
    up = 190.6,
    right = 284.4
}

--[[ NOTE_LANE_X_CORD = {
    left = 10,
    down = 90,
    up = 180,
    right = 270
} ]]


DIRECTIONS = {
    "left",
    "down",
    "up",
    "right",
}

ARROWS_X_COORDINATE = {
    10,
    90,
    180,
    270
}

ARROW_COLORS = {
    ["left"] = "orange",
    ["down"] = "blue",
    ["up"] = "green",
    ["right"] = "red"
}

ARROW_COLOR_VALUES = {
    ["left"] = { 239 / 255, 142 / 255, 58 / 255 },
    ["down"] = { 96 / 255, 129 / 255, 231 / 255 },
    ["up"] = { 101 / 255, 222 / 255, 39 / 255 },
    ["right"] = { 207 / 255, 66 / 255, 66 / 255 }
}

CHAPTERS = {
    {
        ["available"] = true,
        ["name"] = "City Jam",
        ["thumbnail"] = '',
        ["background"] = '',
        ["levels"] = {
            {
                ["song"] = 'assets/songs/chapter 1/Arcade 1/music.ogg',
                ["json_data"] = 'assets/songs/chapter 1/Arcade 1/data.json',
                ["format"] = "ogg",
            },
            {
                ["song"] = 'assets/songs/chapter 1/Arcade 2/music.ogg',
                ["json_data"] = 'assets/songs/chapter 1/Arcade 2/data.json',
                ["format"] = "ogg"
            },
            {
                ["song"] = 'assets/songs/chapter 1/Arcade 3/music.ogg',
                ["json_data"] = 'assets/songs/chapter 1/Arcade 3/data.json',
                ["format"] = "ogg"
            },
        }
    },

    {
        ["available"] = true,
        ["name"] = "Savanna Jam",
        ["thumbnail"] = '',
        ["background"] = '',
        ["levels"] = {
            {
                ["song"] = 'assets/songs/chapter 2/Savanna 1/music.ogg',
                ["json_data"] = 'assets/songs/chapter 2/Savanna 1/data.json',
                ["format"] = "ogg",
            },
            {
                ["song"] = 'assets/songs/chapter 2/Savanna 2/music.ogg',
                ["json_data"] = 'assets/songs/chapter 2/Savanna 2/data.json',
                ["format"] = 'ogg'
            },
            {
                ["song"] = 'assets/songs/chapter 2/Savanna 3/music.ogg',
                ["json_data"] = 'assets/songs/chapter 2/Savanna 3/data.json',
                ["format"] = "ogg"
            },
        }
    },

    {
        ["available"] = false,
        ["name"] = "Dessert Jam",
        ["thumbnail"] = '',
        ["background"] = '',
        ["levels"] = {
            {
                ["song"] = '',
                ["json_data"] = '',
                ["format"] = "ogg",
            },
            {
                ["song"] = '',
                ["json_data"] = '',
                ["format"] = "ogg"
            },
            {
                ["song"] = '',
                ["json_data"] = '',
                ["format"] = "ogg"
            },
        }
    },
}
