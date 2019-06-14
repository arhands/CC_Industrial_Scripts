--User settings
--NOTE: current max value for V is 2
local multFactor = 2;--the amount reactors worth of resources the turtle
--will get each collection run.
--

local componentHeatVentSlot = -1;
local componentHeatVentName = "ic2:component_heat_vent";

local overclockedHeatVentSlot = -1;
local overclockedHeatVentName = "ic2:overclocked_heat_vent";

local exchangerSlot = -1;
local exchangerName = "ic2:component_heat_exchanger";

local uraniumSlot = -1;--fuel rods
local uraniumName = "ic2:quad_uranium_fuel_rod";

local platingSlot = -1;
local platingName = "ic2:plating";

local fuelSlot = -1;

--
function findItemIndex(name)
    while(true) do
        for i = 1,16,1 do
            if(turtle.getItemCount(i) > 0) then
                if(string.find(turtle.getItemDetail(i).name,name) ~= nil) then
                    --print(name.." is located at:");
                    --print(i);
                    --read();
                    return i;
                end
            end
        end
        print(name.." not found");
    end
end
function refreshItemLocations()
    componentHeatVentSlot = findItemIndex(componentHeatVentName);
    overclockedHeatVentSlot = findItemIndex(overclockedHeatVentName);
    exchangerSlot = findItemIndex(exchangerName);
    uraniumSlot = findItemIndex(uraniumName);
    platingSlot = findItemIndex(platingName);
    fuelSlot = findItemIndex("coal");
end
function placeCVent()
    turtle.select(componentHeatVentSlot);
    turtle.dropDown(1);
end
function placeOVent()
    turtle.select(overclockedHeatVentSlot);
    turtle.dropDown(1);
end
function placeExchanger()
    turtle.select(exchangerSlot);
    turtle.dropDown(1);
end
function placeUraniumRod()
    turtle.select(uraniumSlot);
    turtle.dropDown(1);
end
function placePlating()
    turtle.select(platingSlot);
    turtle.dropDown(1);
end
function placeItemsInReactor()
    --R1
    placeUraniumRod();
    placeCVent();
    placeOVent();
    placeExchanger();
    placeOVent();
    placeOVent();
    placeCVent();
    placeOVent();
    placePlating();
    --R2
    placePlating();
    placeCVent();
    placeOVent();
    placeOVent();
    placeCVent();
    placeOVent();
    placeOVent();
    placeUraniumRod();
    placeOVent();
    --R3
    placePlating();
    placeOVent();
    placeUraniumRod();
    placeOVent();
    placeOVent();
    placeUraniumRod();
    placeOVent();
    placeOVent();
    placeCVent();
    --R4
    placeCVent();
    placeOVent();
    placeOVent();
    placeCVent();
    placeOVent();
    placeOVent();
    placeCVent();
    placeOVent();
    placePlating();
    --R5
    placeOVent();
    placeUraniumRod();
    placeOVent();
    placeOVent();
    placeUraniumRod();
    placeOVent();
    placeOVent();
    placeUraniumRod();
    placeOVent();
    --R6
    placePlating();
    placeOVent();
    placeCVent();
    placePlating();
    placeOVent();
    placeCVent();
    placePlating();
    placeOVent();
    placeCVent();
end
function checkIfEnoughItems()--should always have at least one of every item
    if(turtle.getItemCount(componentHeatVentSlot) <= 11) then
        return false;
    elseif(turtle.getItemCount(overclockedHeatVentSlot) <= 28) then
        return false;
    elseif(turtle.getItemCount(exchangerSlot) <= 1) then
        return false;
    elseif(turtle.getItemCount(uraniumSlot) <= 7) then
        return false;
    elseif(turtle.getItemCount(platingSlot) <= 7) then
        return false;
    else
        return true;
    end
end
function travel(distance)
    if(distance == 0) then
        return;
    end
    for i = 1, distance, 1 do
        turtle.forward();
    end
end
--turtle must be facing the same direction it was when it started
function refillSlot(slot,requiredAmount)
    turtle.select(slot);
    while(requiredAmount > turtle.getItemCount()) do
        sleep(1);
    end
    
end
function makeSupplyRun(x,y)
    turtle.turnLeft();
    travel(x);
    turtle.turnLeft();
    travel(y);
    --collecting items
    refillSlot(componentHeatVentSlot,11*multFactor+1);
    refillSlot(overclockedHeatVentSlot,28*multFactor+1);
    refillSlot(exchangerSlot,multFactor+1);
    refillSlot(uraniumSlot,7*multFactor+1);
    refillSlot(platingSlot,7*multFactor+1);
    refillSlot(fuelSlot,64);
    --returning
    turtle.turnLeft();
    travel(x);
    turtle.turnLeft();
    travel(y);
end

function addItemsToReactors(rows,columns)
    for i = 1, columns, 1 do
        for j = 1, rows, 1 do
            if(turtle.getFuelLevel() < 1000) then
                turtle.select(fuelSlot);
                turtle.refuel(16);
            end
            --add items
            if(not checkIfEnoughItems()) then
                local x = 3*(i-1);
                if(i % 2 == 1) then
                    local y = (j-1)*3;
                    makeSupplyRun(x,y);
                else
                    turtle.turnRight();
                    turtle.turnRight();
                    local y = (rows - j)*3;
                    makeSupplyRun(x,y);
                    turtle.turnRight();
                    turtle.turnRight();
                end
            end
            placeItemsInReactor();
            --travel to next node
            if(j < rows) then
                travel(3);
            end
        end
        if(i % 2 == 1) then
            turtle.turnRight();
            travel(3);
            turtle.turnRight();
        else
            turtle.turnLeft();
            travel(3);
            turtle.turnLeft();
        end
    end
end
function main() 
    print("What is the length?");
    local length = tonumber(read());
    print("What is the width?");
    local width = tonumber(read());
    print("Customization complete.");
    print("Checking Item Locations...");
    refreshItemLocations();
    print("Check complete, setting up reactors.");
    addItemsToReactors(length,width);
end
main();
