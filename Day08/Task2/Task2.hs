{-
-- EPITECH PROJECT, 2024
-- AdventOfCode2024
-- File description:
-- Task2
-}

import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.Map (Map)
import Data.List (foldl')
import Data.Set (Set)

processChar :: Int -> Map Char [(Int, Int)] -> (Int, Char) -> Map Char [(Int, Int)]
processChar row acc (col, char)
    | char == '.' = acc
    | otherwise = Map.insertWith (++) char [(row, col)] acc

processLine :: Map Char [(Int, Int)] -> (Int, String) -> Map Char [(Int, Int)]
processLine acc (row, line) =
    foldl' (processChar row) acc (zip [0..] line)

buildCharMap :: [String] -> Map Char [(Int, Int)]
buildCharMap grid =
    foldl' processLine Map.empty (zip [0..] grid)

isInBounds :: Int -> (Int, Int) -> Bool
isInBounds len (x, y) =
    x >= 0 && x < len && y >= 0 && y < len

checkLineAntinode :: Int -> (Int, Int) -> (Int, Int) -> [(Int, Int)]
checkLineAntinode len (x, y) (vx, vy) = case isInBounds len (x, y) of
        True -> [(x, y)] ++ (checkLineAntinode len (x - vx, y - vy) (vx, vy))
        False -> []

checkAntinode :: Int -> ((Int, Int), (Int, Int)) -> Set (Int, Int)
checkAntinode len ((x1, y1), (x2, y2)) =
    let (vx, vy) = (x1 - x2, y1 - y2)
        firstAntinode = (x1 + vx, y1 + vy)
        secondAntinode = (x2 - vx, y2 - vy)
    in Set.fromList $
        checkLineAntinode len firstAntinode (-vx, -vy) ++
        checkLineAntinode len secondAntinode (vx, vy)

collectAntinodes :: [String] -> [((Int, Int), (Int, Int))] -> Set (Int, Int)
collectAntinodes grid coordsToCheck =
    let len = length grid
    in foldl' (\acc coord -> acc `Set.union` checkAntinode len coord) Set.empty coordsToCheck

processKey :: (Char, [(Int, Int)]) -> [((Int, Int), (Int, Int))]
processKey (key, points) =
    [ (p1, p2) | (p1, idx1) <- zip points [0..], (p2, idx2) <- zip points [0..], idx1 < idx2 ]

processMap :: Map Char [(Int, Int)] -> [((Int, Int), (Int, Int))]
processMap charMap = concatMap processKey (Map.toList charMap)

main :: IO ()
main = do
    content <- readFile "../input.txt" -- * Get file content
    let grid = lines content
    let charMap = buildCharMap grid -- * Split the file content into a dictionnary
    let coordsToCheck = processMap charMap -- * Get all the potential antinode
    let antinodeSet = collectAntinodes grid coordsToCheck -- * Check if antinodes are good

    -- * Combine antinode set and the extracted coordinates from the map values
    let mapValuesSet = Set.fromList (concat (Map.elems charMap))
    let antinodeList = Set.toList (Set.union antinodeSet mapValuesSet)

    -- * Print the result
    putStrLn $ "Antinode: " ++ show (antinodeList)
    putStrLn $ "Antinode numbers: " ++ show (length antinodeList)
    -- * Answer should be 809
