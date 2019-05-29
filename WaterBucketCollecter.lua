while(true) do
    print("Getting container");
--this while loop V not actually
--necessary, its just to make the
--output look better
    while(turtle.getItemCount() == 0) do
        turtle.suckUp(1);
    end
    print("Collecting water");
    turtle.place();
    print("Dropping water into chest");
--same with this V while loop
    while(turtle.getItemCount() > 0) do
        turtle.dropDown();
    end
end
