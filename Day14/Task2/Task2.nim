import strutils, os, sequtils

let width = 101
let height = 103
let patternArea = 200

type
  Position = tuple[x, y: int]

type
  Robot = object
    position: Position
    velocity: Position

proc removePrefix(s: string, prefix: string): string =
    if s.startswith(prefix):
        return s[prefix.len .. ^1]
    else:
        return s

proc parseLine(line: string): Robot =
    let parts = line.split(' ')
    if parts.len != 2:
        raise newException(ValueError, "Invalid line format: " & line)

    let position = removePrefix(parts[0], "p=").split(',').mapIt(parseInt(it))
    let velocity = removePrefix(parts[1], "v=").split(',').mapIt(parseInt(it))

    if position.len != 2 or velocity.len != 2:
        raise newException(ValueError, "Invalid position or velocity format in line: " & line)

    result = Robot(position: (x: position[0], y: position[1]), velocity: (x: velocity[0], y: velocity[1]))

proc printMap(iteration: int, positions: seq[Position]) =

    echo "Iteration: ", iteration
    for y in 0..<height:
        for x in 0..<width:
            if (x, y) in positions:
                stdout.write("X")
            else:
                stdout.write(".")
        echo ""

proc removePosition(positions: var seq[Position], pos: Position): seq[Position] =
    result = @[]
    for p in positions:
        if p != pos:
            result.add(p)

proc floodFill(positions: var seq[Position], x, y: int): int =
    if x < 0 or x >= width or y < 0 or y >= height or (x, y) notin positions:
        return 0

    positions = removePosition(positions, (x, y))

    var area = 1
    area += floodFill(positions, x + 1, y)
    area += floodFill(positions, x - 1, y)
    area += floodFill(positions, x, y + 1)
    area += floodFill(positions, x, y - 1)
    return area

proc findLargestArea(positions: var seq[Position]): int =
    if positions.len == 0:
        return 0

    var largestArea = 0
    while positions.len > 0:
        let (x, y) = positions[0]
        let area = floodFill(positions, x, y)
        largestArea = max(largestArea, area)
    return largestArea

proc updateRobotPositions(robots: seq[Robot]): (seq[Position], seq[Robot]) =
  var positions: seq[Position] = @[]
  var tmpRobots: seq[Robot] = @[]

  for i in 0..<len(robots):
    var robot = robots[i]
    let newX = (robot.position.x + robot.velocity.x) mod width
    let newY = (robot.position.y + robot.velocity.y) mod height

    robot.position.x = if newX < 0: newX + width else: newX
    robot.position.y = if newY < 0: newY + height else: newY

    positions.add(robot.position)
    tmpRobots.add(robot)

  return (positions, tmpRobots)

when isMainModule:
    if paramCount() != 1:
        echo "Usage: ./program_name <filename>"
        quit(1)

    let filename = paramStr(1)
    if not fileExists(filename):
        echo "Error: File '", filename, "' does not exist."
        quit(1)

    var robots: seq[Robot] = @[]

    try:
        for line in lines(filename):
            if line.len > 0:
                let robot = parseLine(line)
                robots.add(robot)

        for j in 1..<10000:
            var (positions, tmpRobots) = updateRobotPositions(robots)
            let largestArea = findLargestArea(positions)
            if largestArea >= patternArea:
                (positions, tmpRobots) = updateRobotPositions(robots)
                printMap(j, positions)
            robots = tmpRobots

        # * Answer should be 6876
    except ValueError as e:
        echo "Error while parsing the file: ", e.msg
        quit(1)
