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

function refreshItemLocations()
    markerSlot = findItemIndex("marker");
    cobbleSlot = findItemIndex("cobble");
    woodPipeSlot = findItemIndex("pipe");
    mjProducerSlot = findItemIndex("producer");
    powerBridgeSlot = findItemIndex("bridge");
    fuel = findItemIndex("coal");
    
end
function findItemIndex(name)
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
        findItemIndex("cobble");
    end
end

function checkMarkers()
    if(turtle.getItemCount(markerSlot) == 0) then
        findItemIndex("marker");
    end
end

function travel(distance)
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
function buildInnerNode()
    for i = 1, 3, 1 do
        buildCornerNode();
        travel(quarrySpacing);
        turtle.turnLeft();
        travel(quarrySpacing);
        turtle.turnLeft();
        turtle.turnLeft();
    end
    buildCornerNode();
    turtle.turnRight();
end
--upgrades an inner node to an inner node w/ quarry
function upgradeNodeQuarry()
    turtle.turnLeft();
    for i = 1, 4, 1 do
        turtle.down();
        checkCobble();
        turtle.select(cobbleSlot);
        turtle.placeDown();
        turtle.up();
        turtle.select(markerSlot);
        checkMarkers();
        turtle.placeDown();
        
        turtle.turnRight();
        turtle.forward();
        turtle.turnLeft();

        --place stuff AND return to local default height


        if(i < 4) then
            travel(quarrySpacing);
            turtle.turnRight();
            travel(quarrySpacing - 1);
        end
    end
    turtle.turnRight();
    travel(quarrySpacing - 1);

    --place power/storage stuff AND return to local default height


    travel(quarrySpacing);
end

--
--END node section
--
function buildQuarryCluster(size)
    --outside
    for i = 1, 4, 1 do
        buildCornerNode();
        for j = 2, size, 1 do
            travel(quarrySize-1);
            buildEdgeNode(i % 2 == 0);
        end
        if(i < 4) then
            travel(quarrySize-1);
        end
        turtle.turnRight();
    end
    --inside
    travel(quarrySize - 1);
    turtle.turnRight();

    for i = 2, size, 1 do
        for j = 2, size, 1 do
            buildInnerNode();
            if(j < size) then
                travel(quarrySize-1);
            end
        end
        if(i < size) then
            if(i % 2 == 0) then
                travel(quarrySpacing*2);
                turtle.turnLeft();
                travel(quarrySize-1 + 2*quarrySpacing);
                turtle.turnLeft();
            else
                turtle.turnRight();
                travel(quarrySize-1);
                turtle.turnRight();
            end
        end
    end

    --place quarries
    turtle.turnLeft();

    for i = 2, size, 1 do
        for j = 2, size, 1 do
            if((j + i) % 2 == 0) then
                upgradeNodeQuarry();
            else
                travel(quarrySpacing);
                turtle.turnLeft();
                travel(quarrySpacing);
            end
        end
        if(i < size) then
            if(i % 2 == 0) then
                turtle.turnLeft();
                travel(quarrySize-1);
            else
                turtle.turnRight();
                travel(quarrySize-1 + 2*quarrySpacing);
                turtle.turnRight();
                travel(quarrySpacing*2);
                turtle.turnRight();
            end
        end
    end
end
refreshItemLocations();
turtle.select(fuel);
turtle.refuel();
buildQuarryCluster(4);
