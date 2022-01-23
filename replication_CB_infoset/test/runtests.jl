using Test, replication_CB_infoset

@test hello("Julia") == "Hello, Julia"
@test domath(2.0) ≈ 7.0
