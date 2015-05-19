(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.lazy = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var this_module,
  slice = [].slice;

this_module = function(arg) {
  var Iterator, LazyList, Symbol, all, any, best, brk, cartProd, concat, cons, drop, dropWhile, enumerate, filter, foldl, foreach, group, groupBy, groupOn, head, iterate, last, lazy, length, list, map, naturals, nil, partition, permutations, primes, random_gen, range, ranged_random_gen, ref, repeat, reverse, scanl, sort, sortOn, streak, take, takeWhile, zip, zipWith;
  Symbol = arg.Symbol;
  LazyList = function(f) {
    f[Symbol.iterator] = function() {
      return f();
    };
    f.toString = function() {
      return "LazyList";
    };
    return f;
  };
  nil = LazyList(function() {
    return nil;
  });
  nil.toString = function() {
    return 'nil';
  };
  Iterator = function(it) {
    it.next = function() {
      var r;
      r = it();
      return {
        value: r,
        done: r === nil
      };
    };
    it.toString = function() {
      return "Iterator";
    };
    return it;
  };
  naturals = LazyList(function() {
    var i;
    i = -1;
    return Iterator(function() {
      return ++i;
    });
  });
  range = function() {
    var args;
    args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    if (args.length === 0) {
      return naturals;
    } else if (args.length === 1) {
      return LazyList(function() {
        var i, stop;
        stop = args[0];
        i = -1;
        return Iterator(function() {
          if (++i < stop) {
            return i;
          } else {
            return nil;
          }
        });
      });
    } else if (args.length === 2) {
      return LazyList(function() {
        var i, start, stop;
        start = args[0], stop = args[1];
        if (start < stop) {
          i = start - 1;
          return Iterator(function() {
            if (++i < stop) {
              return i;
            } else {
              return nil;
            }
          });
        } else {
          i = start + 1;
          return Iterator(function() {
            if (--i > stop) {
              return i;
            } else {
              return nil;
            }
          });
        }
      });
    } else {
      return LazyList(function() {
        var i, start, step, stop;
        start = args[0], stop = args[1], step = args[2];
        if (stop !== start && (stop - start) * step < 0) {
          throw 'ERR IN range(): YOU ARE CREATING AN UNLIMITTED RANGE';
        }
        i = start - step;
        if (start < stop) {
          return Iterator(function() {
            if ((i += step) < stop) {
              return i;
            } else {
              return nil;
            }
          });
        } else {
          return Iterator(function() {
            if ((i += step) > stop) {
              return i;
            } else {
              return nil;
            }
          });
        }
      });
    }
  };
  primes = LazyList(function() {
    return filter(function(x) {
      return all(function(p) {
        return x % p !== 0;
      })(takeWhile(function(p) {
        return p * p <= x;
      })(range(2, Infinity)));
    })(range(2, Infinity))();
  });
  lazy = function(xs) {
    var ref;
    if (typeof xs === 'function') {
      if (xs[Symbol.iterator] != null) {
        return xs;
      } else {
        return LazyList(xs);
      }
    } else if ((ref = xs.constructor) === Array || ref === String) {
      return LazyList(function() {
        var i;
        i = -1;
        return Iterator(function() {
          if ((++i) < xs.length) {
            return xs[i];
          } else {
            return nil;
          }
        });
      });
    } else if (xs[Symbol.iterator] != null) {
      return LazyList(function() {
        var it;
        it = xs[Symbol.iterator]();
        return Iterator(function() {
          var r;
          r = it.next();
          if (r.done) {
            return nil;
          } else {
            return r.value;
          }
        });
      });
    } else {
      throw Error('lazy(xs): xs is neither Array nor Iterable');
    }
  };
  enumerate = function(it) {
    if ((it[Symbol.iterator] != null) || it instanceof Array) {
      return zip(naturals, it);
    } else {
      return LazyList(function() {
        var i, keys;
        keys = Object.keys(it);
        i = -1;
        return Iterator(function() {
          var k;
          if (++i < keys.length) {
            return [(k = keys[i]), it[k]];
          } else {
            return nil;
          }
        });
      });
    }
  };
  repeat = function(x) {
    return LazyList(function() {
      return Iterator(function() {
        return x;
      });
    });
  };
  iterate = function(next, init) {
    return LazyList(function() {
      var st;
      st = init;
      return Iterator(function() {
        var r;
        r = st;
        st = next(st);
        return r;
      });
    });
  };
  random_gen = (function() {
    var hash;
    hash = function(x) {
      x = Math.sin(x) * 1e4;
      return x - Math.floor(x);
    };
    return function(opts) {
      var ref, seed;
      seed = hash((ref = opts != null ? opts.seed : void 0) != null ? ref : Math.random());
      return iterate(hash, seed);
    };
  })();
  ranged_random_gen = function(range, opts) {
    var ref, seed;
    seed = (ref = opts != null ? opts.seed : void 0) != null ? ref : Math.random();
    return map(function(x) {
      return Math.floor(x * range);
    })(random_gen({
      seed: seed
    }));
  };
  permutations = (function() {
    var next_permutation;
    next_permutation = function(x) {
      var l, m, r, ref, ref1;
      x = x.slice(0);
      l = x.length - 1;
      while (l >= 1 && x[l] <= x[l - 1]) {
        --l;
      }
      if (l !== 0) {
        m = x.length - 1;
        while (m > l - 1 && x[m] <= x[l - 1]) {
          --m;
        }
        ref = [x[l - 1], x[m]], x[m] = ref[0], x[l - 1] = ref[1];
      }
      r = x.length - 1;
      while (l < r) {
        ref1 = [x[r], x[l]], x[l] = ref1[0], x[r] = ref1[1];
        ++l;
        --r;
      }
      return x;
    };
    return function(xs) {
      var arr;
      arr = list(xs);
      if (arr.length === 0) {
        return nil;
      } else {
        return cons(arr.slice(0))(takeWhile(function(ls) {
          return json(ls) !== json(arr);
        })(drop(1)(iterate(next_permutation, arr))));
      }
    };
  })();
  take = function(n) {
    return function(xs) {
      return LazyList(function() {
        var c, iter;
        iter = lazy(xs)[Symbol.iterator]();
        c = -1;
        return Iterator(function() {
          if (++c < n) {
            return iter();
          } else {
            return nil;
          }
        });
      });
    };
  };
  takeWhile = function(ok) {
    return function(xs) {
      return LazyList(function() {
        var iter;
        iter = lazy(xs)[Symbol.iterator]();
        return Iterator(function() {
          var x;
          if ((x = iter()) !== nil && ok(x)) {
            return x;
          } else {
            return nil;
          }
        });
      });
    };
  };
  drop = function(n) {
    return function(xs) {
      return LazyList(function() {
        var finished, i, iter, j, ref;
        iter = lazy(xs)[Symbol.iterator]();
        finished = false;
        for (i = j = 0, ref = n; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
          finished || (finished = iter() === nil);
          if (finished) {
            break;
          }
        }
        if (finished) {
          return function() {
            return nil;
          };
        } else {
          return iter;
        }
      });
    };
  };
  dropWhile = function(ok) {
    return function(xs) {
      return LazyList(function() {
        var iter, x;
        iter = lazy(xs)[Symbol.iterator]();
        while (ok(x = iter()) && x !== nil) {
          null;
        }
        return Iterator(function() {
          var prevx, ref;
          ref = [x, iter()], prevx = ref[0], x = ref[1];
          return prevx;
        });
      });
    };
  };
  cons = function(x) {
    return function(xs) {
      return LazyList(function() {
        var iter;
        iter = null;
        return Iterator(function() {
          if (iter === null) {
            iter = lazy(xs)[Symbol.iterator]();
            return x;
          } else {
            return iter();
          }
        });
      });
    };
  };
  map = function(f) {
    return function(xs) {
      return LazyList(function() {
        var iter;
        iter = lazy(xs)[Symbol.iterator]();
        return Iterator(function() {
          var x;
          if ((x = iter()) !== nil) {
            return f(x);
          } else {
            return nil;
          }
        });
      });
    };
  };
  filter = function(ok) {
    return function(xs) {
      return LazyList(function() {
        var iter;
        iter = lazy(xs)[Symbol.iterator]();
        return Iterator(function() {
          var x;
          while (!ok(x = iter()) && x !== nil) {
            null;
          }
          return x;
        });
      });
    };
  };
  scanl = function(f, r) {
    return function(xs) {
      return LazyList(function() {
        var iter;
        iter = lazy(xs)[Symbol.iterator]();
        return Iterator(function() {
          var got, x;
          got = r;
          r = (x = iter()) !== nil ? f(r, x) : nil;
          return got;
        });
      });
    };
  };
  streak = function(n) {
    if (n < 1) {
      return nil;
    } else {
      return function(xs) {
        return drop(n - 1)(LazyList(function() {
          var buf, iter;
          iter = lazy(xs)[Symbol.iterator]();
          buf = [];
          return Iterator(function() {
            var x;
            if ((x = iter()) === nil) {
              return nil;
            }
            buf.push(x);
            if (buf.length > n) {
              buf.shift(1);
            }
            return buf.slice(0);
          });
        }));
      };
    }
  };
  reverse = function(xs) {
    var ref;
    if ((ref = xs.constructor) === Array || ref === String) {
      return LazyList(function() {
        var i;
        i = xs.length;
        return Iterator(function() {
          if ((--i) >= 0) {
            return xs[i];
          } else {
            return nil;
          }
        });
      });
    } else {
      return list(lazy(xs)).reverse();
    }
  };
  sort = function(xs) {
    var arr;
    arr = list(lazy(xs));
    return arr.sort();
  };
  sortOn = function(f) {
    return function(xs) {
      var arr;
      arr = list(lazy(xs));
      return arr.sort(function(a, b) {
        var fa, fb;
        return ((fa = f(a)) > (fb = f(b))) - (fa < fb);
      });
    };
  };
  group = function(xs) {
    return LazyList(function() {
      var iter, t, x;
      iter = lazy(xs)[Symbol.iterator]();
      t = nil;
      x = iter();
      return Iterator(function() {
        if (x === nil) {
          return nil;
        } else if (x !== t) {
          t = x;
          return LazyList(function() {
            return Iterator(function() {
              var r;
              if ((r = x) === t) {
                x = iter();
                return r;
              } else {
                return nil;
              }
            });
          });
        }
      });
    });
  };
  groupBy = function(eq) {
    return function(xs) {
      return LazyList(function() {
        var iter, t, x;
        iter = lazy(xs)[Symbol.iterator]();
        t = nil;
        x = iter();
        return Iterator(function() {
          if (x === nil) {
            return nil;
          } else if (!eq(x, t)) {
            t = x;
            return LazyList(function() {
              return Iterator(function() {
                var r;
                if (eq((r = x), t)) {
                  x = iter();
                  return r;
                } else {
                  return nil;
                }
              });
            });
          }
        });
      });
    };
  };
  groupOn = function(f) {
    return function(xs) {
      var k, memo, v;
      memo = {};
      foreach(xs, function(x) {
        var y;
        y = f(x);
        if (memo[y] == null) {
          memo[y] = [];
        }
        return memo[y].push(x);
      });
      return (function() {
        var results;
        results = [];
        for (k in memo) {
          v = memo[k];
          results.push(v);
        }
        return results;
      })();
    };
  };
  partition = function(f) {
    return function(xs) {
      var memo;
      memo = [[], []];
      foreach(xs, function(x) {
        var y;
        y = !f(x) + 0;
        return memo[y].push(x);
      });
      return memo;
    };
  };
  concat = function(xss) {
    return LazyList(function() {
      var iter, xs, xs_iter;
      xs_iter = lazy(xss)[Symbol.iterator]();
      xs = xs_iter();
      iter = lazy(xs)[Symbol.iterator]();
      return Iterator(function() {
        var x;
        if ((x = iter()) !== nil) {
          return x;
        } else if ((xs = xs_iter()) !== nil) {
          iter = lazy(xs)[Symbol.iterator]();
          return iter();
        } else {
          return nil;
        }
      });
    });
  };
  ref = (function() {
    var finished, zip, zipWith;
    finished = function(arr) {
      var j, len1, x;
      for (j = 0, len1 = arr.length; j < len1; j++) {
        x = arr[j];
        if (x === nil) {
          return true;
        }
      }
      return false;
    };
    zip = function() {
      var xss;
      xss = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      return LazyList(function() {
        var iters, xs;
        iters = (function() {
          var j, len1, results;
          results = [];
          for (j = 0, len1 = xss.length; j < len1; j++) {
            xs = xss[j];
            results.push(lazy(xs)[Symbol.iterator]());
          }
          return results;
        })();
        return Iterator(function() {
          var iter, next;
          next = (function() {
            var j, len1, results;
            results = [];
            for (j = 0, len1 = iters.length; j < len1; j++) {
              iter = iters[j];
              results.push(iter());
            }
            return results;
          })();
          if (finished(next)) {
            return nil;
          } else {
            return next;
          }
        });
      });
    };
    zipWith = function(f) {
      return function() {
        var xss;
        xss = 1 <= arguments.length ? slice.call(arguments, 0) : [];
        return LazyList(function() {
          var iters, xs;
          iters = (function() {
            var j, len1, results;
            results = [];
            for (j = 0, len1 = xss.length; j < len1; j++) {
              xs = xss[j];
              results.push(lazy(xs)[Symbol.iterator]());
            }
            return results;
          })();
          return Iterator(function() {
            var iter, next;
            next = (function() {
              var j, len1, results;
              results = [];
              for (j = 0, len1 = iters.length; j < len1; j++) {
                iter = iters[j];
                results.push(iter());
              }
              return results;
            })();
            if (finished(next)) {
              return nil;
            } else {
              return f.apply(null, next);
            }
          });
        });
      };
    };
    return {
      zip: zip,
      zipWith: zipWith
    };
  })(), zip = ref.zip, zipWith = ref.zipWith;
  cartProd = (function() {
    var apply_vector, inc_vector;
    inc_vector = function(limits) {
      var len_minus_1;
      len_minus_1 = limits.length - 1;
      return function(vec) {
        var i;
        i = len_minus_1;
        while (!(++vec[i] < limits[i] || i <= 0)) {
          vec[i--] = 0;
        }
        return vec;
      };
    };
    apply_vector = function(space) {
      var len;
      len = space.length;
      return function(vec) {
        var i, j, ref1, results;
        results = [];
        for (i = j = 0, ref1 = len; 0 <= ref1 ? j < ref1 : j > ref1; i = 0 <= ref1 ? ++j : --j) {
          results.push(space[i][vec[i]]);
        }
        return results;
      };
    };
    return function() {
      var xss;
      xss = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      return LazyList(function() {
        var get_value, i, inc, j, len, len1, limits, v, xs;
        xss = (function() {
          var j, len1, results;
          results = [];
          for (j = 0, len1 = xss.length; j < len1; j++) {
            xs = xss[j];
            results.push(list(xs));
          }
          return results;
        })();
        limits = (function() {
          var j, ref1, results;
          results = [];
          for (i = j = 0, ref1 = xss.length; 0 <= ref1 ? j < ref1 : j > ref1; i = 0 <= ref1 ? ++j : --j) {
            results.push(xss[i].length);
          }
          return results;
        })();
        for (j = 0, len1 = limits.length; j < len1; j++) {
          len = limits[j];
          if (len === 0) {
            return nil;
          }
        }
        inc = inc_vector(limits);
        get_value = apply_vector(xss);
        v = (function() {
          var o, ref1, results;
          results = [];
          for (i = o = 0, ref1 = xss.length; 0 <= ref1 ? o < ref1 : o > ref1; i = 0 <= ref1 ? ++o : --o) {
            results.push(0);
          }
          return results;
        })();
        return Iterator(function() {
          var r;
          if (v[0] < limits[0]) {
            r = get_value(v);
            inc(v);
            return r;
          } else {
            return nil;
          }
        });
      });
    };
  })();
  list = function(xs) {
    var it, n, results, results1, x;
    if (xs instanceof Array) {
      return xs;
    } else if (typeof xs === 'function') {
      it = xs[Symbol.iterator]();
      results = [];
      while ((x = it()) !== nil) {
        results.push(x);
      }
      return results;
    } else if (xs[Symbol.iterator] != null) {
      it = lazy(xs)[Symbol.iterator]();
      results1 = [];
      while ((x = it()) !== nil) {
        results1.push(x);
      }
      return results1;
    } else if (typeof xs === 'number') {
      n = xs;
      return function(xs) {
        return list(take(n)(xs));
      };
    } else {
      throw Error('list(xs): xs is neither Array nor Iterable');
    }
  };
  head = function(xs) {
    var iter, ref1, ref2;
    if ((ref1 = xs.constructor) === Array || ref1 === String) {
      return (ref2 = xs[0]) != null ? ref2 : nil;
    } else {
      iter = lazy(xs)[Symbol.iterator]();
      return iter();
    }
  };
  last = function(xs) {
    var iter, r, ref1, ref2, x;
    if ((ref1 = xs.constructor) === Array || ref1 === String) {
      return (ref2 = xs[xs.length - 1]) != null ? ref2 : nil;
    } else {
      iter = lazy(xs)[Symbol.iterator]();
      r = nil;
      while ((x = iter()) !== nil) {
        r = x;
      }
      return r;
    }
  };
  length = function(xs) {
    var iter, r, ref1, x;
    if ((ref1 = xs.constructor) === Array || ref1 === String) {
      return xs.length;
    } else {
      iter = lazy(xs)[Symbol.iterator]();
      r = 0;
      while ((x = iter()) !== nil) {
        ++r;
      }
      return r;
    }
  };
  foldl = function(f, init) {
    return function(xs) {
      var iter, r, x;
      r = init;
      iter = lazy(xs)[Symbol.iterator]();
      while ((x = iter()) !== nil) {
        r = f(r, x);
      }
      return r;
    };
  };
  best = function(better) {
    return function(xs) {
      var it, iter, r;
      iter = lazy(xs)[Symbol.iterator]();
      if ((r = iter()) === nil) {
        return null;
      }
      while ((it = iter()) !== nil) {
        r = better(it, r) ? it : r;
      }
      return r;
    };
  };
  all = function(f) {
    if (typeof f !== 'function') {
      f = (function(x) {
        return x === f;
      });
    }
    return function(xs) {
      var iter, x;
      iter = lazy(xs)[Symbol.iterator]();
      while ((x = iter()) !== nil) {
        if (!f(x)) {
          return false;
        }
      }
      return true;
    };
  };
  any = function(f) {
    var all_not;
    all_not = all(function(x) {
      return !f(x);
    });
    return function(xs) {
      return !(all_not(xs));
    };
  };
  brk = function() {
    return brk;
  };
  brk.toString = function() {
    return 'foreach.break';
  };
  foreach = function(xs, callback, fruit) {
    var iter, x;
    iter = lazy(xs)[Symbol.iterator]();
    while ((x = iter()) !== nil) {
      if (callback(x, fruit) === brk) {
        break;
      }
    }
    return fruit;
  };
  Object.defineProperties(foreach, {
    "break": {
      writable: false,
      configurable: false,
      enumerable: false,
      value: brk
    }
  });
  return {
    nil: nil,
    LazyList: LazyList,
    Iterator: Iterator,
    Symbol: Symbol,
    naturals: naturals,
    range: range,
    primes: primes,
    lazy: lazy,
    enumerate: enumerate,
    repeat: repeat,
    iterate: iterate,
    random_gen: random_gen,
    ranged_random_gen: ranged_random_gen,
    permutations: permutations,
    cons: cons,
    map: map,
    filter: filter,
    take: take,
    takeWhile: takeWhile,
    drop: drop,
    dropWhile: dropWhile,
    scanl: scanl,
    streak: streak,
    reverse: reverse,
    sort: sort,
    sortOn: sortOn,
    group: group,
    groupBy: groupBy,
    groupOn: groupOn,
    partition: partition,
    concat: concat,
    zip: zip,
    zipWith: zipWith,
    cartProd: cartProd,
    list: list,
    head: head,
    last: last,
    length: length,
    foldl: foldl,
    best: best,
    all: all,
    any: any,
    foreach: foreach
  };
};

module.exports = this_module({
  Symbol: typeof Symbol !== "undefined" && Symbol !== null ? Symbol : {
    iterator: 'iter'
  }
});


},{}]},{},[1])(1)
});


//# sourceMappingURL=lazy.js.map