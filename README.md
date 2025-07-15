## for loops
This sets the guide for naming when iterating through any key/pair table values

### Resources
When looping through any table in which the pair key is a ResourceID, iterate like this:

```luau
for ResourceID, resourceData in Resources do
    myTable[ResourceID] = resourceData.value
end
```

### Buildings
When looping through any table in which the pair key is a UUID, iterate like this:

```luau
-- Pascal cased type of building + ID
for DrillID, drillData in Drills do
    myDrills[DrillID] = Drill.new(DrillID, drillData)
end
```