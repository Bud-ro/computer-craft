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
local function canCraft(itemToCraft, inv)
    for k, itemName in ipairs(recipeConfig) do
        if itemName.name == itemToCraft then
            for kk, currentIngredient in ipairs(itemName.ingredients) do
                local foundEnough = false
                for slot, item in pairs(inv.list()) do
                    --Assume only one slot in the inventory can hold a particular item (dank) TODO: Remove limitation
                    if ((item.count < currentIngredient.count) and (item.name == currentIngredient.name)) then
                        return false
                    elseif item.name == currentIngredient.name then
                        foundEnough = true;
                        break
                    end
                end
                if (foundEnough == false) then
                    return false
                end
            end
            -- If we made it here then we found enough of all items
            return true
        end
    end

    print("itemToCraft name not in recipeConfig!!!")
    return false
end

---Finds an ingredient in the inventory and then pushes to orb.
---Assumes that every stack has enough ingredients for craft. This
---Code WILL BREAK if used with an inventory that isn't a dank, or if
---a recipe contains identical unstackable items
---@param ingredient table
local function findItemAndPush(ingredient)
    for slot, invItem in pairs(mainInv.list()) do
        if invItem.name == ingredient.name then
            mainInv.pushItems(peripheral.getName(orb), slot, ingredient.count)
            return
        end
    end
end

while true do
    if (orb.getItemDetail(1) ~= nil) then
        orb.pushItems(peripheral.getName(mainInv), 1)
    elseif (next(orb.list()) == nil) then
        for k, item in ipairs(recipeConfig) do
            if canCraft(item.name, mainInv) then
                for _, ingredient in ipairs(item.ingredients) do
                    findItemAndPush(ingredient)
                end
                -- After pushing items for craft, break from loop
                break
            end
        end
    end

    sleep(0)
end
