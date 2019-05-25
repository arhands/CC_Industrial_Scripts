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

function travel(distance)
    for(i = 1, distance, 1) do
        turtle.forward();
    end
end

--input can be negative
function travelVirtical(distance) do
    if(distance < 0) then
        distance = -distance;
        for(i = 1, distance,1) do
            turtle.down();
        end
    else
        for(i = 1, distance,1) do
            turtle.up();
        end
    end
end
--
--NODES
--
function buildCornerNode()
    travelVirtical(-height);
    turtle.select(cobbleSlot);
    turtle.placeDown();
    turtle.travelVirtical(1);
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
function buildInnerNodeNoQuarry()
    for(i = 1, 4, 1) do
        buildCornerNode();
        travel(quarrySpacing);
        turtle.turnLeft();
        travel(quarrySpacing);
        turtle.turnLeft();
        turtle.turnLeft();
    end
end

function buildInnerNodeQuarry()
    buildInnerNode();
    turtle.down();
    for(i = 1, 4, 1) do
        turtle.forward();
        turtle.select(cobbleSlot);
        turtle.placeUp();
        turtle.back();
        turtle.select(markerSlot);
        turtle.placeUp();
        travelVirtical(2 - height);
    end
end

