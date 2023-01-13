# sage: w.multiplicative_order()
# 1330
# sage: 11^3 - 1
# 1330
# sage: K.<w> = GF(11^3, repr="int")
# sage: w
# 11

p = 199
# sage: factor(199^3 - 1)
# 2 * 3^3 * 11 * 13267
n = 27

assert p.is_prime()

def find_ext_order(p, n):
    N = 1
    while True:
        pNx_order = p^N - 1

        # Does n divide the group order 𝔽_{p^N}^×?
        if pNx_order % n == 0:
            return N

        N += 1

def find_nth_root_unity(K, n):
    # It cannot be a quadratic residue if n is odd
    assert n % 2 == 1

    # So there is an nth root of unity in p^N. Now we have to find it.
    pNx_order = p^N - 1

    ω = K.gens()[0]
    ω = ω^(pNx_order/n)
    assert ω^n == 1
    assert ω^(n - 1) != 1

    return ω

N = find_ext_order(p, n)
print(f"N = {N}")
K.<a> = GF(p^N, repr="int")
ω = find_nth_root_unity(K, n)

L.<X> = K[]

f = 3*X^5 + 7*X^3 + X^2 + 4
g = 2*X^5 + 2*X^4 + 2*X^2 + 110

row_padding = [0 for _ in range(n - 5)]
fT = vector([4,   1, 7, 0, 3] + row_padding)
gT = vector([110, 2, 0, 2, 2] + row_padding)
assert len(fT) == len(gT) == n

Vω = matrix([
    [1,   1,   1,   1,   1] + row_padding,
    [1, ω^1, ω^2, ω^3, ω^4] + row_padding,
    [1, ω^2, ω^4, ω^1, ω^3] + row_padding,
    [1, ω^3, ω^1, ω^4, ω^2] + row_padding,
    [1, ω^4, ω^3, ω^2, ω^1] + row_padding,
] + [[0 for _ in range(n)] for _ in range(n - 5)])
DFT_ω = Vω * fT
print(f"DFT_ω = {DFT_ω}")
print()
f_evals = [f(X=ω^i) for i in range(n)]
print(f"f(ω^i) = {f_evals}")

