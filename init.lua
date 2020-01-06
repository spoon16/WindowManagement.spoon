local wmspoon = {
    name = "WindowManagement",
    version = "1",
    author = "spoon16",
    homepage = "github.com/spoon16/WindowManagement.spoon",
    license = "https://opensource.org/licenses/MIT"
}

local hyper = {
    "ctrl",
    "alt",
    "shift"
}

function wmspoon:_nextCell(currentWinCell, candidateCells)
    print("wmspoon:_nextCell: " .. hs.inspect.inspect(currentWinCell) .. " " .. hs.inspect.inspect(candidateCells))
    local nextWinCell = candidateCells[1]
    for i,c in ipairs(candidateCells) do
        if currentWinCell == c then
            local nwc = candidateCells[i + 1]
            if nwc ~= nil then nextWinCell = nwc end
            break
        end
    end
    print("next cell " .. hs.inspect.inspect(nextWinCell))
    return nextWinCell
end

function wmspoon:_sizeWindow(target)
    print("wmspoon:_sizeWindow: " .. target)
    
    local win = hs.window.frontmostWindow()
    print("win " .. hs.inspect.inspect(win:id()))
    
    local screen = win:screen()
    print("screen " .. hs.inspect.inspect(screen:id()))

    currentWinCell = hs.grid.get(win, screen)
    print("current cell " .. hs.inspect.inspect(currentWinCell))

    local positionCells = nil
    if screen:id() == -1 then
    else
        if target == "center" then
            positionCells = {
                hs.geometry.rect(2, 2, 8, 8),
                hs.geometry.rect(1, 1, 10, 10),
                hs.geometry.rect(4, 4, 4, 4),
            }
        elseif target == "left" then
            positionCells = {
                hs.geometry.rect(0, 0, 6, 12),
                hs.geometry.rect(0, 0, 8, 12),
                hs.geometry.rect(0, 0, 4, 12)
            }
        elseif target == "right" then
            positionCells = {
                hs.geometry.rect(6, 0, 6, 12),
                hs.geometry.rect(4, 0, 8, 12),
                hs.geometry.rect(8, 0, 4, 12)
            }
        elseif target == "top" then
            positionCells = {
                hs.geometry.rect(0, 0, 12, 6),
                hs.geometry.rect(0, 0, 12, 8),
                hs.geometry.rect(0, 0, 12, 4)
            }
        elseif target == "top-left" then
            positionCells = {
                hs.geometry.rect(0, 0, 6, 6),
                hs.geometry.rect(0, 0, 8, 8)
            }
        elseif target == "top-right" then
            positionCells = {
                hs.geometry.rect(6, 0, 6, 6),
                hs.geometry.rect(4, 0, 8, 8)
            }
        elseif target == "bottom" then
            positionCells = {
                hs.geometry.rect(0, 6, 12, 6),
                hs.geometry.rect(0, 4, 12, 8),
                hs.geometry.rect(0, 8, 12, 4)
            }
        elseif target == "bottom-left" then
            positionCells = {
                hs.geometry.rect(0, 6, 6, 6),
                hs.geometry.rect(0, 4, 8, 8)
            }
        elseif target == "bottom-right" then
            positionCells = {
                hs.geometry.rect(6, 6, 6, 6),
                hs.geometry.rect(4, 4, 8, 8)
            }
        else
            positionCells = { hs.geometry.rect(0, 0, 12, 12) }
        end
    end
    
    local nextWinCell = self:_nextCell(currentWinCell, positionCells)
    hs.grid.set(win, nextWinCell, screen)
end

function wmspoon:bindHotkeys()
    print("wmspoon:bindHotkeys")

    -- hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function (event)
    --     local flags = event:getFlags()

    --     local hyperDown = true
    --     for _,h in pairs(hyper) do
    --         if flags[h] == nil then  
    --             hyperDown = false
    --             break
    --         end 
    --     end
    --     print("*** hyperDown: " .. hs.inspect.inspect(hyperDown))
    -- end):start()

    -- hs.hotkey.bind(hyper, "space", function ()
    --     print("*** hyper pressed")
    -- end, function ()
    --     print("*** hyper released")
    -- end)

    hs.hotkey.bind(hyper, "q", function ()
        self:_sizeWindow("top-left")
    end)

    hs.hotkey.bind(hyper, "w", function ()
        self:_sizeWindow("top")
    end)

    hs.hotkey.bind(hyper, "e", nil, function ()
        self:_sizeWindow("top-right")
    end)

    hs.hotkey.bind(hyper, "a", function ()
        self:_sizeWindow("left")
    end)

    hs.hotkey.bind(hyper, "s", function ()
        self:_sizeWindow("center")
    end)

    hs.hotkey.bind(hyper, "d", function ()
        self:_sizeWindow("right")
    end)

    hs.hotkey.bind(hyper, "f", function ()
        self:_sizeWindow("full")
    end)

    hs.hotkey.bind(hyper, "z", function ()
        self:_sizeWindow("bottom-left")
    end)

    hs.hotkey.bind(hyper, "x", function ()
        self:_sizeWindow("bottom")
    end)

    hs.hotkey.bind(hyper, "c", function ()
        self:_sizeWindow("bottom-right")
    end)

    hs.hotkey.bind(hyper, "escape", function ()
        print("wmspoon:exit full screen")
        hs.window.focusedWindow():setFullScreen(false)
    end)
end

function wmspoon:init()
    print("wmspoon:init")

    print("hs.window.animationDuration: " .. hs.inspect.inspect(gridDimensions))
    hs.window.animationDuration = 0.2

    local gridDimensions = hs.geometry.size(12, 12)
    print("hs.grid.setGrid: " .. hs.inspect.inspect(gridDimensions))
    hs.grid.setGrid(gridDimensions)

    local gridMargins = hs.geometry.size(0, 0)
    print("hs.grid.setMargins: " .. hs.inspect.inspect(gridMargins))
    hs.grid.setMargins(gridMargins)
end

return wmspoon
