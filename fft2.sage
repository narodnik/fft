p = 199
assert p.is_prime()

# We want a > nth root of unity
# Calculate required field extension

assert n % 2 == 1
n = 199^2

def find_nth_root_unity(p, n):
    for N in range(1, 5):
        pNx_order = euler_phi(p^N)

        # Does n divide the group order?
        if pNx_order % n == 0:
            print(f"N = {N}")
            break

    # So there is an nth root of unity in p^N. Now we have to find it.

    while True:
        pNx_order = euler_phi(p^N)

        a = Integers(p^N).random_element()
        assert a^pNx_order == 1

        g = a^(pNx_order/n)
        print(f"g = {g}")

        # We don't check this is a primitive root of unity

        break

    assert (g^n) % (p^N) == 1
    return g, N

g, N = find_nth_root_unity(p, n)

