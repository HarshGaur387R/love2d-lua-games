local JSON_NULL = {}

local function decodeJSON(text)
    if type(text) ~= "string" then
        return nil, "JSON input must be a string"
    end

    local position = 1
    local length = #text

    local function fail(message)
        error(string.format("Invalid JSON at byte %d: %s", position, message), 0)
    end

    local function skipWhitespace()
        while position <= length and text:sub(position, position):match("[ \t\r\n]") do
            position = position + 1
        end
    end

    local function encodeCodepoint(codepoint)
        if codepoint <= 0x7F then
            return string.char(codepoint)
        elseif codepoint <= 0x7FF then
            return string.char(0xC0 + math.floor(codepoint / 0x40), 0x80 + codepoint % 0x40)
        elseif codepoint <= 0xFFFF then
            return string.char(0xE0 + math.floor(codepoint / 0x1000), 0x80 + math.floor(codepoint / 0x40) % 0x40,
                0x80 + codepoint % 0x40)
        end

        return string.char(0xF0 + math.floor(codepoint / 0x40000), 0x80 + math.floor(codepoint / 0x1000) % 0x40,
            0x80 + math.floor(codepoint / 0x40) % 0x40, 0x80 + codepoint % 0x40)
    end

    local parseValue

    local function parseString()
        position = position + 1
        local parts = {}
        local start = position

        while position <= length do
            local character = text:sub(position, position)

            if character == '"' then
                parts[#parts + 1] = text:sub(start, position - 1)
                position = position + 1
                return table.concat(parts)
            elseif character == "\\" then
                parts[#parts + 1] = text:sub(start, position - 1)
                position = position + 1
                local escape = text:sub(position, position)
                local escapedCharacters = {
                    ['"'] = '"',
                    ["\\"] = "\\",
                    ["/"] = "/",
                    ["b"] = "\b",
                    ["f"] = "\f",
                    ["n"] = "\n",
                    ["r"] = "\r",
                    ["t"] = "\t"
                }

                if escapedCharacters[escape] then
                    parts[#parts + 1] = escapedCharacters[escape]
                    position = position + 1
                elseif escape == "u" then
                    local hex = text:sub(position + 1, position + 4)
                    local codepoint = tonumber(hex, 16)
                    if #hex ~= 4 or not codepoint then
                        fail("invalid Unicode escape")
                    end
                    position = position + 5

                    if codepoint >= 0xD800 and codepoint <= 0xDBFF then
                        if text:sub(position, position + 1) ~= "\\u" then
                            fail("missing low surrogate")
                        end
                        local lowHex = text:sub(position + 2, position + 5)
                        local lowSurrogate = tonumber(lowHex, 16)
                        if not lowSurrogate or lowSurrogate < 0xDC00 or lowSurrogate > 0xDFFF then
                            fail("invalid low surrogate")
                        end
                        codepoint = 0x10000 + (codepoint - 0xD800) * 0x400 + (lowSurrogate - 0xDC00)
                        position = position + 6
                    elseif codepoint >= 0xDC00 and codepoint <= 0xDFFF then
                        fail("unexpected low surrogate")
                    end

                    parts[#parts + 1] = encodeCodepoint(codepoint)
                else
                    fail("invalid string escape")
                end
                start = position
            elseif character:byte() < 0x20 then
                fail("unescaped control character in string")
            else
                position = position + 1
            end
        end

        fail("unterminated string")
    end

    local function parseNumber()
        local start = position

        if text:sub(position, position) == "-" then
            position = position + 1
        end

        if text:sub(position, position) == "0" then
            position = position + 1
            if text:sub(position, position):match("%d") then
                fail("leading zero in number")
            end
        else
            if not text:sub(position, position):match("[1-9]") then
                fail("invalid number")
            end
            repeat
                position = position + 1
            until not text:sub(position, position):match("%d")
        end

        if text:sub(position, position) == "." then
            position = position + 1
            if not text:sub(position, position):match("%d") then
                fail("missing digits after decimal point")
            end
            repeat
                position = position + 1
            until not text:sub(position, position):match("%d")
        end

        local exponent = text:sub(position, position)
        if exponent == "e" or exponent == "E" then
            position = position + 1
            local sign = text:sub(position, position)
            if sign == "+" or sign == "-" then
                position = position + 1
            end
            if not text:sub(position, position):match("%d") then
                fail("missing exponent digits")
            end
            repeat
                position = position + 1
            until not text:sub(position, position):match("%d")
        end

        return tonumber(text:sub(start, position - 1))
    end

    local function parseArray()
        position = position + 1
        skipWhitespace()
        local result = {}

        if text:sub(position, position) == "]" then
            position = position + 1
            return result
        end

        while true do
            result[#result + 1] = parseValue()
            skipWhitespace()
            local separator = text:sub(position, position)
            if separator == "]" then
                position = position + 1
                return result
            elseif separator ~= "," then
                fail("expected ',' or ']' in array")
            end
            position = position + 1
            skipWhitespace()
        end
    end

    local function parseObject()
        position = position + 1
        skipWhitespace()
        local result = {}

        if text:sub(position, position) == "}" then
            position = position + 1
            return result
        end

        while true do
            if text:sub(position, position) ~= '"' then
                fail("expected a string key")
            end
            local key = parseString()
            skipWhitespace()
            if text:sub(position, position) ~= ":" then
                fail("expected ':' after object key")
            end
            position = position + 1
            skipWhitespace()
            result[key] = parseValue()
            skipWhitespace()
            local separator = text:sub(position, position)
            if separator == "}" then
                position = position + 1
                return result
            elseif separator ~= "," then
                fail("expected ',' or '}' in object")
            end
            position = position + 1
            skipWhitespace()
        end
    end

    parseValue = function()
        skipWhitespace()
        local character = text:sub(position, position)

        if character == '"' then
            return parseString()
        elseif character == "{" then
            return parseObject()
        elseif character == "[" then
            return parseArray()
        elseif character == "-" or character:match("%d") then
            return parseNumber()
        elseif text:sub(position, position + 3) == "true" then
            position = position + 4
            return true
        elseif text:sub(position, position + 4) == "false" then
            position = position + 5
            return false
        elseif text:sub(position, position + 3) == "null" then
            position = position + 4
            return JSON_NULL
        end

        fail("unexpected value")
    end

    local success, result = pcall(function()
        local value = parseValue()
        skipWhitespace()
        if position <= length then
            fail("unexpected data after value")
        end
        return value
    end)

    if success then
        return result
    end
    return nil, result
end

return {
    decode = decodeJSON,
    null = JSON_NULL
}
