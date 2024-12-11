import java.io.File

fun processStones(numbers: List<Long>, ) : List<Long>
{
    val result = mutableListOf<Long>()

    for (number in numbers) {
        if (number == 0L)
            result.add(1L)
        else if (number.toString().length % 2 == 0) {
            val strNum = number.toString()
            val mid = strNum.length / 2
            val left = strNum.substring(0, mid).toLong()
            val right = strNum.substring(mid).toLong()
            if (left != 0L)
                result.add(left)
            result.add(right)
        } else {
            result.add(number * 2024L)
        }
    }
    return result
}

fun main(args: Array<String>)
{
    if (args.isEmpty()) {
        println("Usage: kotlin ProgramKt <file-path>")
        return
    }
    val filePath = args[0]
    try {
        val content = File(filePath).readText()
        var numbers = content.trim().split("\\s+".toRegex()).map { it.toLong() }
        for (i in 0 until 25)
            numbers = processStones(numbers)
        // * Print the result
        println(numbers.size)
        // * Answer should be 183484
    } catch (e: Exception) {
        println("Error: ${e.message}")
    }
}