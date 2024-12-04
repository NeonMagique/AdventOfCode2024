import std.stdio;
import std.string;
import std.file;
import std.array;
import std.typecons;

void check_cross(string []tab, int y, int x, int *xmas)
{
    static Tuple!(int, int)[]cross = [tuple(0, 1), tuple(0, -1), tuple(1, 0), tuple(-1, 0), tuple(1, 1), tuple(-1, -1), tuple(-1, 1), tuple(1, -1)];
    static Tuple!(int, char)[]letters = [tuple(1, 'M'), tuple(2, 'A'), tuple(3, 'S')];
    int tmp_y = 0;
    int tmp_x = 0;
    bool succeed;

    foreach (pair; cross) {
        succeed = true;
        foreach (letter; letters) {
            tmp_y = y + (pair[0] * letter[0]);
            tmp_x = x + (pair[1] * letter[0]);
            if (tmp_y < 0 || tmp_y >= tab.length || tmp_x < 0 || tmp_x >= tab[tmp_y].length ) {
                succeed = false;
                break;
            }
            if (tab[tmp_y][tmp_x] != letter[1]) {
                succeed = false;
                break;
            }
        }
        if (succeed)
            (*xmas) += 1;
    }
}

void find_xmas(string []tab)
{
    int xmas = 0;

    for (int y = 0; y < tab.length; y++)
        for (int x = 0; x < tab[y].length; x++)
            if (tab[y][x] == 'X')
                check_cross(tab, y, x, &xmas);
    // * Result should be 2571
    write(xmas);
    return;
}

string []read_lines(File file)
{
    string []tab = [];

    try {
        while (!file.eof()) {
            string line = file.readln().strip();
            tab ~= line;
        }
    } catch (Exception e) {
        writeln("Error reading file: ", e.msg);
        return null;
    }
    return tab;
}


int main(string []argv)
{
    if (argv.length < 2)
        return 84;
    try {
        File file = File(argv[1], "r");
        string []tab = read_lines(file);
        if (!tab)
            return 84;
        find_xmas(tab);
        file.close();
    } catch (FileException e) {
        writeln("Failed to open file: ", e.msg);
        return 84;
    } catch (Exception e) {
        writeln("An unexpected error occurred: ", e.msg);
        return 84;
    }
    return 0;
}
