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
n = 3^3

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
print()
K.<a> = GF(p^N, repr="int")
ω = find_nth_root_unity(K, n)

L.<X> = K[]

f = 3*X^4 + 7*X^3 + X^2 + 4
g = 2*X^4 + 2*X^2 + 110
assert f.degree() * g.degree() < n

fT = vector([f[i] for i in range(f.degree())] +
            # Zero padding
            [0 for _ in range(n - f.degree())])
gT = vector([g[i] for i in range(g.degree())] +
            # Zero padding
            [0 for _ in range(n - f.degree())])

def nXn_vandermonde(n, ω):
    # We hardcode this one so you know what is looks like
    if n == 5:
        Vω = matrix([
            [1,   1,   1,   1,   1],
            [1, ω^1, ω^2, ω^3, ω^4],
            [1, ω^2, ω^4, ω^1, ω^3],
            [1, ω^3, ω^1, ω^4, ω^2],
            [1, ω^4, ω^3, ω^2, ω^1],
        ])
        return Vω

    # This is the code to generate it
    Vω = matrix([[ω^(i * j) for j in range(n)] for i in range(n)])
    return Vω

Vω = nXn_vandermonde(n, ω)

DFT_ω_f = Vω * fT
f_evals = [f(X=ω^i) for i in range(n)]
print(f"DFT_ω(f) = {DFT_ω_f}")
print(f"f(ω^i) = {f_evals}")
print()

DFT_ω_g = Vω * gT
g_evals = [g(X=ω^i) for i in range(n)]
print(f"DFT_ω_g = {DFT_ω_g}")
print(f"g(ω^i) = {g_evals}")
print()

# Lemma: V_ω^{-1} = 1/n V_{ω^-1}
assert nXn_vandermonde(n, ω)^-1 == nXn_vandermonde(n, ω^-1)/n

def convolution(f, g):
    return f*g % (X^(2*n - 1))
def pointwise_prod(fT, gT):
    return [a_i*b_i for a_i, b_i in zip(fT, gT)]

fжg = convolution(f, g)
assert fжg == f*g
assert fжg.degree() < n
fжgT = vector([fжg[i] for i in range(fжg.degree())] +
              [0 for _ in range(n - fжg.degree())])
# Just check decomposed polynomial is in the correct order
assert sum([fжg[i]*X^i for i in range(2*n - 1)]) == fжg

DFT_ω_fжg = Vω * fжgT
for i in range(n):
    assert fжg(X=ω^i) == f(ω^i)*g(ω^i)
# This does not work:
#assert DFT_ω_fжg == pointwise_prod(DFT_ω_f, DFT_ω_g)

