import std.stdio;
import std.string;
import std.file;
import std.array;
import std.typecons;

bool check_diag(string []tab, int y, int x, Tuple!(int, int) pair)
{
    int first_y = y + pair[0];
    int first_x = x + pair[1];
    int second_y = y - pair[0];
    int second_x = x - pair[1];

    if (first_y < 0 || first_y >= tab.length || first_x < 0 || first_x >= tab[first_y].length)
        return false;
    if (second_y < 0 || second_y >= tab.length || second_x < 0 || second_x >= tab[second_y].length)
        return false;
    if ((tab[first_y][first_x] == 'M' && tab[second_y][second_x] == 'S') ||
        (tab[second_y][second_x] == 'M' && tab[first_y][first_x] == 'S'))
        return true;
    return false;
}

void check_cross(string []tab, int y, int x, int *xmas)
{
    static Tuple!(int, int)[]cross = [tuple(1, 1), tuple(-1, 1)];

    foreach (pair; cross)
        if (!check_diag(tab, y, x, pair))
            return;
    (*xmas) += 1;
}

void find_xmas(string []tab)
{
    int xmas = 0;

    for (int y = 0; y < tab.length; y++)
        for (int x = 0; x < tab[y].length; x++)
            if (tab[y][x] == 'A')
                check_cross(tab, y, x, &xmas);
    // * Result should be 1992
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
