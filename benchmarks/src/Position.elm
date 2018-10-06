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
            , lengthR
            , lengthA
            ]


pivot1000 : Pivot Int
pivot1000 =
    Pivot.fromCons 0 (List.repeat 999 0)
        |> Pivot.withRollback (Pivot.goAbsolute 500)


lengthL : Benchmark
lengthL =
    benchmark "lengthL" (\_ -> Pivot.Position.lengthL pivot1000)


lengthR : Benchmark
lengthR =
    benchmark "lengthR" (\_ -> Pivot.Position.lengthR pivot1000)


lengthA : Benchmark
lengthA =
    benchmark "lengthA" (\_ -> Pivot.Position.lengthA pivot1000)
