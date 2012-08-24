class ArenaInventoryManager extends InventoryManager;



//Create the Archetype of the Created Inventory
function Inventory CreateInventoryArchetype(Inventory NewInventoryItemArchetype, optional bool bDoNotActivate)
{
    local Inventory Inv;


    if (NewInventoryItemArchetype != none)
    {
        Inv = Spawn(NewInventoryItemArchetype.class, Owner,,,, NewInventoryItemArchetype);


        if (Inv != none)
        {
            if (!AddInventory(Inv, bDoNotActivate))
            {
                Inv.Destroy();
                Inv = none;
            }
        }
    }

    return Inv;
}

DefaultProperties
{
    PendingFire(0)=0
    PendingFire(1)=0
}