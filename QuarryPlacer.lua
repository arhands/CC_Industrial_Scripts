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
function goToNextNode()
    travel(quarrySpacing + quarrySpacing);
    turtle.turnRight();
    travel(quarrySpacing);
end

function buildEdgeNode()
    travelVirtical(-height);
    turtle.select(cobbleSlot);
    turtle.placeDown();
    turtle.travelVirtical(1);
    turtle.select(markerSlot);
    turtle.placeDown();
    travelVirtical(height - 1);
end

--no quarries or power
function buildInnerNode()
    travelVirtical(1-height);
    for(i = 1, 4, 1) do
        buildEdgeNode();
        travel(quarrySpacing);
        turtle.turnLeft();
    end
end