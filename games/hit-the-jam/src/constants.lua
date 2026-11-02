VIRTUAL_WIDTH = 360
VIRTUAL_HEIGHT = 640
ARROW_HEIGHT = 123
ARROW_WIDTH = 123

DRAG_HEIGHT = 63
DRAG_WIDTH = 65

DRAG_HEAD_HEIGHT = 5
DRAG_HEAD_WIDTH = 65

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
