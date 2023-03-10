---
header-includes: |
    - \usepackage{mathtools}
    - \newcommand{\DFT}{\textrm{DFT}}
---

$$ f(x)g(x) โ ๐ฝ_{<2n}[x] $$
$$ fg = \sum_{i + j < 2n - 2} a_i b_j x^{i + j} $$
Complexity: $O(n^2)$

Suppose $ฯ โ ๐ฝ$ is an nth root of unity.

Recall: if $๐ฝ = ๐ฝ_{p^k}$ then $โN : ๐ฝ_{p^N}$
contains all nth roots of unity.

$$ \DFT_ฯ : ๐ฝ^n โ ๐ฝ^n $$
$$ \DFT_ฯ(f) = (f(ฯ^0), f(ฯ^1), โฆ, f(ฯ^{n - 1})) $$

$$ V_ฯ =
\begin{pmatrix}
1 & 1   & 1   & \hdots & 1 \\
1 & ฯ^1 & ฯ^2 & \hdots & ฯ^{n - 1} \\
1 & ฯ^2 & ฯ^4 & \hdots & ฯ^{2(n - 1)} \\
\vdots \\
1 & ฯ^{n - 1} & ฯ^{2(n - 1)} & \hdots & ฯ^{(n - 1)^2} \\
\end{pmatrix}
$$

$$ \DFT_ฯ(f) = V_ฯ ยท f^T $$
since vandermonde multiplication is simply evaluation of a polynomial.

# Lemma: $V_ฯ^{-1} = \frac{1}{n} V_{ฯ^{-1}}$

Use $1 + ฯ + โฏ + ฯ^{n - 1}$ and compute $V_ฯ V_{ฯ^{-1}}$

Corollary: $\DFT_ฯ$ is invertible.

# Definitions

1. Convolution $f * g = fg \mod (x^n - 1)$
2. Pointwise product
   $$(a_0, โฆ, a_{n - 1})ยท(b_0, โฆ, b_{n - 1}) =
         (a_0 b_0, โฆ, a_{n - 1} b_{n - 1}) โ ๐ฝ^n โ ๐ฝ_{<n}[x]$$

# Theorem: $\DFT_ฯ(f*g) = \DFT_ฯ(f)ยท\DFT_ฯ(g)$

$$ fg = q'(x^n - 1) + f*g  $$
$$ โ f*g = fg + q(x^n - 1) $$
$$ \deg fg โค 2n - 2        $$

\begin{align*}
(f*g)(ฯ^i) &= f(ฯ^i)g(ฯ^i) + q(ฯ^i)(ฯ^{in} - 1) \\
           &= f(ฯ^i)g(ฯ^i)
\end{align*}

# Result

$$ f, g โ ๐ฝ_{<n/2}[x] $$
$$ fg = f*g $$
$$ \DFT_ฯ(f*g) = \DFT_ฯ(f)ยท\DFT_ฯ(g) $$
$$ fg = \frac{1}{n} \DFT_{ฯ^{-1}} (\DFT_ฯ(f) ยท \DFT_ฯ(g)) $$

# Finite Field Extension Containing Nth Roots of Unity

$$ ฮผ_N = โจฯโฉ, |๐ฝ_{p^N}^ร| = p^N - 1 $$
$$ \textrm{ord}(ฯ) = n | p^N - 1 $$
but $๐ฝ_{p^N}^ร$ is cyclic.

For all $d | p^N - 1$, there exists $x โ ๐ฝ_{p^N}^ร$
with ord$(x) = d$.

Finding $n | p^N - 1$ is sufficient for $ฯ โ ๐ฝ_{p^N}$
$$ n | p^N - 1 โ \textrm{ord}(p) = (โค / nโค)^ร $$

# FFT Algorithm Recursive Compute

We recurse to a depth of $\log n$. Since each recursion uses $ฯ^i$, then
in the final step $ฯ^i = 1$, and we simply return $f^T$.

We only need to prove a single step of the algorithm produces the desired
result, and then the correctness is inductively proven.

\begin{align*}
f(X)    &= a_0 + a_1 X + a_2 X^2 + โฏ + a_{n - 1} X^{n - 1} \\
        &= g(X) + X^{n/2} h(X)
\end{align*}

## Algorithm

