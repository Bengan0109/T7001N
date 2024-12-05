from amplpy import AMPL

# Initialize the AMPL object
ampl = AMPL()

# Read the model file first
ampl.read("LAB_2_Location.mod")

# Then read the data file
ampl.read("Lab_2_Location.dat")

# Set the solver here!
ampl.set_option("solver", "highs")

# Solve the problem
ampl.solve()

# Enhanced results display
print("\n=== Solution Results ===")
print("\nObjective Value (Total Cost):")
print(f"€{ampl.get_objective('TotalCost').value():,.2f}")

print("\nFacilities opened:")
y = ampl.getVariable("y").getValues()
for i, val in y.toDict().items():
    if val == 1:
        print(f"- {i}")

print("\nCustomer assignments:")
x = ampl.getVariable("x").getValues()
for (i, j), val in x.toDict().items():
    if val == 1:
        print(f"- {j} is served by {i}")

print("\nTruck allocations:")
v = ampl.getVariable("v").getValues()
for (i, k), val in v.toDict().items():
    if val > 0:
        print(f"- {i}: {int(val)} {k}(s)")