import java.io.File

val map = hashMapOf<Pair<Long, Int>, Long>()

fun processOneStone(number: Long, iteration: Int): Long {
    val tuple = Pair(number, iteration)

    if (iteration == 75)
        return 1L
    if (number == 0L) {
        if (!map.containsKey(tuple)) {
            map[tuple] = processOneStone(1L, iteration + 1)
        }
        return map[tuple] ?: 0L
    } else if (number.toString().length % 2 == 0) {
        if (map.containsKey(tuple)) {
            return map[tuple] ?: 0L
        }
        val strNum = number.toString()
        val mid = strNum.length / 2
        val left = strNum.substring(0, mid).toLong()
        val right = strNum.substring(mid).toLong()
        map[tuple] = processOneStone(left, iteration + 1) + processOneStone(right, iteration + 1)
        return map[tuple] ?: 0L
    } else {
        if (!map.containsKey(tuple)) {
            map[tuple] = processOneStone(number * 2024L, iteration + 1)
        }
        return map[tuple] ?: 0L
    }
}

fun processStones(numbers: Sequence<Long>): Long {
    var count = 0L
    for (number in numbers)
        count += processOneStone(number, 0)
    return count
}

fun main(args: Array<String>) {
    if (args.isEmpty()) {
        println("Usage: kotlin ProgramKt <file-path>")
        return
    }
    val filePath = args[0]
    try {
        val content = File(filePath).readText()
        var numbers = content.trim().split("\\s+".toRegex()).map { it.toLong() }.asSequence()
        val count = processStones(numbers)
        // * Print the final result
        println("Final size of numbers sequence after 75 iterations: $count")
        // * Example output, adjust as needed

    } catch (e: Exception) {
        println("Error: ${e.message}")
    }
}