\begin{algorithm}[H]
    \caption{Discrete Fourier Transform}
    \label{dft}
    \begin{algorithmic}[1] % The number tells where the line numbering should start
        \Function{DFT}{$n = 2^d, f(X)$}
            \If {$n = 1$}
                \State \textbf{return} $f(X)$
            \EndIf
            \State $f(X) = g(X) + X^{n/2} h(X)$             \Comment{Write $f(X)$ as the sum of two polynomials with equal degree}
            \State Let $\mathbf{g}, \mathbf{h}$ be the vector representations of $g(X), h(X)$
            \State
            \State $\mathbf{r} = \mathbf{g} + \mathbf{h}$
            \State $\mathbf{s} = (\mathbf{g} - \mathbf{h})ยท(ฯ^0, โฆ, ฯ^{n/2 - 1})$
            \State Let $r(X), s(X)$ be the polynomials represented by the vectors $\mathbf{r}, \mathbf{s}$
            \State
            \State Compute $(r(ฯ^0), โฆ, r(ฯ^{n/2})) = \textrm{DFT}_{ฯ^2}(n/2, r(X))$
            \State Compute $(s(ฯ^0), โฆ, s(ฯ^{n/2})) = \textrm{DFT}_{ฯ^2}(n/2, s(X))$
            \State
            \State \textbf{return} $(r(ฯ^0), s(ฯ^0), r(ฯ^2), s(ฯ^2), โฆ, r(ฯ^{n/2}), s(ฯ^{n/2}))$
        \EndFunction
    \end{algorithmic}
\end{algorithm}

## Even Values

\begin{align*}
r(X)        &= g(X) + h(X) \\
\\
f(ฯ^{2i})   &= g(ฯ^{2i}) + (ฯ^{2i})^{n/2} h(ฯ^{2i}) \\
            &= g(ฯ^{2i}) +                h(ฯ^{2i}) \\
            &= (g + h)(ฯ^{2i}) \\
\end{align*}

So then we can now compute $DFT_ฯ(f)_{k=2i} = DFT_{ฯ^2}(r)$
for the even powers of $f(ฯ^{2i})$.

## Odd Values

For odd values $k = 2i + 1$

\begin{align*}
s(X)        &= (g(X) - h(X))ยท(ฯ^0, โฆ, ฯ^{n/2 - 1}) \\
\\
f(X)          &= a_0 + a_1 X + a_2 X^2 + โฏ + a_{n - 1} X^{n - 1} \\
              &= g(X) + X^{n/2} h(X) \\
f(ฯ^{2i + 1}) &= g(ฯ^{2i + 1}) + (ฯ^{2i + 1})^{n/2} h(ฯ^{2i + 1}) \\
\end{align*}
But observe that for any $n$th root of unity $ฯ^n = 1$ and $ฯ^{n/2} = -1$
$$ (ฯ^{2i + 1})^{n/2} = ฯ^{in} ฯ^{n/2} = ฯ^{n/2} = -1 $$
\begin{align*}
โ f(ฯ^{2i + 1}) &= g(ฯ^{2i + 1}) - h(ฯ^{2i + 1}) \\
                &= (g - h)(ฯ^{2i + 1})
\end{align*}

Let $\mathbf{s} = (\mathbf{g} - \mathbf{h})ยท(ฯ^0, โฆ, ฯ^{n/2 - 1})$ be the
representation for $s(X)$. Then we can see that $s(ฯ^{2i}) = (g - h)(ฯ^{2i + 1})$
as desired.

So then we can now compute $DFT_ฯ(f)_{k=2i + 1} = DFT_{ฯ^2}(s)$
for the odd powers of $f(ฯ^{2i + 1})$.

# Example

Let $n = 8$
\begin{align*}
f(X)    &= (a_0 + a_1 X + a_2 X^2 + a_3 X^3) +     (a_4 X^4 + a_5 X^5 + a_6 X^6 + a_7 X^7) \\
        &= (a_0 + a_1 X + a_2 X^2 + a_3 X^3) + X^4 (a_4     + a_5 X   + a_6 X^2 + a_7 X^3) \\
        &= g(X) + X^{n/2} h(X) \\
g(X)    &=  a_0 + a_1 X + a_2 X^2 + a_3 X^3 \\
h(X)    &=  a_4 + a_5 X + a_6 X^2 + a_7 X^3 \\
\end{align*}
Now vectorize $g(X), h(X)$
\begin{align*}
\mathbf{g} &= (a_0, a_1, a_2, a_3) \\
\mathbf{h} &= (a_4, a_5, a_6, a_7) \\
\end{align*}
Compute reduced polynomials in vector form
\begin{align*}
\mathbf{r} &=  \mathbf{g} + \mathbf{h} \\
           &= (a_0 + a_4, a_1 + a_5, a_2 + a_6, a_3 + a_7) \\
\mathbf{s} &= (\mathbf{g} - \mathbf{h})ยท(1, ฯ, ฯ^2, ฯ^3) \\
           &= (a_0 - a_4, a_1 - a_5, a_2 - a_6, a_3 - a_7)ยท(1, ฯ, ฯ^2, ฯ^3) \\
           &= (a_0 - a_4, ฯ (a_1 - a_5), ฯ^2 (a_2 - a_6), ฯ^3 (a_3 - a_7)) \\
\end{align*}
Convert them to polynomials from the vectors. We also expand them out below
for completeness.
\begin{align*}
r(X)       &= r_0 + r_1 X + r_2 X^2 + r_3 X^3 \\
           &= (a_0 + a_4) + (a_1 + a_5) X + (a_2 + a_6) X^2 + (a_3 + a_7) X^3 \\
