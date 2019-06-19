--place the turtle in 
--the bottom right of 
--where it is to place it, but note that it 
--will build the quarry below where you put the turtle
local quarrySize = 64;
local quarrySpacing = 2;--the total space between quarries
local height = 4;

local fuelSlot = 17;
local exportEnderChestSlot = 17;

function refreshItemLocations()
    exportEnderChestSlot = findItemIndex("ender");
    fuelSlot = findItemIndex("coal");
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
    if(distance < 0) then
        distance = -distance;
        ensureFuelFor(distance);
        for i = 1, distance,1 do
            turtle.down();
        end
    else
        ensureFuelFor(distance);
        for i = 1, distance,1 do
            turtle.up();
        end
    end
end
function  recursiveMine()
    ensureFuelFor(6);
    local success, data;
    for i = 1,4,1 do
        success, data = turtle.inspect();
        if(success) then
            if(data.name ~= "buildcraftbuilders:frame") then
                print("Mining "..data.name);
                turtle.dig();
                turtle.forward();
                recursiveMine();
                turtle.back();
            end
        end
        turtle.turnRight();
    end
    success, data = turtle.inspectDown();
    if(success) then
        if(data.name ~= "buildcraftbuilders:frame") then
            turtle.digDown();
            turtle.down();
            recursiveMine();
            turtle.up();
        end
    end
    success, data = turtle.inspectUp();
    if(success) then
        if(data.name ~= "buildcraftbuilders:frame") then
            turtle.digUp();
            turtle.up();
            recursiveMine();
            turtle.down();
        end
    end
    ensureFuelFor(6);
end
function clearInventory()
    turtle.select(exportEnderChestSlot);
    turtle.placeUp();
    for i = 1,16,1 do
        turtle.select(i);
        if(turtle.getItemCount() > 0) then
            if(string.find(turtle.getItemDetail().name,"coal") == nil) then
                turtle.dropUp(64);
            end
        end
    end
    turtle.digUp();
    exportEnderChestSlot = findItemIndex("ender");
end
function removeQuarries(length,width)
    local lengthQuarries = length / 2;
    local widthQuarries = width / 2;
    --going to starting position
    turtle.turnRight();
    travel(quarrySize - 1 + quarrySpacing);
    turtle.turnLeft();
    travel(quarrySize - 1);
    for i = 1, lengthQuarries, 1 do
        for j = 1, widthQuarries, 1 do
            --remove inner node
            travelVirtical(1-height);
            recursiveMine();
            travelVirtical(height-1);
            clearInventory();
            --travel to next inner node quarry
            if(j < widthQuarries) then
                travel((quarrySize - 1)*2);
                travel(quarrySpacing*2);
                turtle.turnRight();
                travel(quarrySpacing*2);
                turtle.turnLeft();
            end
        end
        if(i < lengthQuarries) then
            if(i % 2 == 1) then
                turtle.turnRight();
                travel((quarrySize - 1)*2);
                travel(quarrySpacing*2);
                turtle.turnRight();
                travel(quarrySpacing*2);
            else
                turtle.turnLeft();
                travel((quarrySize - 1)*2);
                travel(quarrySpacing*2);
                turtle.turnRight();
                travel(quarrySpacing*2);
                turtle.turnRight();
                turtle.turnRight();
            end
        end
    end
end
function main()
    print("What is the length in quarries?");
    local length = tonumber(read());
    print("What is the width in quarries?");
    local width = tonumber(read());
    print("Ensure you have provided an ender chest for removing items.");
    local coalRequiredEstimate = math.ceil(quarrySize*(length+width)/80)*2;
    if(coalRequiredEstimate > 64) then
        print("It is suggested that you use at least");
        print(math.ceil(coalRequiredEstimate/9));
        print("charcoal or coal blocks.");
    else
        print("It is suggested that you use at least");
        print(coalRequiredEstimate);
        print("charcoal or coal.");
    end
    print("Press Enter to continue.");
    read();
    refreshItemLocations();
    removeQuarries(length,width);
end
--refreshItemLocations();
--recursiveMine();
main();

