local peripheralConfig = require("peripheralConfig")
local recipeConfig = require("recipeConfig")

---@type Inventory
local orb = peripheral.wrap(peripheralConfig["energizingOrb"])
---@type Inventory
local mainInv = peripheral.wrap(peripheralConfig["mainInventory"])

---Checks if you can craft an item by name using the items in inv based on configured recipes
---@param itemName string
---@param inv Inventory
---@param recipeConfig table
---@return boolean
function canCraft(itemName, inv)
    for k, v in ipairs(recipeConfig) do
        if v.name == itemName then
            for kk, currentIngredient in ipairs(v.ingredients) do
                local foundEnough = false
                for slot, item in pairs(inv.list()) do
                    if ((item.count < currentIngredient.count) and (item.name == currentIngredient.name)) then
                        return false
                    elseif item.name == currentIngredient.name then
                        foundEnough = true;
                        break
                    end
                end
            end
            -- If we made it here then we found enough of all items
            return true
        end
    end

    return false
end

while true do
    if (orb.getItemDetail(1) ~= nil) then
        orb.pushItems(peripheral.getName(mainInv), 1)
    elseif (next(orb.list()) == nil) then
        for k, item in ipairs(recipeConfig) do
            if canCraft(item.name, mainInv) then
                for _, ingredient in ipairs(item.ingredients) do
                    for slot, invItem in pairs(mainInv.list()) do
                        if invItem.name == ingredient.name then
                            mainInv.pushItems(peripheral.getName(orb), slot, ingredient.count)
                        end
                    end
                end
                -- After pushing items for craft, break from loop
                break
            end
        end
    end

    os.startTimer(0.05)
    os.pullEvent("timer")
end
