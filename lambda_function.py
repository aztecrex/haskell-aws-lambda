from ctypes import *
import os, sys
import json
from datetime import datetime

epoch = datetime(1970, 1, 1)

def lambda_handler(event, context):
    data = json.dumps(event, allow_nan=False, ensure_ascii=False, skipkeys=True)

    delta = (datetime.utcnow() - epoch).total_seconds() * 1000
    deadline = int( round(delta) + context.get_remaining_time_in_millis())
    # deadline = context.get_remaining_time_in_millis()

# >>> import datetime
# >>> delta = datetime.datetime.utcnow() - datetime.datetime(1970, 1, 1)
# >>> delta
# datetime.timedelta(15928, 52912, 55000)
# >>> delta.total_seconds()
# 1376232112.055
# >>> delta.days, delta.seconds, delta.microseconds
# (15928, 52912, 55000)



    context_ = {
        'lambdaName': context.function_name,
        'lambdaVersion': context.function_version,
        'lambdaInvocation': context.aws_request_id,
        'lambdaDeadline': deadline,
        'name': context.function_name,
        'version': context.function_version,
        'arn': context.invoked_function_arn,
        'memory': context.memory_limit_in_mb,
        'requestId': context.aws_request_id,
        'logGroup': context.log_group_name,
        'logStream': context.log_stream_name
        }
    ctx = json.dumps(context_, allow_nan=False, ensure_ascii=False, skipkeys=True)
    hret = lib.bar(ctx.encode('utf-8'), data.encode('utf-8')).decode('utf-8')
    rval = json.loads(hret)
    return rval

def find_file_ending_with(ending_with_str, path='.'):
    for root, dirs, files in os.walk(path):
        for candidate_path in [os.path.join(root, f) for f in files]:
            if candidate_path.endswith(ending_with_str):
                return candidate_path
    raise Exception("Could not find " + ending_with_str + " in " + path)
so_file_path = find_file_ending_with('libhelloFromHaskell.so')

free = cdll.LoadLibrary("libc.so.6").free
lib = cdll.LoadLibrary(so_file_path)
lib.bar.restype = c_char_p

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

