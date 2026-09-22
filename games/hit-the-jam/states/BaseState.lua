BaseState = Object:extend()

---@class BaseState
function BaseState:new() end

function BaseState:enter() end

function BaseState:exit() end

function BaseState:ender() end

function BaseState:update(dt) end

return BaseState
