const fs = require('fs');
const args = process.argv.slice(2);

if (args.length < 1)
    process.exit(84);

function isValid(map, position)
{
    let [x, y] = position;
    return y >= 0 && y < map.length && x >= 0 && x < map[y].length;
}

fs.readFile(args[0], 'utf-8', (err, data) => {
    if (err)
        process.exit(84);

    const directions = [[0, -1], [1, 0], [0, 1], [-1, 0]];

    const map = data.split('\n').filter(line => line.trim() !== '');
    const base = map.flatMap((line, lineIndex) =>
        [...line].map((char, charIndex) => char === '0' ? {x: charIndex, y: lineIndex} : null)
    ).filter(Boolean);

    let total = 0;
    for (const {x, y} of base) {
        let set = new Set();
        let tmpPosition = [{ x: x, y: y, value: 0 }];

        while (tmpPosition.length > 0) {
            let {x: currentX, y: currentY, value} = tmpPosition.pop();
            if (value === 9) {
                set.add(`${currentX},${currentY}`);
                continue;
            }
            for (const [offsetX, offsetY] of directions) {
                let [tmpX, tmpY] = [currentX + offsetX, currentY + offsetY];
                if (isValid(map, [tmpX, tmpY]) && map[tmpY][tmpX] == value + 1)
                    tmpPosition.push({ x: tmpX, y: tmpY, value: value + 1 });
            }
        }
        total += set.size;
    }
    // * Print the Result
    console.log("Count: ", total);
    // * Answer should be 459
});
