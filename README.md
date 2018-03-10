Chicken innards
===============

Trying out the FFI and data representation of chicken.

Build
-----

get [CHICKEN](http://call-cc.org/)

````
$ chicken slist.scm
$ clang -O2 -pipe -fsanitize=address -L/usr/local/lib \
    -I/usr/local/include/chicken -o slist slist.c -lchicken
````

Or however your environment is set up.
