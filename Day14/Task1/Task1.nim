import strutils, os, sequtils

let width = 101
let height = 103
let midWidth = 50
let midHeight = 51

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

        var quadrantCounter = @[0, 0, 0, 0]
        for robot in robots:
            let newX = (robot.position.x + (robot.velocity.x * 100)) mod width
            let newY = (robot.position.y + (robot.velocity.y * 100)) mod height

            let adjustedX = if newX < 0: newX + width else: newX
            let adjustedY = if newY < 0: newY + height else: newY

            if adjustedX != midWidth and adjustedY != midHeight:
                if adjustedX < midWidth and adjustedY < midHeight:
                    quadrantCounter[0] += 1
                elif adjustedX > midWidth and adjustedY < midHeight:
                    quadrantCounter[1] += 1
                elif adjustedX < midWidth and adjustedY > midHeight:
                    quadrantCounter[2] += 1
                else:
                    quadrantCounter[3] += 1

        # * Print the Result
        echo "Result is: ", quadrantCounter[0] * quadrantCounter[1] * quadrantCounter[2] * quadrantCounter[3]
        # * Answer should be 216027840
    except ValueError as e:
        echo "Error while parsing the file: ", e.msg
        quit(1)
