--place the turtle in 
--the bottom right of 
--where it is to place it, but note that it 
--will build the quarry below where you put the turtle
local quarrySize = 64;
local quarrySpacing = 2;--the total space between quarries
local height = 4;

local markerSlot = 1;
local quarrySlot = 2;
local cobbleSlot = 3;
local fuel = 4;

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
function buildInnerNode()
    for i = 1, 4, 1 do
        buildCornerNode();
        travel(quarrySpacing);
        turtle.turnLeft();
        travel(quarrySpacing);
        turtle.turnLeft();
        turtle.turnLeft();
    end
    travel(2*quarrySpacing);
end
--upgrades an inner node to an inner node w/ quarry
function upgradeNodeQuarry()
    turtle.down();
    for i = 1, 4, 1 do
        turtle.select(cobbleSlot);
        turtle.placeDown();
        
        turtle.up();
        turtle.select(markerSlot);
        turtle.placeDown();
        turtle.forward();
        travelVirtical(-height);
        
        turtle.turnLeft();
        turtle.turnLeft();
        turtle.place();
        
        turtle.up();
        turtle.select(quarrySlot);
        turtle.placeDown();
        
        turtle.turnLeft();
        travel(quarrySpacing);
        turtle.turnLeft();
        travel(quarrySpacing - 1);
        travelVirtical(height - 2);
        turtle.turnLeft();
    end
    travel(quarrySpacing);
    travelVirtical(3);
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
            travel(quarrySize);
            buildEdgeNode(i % 2 == 0);
        end
        if(i < 4) then
            travel(quarrySize);
        end
        turtle.turnRight();
    end
    --inside
    for i = 2, size, 1 do
        for j = 2, size, 1 do
            travel(quarrySize);
            buildInnerNode();
        end
        if(i % 2 == 0) then
            turtle.turnRight();
            travel(quarrySize);
            turtle.turnRight();
        else
            turtle.turnLeft();
            travel(quarrySize);
            turtle.turnLeft();
        end
    end
    --place quarries
    for i = 2, size, 1 do
        for j = 2, size, 1 do
            travel(quarrySize);
            if(j % 2 == 0) then
                upgradeNodeQuarry()
            end
        end
        if(i % 2 == 0) then
            turtle.turnRight();
            travel(quarrySize);
            turtle.turnRight();
        else
            turtle.turnLeft();
            travel(quarrySize);
            turtle.turnLeft();
        end
    end
end
turtle.select(4);
turtle.refuel();
buildQuarryCluster(2);
