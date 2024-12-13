local arg = {...}
local filename = arg[1]

if not filename then
    print("Usage: lua Task1.lua <filename>")
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

local function calculatePerimeter(region, letter)
    local perimeter = 0
    for _, cell in ipairs(region) do
        local x, y = cell[1], cell[2]

        if x - 1 < 1 or rows[y][x - 1] ~= letter then perimeter = perimeter + 1 end -- Top
        if x + 1 > width or rows[y][x + 1] ~= letter then perimeter = perimeter + 1 end -- Bottom
        if y - 1 < 1 or rows[y - 1][x] ~= letter then perimeter = perimeter + 1 end -- Left
        if y + 1 > height or rows[y + 1][x] ~= letter then perimeter = perimeter + 1 end -- Right
    end
    return perimeter
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
    local perimeter = calculatePerimeter(regionData.cells, letter)
    local area = #regionData.cells

    print(string.format("Letter %s: %d * %d", letter, area, perimeter))

    total = total + (area * perimeter)
end

-- * Print the result
print("Total: " .. total)
-- * Answer should be 1477924