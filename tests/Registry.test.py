import tonos_ts4.ts4 as ts4

eq = ts4.eq

ts4.init("../build/", verbose=False)

Registry = ts4.BaseContract("Registry", {})

res = Registry.call_method("secretToHash", {"secret": "secret"})
print (res)