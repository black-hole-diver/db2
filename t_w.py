import math, sys

# find T(W) or
def t_w_or(sca, scb, tr):
    return int (tr * (1 - ( (1 - sca/tr) * (1 - scb/tr) ) ))

# find T(W) ^
def t_w_and(sca, scb, tr):
    return int (tr * (sca/tr * scb/tr))

# find cross join
def t_w_cross_join(tr, ts):
    return int (tr * ts)

def t_w_natural_join(tr, ts, vra, vsa):
    return int ( (tr * ts) / max(vra, vsa) )


# inputs
# print("T(R)/V(R,A): {sca}".format(sca=sys.argv[1]))
# print("T(R)/V(R,B): {scb}".format(scb=sys.argv[2]))
# print("T(R): {tr}".format(tr=sys.argv[3]))

# outputs
# print("Sigma(A=x or B=y): {}".format(repr(t_w_or(int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])))))
# print("Sigma(A=x and B=y): {}".format(repr(t_w_and(int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])))))
print("Cross join tr x ts size: ")
tr = int(input("tr: "))
ts = int(input("ts: "))
vra = int(input("vra: "))
vsa = int(input("vsa: "))
print("The cross-join size is: ", t_w_cross_join(tr, ts))
print("The natural-join size is: ", t_w_natural_join(tr, ts, vra, vsa))
