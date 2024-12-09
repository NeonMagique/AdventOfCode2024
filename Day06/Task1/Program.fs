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

// * Make the guard traverse the map
let travers_map (map: string[], (x, y): int * int) =
    let mutable currentCoord = (x, y)
    let directionMap =
        Map.ofList [
            (Orientation.N, ((0, -1), Orientation.E))
            (Orientation.E, ((1, 0), Orientation.S))
            (Orientation.S, ((0, 1), Orientation.O))
            (Orientation.O, ((-1, 0), Orientation.N))
        ]
    let mutable mySet = Set.empty
    let mutable currentDirection = Orientation.N
    let mutable looping = true

    while looping do
        mySet <- Set.add currentCoord mySet
        let (currentX, currentY) = currentCoord
        let (xMove, yMove), nextDirection = directionMap.[currentDirection]
        let (newX, newY) = (currentX + xMove, currentY + yMove)
        if not (is_valid (map, (newX, newY))) then
            let visitedTiles = mySet.Count
            printfn "Number of tiles visited: %d" visitedTiles
            // * Answer should be 5080
            looping <- false
        elif map.[newY].[newX] = '#' then
            currentDirection <- nextDirection
        else
            currentCoord <- (newX, newY)


let task1 (filePath: string) =
    let map = readLines filePath
    let mutable startCoord = (-1, -1)
    map |> Array.iteri (fun y line ->
        let x = line.IndexOf('^')
        if x >= 0 then
            startCoord <- (x, y)
    )
    travers_map (map, startCoord)

[<EntryPoint>]
let main argv =
    // * Check if there is enough args
    if argv.Length <> 1 then
        printfn "Not enough arguments"
        84
    else
        task1 argv.[0]
        0
