open System.IO

// * Get file content
let readLines (filePath: string) : string[] =
    use sr = new StreamReader(filePath)
    let lines =
        [ while not sr.EndOfStream do
            yield sr.ReadLine() ]
    lines |> Array.ofList

// * Check if a coordinate is valid
let is_valid (map: string[], (x, y): int * int) : bool =
    y >= 0 && y < map.Length && x >= 0 && x < map.[y].Length

type Orientation =
    | N
    | E
    | S
    | O

let directionMap =
    Map.ofList [
        (Orientation.N, ((0, -1), Orientation.E))
        (Orientation.E, ((1, 0), Orientation.S))
        (Orientation.S, ((0, 1), Orientation.O))
        (Orientation.O, ((-1, 0), Orientation.N))
    ]

let checkIfContainsValue (coord: int * int * Orientation) (map: Map<int * int, Set<Orientation>>) =
    let (x, y, direction) = coord
    match Map.tryFind (x, y) map with
    | Some set -> set |> Set.contains direction
    | None -> false

let addOrUpdate (coord: int * int * Orientation) (checkCoords: Map<int * int, Set<Orientation>>) =
    let (x, y, direction) = coord
    checkCoords
    |> Map.change (x, y) (function
        | Some existingSet -> Some (existingSet.Add(direction))
        | None -> Some (Set.singleton direction))

let tryToLoop (startCoord: int * int) (blockCoord: int * int) (map: string[]) =
    let (x, y) = startCoord
    let (blockX, blockY) = blockCoord
    let mutable currentCoord = (x, y, Orientation.N)
    let mutable checkCoords = Map.empty
    let mutable tmpMap = Array.copy map
    let mutable looping = true
    let mutable success = false

    let line = tmpMap.[blockY] |> Seq.toArray
    line.[blockX] <- 'O'
    tmpMap.[blockY] <- new string(line)

    while looping do
        if checkIfContainsValue currentCoord checkCoords then
            looping <- false
            success <- true
        else
            checkCoords <- addOrUpdate currentCoord checkCoords
            let (currentX, currentY, currentDirection) = currentCoord
            let (xMove, yMove), nextDirection = directionMap.[currentDirection]
            let (newX, newY) = (currentX + xMove, currentY + yMove)
            if not (is_valid (tmpMap, (newX, newY))) then
                looping <- false
            elif tmpMap.[newY].[newX] = '#' || tmpMap.[newY].[newX] = 'O' then
                currentCoord <- (currentX, currentY, nextDirection)
            else
                currentCoord <- (newX, newY, currentDirection)
    success

// * Make the guard traverse the map
let travers_map (map: string[], (x, y): int * int) : (int * int)[] =
    let mutable currentCoord = (x, y, Orientation.N)
    let mutable checkCoords: Map<int * int, Set<Orientation>> = Map.empty
    let mutable points = []
    let mutable looping = true

    while looping do
        checkCoords <- addOrUpdate currentCoord checkCoords
        let (currentX, currentY, currentDirection) = currentCoord
        points <- points @ [(currentX, currentY)]
        let (xMove, yMove), nextDirection = directionMap.[currentDirection]
        let (newX, newY) = (currentX + xMove, currentY + yMove)

        if not (is_valid (map, (newX, newY))) then
            looping <- false
        elif map.[newY].[newX] = '#' then
            currentCoord <- (currentX, currentY, nextDirection)
        else
            currentCoord <- (newX, newY, currentDirection)

    points |> List.toArray



let task1 (filePath: string) =
    let map = readLines filePath
    let mutable startCoord = (-1, -1)
    map |> Array.iteri (fun y line ->
        let x = line.IndexOf('^')
        if x >= 0 then
            startCoord <- (x, y)
    )
    let pointList = travers_map (map, startCoord)
    let filterSet =
        pointList |> Array.tail
                |> Array.filter (fun coord -> tryToLoop startCoord coord map)
                |> Set.ofArray
    let count = Set.count filterSet
    // * Answer should be 5080
    printfn "Count is %d" count

[<EntryPoint>]
let main argv =
    // * Check if there is enough args
    if argv.Length <> 1 then
        printfn "Not enough arguments"
        84
    else
        task1 argv.[0]
        0