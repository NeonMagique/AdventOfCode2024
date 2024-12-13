function Task2()
    filename = "../input.txt";
    try
        content = fileread(filename);

        sections = strsplit(content, '\n\n');

        total = 0;
        for i = 1:length(sections)
            total = total + ExecutePrize(sections{i});
        end
        format long
        % * Print the result
        disp(total)
        % * Answer should be 91649162972270
    catch ME
        disp(['An error occurred: ' ME.message]);
    end
end

function result = ExecutePrize(prize)
    [x1, y1, x2, y2, resX, resY] = ExtractCoordinates(prize);

    eqA = x2 * y1 - x1 * y2;
    eqB = resY * x2 - resX * y2;

    coef1 = eqB / eqA;

    if mod(eqB, eqA) == 0
        coef2 = (resY - coef1 * y1) / y2;
        result = 3 * coef1 + coef2;
    else
        result = 0;
    end
end

function [x1, y1, x2, y2, resX, resY] = ExtractCoordinates(input)
    pattern = 'X[=+](\d+), Y[=+](\d+)';
    tokens = regexp(input, pattern, 'tokens');

    if length(tokens) < 3
        error('Not enough coordinate data found.');
    end

    x1 = str2double(tokens{1}{1});
    y1 = str2double(tokens{1}{2});
    x2 = str2double(tokens{2}{1});
    y2 = str2double(tokens{2}{2});
    resX = str2double(tokens{3}{1}) + 10000000000000;
    resY = str2double(tokens{3}{2}) + 10000000000000;
end
