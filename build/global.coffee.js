!function n(r,t,u){function e(i,f){if(!t[i]){if(!r[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(o)return o(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var l=t[i]={exports:{}};r[i][0].call(l.exports,function(n){var t=r[i][1][n];return e(t?t:n)},l,l.exports,n,r,t,u)}return t[i].exports}for(var o="function"==typeof require&&require,i=0;i<u.length;i++)e(u[i]);return e}({1:[function(n){(function(r){var t,u,e;u=n("./lazy");for(t in u)e=u[t],r[t]=e}).call(this,"undefined"!=typeof global?global:"undefined"!=typeof self?self:"undefined"!=typeof window?window:{})},{"./lazy":2}],2:[function(n,r){var t,u=[].slice;t=function(n){var r,t,e,o,i,f,c,a,l,v,h,s,p,g,y,d,m,b,z,S,w,x,E,A,M,N,k,L,O,_,I,R,W,j,q,T,U,D;return r=n.Symbol,z=function(n){return n[r.iterator]=function(){return n()},n.toString=function(){return"LazyList"},n},A=z(function(){return A}),A.toString=function(){return"nil"},d=function(n){return n.next=function(){var r;return r=n(),{value:r,done:r===A}},n.toString=function(){return"Iterator"},n},E=z(function(){var n;return n=-1,d(function(){return++n})}),L=function(){var n;return n=1<=arguments.length?u.call(arguments,0):[],0===n.length?E:z(1===n.length?function(){var r,t;return t=n[0],r=-1,d(function(){return++r<t?r:A})}:2===n.length?function(){var r,t,u;return t=n[0],u=n[1],u>t?(r=t-1,d(function(){return++r<u?r:A})):(r=t+1,d(function(){return--r>u?r:A}))}:function(){var r,t,u,e;if(t=n[0],e=n[1],u=n[2],e!==t&&0>(e-t)*u)throw"ERR IN range(): YOU ARE CREATING AN UNLIMITTED RANGE";return r=t-u,d(e>t?function(){return(r+=u)<e?r:A}:function(){return(r+=u)>e?r:A})})},N=z(function(){return s(function(n){return t(function(r){return n%r!==0})(T(function(r){return n>=r*r})(L(2,1/0)))})(L(2,1/0))()}),b=function(n){return z("function"==typeof n?n:null!=n[r.iterator]?function(){var t;return t=n[r.iterator](),d(function(){var n;return n=t.next(),n.done?A:n.value})}:function(){var r;return r=-1,d(function(){return r+=1,r<n.length?n[r]:A})})},h=function(n){return null!=n[r.iterator]||n instanceof Array?U(E,n):z(function(){var r,t;return t=Object.keys(n),r=-1,d(function(){var u;return++r<t.length?[u=t[r],n[u]]:A})})},I=function(n){return z(function(){return d(function(){return n})})},y=function(n,r){return z(function(){var t;return t=n,d(function(){var n;return n=t,t=r(t),n})})},k=function(){var n;return n=function(n){return n=1e4*Math.sin(n),n-Math.floor(n)},function(r){var t,u;return u=n(null!=(t=null!=r?r.seed:void 0)?t:Math.random()),y(u,n)}}(),O=function(n,r){var t,u;return u=null!=(t=null!=r?r.seed:void 0)?t:Math.random(),x(function(r){return Math.floor(r*n)})(k({seed:u}))},M=function(){var n;return n=function(n){var r,t,u,e,o;for(n=n.slice(0),r=n.length-1;r>=1&&n[r]<=n[r-1];)--r;if(0!==r){for(t=n.length-1;t>r-1&&n[t]<=n[r-1];)--t;e=[n[r-1],n[t]],n[t]=e[0],n[r-1]=e[1]}for(u=n.length-1;u>r;)o=[n[u],n[r]],n[r]=o[0],n[u]=o[1],++r,--u;return n},function(r){return 0===r.length?A:c([r.slice(0)],T(function(n){return json(n)!==json(r)})(l(1)(y(r,n))))}}(),q=function(n){return function(t){return z(function(){var u,e;return e=("function"==typeof t?t:b(t))[r.iterator](),u=-1,d(function(){return++u<n?e():A})})}},T=function(n){return function(t){return z(function(){var u;return u=("function"==typeof t?t:b(t))[r.iterator](),d(function(){var r;return(r=u())!==A&&n(r)?r:A})})}},l=function(n){return function(t){return z(function(){var u,e,o,i,f;for(o=("function"==typeof t?t:b(t))[r.iterator](),u=!1,e=i=0,f=n;(f>=0?f>i:i>f)&&(u||(u=o()===A),!u);e=f>=0?++i:--i);return u?function(){return A}:o})}},v=function(n){return function(t){return z(function(){var u,e;for(u=("function"==typeof t?t:b(t))[r.iterator]();n(e=u())&&e!==A;);return d(function(){var n,r;return r=[e,u()],n=r[0],e=r[1],n})})}},a=function(n){return function(t){return z(function(){var u;return u=null,d(function(){return null===u?(u=("function"==typeof t?t:b(t))[r.iterator](),n):u()})})}},x=function(n){return function(t){return z(function(){var u;return u=("function"==typeof t?t:b(t))[r.iterator](),d(function(){var r;return(r=u())!==A?n(r):A})})}},s=function(n){return function(t){return z(function(){var u;return u=("function"==typeof t?t:b(t))[r.iterator](),d(function(){for(var r;!n(r=u())&&r!==A;);return r})})}},W=function(n,t){return function(u){return z(function(){var e;return e=("function"==typeof u?u:b(u))[r.iterator](),d(function(){var r,u;return r=t,t=(u=e())!==A?n(t,u):A,r})})}},j=function(n){return function(t){return z(function(){var u,e;return e=("function"==typeof t?t:b(t))[r.iterator](),u=[],d(function(){var r;return(r=e())===A?A:(u.push(r),u.length>n&&u.shift(1),u.slice(0))})})}},R=function(n){var r;return r="function"==typeof n?w(n):copy(n),b(r.reverse())},c=function(){var n;return n=1<=arguments.length?u.call(arguments,0):[],z(function(){var t,u;return u=(null!=n[0][r.iterator]?n[0]:b(n[0]))[r.iterator](),t=0,d(function(){var e;return(e=u())!==A?e:++t<n.length?(u=(null!=n[t][r.iterator]?n[t]:b(n[t]))[r.iterator]())():A})})},_=function(){var n,t,e;return n=function(n){var r,t,u;for(r=0,t=n.length;t>r;r++)if(u=n[r],u===A)return!0;return!1},t=function(){var t;return t=1<=arguments.length?u.call(arguments,0):[],z(function(){var u,e;return u=function(){var n,u,o;for(o=[],n=0,u=t.length;u>n;n++)e=t[n],o.push(("function"==typeof e?e:b(e))[r.iterator]());return o}(),d(function(){var r,t;return t=function(){var n,t,e;for(e=[],n=0,t=u.length;t>n;n++)r=u[n],e.push(r());return e}(),n(t)?A:t})})},e=function(t){return function(){var e;return e=1<=arguments.length?u.call(arguments,0):[],z(function(){var u,o;return u=function(){var n,t,u;for(u=[],n=0,t=e.length;t>n;n++)o=e[n],u.push(("function"==typeof o?o:b(o))[r.iterator]());return u}(),d(function(){var r,e;return e=function(){var n,t,e;for(e=[],n=0,t=u.length;t>n;n++)r=u[n],e.push(r());return e}(),n(e)?A:t.apply(null,e)})})}},{zip:t,zipWith:e}}(),U=_.zip,D=_.zipWith,f=function(){var n,r;return r=function(n){var r;return r=n.length-1,function(t){var u;for(u=r;!(++t[u]<n[u]||0>=u);)t[u--]=0;return t}},n=function(n){var r;return r=n.length,function(t){var u,e,o,i;for(i=[],u=e=0,o=r;o>=0?o>e:e>o;u=o>=0?++e:--e)i.push(n[u][t[u]]);return i}},function(){var t;return t=1<=arguments.length?u.call(arguments,0):[],z(function(){var u,e,o,i,f,c,a,l,v;for(t=function(){var n,r,u;for(u=[],n=0,r=t.length;r>n;n++)v=t[n],u.push(w(v));return u}(),a=function(){var n,r,u;for(u=[],e=n=0,r=t.length;r>=0?r>n:n>r;e=r>=0?++n:--n)u.push(t[e].length);return u}(),i=0,c=a.length;c>i;i++)if(f=a[i],0===f)return A;return o=r(a),u=n(t),l=function(){var n,r,u;for(u=[],e=n=0,r=t.length;r>=0?r>n:n>r;e=r>=0?++n:--n)u.push(0);return u}(),d(function(){var n;return l[0]<a[0]?(n=u(l),o(l),n):A})})}}(),w=function(n){var t,u,e,o,i;if("number"==typeof n)return u=n,function(n){return w(q(u)(n))};if("function"==typeof n){for(t=n[r.iterator](),e=[];(i=t())!==A;)e.push(i);return e}if(null!=n[r.iterator]){for(t=b(n)[r.iterator](),o=[];(i=t())!==A;)o.push(i);return o}if(n instanceof Array)return n;throw Error("list(xs): xs is neither LazyList nor Array")},m=function(n){var t,u,e,o;if(null==n[r.iterator])return null!=(e=n[n.length-1])?e:A;for(t=("function"==typeof n?n:b(n))[r.iterator](),u=A;(o=t())!==A;)u=o;return u},S=function(n){var t,u,e;if(null==n[r.iterator])return n.length;for(t=("function"==typeof n?n:b(n))[r.iterator](),u=0;(e=t())!==A;)++u;return u},p=function(n,t){return function(u){var e,o,i;for(o=t,e=("function"==typeof u?u:b(u))[r.iterator]();(i=e())!==A;)o=n(o,i);return o}},o=function(n){return function(t){var u,e,o;if(e=("function"==typeof t?t:b(t))[r.iterator](),(o=e())===A)return null;for(;(u=e())!==A;)o=n(u,o)?u:o;return o}},t=function(n){return"function"!=typeof n&&(n=function(r){return r===n}),function(t){var u,e;for(u=("function"==typeof t?t:b(t))[r.iterator]();(e=u())!==A;)if(!n(e))return!1;return!0}},e=function(n){var r;return r=t(function(r){return!n(r)}),function(n){return!r(n)}},i=function(){return i},i.toString=function(){return"foreach.break"},g=function(n,t,u){var e,o;for(e=("function"==typeof n?n:b(n))[r.iterator]();(o=e())!==A&&t(o,u)!==i;);return u},Object.defineProperties(g,{"break":{writable:!1,configurable:!1,enumerable:!1,value:i}}),{nil:A,lazylist:z,iterator:d,Symbol:r,naturals:E,range:L,primes:N,lazy:b,enumerate:h,repeat:I,generate:y,random_gen:k,ranged_random_gen:O,permutation_gen:M,cons:a,map:x,filter:s,take:q,takeWhile:T,drop:l,dropWhile:v,scanl:W,streak:j,reverse:R,concat:c,zip:U,zipWith:D,cartProd:f,list:w,last:m,length:S,foldl:p,best:o,all:t,any:e,foreach:g}},r.exports=t({Symbol:"undefined"!=typeof Symbol&&null!==Symbol?Symbol:{iterator:"iter"}})},{}]},{},[1]);
//# sourceMappingURL=global.coffee.js.map