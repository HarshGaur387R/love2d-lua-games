local scriptPath = arg[0]:gsub("\\", "/")
local scriptDirectory = scriptPath:match("^(.*)/") or "."
local JSON = dofile(scriptDirectory .. "/decode-json.lua")

local passed = 0
local failed = 0

local function test(name, callback)
    local success, message = pcall(callback)
    if success then
        passed = passed + 1
        print("PASS " .. name)
    else
        failed = failed + 1
        print("FAIL " .. name .. ": " .. tostring(message))
    end
end

local function assertDecodeError(text)
    local value, message = JSON.decode(text)
    assert(value == nil, "expected invalid JSON to fail")
    assert(type(message) == "string" and message:match("Invalid JSON"), "expected a JSON parse error")
end

test("nested objects and arrays", function()
    local value, message = JSON.decode([[{"level":{"notes":[1,2,3]}}]])
    assert(value, message)
    assert(value.level.notes[1] == 1 and value.level.notes[3] == 3)
end)

test("JSON scalar types and null", function()
    local value, message = JSON.decode([[ [0,-1,1.25,2e3,true,false,null] ]])
    assert(value, message)
    assert(value[1] == 0 and value[2] == -1 and value[3] == 1.25 and value[4] == 2000)
    assert(value[5] == true and value[6] == false and value[7] == JSON.null)
end)

test("string escapes and Unicode", function()
    local value, message = JSON.decode([["line\n\t\u263A"]])
    assert(value, message)
    assert(value == "line\n\t" .. string.char(0xE2, 0x98, 0xBA))

    local supplementary, supplementaryMessage = JSON.decode([["\uD83D\uDE00"]])
    assert(supplementary, supplementaryMessage)
    assert(supplementary == string.char(0xF0, 0x9F, 0x98, 0x80))
end)

test("empty containers and whitespace", function()
    local value, message = JSON.decode(" \t{\"object\":{},\"array\":[]}\n")
    assert(value, message)
    assert(next(value.object) == nil and #value.array == 0)
end)

test("rejects malformed JSON", function()
    local invalidInputs = {
        "",
        "{]",
        "01",
        "[1,]",
        "{\"key\":1,}",
        "\"unterminated",
        "true false"
    }

    for _, text in ipairs(invalidInputs) do
        assertDecodeError(text)
    end
end)

test("rejects non-string input", function()
    local value, message = JSON.decode({})
    assert(value == nil and message == "JSON input must be a string")
end)

print(string.format("\n%d passed, %d failed", passed, failed))
if failed > 0 then
    os.exit(1)
end
