
--USER SETTINGS

--must be a multiple of four
--AND a square
local quarryCount = 16;
--

local waterInset = 4;

--ender chest slots for the ender chests
local enderCharged = 13;
local enderDepleted = 14;
local enderQuarry = 15;
local enderWater = 16;
--

--DONT CHANGE BELOW THIS LINE


--place the turtle in 
--the bottom right of 
--where it is to place it, but note that it 
--will build the quarry below where you put the turtle
local quarrySize = 64;
local quarrySpacing = 2;--the total space between quarries
local height = 4;

local markerSlot = 1;
local cobbleSlot = 2;
local woodPipeSlot = 3;
local mjProducerSlot = 0;
local fuel = 3;
local powerBridgeSlot = 0;
local kinesisPipeSlot = 0;
local euConsumerSlot = 0;
local itemductSlot = 0;


function refreshItemLocations()
    markerSlot = findItemIndex("marker");
    cobbleSlot = findItemIndex("cobble");
    woodPipeSlot = findItemIndex("_item");
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

function checkCobble()
    if(turtle.getItemCount(cobbleSlot) == 0) then
        cobbleSlot = findItemIndex("cobble");
    end
end

function checkMarkers()
    if(turtle.getItemCount(markerSlot) == 0) then
        markerSlot = findItemIndex("marker");
    end
end
function checkPipes()
    if(turtle.getItemCount(woodPipeSlot) == 0) then
        woodPipeSlot = findItemIndex("_item");
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

--input can be negative
function travelVirtical(distance)
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
    checkCobble();
    turtle.select(cobbleSlot);
    turtle.placeDown();
    travelVirtical(1);
    checkMarkers();
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
            checkCobble();
            turtle.select(cobbleSlot);
            turtle.placeDown();
            travelVirtical(2);

            turtle.forward();
            checkPipes();
            turtle.select(woodPipeSlot);
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
refreshItemLocations();
turtle.select(fuel);
turtle.refuel();
travelVirtical(height);
buildQuarryCluster(quarryCount);
