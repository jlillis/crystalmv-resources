# ByteData documentation

ByteData makes it easy to convert values to a string of binary data and vice-versa. It was inspired by struct module in Python programming language.

Notice: floating point types seem to be converted incorrectly, at least on the client, possibly because of reduced mathematical precision of MTA client.

## Functions

`dataToBytes` is the 'counterpart' of Python's `struct.pack` and `bytesToData` is the 'counterpart' of `struct.unpack`.
```
dataToBytes (format, ...)

Server and client function

Converts values passed as arguments to the string of binary data.

    format: A string determining the way to store the data
    ...: Variable number of arguments, the data which you want to store

Returns the string containing the data in the given format.
```

```
bytesToData (format, bstr)

Server and client function

Converts the string of binary data passed as argument to multiple values stored in that string.

    format: A string determining the way the data is stored
    bstr: The string containing the data in the given format

Returns the variable number of values which were stored in bstr in the given format.
```

## Formatting

The first argument of both functions describes the data format. It is a sequence of symbols which mark the different data types. A number before the type symbol determines how many values of that type will be used.
```
L: big-endian signed 8 bytes integer (signed long long)
I: big-endian signed 4 bytes integer (signed long)
S: big-endian signed 2 bytes integer (signed short)
B: big-endian signed 1 byte integer (signed char)
uL: big-endian unsigned 8 bytes integer (unsigned long long)
uI: big-endian unsigned 4 bytes integer (unsigned long)
uS: big-endian unsigned 2 bytes integer (unsigned short)
uB: big-endian unsigned 1 byte integer (unsigned char)
l: little-endian signed 8 bytes integer (signed long long)
i: little-endian signed 4 bytes integer (signed long)
s: little-endian signed 2 bytes integer (signed short)
b: little-endian signed 1 byte integer (signed char)
ul: little-endian unsigned 8 bytes integer (unsigned long long)
ui: little-endian unsigned 4 bytes integer (unsigned long)
us: little-endian unsigned 2 bytes integer (unsigned short)
ub: little-endian unsigned 1 byte integer (unsigned char)
D: big-endian 8 bytes float (float)
F: big-endian 4 bytes float (double)
d: little-endian 8 bytes float (float)
f: little-endian 4 bytes float (double)
c: string
```

## Example
```
local datastr = dataToBytes("2i3biulf16s", 1, 2, 20, 30, 40, 3, 27, 56.87, "somedata")
-- Binary string now contains this data:
-- 2 signed long integers (1, 2)
-- 3 signed char integers (20, 30, 40)
-- a signed long integer (3)
-- an unsigned long long integer (27)
-- a float (56.87)
-- a string ("somedata")
local v1, v2, v3, v4, v5, v6, v7, v8, v9 = bytesToData("2i3biulf16s", datastr)
-- The values have been retrieved from datastr to v1, v2, ..., v9
print(v1, v2, v3, v4, v5, v6, v7, v8, v9)
-- Outputs: 1 2 20 30 40 3 27 56.87 somedata
```

*Original page for this resource available via web archive: https://web.archive.org/web/20161129152106/http://crystalmv.net84.net:80/pages/scripts/bytedata.php*