s(X)       &= s_0 + s_1 X + s_2 X^2 + s_3 X^3 \\
           &= (a_0 - a_4) + ฯ (a_1 - a_5) X + ฯ^2 (a_2 - a_6) X^2 + ฯ^3 (a_3 - a_7) X^3 \\
\end{align*}
Compute
$$ \textrm{DFT}_{ฯ^2}(4, r(X)), \textrm{DFT}_{ฯ^2}(4, s(X)) $$
The values returned will be
$$
(r(1), s(1), r(ฯ^2), s(ฯ^2), r(ฯ^4), s(ฯ^4), r(ฯ^6), s(ฯ^6))
=
(f(1), f(ฯ), f(ฯ^2), f(ฯ^3), f(ฯ^4), f(ฯ^5), f(ฯ^6), f(ฯ^7))
$$
Which is the output we return.

# Comparing Evaluations for $f(X)$ and $r(X), s(X)$

We can see the evaluations are correct by substituting in $ฯ^i$.

We expect that $s(X)$ on the domain $(1, ฯ^2, ฯ^4, ฯ^6)$ produces the values
$(f(1), f(ฯ^2), f(ฯ^4), f(ฯ^6))$, while $r(X)$ on the same domain produces
$(f(ฯ), f(ฯ^3), f(ฯ^5), f(ฯ^7))$.

## Even Values

Let $k = 2i$, be an even number. Then note that $k$ is a multiple of 2, so
$4k$ is a multiple of $n โ ฯ^{4k} = 1$,
\begin{align*}
r(X)       &= (a_0 + a_4) + (a_1 + a_5) X + (a_2 + a_6) X^2 + (a_3 + a_7) X^3 \\
r(ฯ^{2i})  &= (a_0 + a_4) + (a_1 + a_5) ฯ^{2i} + (a_2 + a_6) ฯ^{4i} + (a_3 + a_7) ฯ^{6i} \\
f(ฯ^k)     &= (a_0 + a_1 ฯ^k + a_2 ฯ^{2k} + a_3 ฯ^{3k}) + ฯ^{4k} (a_4     + a_5 ฯ^k   + a_6 ฯ^{2k} + a_7 ฯ^{3k}) \\
           &= (a_0 + a_1 ฯ^k + a_2 ฯ^{2k} + a_3 ฯ^{3k}) +        (a_4     + a_5 ฯ^k   + a_6 ฯ^{2k} + a_7 ฯ^{3k}) \\
           &= (a_0 + a_4) + (a_1 + a_5) ฯ^k + (a_2 + a_6) ฯ^{2k} + (a_3 + a_7) ฯ^{3k} \\
           &= f(ฯ^{2i}) \\
           &= (a_0 + a_4) + (a_1 + a_5) ฯ^{2i} + (a_2 + a_6) ฯ^{4i} + (a_3 + a_7) ฯ^{6i} \\
           &= r(ฯ^{2i})
\end{align*}

## Odd Values

For $k = 2i + 1$ odd, we have a similar relation where $4k = 8i + 4$, so
$ฯ^{4k} = ฯ^4$. But observe that $ฯ^4 = -1$.
\begin{align*}
s(X)       &= (a_0 - a_4) + ฯ (a_1 - a_5) X + ฯ^2 (a_2 - a_6) X^2 + ฯ^3 (a_3 - a_7) X^3 \\
s(ฯ^{2i})  &= (a_0 - a_4) + (a_1 - a_5) ฯ^{2i + 1} + (a_2 - a_6) ฯ^{4i + 2} + (a_3 - a_7) ฯ^{6i + 3} \\
f(ฯ^k)     &= (a_0 + a_1 ฯ^k + a_2 ฯ^{2k} + a_3 ฯ^{3k}) + ฯ^{4k} (a_4     + a_5 ฯ^k   + a_6 ฯ^{2k} + a_7 ฯ^{3k}) \\
           &= (a_0 + a_1 ฯ^k + a_2 ฯ^{2k} + a_3 ฯ^{3k}) -        (a_4     + a_5 ฯ^k   + a_6 ฯ^{2k} + a_7 ฯ^{3k}) \\
           &= f(ฯ^{2i + 1}) \\
           &= (a_0 + a_1 ฯ^{2i + 1} + a_2 ฯ^{4i + 2} + a_3 ฯ^{6i + 3}) -  (a_4     + a_5 ฯ^{2i + 1}   + a_6 ฯ^{4i + 2} + a_7 ฯ^{6i + 3}) \\
           &= 
           (a_0  - a_4)
           + (a_1 - a_5) ฯ^{2i + 1}
           + (a_2 - a_6) ฯ^{4i + 2}
           + (a_3 - a_7) ฯ^{6i + 3} \\
           &= s(ฯ^{2i})
\end{align*}

