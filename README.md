Lazy List
=========

A lazy javascript library for Haskell & FP(Functional Programming) lovers.

- better performance.
- well named and designed helper functions.
- allowing recursive LazyList definition.
- almost no gap between normal Array and LazyList.
- includes useful things like random_gen, permutation_gen, cartProd.
- fully tested.
- use it without CoffeeScript is also ok.
- ES6 supported. (you can use the for...of syntax to enumerate an LazyList)

Conceptions
-----------

Here explained the core conceptions of lazy-list. you can find [**APIs' descriptions and demo** here](APIs.md)

### nil, LazyList, Iterator

these three concepts gives the core definition of LazyList.

- *Iterator* is a function which keeps status in it's closure, everytime you call an Iterator may got different return values.
- *LazyList* is almost a list except it is lazy evaluated. you can call the `.iter()` method to get a new Iterator of a LazyList.
- `nil` is both an empty list and the end sign of a LazyList.
- the function `LazyList` is used to define a LazyList from a without-argument-function which returns an Iterator.
- the function `Iterator` is used to get an Iterator from a without-argument-function which keeps status in it's closure. the `.next()` method is provided to support ES6 standard.

### constants/producers, decorators/combiners, consumers

- *constants* and *producers* is provided to get most used LazyLists.
- *decorators* and *combiners* is provided to get new LazyList from existing LazyLists.
- *consumers* is provided to get some normal value or side effects via enumerating a LazyList.

Most Possible Abuse
-------------------

### use `map` to do side effect.

you should **never** do side effect in the argument function of `map` or any other decorators/combiners. if you want to enumerate a LazyList to do something, `foreach` is exactly what you want.

ie. lots of people used to do things like this:

```coffeescript
map((x) ->
	console.log x
) range(10)
```

it is strongly recommended that you use `foreach` instead:

```coffeescript
foreach range(10), (x) ->
	console.log x
```

The abuse of `map` will make thing unclear since `map` is designed to return a LazyList and changes nothing else. Actually the `map` one won't work since the mapping function is not called immediately.

And `foreach` is designed to enumerate items in a LazyList and do side effects in it's callback function.

Do right things in right way keeps bugs away.

### use recursive definitions of LazyList everywhere

Actually this is not mistake of users. But it is still not recommended to use recursive definitions frequently. Since there is neither graph reduction optimization in lazy-list nor tail call optimization in javascript. the performance of recursive programs is a big problem here.

here is a fibs recursive definition which has an exponential time complexity:

```coffeescript
fibs = lazy -> do
	cons(0) cons(1) (zipWith(plus) fibs, (drop(1) fibs))

console.log last take(15) fibs #will finish in 1 second
console.log last take(30) fibs #will finish in much more than 1 second
```

Instead, you can define fibs like this which has a better performance:

```coffeescript
fibs = map(([a, b]) -> a) generate [0, 1], ([a, b]) -> [b, a + b]

console.log last take(1000) fibs #will finish in 1 second
```

FAQ
---

### why not underscore?

lazy-list is a better compromise between expressive ability and performance. underscore considers less on performance.

### why not lazy.js?

lazy.js did almost the same thing like lazy-list. But, if you don't like the "dot dot dot..." style, if you don't want to mix things up, if you want better named and designed apis, *lazy-list* is just for you! Moreover, this one works well with ES6, and has a litte [performance advantage](http://luochen1990.me/try_coffee?libs=%5B%22https%3A%2F%2Fcdn.rawgit.com%2Fdtao%2Flazy.js%2F0.4.0%2Flazy.min.js%22%5D#cnVuID0gKGYsIHNpemUgPSAxZTcsIHRpbWVzID0gMSkgLT4KCWZvciBpIGluIFswLi4udGltZXNdCgkJZihzaXplKQoKcGx1cyA9ICh4LCB5KSAtPiB4ICsgeQppbmMgPSAoeCkgLT4geCArIDEKCnRlc3QxID0gKGNhc2Vfc2l6ZSkgLT4KCW5hdGl2ZV9zdHlsZSA9IC0+CgkJciA9IDAKCQlmb3IgaSBpbiBbMC4uLmNhc2Vfc2l6ZV0KCQkJciArPSBpCgkJcmV0dXJuIHIKCWxvZyAtPiBuYXRpdmVfc3R5bGUoKQoJbG9nIC0+IExhenkucmFuZ2UoY2FzZV9zaXplKS5yZWR1Y2UocGx1cywgMCkKCWxvZyAtPiBmb2xkbChwbHVzLCAwKSByYW5nZShjYXNlX3NpemUpCgp0ZXN0MiA9IChjYXNlX3NpemUpIC0+CgluYXRpdmVfc3R5bGUyID0gLT4KCQlyID0gdHJ1ZQoJCW9rID0gZ3JlYXRlckVxdWFsKDApCgkJZm9yIGkgaW4gWzAuLi5jYXNlX3NpemVdCgkJCXggPSBpbmMoaSkKCQkJciA9IHIgYW5kIG9rIHgKCQlyZXR1cm4gcgoJbG9nIC0+IG5hdGl2ZV9zdHlsZTIoKQoJbG9nIC0+IExhenkucmFuZ2UoY2FzZV9zaXplKS5tYXAoaW5jKS5ub25lKGxlc3NUaGFuIDApCglsb2cgLT4gYWxsKGdyZWF0ZXJFcXVhbCAwKSBtYXAoaW5jKSByYW5nZShjYXNlX3NpemUpCgpydW4gdGVzdDEKcnVuIHRlc3QyLCAxZTY=) than lazy.js.

### what is lazy evaluation?

In short, lazy evaluation records the process of evaluation in some way(called "thunk"), but only really evaluate it when you need it. this makes your program use less memory than in strict evaluation. This way, you can also express infinity sequences naturally like `range(2, Infinity)`, `primes`, `randoms` etc.

### why head, tail (or car, cdr for lispers), foldr, id, filp etc. is not provided?

This library attemts to provides a sort of utils which takes minutes to implement. It will take a lot of names to provide the takes-seconds-to-implement things, which will not be a good practice in javascript(in which it's hard to manage names). if you need them somewhere, implement them yourself like [this](http://luochen1990.me/try_coffee?code=%22car%20%3D%20head%20%3D%20(xs)%20-%3E%20last%20take(1)%20xs%5Cncdr%20%3D%20tail%20%3D%20drop(1)%5Cnid%20%3D%20(x)%20-%3E%20x%5Cnflip%20%3D%20(f)%20-%3E%20(x)%20-%3E%20(y)%20-%3E%20f(y)(x)%5Cn%22).

### why fold is not provided?

In Haskell, fold is used on Monoids which gives the definition of empty element for the operator. But there is not a similar way to decide what to return when given an empty list. ie. `fold(plus) []` should return `0` but `fold(product) []` should return `1`. So just use foldl and provide an init element like this: `foldl(plus, 0) []`.

### why it is designed like this?

Of course there is many other possible definition about lazylist. But I have to consider about both the design and the performance reason. here is a [comparison](http://luochen1990.me/try_coffee?#cGx1cyA9ICh4LCB5KSAtPiB4ICsgeQpjYXNlX3NpemUgPSAxZTYKCmxvZyAtPiBmb2xkbChwbHVzLCAwKSByYW5nZShjYXNlX3NpemUpCgpjbGFzcyBMYXp5TGlzdAoJY29uc3RydWN0b3I6IChzdGF0dXMsIGl0ZXIpIC0+CgkJQFtTeW1ib2wuaXRlcmF0b3JdID0gLT4KCQkJbmV3IEl0ZXJhdG9yKHN0YXR1cywgaXRlcikKCmNsYXNzIEl0ZXJhdG9yCgljb25zdHJ1Y3RvcjogKHN0YXR1cywgQGl0ZXIpIC0+CgkJQFtrXSA9IHYgZm9yIGssIHYgb2Ygc3RhdHVzCgluZXh0OiAtPgoJCXIgPSBAaXRlcigpCgkJe3ZhbHVlOiByLCBkb25lOiByID09IG5pbH0KCm5pbCA9IG5ldyBMYXp5TGlzdCB7fSwgLT4gbmlsCgpyYW5nZTIgPSAoc3RvcCkgLT4KCW5ldyBMYXp5TGlzdCB7YzogLTF9LCAtPgoJCWlmICsrQGMgPCBzdG9wIHRoZW4gQGMgZWxzZSBuaWwKCQkJCmZvbGRsMiA9IChmLCByKSAtPgoJKHhzKSAtPgoJCWl0ID0geHNbU3ltYm9sLml0ZXJhdG9yXSgpCgkJaXRlciA9IC0+IGl0Lml0ZXIoKQoJCXIgPSBmKHIsIHgpIHdoaWxlICh4ID0gaXRlcigpKSBpc250IG5pbAoJCXJldHVybiByCgpsb2cgLT4gZm9sZGwyKHBsdXMsIDApIHJhbmdlMihjYXNlX3NpemUp) about this implementation and another beautiful(but slow) implementation.

Install
-------

#### install & require in nodejs

- install with npm: `your/repo/> npm install lazy-list`
- require separately: `{map, filter} = require 'lazy-list'`
- require globally: `require 'lazy-list/global'`

#### reference in html directly

```html
<script src="http://rawgit.com/luochen1990/lazy-list/master/build/global.coffee.js" type="text/javascript"></script>
```

NOTE: this [*rawgit*](http://rawgit.com/) url is just for test, please don't use it for production.

Run demo
--------

run `coffee ./demo.coffee` under directory `lazy-list/` directly after you have `coffee-script` installed.

Todo
----

- any way to optimize the performance of recursively defined lazylist.
- the test coverage report.
- finish the doc in APIs.md: description & demo for each function.

