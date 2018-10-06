# Changelog

All notable changes to this project will be documented in this file.

The format is based on the [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) post.

## [3.1.0] - 2018-10-06

### Added

- `toList` as alias for `getA`.

### Changed

- [#13](https://github.com/yotamDvir/elm-pivot/pull/13) Performance: `has*`, `getA` (`toList`), `length*` optimized.
## [3.0.0] - 2018-09-07

**Updated to [Elm 0.19](https://github.com/elm/compiler/blob/master/upgrade-docs/0.19.md)!**

### Added

- [#10](https://github.com/yotamDvir/elm-pivot/issues/10) `indexRelative`.
- `appendListL` and `appendListR`.

### Changed

- [#10](https://github.com/yotamDvir/elm-pivot/issues/10) `zip` replaced by `indexAbsolute`.
- [#11](https://github.com/yotamDvir/elm-pivot/issues/11) Left side is considered starting from the center in mapping using one of the `mapL_` and similar methods (now named `mapWholeL`). This improves performance as internally this saves on a couple of `List.reverse`s. To retain same functionality as before, simply use `List.reverse >> f >> List.reverse` in place of `f` as what is mapped over the left side.
- In all methods `add` replaced by `append`.
- In all methods `map*_` replaced by `mapWhole*`.
- `goBy` replaced by `goRelative` and `goTo` replaced by `goAbsolute`.

## [2.0.0] - 2016-11-29

Changlog started.
