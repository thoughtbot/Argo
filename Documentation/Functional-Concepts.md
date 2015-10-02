## Functional Concepts

Argo really wants to be used with patterns borrowed from functional programming
such as `map` (`<^>`) and `apply` (`<*>`). We feel that these patterns greatly
reduce the pain felt in trying to use JSON (an inherently loosely typed format)
with Swift (a strictly typed language). It also gives us a way to succinctly
maintain Argo's core concept, and short circuit the decoding process if any part
of it fails.

Additionally, we feel that the use of operators for these functions greatly
improves the readability of the code we're suggesting. Using named functions
would lead to nested functions and a confusing number of parenthesis.

If you aren't familiar with how these functions work (or just aren't
comfortable with using operators), that's totally OK. It's possible to use the
library without using them, although it might be a little more painful.

If you're looking to learn more about these functions, we would recommend
reading the following articles:

- [Functional Swift for Dealing with Optional Values](http://robots.thoughtbot.com/functional-swift-for-dealing-with-optional-values)
- [Railway Oriented Programming](http://fsharpforfunandprofit.com/posts/recipe-part2/)

And check out this talk:

- [How I Learned To Stop Worrying And Love The Functor](https://github.com/gfontenot/talks/tree/master/Functors)

