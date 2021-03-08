using GLM, PyPlot, DataFrames, Statistics

sizes, reps = 10:10:200, 10000

function sim_r²(n)
    x = randn(n)
    y = [1 + randn() + v for v in x]
    df = DataFrame(x=x, y=y)
    model = lm(@formula(y ~ x), df)
    return r²(model)
end

r²_q95, r²_q5, r²_mean = Float64[], Float64[], Float64[]

@time for s in sizes
    @show s
    result = [sim_r²(s) for _ in 1:reps]
    push!(r²_mean, mean(result))
    push!(r²_q5, quantile(result, 0.05))
    push!(r²_q95, quantile(result, 0.95))
end

scatter(sizes, r²_mean)
plot(sizes, r²_q5, color="black")
plot(sizes, r²_q95, color="black")
xlabel("sample size")
ylabel("R²")
