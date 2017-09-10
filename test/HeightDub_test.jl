using DataFrames #is this needed here?
using Base.Test
using ForestBiometrics

datapath = joinpath(@__DIR__, "data")

df=readtable(joinpath(datapath, "IEsubset_Data_CSV.csv"))

# 2 parameter Wyckoff coefficients. Default values for IE variant of FVS
FVS_IE=Dict{String,Array{Float64}}(
"WP"=>[5.19988	-9.26718],
"WL"=>[4.97407	-6.78347],
"DF"=>[4.81519	-7.29306],
"GF"=>[5.00233	-8.19365],
"WH"=>[4.97331	-8.19730],
"RC"=>[4.89564	-8.39057],
"LP"=>[4.62171	-5.32481],
"ES"=>[4.9219	-8.30289],
"AF"=>[4.76537	-7.61062],
"PP"=>[4.9288	-9.32795],
"MH"=>[4.77951	-9.31743],
"WB"=>[4.97407	-6.78347],
"LM"=>[4.19200	-5.16510],
"LL"=>[4.76537	-7.61062],
"PI"=>[3.20000	-5.00000],
"RM"=>[3.20000	-5.00000],
"PY"=>[4.19200	-5.16510],
"AS"=>[4.44210	-6.54050],
"CO"=>[4.44210	-6.54050],
"MM"=>[4.44210	-6.54050],
"PB"=>[4.44210	-6.54050],
"OH"=>[4.44210	-6.54050],
"OS"=>[4.77951	-9.31743] )

wyckoff_test=[
100.3704728
61.35043145
11.31948442
11.99184897
71.56773647
75.48849752
4.662859967
38.1318738
86.57926895
89.09331657
83.29702964
82.02991682
59.36359424
92.24130804
80.79924609
95.99589413
89.52703552
73.04225223
95.88342114
59.38502782
4.662859967
4.662859967
97.69440543
96.76176795
106.4984871
75.82474076
100.3704728
105.4603241
92.79168745
78.84582366
79.6182448
77.22661356
92.79168745
86.208065]
#Wyckoff=(x,b)->4.5+exp(b[1]+(b[2]/(x+1)))
p=HeightDiameter(Wyckoff,FVS_IE)
wyckoff_out=[calculate_height(p,df[:DBH][i],df[:Species][i]) for i in 1:size(df,1) ]

user_eq_test=[
100.37047284416056
61.3504314548922
11.319484421435718
11.991848965935239
71.56773647020071
75.48849751905001
4.662859967018998
38.13187380388209
86.57926895263638
89.09331657177808
83.29702963805494
82.02991681961564
59.3635942426874
92.24130803769208
80.79924608605168
95.99589412836896
89.52703551776979
73.04225222668002
95.88342114290104
59.385027822318165
4.662859967018998
4.662859967018998
97.69440542934592
96.76176794990653
106.49848706273958
75.82474075633411
100.37047284416056
105.46032414620028
92.7916874489734
78.84582366172639
79.61824480322522
77.2266135618811
92.7916874489734
86.20806500491511]

p2=HeightDiameter((x,b)->4.5+x^b[1]^b[2],FVS_IE)

user_eq_out=[calculate_height(p,df[:DBH][i],df[:Species][i]) for i in 1:size(df,1) ]

@testset HeightDub_tests begin
    @test isapprox(wyckoff_out, wyckoff_test)
    @test isapprox(user_eq_out, user_eq_test)
end
