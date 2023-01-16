import itertools

p = 199
n = 8

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
    #assert n % 2 == 1

    # So there is an nth root of unity in p^N. Now we have to find it.
    pNx_order = p^N - 1

    ω = K.gens()[0]
    ω = ω^(pNx_order/n)
    assert ω^n == 1
    assert ω^(n - 1) != 1

    return ω

N = find_ext_order(p, n)
print(f"p = {p}")
print(f"n = {n}")
print(f"N = {N}")
print(f"p^N = {p^N}")
K.<a> = GF(p^N, repr="int")
ω = find_nth_root_unity(K, n)
print(f"ω = {ω}")
print()

L.<X> = K[]

f = 7*X^3 + X^2 + 110*X + 4
assert f.degree() < n/2
print(f"f = {f}")
print()

def vectorify(f):
    assert f.degree() < n
    fT = vector([f[i] for i in range(f.degree() + 1)] +
                # Zero padding
                [0 for _ in range(n - f.degree() - 1)])
    assert len(fT) == n
    # Just check decomposed polynomial is in the correct order
    assert sum([fT[i]*X^i for i in range(n)]) == f
    return fT

def dot(a, b):
    assert len(a) == len(b)
    return [a_i*b_i for a_i, b_i in zip(a, b)]

# ABC, DEF -> ADBECF
def alternate(list1, list2):
    return itertools.chain(*zip(list1, list2))

def calc_dft(ω_powers, f):
    m = len(f)
    indent = " " * (n - m)
    print(f"{indent}calc_dft({ω_powers}, {f})")
    print(f"{indent}  m = {m}")
    if m == 1:
        print(f"  m = 1 so return f")
        return f
    g, h = vector(f[:m/2]), vector(f[m/2:])
    print(f"{indent}  g = {g}")
    print(f"{indent}  h = {h}")

    r = g + h
    s = dot(g - h, ω_powers)
    print(f"{indent}  r = {r}")
    print(f"{indent}  s = {s}")
    print()

    ω_powers = vector(ω_i for ω_i in ω_powers[::2])
    rT = calc_dft(ω_powers, r)
    sT = calc_dft(ω_powers, s)

    result = list(alternate(rT, sT))
    print(f"{indent}return {result}")
    return result

ω_powers = vector(ω^i for i in range(n/2))
fT = vectorify(f)
dft = calc_dft(ω_powers, fT)
print()
print(f"DFT(f) = {dft}")
f_evals = [f(X=ω^i) for i in range(n)]
print(f"f(ω^i) = {f_evals}")

