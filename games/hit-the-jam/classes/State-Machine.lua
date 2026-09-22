StateMachine = Object:extend()

function StateMachine:new(states)
    self.empty = {
        enter = function(_self, params) end,
        exit = function() end,
        render = function() end,
        update = function(_self, dt) end

    }
    self.states = states or {}
    self.current = self.empty
    self.currentStateName = ''
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])
    self.current:exit()
    self.current = self.states[stateName]()
    self.currentStateName = stateName
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end
