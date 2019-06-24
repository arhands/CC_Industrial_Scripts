
--USER SETTINGS

--
--The amount of nodes worth of items to be collected at each node.
local multFactor = 2;
local waterInset = 4;

--ender chest slots for the ender chests
local enderStorage = 12;
local enderCharged = 13;
local enderDepleted = 14;
local enderQuarry = 15;
local enderWater = 16;
--

--DONT CHANGE BELOW THIS LINE
local quarryCount = 3;

--place the turtle in 
--the bottom right of 
--where it is to place it, but note that it 
--will build the quarry below where you put the turtle
local quarrySize = 64;
local quarrySpacing = 2;--the total space between quarries
local height = 4;

local markerSlot = 17;
local cobbleSlot = 17;
local stonePipeSlot = 17;
local mjProducerSlot = 17;
local fuel = 17;
local powerBridgeSlot = 17;
local kinesisPipeSlot = 17;
local euConsumerSlot = 17;
local itemductSlot = 17;


function refreshItemLocations()
    markerSlot = findItemIndex("marker");
    cobbleSlot = findItemIndex("cobble");
    stonePipeSlot = findItemIndex("_item");
    mjProducerSlot = findItemIndex("producer");
    powerBridgeSlot = findItemIndex("bridge");
    fuel = findItemIndex("coal");
    kinesisPipeSlot = findItemIndex("_power");
    euConsumerSlot = findItemIndex("consumer");
    itemductSlot = findItemIndex("duct");
end
function findItemIndex(name)
    while(true) do
        for i = 1,16,1 do
            if(turtle.getItemCount(i) > 0) then
                if(string.find(turtle.getItemDetail(i).name,name) ~= nil) then
                    return i;
                end
            end
        end
        print(name.." not found");
    end
end
function checkForItem(name)--returns -1 if item not found
    for i = 1,16,1 do
        if(turtle.getItemCount(i) > 0) then
            if(string.find(turtle.getItemDetail(i).name,name) ~= nil) then
                return i;
            end
        end
    end
    return -1;
end
function ensureFuelFor(moves)
    local neededFuel =moves - turtle.getFuelLevel(); 
    while(neededFuel > 0) do
        turtle.select(fuelSlot);
        if(turtle.getItemCount() < neededFuel/80.0) then
            print("Need more fuel, please add");
            print(math.ceil(neededFuel/80.0));
            print("coal or charcoal.");
            print("\nPress Enter to continue.");
            read();
        end
        turtle.refuel(math.ceil(moves/80.0));
        neededFuel =moves - turtle.getFuelLevel();
    end
end
function refillSlot(slot,requiredAmount)
    turtle.select(slot);
    while(requiredAmount > turtle.getItemCount()) do
        print("waiting for items to be added to slot");
        print(slot);
        sleep(1);
    end
end
function checkIfEnoughItems()--should always have at least one of every item
    if(turtle.getItemCount(markerSlot) <= 4) then
        return false;
    elseif(turtle.getItemCount(cobbleSlot) <= 4) then
        return false;
    elseif(turtle.getItemCount(stonePipeSlot) <= 4) then
        return false;
    elseif(turtle.getItemCount(mjProducerSlot) <= 1) then
        return false;
    elseif(turtle.getItemCount(fuel) <= 16) then
        return false;
    elseif(turtle.getItemCount(powerBridgeSlot) <= 1) then
        return false;
    elseif(turtle.getItemCount(kinesisPipeSlot) <= 1) then
        return false;
    elseif(turtle.getItemCount(euConsumerSlot) <= 1) then
        return false;
    elseif(turtle.getItemCount(itemductSlot) <= 2) then
        return false;
    elseif(turtle.getItemCount(enderCharged) <= 1) then
        return false;
    elseif(turtle.getItemCount(enderDepleted) <= 1) then
        return false;
    elseif(turtle.getItemCount(enderQuarry) <= 1) then
        return false;
    else
        return true;
    end
end
function refillInventory()
    turtle.select(enderStorage);
    turtle.placeUp();

    refillSlot(markerSlot,4*multFactor+1);
    refillSlot(cobbleSlot,4*multFactor+1);
    refillSlot(stonePipeSlot,4*multFactor+1);
    refillSlot(mjProducerSlot,multFactor+1);
    refillSlot(fuel,64);

    refillSlot(powerBridgeSlot,multFactor+1);
    refillSlot(kinesisPipeSlot,multFactor+1);
    refillSlot(euConsumerSlot,multFactor+1);
    refillSlot(itemductSlot,2*multFactor+1);
    refillSlot(enderCharged,multFactor+1);

    refillSlot(enderDepleted,multFactor+1);
    refillSlot(enderQuarry,multFactor+1);
    turtle.select(enderStorage);
    turtle.digUp();
end
function checkInventory()
    if(not checkIfEnoughItems()) then
        refillInventory();
    end
end
function travel(distance)
    ensureFuelFor(distance);
    if(distance == 0) then
        return;
    end
    for i = 1, distance, 1 do
        turtle.forward();
    end
end

--input can be negative
function travelVirtical(distance)
    ensureFuelFor(distance);
    if(distance < 0) then
        distance = -distance;
        for i = 1, distance,1 do
            turtle.down();
        end
    else
        for i = 1, distance,1 do
            turtle.up();
        end
    end
