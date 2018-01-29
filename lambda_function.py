from ctypes import *
import os, sys

print 'ld library path:'
print os.environ['LD_LIBRARY_PATH']

def lambda_handler(event, context):
    lib.bar()
    return 'Hello from Lambda'

def find_file_ending_with(ending_with_str, path='.'):
    for root, dirs, files in os.walk(path):
        for candidate_path in [os.path.join(root, f) for f in files]:
            if candidate_path.endswith(ending_with_str):
                return candidate_path
    raise Exception("Could not find " + ending_with_str + " in " + path)
so_file_path = find_file_ending_with('libhelloFromHaskell.so')

free = cdll.LoadLibrary("libc.so.6").free
lib = cdll.LoadLibrary(so_file_path)

lib.hs_init(0, 0)


# # Some shortcuts
# def make_msgpack_fun(fun):
#     fun.restype = POINTER(c_char)

#     def f(*args):
#         packed = msgpack.packb(args)
#         length_64bits = struct.pack(">q", len(packed)) # big-endian
#         ptr = fun(length_64bits + packed)
#         data_length = struct.unpack(">q", ptr[:8])[0]
#         res = msgpack.unpackb(ptr[8:8+data_length])
#         free(ptr)
#         return res

#     return f


# # Now this is the only thing required
# fib = make_msgpack_fun(lib.fib_export)

# print "Haskell fib:", fib(13)


# def fib(n):
#     if n == 0 or n == 1: return 1
#     return fib(n-1) + fib(n-2)

# lib.hs_exit()

