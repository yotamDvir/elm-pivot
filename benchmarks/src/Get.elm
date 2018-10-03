module Get exposing (main)

import Benchmark exposing (Benchmark, benchmark)
import Benchmark.Runner exposing (BenchmarkProgram)
import Pivot exposing (Pivot)
import Pivot.Get


main : BenchmarkProgram
main =
    Benchmark.Runner.program <|
        Benchmark.describe "Pivot.Get"
            [ hasL
            , hasLOptimized
            , hasR
            , hasROptimized
            , getA
            , getAOptimized
            ]


pivot1000 : Pivot Int
pivot1000 =
    Pivot.fromCons 0 (List.repeat 999 0)
        |> Pivot.withRollback (Pivot.goAbsolute 500)


hasL : Benchmark
hasL =
    benchmark "hasL" (\_ -> Pivot.Get.hasL pivot1000)


hasLOptimized : Benchmark
hasLOptimized =
    benchmark "hasL optimized" (\_ -> Pivot.Get.hasLOptimized pivot1000)


hasR : Benchmark
hasR =
    benchmark "hasR" (\_ -> Pivot.Get.hasR pivot1000)


hasROptimized : Benchmark
hasROptimized =
    benchmark "hasR optimized" (\_ -> Pivot.Get.hasROptimized pivot1000)


getA : Benchmark
getA =
    benchmark "getA" (\_ -> Pivot.Get.getA pivot1000)


getAOptimized : Benchmark
getAOptimized =
    benchmark "getA optimized" (\_ -> Pivot.Get.getAOptimized pivot1000)
