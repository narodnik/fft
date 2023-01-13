#p = 199
#n = 199^2

p = 11
n = 5

# We want a > nth root of unity
# Calculate required field extension
assert p.is_prime()
assert n % 2 == 1

def find_nth_root_unity(p, n):
    found = False
    for N in range(1, 100):
        pNx_order = euler_phi(p^N)

        # Does n divide the group order?
        if pNx_order % n == 0:
            print(f"N = {N}")
            found = True
            break
    assert found

    # So there is an nth root of unity in p^N. Now we have to find it.

    while True:
        pNx_order = euler_phi(p^N)

        a = Integers(p^N).random_element()
        assert a^pNx_order == 1

        g = a^(pNx_order/n)

        # We don't check this is a primitive root of unity

        break

    # Apply reduction to [g]
    g̅ = g % (p^N)
    print(f"gen = {g̅}")

    assert (g̅^n) % (p^N) == 1
    return int(g̅), N

ω, N = find_nth_root_unity(p, n)

f = 3*x^5 + 7*x^3 + x^2 + 4
g = 2*x^5 + 2*x^4 + 2*x^2 + 110

fT = vector([3, 0, 7, 1, 4])
gT = vector([2, 2, 0, 2, 110])

Vω = matrix([
    [1,   1,   1,   1,   1],
    [1, ω^1, ω^2, ω^3, ω^4],
    [1, ω^2, ω^4, ω^1, ω^3],
    [1, ω^3, ω^1, ω^4, ω^2],
    [1, ω^4, ω^3, ω^2, ω^1],
])
DFT_ω = (Vω * fT) % (p^N)
print(f"DFT_ω = {DFT_ω}")
f_evals = [int(f(x=ω^i)) % (p^N) for i in range(n)]
print(f"f(ω^i) = {f_evals}")

