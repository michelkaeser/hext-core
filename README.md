# hx-lib

> A completing yet alternative standard library for Haxe.

## Compilation Flags

`-D LIB_DEBUG` which enables debug mode. Setting this flag will tell the `Throwable`s to include full Call- and ExceptionStack information. Though this can be helpful during development, it should not be enabled for production/releases as the operations are expensive.

`-D LIB_PERFORMANCE` which will disable runtime checks in `lib.io.Bit(s)` abstracts. This gives a little performance boost to the cost of safety.

`-D LIB_WIN` which will tell the library that we are compiling on a Windows system. This flag is used in `std.vm.Lock` class, as `SemaphoreSlim` doesn't work on non-Windows environments.

## Nullability

Haxe has a special type `Null<T>` which is mainly for documentation purpose and for static platforms (so e.g. `Int` can be `null`). You can find its typedef here: http://api.haxe.org/Null.html

Trying to follow the documentation aspect, all methods that accept a nullable value (e.g. `Null<Bytes>`) can safely be called with `null` - it is ensured they will _not_ throw an Exception or Error.

On the other hand, when a methods returns a value of type `Null<T>` that means, that the returned value may be `null`.

## License

The MIT License (MIT)

Copyright (c) 2014 Michel Käser

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