end
--
--NODES
--all node builder functions end at the opposite side of the node they build
--
function buildCornerNode()
    travelVirtical(-height);
    turtle.select(cobbleSlot);
    turtle.placeDown();
    travelVirtical(1);
    turtle.select(markerSlot);
    turtle.placeDown();
    travelVirtical(height - 1);
end
function buildEdgeNode(horizontal)
    if(horizontal) then
        buildCornerNode();
        travel(2);
        turtle.turnRight();
        travel(2);
        turtle.turnLeft();
        buildCornerNode();
    else
        buildCornerNode();
        travel(2);
        turtle.turnRight();
        travel(2);
        turtle.turnLeft();
        buildCornerNode();
    end
end
--no quarries or power
function buildInnerNode(addQuarrySetup)
    print("building inner node");
    for i = 1, 4, 1 do
        if(addQuarrySetup) then
            travelVirtical(-height);
            turtle.select(cobbleSlot);
            turtle.placeDown();
            travelVirtical(2);
            ensureFuelFor(1);
            turtle.forward();
            turtle.select(stonePipeSlot);
            turtle.placeDown();
            travelVirtical(height - 2);
            travel(quarrySpacing - 1);
        else
            buildCornerNode();
            travel(quarrySpacing);
        end
        if(i == 3) then
            if(addQuarrySetup) then
                travelVirtical(-height-4);
                ensureFuelFor(6);
                turtle.select(itemductSlot);
                turtle.place();
                turtle.turnRight();
                turtle.turnRight();
                turtle.place();
                turtle.select(cobbleSlot);
                turtle.placeDown();
                turtle.up();

                turtle.select(enderCharged);
                turtle.place();
                turtle.turnRight();
                turtle.turnRight();
                turtle.select(enderDepleted);
                turtle.place();
                turtle.up();

                turtle.select(euConsumerSlot);
                turtle.placeDown();
                turtle.up();

                turtle.select(powerBridgeSlot);
                turtle.placeDown();
                turtle.up();

                turtle.select(mjProducerSlot);
                turtle.placeDown();
                turtle.up();

                turtle.select(kinesisPipeSlot);
                turtle.placeDown();
                turtle.up();

                turtle.select(enderQuarry);
                turtle.placeDown();
                
                travelVirtical(height - 2);
            end
        end
        if(i < 4) then
            turtle.turnLeft();
            travel(quarrySpacing);
            turtle.turnLeft();
            turtle.turnLeft();
        end
    end
    turtle.turnRight();
    turtle.turnRight();
    travel(quarrySpacing);
    turtle.turnLeft();
end

--
--END node section
--
function placeWater()
    turtle.select(enderWater);
    turtle.placeUp();
    turtle.suckUp();
    turtle.placeDown();
    turtle.drop();
    turtle.digUp();
end
function travelAlongSide(inner)
    travel(math.floor((quarrySize-1)/2));
    turtle.turnRight();
    travel(waterInset);
    placeWater();
    turtle.turnLeft();
    turtle.turnLeft();
    travel(waterInset);
    if(inner) then
        travel(waterInset);
        placeWater();
        turtle.turnLeft();
        turtle.turnLeft();
        travel(waterInset);
        turtle.turnLeft();
    else
        turtle.turnRight();
    end
    travel(math.ceil((quarrySize-1)/2));
end
function buildQuarryCluster(size)
    size = math.sqrt(size);
    checkInventory();
    --outside
    for i = 1, 4, 1 do
        buildCornerNode();
        for j = 2, size, 1 do
            travelAlongSide(false);
            buildEdgeNode(i % 2 == 0);
        end
        if(i < 4) then
            travel(quarrySize-1);
        end
        turtle.turnRight();
    end
    --inside
    travelAlongSide(true);
    turtle.turnRight();

    for i = 2, size, 1 do
        for j = 2, size, 1 do
            checkInventory();
            if(i % 2 == 0) then
                buildInnerNode(j % 2 == 0);
            else
                buildInnerNode(false);
            end
            if(j < size) then
                travelAlongSide(true);
            end
        end
        if(i < size) then
            if(i % 2 == 0) then
                travel(quarrySpacing*2);
                turtle.turnLeft();
                travelAlongSide(true);
                travel(2*quarrySpacing);
                turtle.turnLeft();
            else
                turtle.turnRight();
                travelAlongSide(true);
                turtle.turnRight();
            end
        end
    end
end
function main()
    refreshItemLocations();
    travelVirtical(height);
    while(true) do
        print("How many quarries do you want?");
        print("NOTE: Value must be even AND a perfect square.");
        quarryCount = tonumber(read());
        if(quarryCount % 2 == 0) then
            local sqrt = math.round(math.sqrt(quarryCount));
            if(sqrt*sqrt==quarryCount) then
                break;
            else
                print("ERROR - Value is not a perfect square");    
            end
        else
            print("ERROR - Value is not even");
        end
    end

    print("This structure shall be "..tostring(quarryCount*66 - 2).." blocks across");
    print("Note, five different ender chests have to be added if they have not been already.");
    print("See \"User settings\" in script for details.");
    print("Press Enter to continue.");
    read();
    buildQuarryCluster(quarryCount);
end
main();
