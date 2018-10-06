module Position exposing (main)

import Benchmark exposing (Benchmark, benchmark)
import Benchmark.Runner exposing (BenchmarkProgram)
import Pivot exposing (Pivot)
import Pivot.Position


main : BenchmarkProgram
main =
    Benchmark.Runner.program <|
        Benchmark.describe "Pivot.Position"
            [ lengthL
            , lengthLOptimized
            , lengthR
            , lengthROptimized
            , lengthA
            , lengthAOptimized
            ]


pivot1000 : Pivot Int
pivot1000 =
    Pivot.fromCons 0 (List.repeat 999 0)
        |> Pivot.withRollback (Pivot.goAbsolute 500)


lengthL : Benchmark
lengthL =
    benchmark "lengthL" (\_ -> Pivot.Position.lengthL pivot1000)


lengthLOptimized : Benchmark
lengthLOptimized =
    benchmark "lengthL optimized" (\_ -> Pivot.Position.lengthLOptimized pivot1000)


lengthR : Benchmark
lengthR =
    benchmark "lengthR" (\_ -> Pivot.Position.lengthR pivot1000)


lengthROptimized : Benchmark
lengthROptimized =
    benchmark "lengthR optimized" (\_ -> Pivot.Position.lengthROptimized pivot1000)


lengthA : Benchmark
lengthA =
    benchmark "lengthA" (\_ -> Pivot.Position.lengthA pivot1000)


lengthAOptimized : Benchmark
lengthAOptimized =
    benchmark "lengthA optimized" (\_ -> Pivot.Position.lengthAOptimized pivot1000)
