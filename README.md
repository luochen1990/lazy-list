lazy.coffee
===========

A lazy javascript library for Haskell & FP(Functional Programming) lovers.

- better performance.
- well named and designed helper functions.
- allowing recursive lazylist definition.
- almost no gap between normal Array and lazylist.
- includes useful things like random_gen, permutation_gen, cartProd.
- fully tested.
- use it without CoffeeScript is also ok.
- ES6 supported. (you can use the for...of syntax to enumerate an lazylist)

Concepts [_details_](APIs.md)
--------

### nil, lazylist, iterator

these three concepts gives the core definition of lazylist.

- *iterator* is a function which keeps status in it's closure, everytime you call an iterator may got different return values.
- *lazylist* is almost a list except it is lazy evaluated. you can call the `.iter()` method to get a new iterator of a lazylist.
- `nil` is both an empty list and the end sign of a lazylist.
- the function `lazylist` is used to define a lazylist from a without-argument-function which returns an iterator.
- the function `iterator` is used to get an iterator from a without-argument-function which keeps status in it's closure. the `.next()` method is provided to support ES6 standard.

### constants/producers, decorators/combiners, consumers

- *constants* and *producers* is provided to get most used lazylists.
- *decorators* and *combiners* is provided to get new lazylist from existing lazylists.
- *consumers* is provided to get some normal value or side effects via enumerating a lazylist.

Most Possible Abuse
-------------------

### use `map` to do side effect.

you should **never** do side effect in the argument function of `map` or any other decorators/combiners. if you want to enumerate a lazylist to do something, `foreach` is exactly what you want.

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

The abuse of `map` will make thing unclear since `map` is designed to return a lazylist and changes nothing else. Actually the `map` one won't work since the mapping function is not called immediately.

And `foreach` is designed to enumerate items in a lazylist and do side effects in it's callback function.

Do right things in right way keeps bugs away.

### use recursive definitions of lazylist everywhere

Actually this is not mistake of users. But it is still not recommended to use recursive definitions frequently. Since there is neither graph reduction optimization in lazy.coffee nor tail call optimization in javascript. the performance of recursive programs is a big problem here.

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

FAQ for FP newbies
------------------

### why not underscore?

lazy.coffee is a better compromise between expressive ability and performance. underscore considers less on performance.

### why not lazy.js?

lazy.js did almost the same thing like lazy.coffee. But, if you don't like the "dot dot dot..." style, if you don't want to mix things up, if you want better named and designed apis, *lazy.coffee* is just for you! Moreover, this one works well with ES6, and has a litte [performance advantage](http://luochen1990.me/try_coffee?code=%22run%20%3D%20(f%2C%20size%20%3D%201e7%2C%20times%20%3D%201)%20-%3E%5Cn%5Ctfor%20i%20in%20%5B0...times%5D%5Cn%5Ct%5Ctf(size)%5Cn%5Cnplus%20%3D%20(x%2C%20y)%20-%3E%20x%20%2B%20y%5Cninc%20%3D%20(x)%20-%3E%20x%20%2B%201%5Cn%5Cntest1%20%3D%20(case_size)%20-%3E%5Cn%5Ctnative_style%20%3D%20-%3E%5Cn%5Ct%5Ctr%20%3D%200%5Cn%5Ct%5Ctfor%20i%20in%20%5B0...case_size%5D%5Cn%5Ct%5Ct%5Ctr%20%2B%3D%20i%5Cn%5Ct%5Ctreturn%20r%5Cn%5Ctlog%20-%3E%20native_style()%5Cn%5Ctlog%20-%3E%20Lazy.range(case_size).reduce(plus%2C%200)%5Cn%5Ctlog%20-%3E%20foldl(plus%2C%200)%20range(case_size)%5Cn%5Cntest2%20%3D%20(case_size)%20-%3E%5Cn%5Ctnative_style2%20%3D%20-%3E%5Cn%5Ct%5Ctr%20%3D%20true%5Cn%5Ct%5Ctok%20%3D%20greaterEqual(0)%5Cn%5Ct%5Ctfor%20i%20in%20%5B0...case_size%5D%5Cn%5Ct%5Ct%5Ctx%20%3D%20inc(i)%5Cn%5Ct%5Ct%5Ctr%20%3D%20r%20and%20ok%20x%5Cn%5Ct%5Ctreturn%20r%5Cn%5Ctlog%20-%3E%20native_style2()%5Cn%5Ctlog%20-%3E%20Lazy.range(case_size).map(inc).none(lessThan%200)%5Cn%5Ctlog%20-%3E%20all(greaterEqual%200)%20map(inc)%20range(case_size)%5Cn%5Cnrun%20test1%5Cnrun%20test2%2C%201e6%22&libs=%5B%22https%3A%2F%2Fcdn.rawgit.com%2Fdtao%2Flazy.js%2F0.4.0%2Flazy.min.js%22%5D) than lazy.js.

### what is lazy evaluation?

In short, lazy evaluation records the process of evaluation in some way(called "thunk"), but only really evaluate it when you need it. this makes your program use less memory than in strict evaluation. This way, you can also express infinity sequences naturally like `range(2, Infinity)`, `primes`, `randoms` etc.

FAQ for FP masters
------------------

### why head, tail (or car, cdr for lispers), foldr, id, filp etc. is not provided?

This library attemts to provides a sort of utils which takes minutes to implement. It will take a lot of names to provide the takes-seconds-to-implement things, which will not be a good practice in javascript(in which it's hard to manage names). if you need them somewhere, implement them yourself like [this](http://luochen1990.me/try_coffee?code=%22car%20%3D%20head%20%3D%20(xs)%20-%3E%20last%20take(1)%20xs%5Cncdr%20%3D%20tail%20%3D%20drop(1)%5Cnid%20%3D%20(x)%20-%3E%20x%5Cnflip%20%3D%20(f)%20-%3E%20(x)%20-%3E%20(y)%20-%3E%20f(y)(x)%5Cn%22).

### why fold is not provided?

In Haskell, fold is used on Monoids which gives the definition of empty element for the operator. But there is not a similar way to decide what to return when given an empty list. ie. `fold(plus) []` should return `0` but `fold(product) []` should return `1`. So just use foldl and provide an init element like this: `foldl(plus, 0) []`.

Install
-------

#### install & require in nodejs

- install with npm: `npm install lazy.coffee`
- require separately: `{map, filter} = require 'lazy.coffee'`
- require globally: `require 'lazy.coffee/global'`

#### reference in html directly

```html
<script src="http://rawgit.com/luochen1990/lazy.coffee/master/build/global.coffee.js" type="text/javascript"></script>
```

Run Demo
--------

run `coffee ./demo.coffee` under directory `lazy.coffee/` directly after you have `coffee-script` installed.

Todo
----

- any way to optimize the performance of recursively defined lazylist.
- the test coverage report.
- finish the doc in APIs.md: description & demo for each function.

