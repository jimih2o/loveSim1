if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

function love.draw()
    love.graphics.print("Hello World", 400, 300)
end
