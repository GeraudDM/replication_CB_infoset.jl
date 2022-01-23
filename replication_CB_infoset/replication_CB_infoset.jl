module replication_CB_infoset

using XLSX, DataFrames, RegressionTables, GLM, Plots, Statistics, StatsBase

#loading XLSX file (must be in the same file as the notebook)
xf = XLSX.readxlsx("Referee_data_cleaned.xlsx") 

#Loading data of interest in different Dataframes (from most general to most granular)
df = DataFrame(XLSX.readtable("Referee_data_cleaned.xlsx", "Data_Final", infer_eltypes = true)...)
stats = DataFrame(XLSX.readtable("Referee_data_cleaned.xlsx", "Descriptive_statistics")...)
output = DataFrame(XLSX.readtable("Referee_data_cleaned.xlsx", "Growth_output")...)
inflation = DataFrame(XLSX.readtable("Referee_data_cleaned.xlsx", "Growth_Prices")...)
output_gap = DataFrame(XLSX.readtable("Referee_data_cleaned.xlsx", "Growth_output_gap_supclean")...)

#Transfgorming into Matrixes for plots
M1 = Matrix(output)
M2 = Matrix(inflation)
M3 = Matrix(output_gap)
M4 = Matrix(df)

# Replicating and testing figure 1

    # Declaring variables
x = [0:length(M2[1,2:end])-1]
g1 = M1[1,2:54]
g2 = M1[84,2:54]
pi1 = M2[1,2:end]
pi2 = M2[84,2:end]

    #Plotting
p1 = plot(x, g1, title = "(a) GDP Growth", label = "1987:Q3")
p1 = plot!(x, g2, label = "2008:Q2", size = (900,300))	
p2 = plot(x, pi1, title= "(b) Inflation", label = "1987:Q3")
p2 = plot!(x, pi2, label = "2008:Q2", size = (900,300))
plot(p1, p2, layout= (1,2))	
savefig("Fig1_rep.png")

# ploting potential output vs. acutal output
plot([0:83], M4[:, 3]-M4[:, 2], label = "potential output" )
plot!([0:83],  M4[:, 3], label = "realised output")
savefig("Fig10_rep.png")

#Creating statistics table
Summary = ["Mean" mean(M4[:, 3]-M4[:, 2]) mean(M4[:, 3]);
"Variance" var(M4[:, 3]-M4[:, 2]) var(M4[:,3])
"Correlation" cor(M4[:, 3]-M4[:, 2], M4[:,3]) cor(M4[:, 3]-M4[:, 2], M4[:,3])]
SumStats = DataFrame(Summary, :auto)
rename!(SumStats, ["Stats", "Potential", "Actual"])

#Replicating Table 5 with new data

	# replicating equation (5)
ols1 = GLM.lm(@formula(i~ux), df)
ols2 = GLM.lm(@formula(i~up), df)
ols3 = GLM.lm(@formula(i~ug), df)
ols4 = GLM.lm(@formula(i~ux+up+ug), df)
ols5 = GLM.lm(@formula(i~ux+up), df)

	#Building a Latex RegressionTables

regtable(ols1, ols2, ols3, ols4, ols5; renderSettings = latexOutput("myoutputfile.tex"))





end
