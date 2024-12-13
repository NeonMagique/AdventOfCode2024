local arg = {...}
local filename = arg[1]

if not filename then
    print("Usage: lua Task2.lua <filename>")
    os.exit(1)
end

local file, err = io.open(filename, "r")
if not file then
    print("Error opening file: " .. err)
    os.exit(1)
end

local rows = {}
for line in file:lines() do
    local row = {}
    for char in line:gmatch(".") do
        table.insert(row, char)
    end
    table.insert(rows, row)
end
file:close()

local height = #rows
local width = #rows[1]

local visited = {}
for y = 1, height do
    visited[y] = {}
    for x = 1, width do
        visited[y][x] = false
    end
end

local function floodFill(y, x, letter, region)
    if x < 1 or y < 1 or y > height or x > width then
        return
    end
    if visited[y][x] or rows[y][x] ~= letter then
        return
    end

    visited[y][x] = true
    table.insert(region, {x, y})

    floodFill(y - 1, x, letter, region)
    floodFill(y + 1, x, letter, region)
    floodFill(y, x - 1, letter, region)
    floodFill(y, x + 1, letter, region)
end

local directions = {
    {0, -1},   -- Up
    {1, 0},    -- Right
    {0, 1},    -- Down
    {-1, 0},   -- Left
}

local function countCorners(x, y)
    local count = 0

    for d = 1, 4 do
        local dx1, dy1 = directions[d][1], directions[d][2]
        local dx2, dy2 = directions[(d % 4) + 1][1], directions[(d % 4) + 1][2]

        local plant = rows[y][x]
         -- * nil if coords are not in bounds
        local left = rows[y + dy1] and rows[y + dy1][x + dx1]
        local right = rows[y + dy2] and rows[y + dy2][x + dx2]
        local mid = rows[y + dy1 + dy2] and rows[y + dy1 + dy2][x + dx1 + dx2]

        -- * There are two possibilities for being a corner:
        -- * 1. Right and Left are not equal to the plant.
        -- * 2. Both are equal, but the middle (mid) is not equal to the plant.
        if (left ~= plant and right ~= plant) or (left == plant and right == plant and mid ~= plant) then
            count = count + 1
        end
    end

    return count
end

local function calculateSides(region, letter)
    local count = 0
    for _, point in ipairs(region) do
        local x, y = point[1], point[2]
        count = count + countCorners(x, y)
    end
    return count
end

local regions = {}
for y = 1, height do
    for x = 1, width do
        if not visited[y][x] then
            local region = {}
            local letter = rows[y][x]
            floodFill(y, x, letter, region)
            table.insert(regions, {letter = letter, cells = region})
        end
    end
end

local total = 0

for _, regionData in ipairs(regions) do
    local letter = regionData.letter
    local sides = calculateSides(regionData.cells, letter)
    local area = #regionData.cells

    print(string.format("Letter %s: (area) %d * %d (sides)", letter, area, sides))

    total = total + (area * sides)
end

-- * Print the result
print("Total: " .. total)
-- * Answer should be 841934