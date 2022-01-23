push!(LOAD_PATH,"../src/")
using Documenter, replication_CB_infoset

makedocs(modules = [replication_CB_infoset], sitename = "replication_CB_infoset.jl")

deploydocs(repo = "github.com/GeraudDM/replication_CB_infoset.jl.git", devbranch = "main")
