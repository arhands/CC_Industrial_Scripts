local x = 0;
local HEIGHT = 20;
local MAX_LENGTH = 1024;

function refuel()
    print("Refueling");
    for i = 1,16,1 do
        turtle.select(i);
        turtle.refuel(64);
    end
end

function clearInventory()
    print("Clearing inventory");
    turtle.turnLeft();
    turtle.turnLeft();
    for i = 1,16,1 do
        turtle.select(i);
        local details = turtle.getItemDetail();
        if(not turtle.drop()) then
            return false;
        end
    end
    turtle.turnLeft();
    turtle.turnLeft();
    return true;
end

--goes to depo
--drops off resources and gets fuel
--then returns
function goToDepo()
    print("Going to depo");
    local x_1 = x;
    while(x > 0) do
        turtle.back();
        x = x - 1;
    end
    if(clearInventory()) then
        --refuel();
        while(x < x_1) do
            turtle.forward();
            x = x + 1;
        end
        return true;
    end
    return false;
end
function needToGoToDepo()
    for i = 1,16,1 do
        if(turtle.getItemCount(i) == 0) then
            return false;
        end
    end
    return true;
end

function mineSection()
    for i = 1, HEIGHT, 1 do
        turtle.turnLeft();
        turtle.dig();
        turtle.turnRight();
        turtle.turnRight();
        turtle.dig();
        turtle.digUp();
        turtle.turnLeft();
        turtle.up();
    end
    for i = 1, HEIGHT, 1 do
        turtle.down();
    end
end

function digTunnel()
    for i = 1, MAX_LENGTH, 1 do
        refuel();
        mineSection();
        if(needToGoToDepo()) then
            if(not goToDepo()) then
                return;
            end
        end
        turtle.dig();
        turtle.forward();
        x = x + 1;
    end
end

function main()
    digTunnel();
    turtle.turnLeft();
    turtle.turnLeft();
end

main();
