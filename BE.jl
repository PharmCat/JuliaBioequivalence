# Julia Bioequivalence
# 2X2 Crossover design

using DataFrames, GLM, CSV

dirp="C:\\...\\src\\testdata\\"
filep = dirp*"MOESM1.csv"

if isfile(filep) df = CSV.File(filep, delim='\t') |> DataFrame end

df.LnVar = log.(df.Var)
categorical!(df, :Subj);
categorical!(df, :Per);
categorical!(df, :Seq);
categorical!(df, :Trt);

ols  = lm(@formula(LnVar ~ Seq+Per+Trt+Subj), df, true)

cint = confint(ols, 0.9)
println("--------------------------------------")
print("Lower bound: ")
print(round(exp(cint[4,1])*100, digits=2))
println("%")
print("Upper bound: ")
print(round(exp(cint[4,2])*100, digits=2))
println("%")
sigm = GLM.dispersion(ols.model, false)
var = sigm^2
cv = sqrt(exp(var)-1)*100
print("Var: ")
println(round(var, digits=6))
print("CV: ")
print(round(cv, digits=2))
println("%")
println("--------------------------------------")
