using Statistics

function v_asian_sample(T, r, K, σ, X₀, m)
    X = X₀
    hatX = zero(X)
    Δ = T / m
    for i in 1:m
        X *= exp((r-σ^2/2)*Δ + σ*sqrt(Δ)*randn())
        hatX += X
    end
    return exp(-r*T) * max(hatX/m - K, 0)
end

function v_asian(T, r, K, σ, X₀, m, n)
    res = [v_asian_sample(T, r, K, σ, X₀, m) for i in 1:n]
    return mean(res)
end

@time v_asian(1.0, 0.05, 55.0, 0.3, 50.0, 10_000, 10_000)
