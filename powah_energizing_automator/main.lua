local peripheralConfiguration = require("peripheralConfiguration")
---@type Inventory
local orb = peripheral.wrap(peripheralConfiguration["energizingOrb"])
---@type Inventory
local mainInv = peripheral.wrap(peripheralConfiguration["mainInventory"])

while true do
    if (orb.getItemDetail(1) ~= nil) then
        orb.pushItems(peripheral.getName(mainInv), 1)
    end

    os.startTimer(0.05)
    os.pullEvent("timer")
end
