# Contributing

Thank you kind soul! Here are some ways to contribute. Small contributions are just as welcome as large ones.

## Bug Report

If something doesn't work quite right, please [post an issue in the repository](https://github.com/yotamDvir/elm-pivot/issues).

## Suggestions

If you feel this library is lacking a method you think would rock, please [post an issue in the repository](https://github.com/yotamDvir/elm-pivot/issues).

## Pull Requests

Pull request with fixes or improvement are welcome! A successful one must use [elm-format](https://github.com/avh4/elm-format/), adhere to the naming conventions, and add relevant documentation (if you're overwhelmed you can start by simply submitting what you have and continue working through feedback cycles).

> In this library, we suffix functions with letters to denote their context,
> as follows.
>
> - The **C**enter
> - Both **S**ides
> - The **L**eft side
> - The **R**ight side
> - **A**ll the members
>
> This way you can guess a function's name easily.
> See the different `map*` functions.
>
> For example, `getL` gets the left side of a pivot.

## Testing

The `tests` folder should at least mirror the examples and guarantees made in the documentation. Some of these have already been written, but there is still much more work.
Ideally, every method would be documented with exhaustive examples and guarantees that are covered in the tests.

## Usage Examples

The `examples` folder describes a few possible uses for this package. More such examples would be welcome. They should adhere to [SSCCE](http://sscce.org/) as much as possible, but at the same time actually be useful, so there is a balance to strike.
