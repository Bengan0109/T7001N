# Sets
set K; # Types of vehicles
set I; # Facility locations
set J; # Customers

# Parameters
param f {K}; # Cost to utilize a truck of type k
param u {K}; # Capacity of a truck of type k
param M {I}; # Max number of trucks at facility i
param U {I}; # Capacity of facility i
param C {I}; # Max number of customers at facility i
param F {I}; # Cost of opening facility i
param D {J}; # Demand of customer j
param c {I, J}; # Cost of assigning customer j to facility i

# Decision variables
var y {I} binary; # 1 if facility i is opened, 0 otherwise
var x {I, J} binary; # 1 if customer j is assigned to facility i, 0 otherwise
var v {I, K} >= 0 integer; # Number of trucks of type k allocated to facility i

# Objective: Minimize total cost
minimize TotalCost:
    sum {i in I} F[i] * y[i] +
    sum {i in I, k in K} f[k] * v[i, k] +
    sum {i in I, j in J} c[i, j] * x[i, j];

# Constraints
# Each customer is assigned to exactly one facility
subject to SingleSourcing {j in J}:
    sum {i in I} x[i, j] = 1;

# Facility capacity is respected
subject to FacilityCapacity {i in I}:
    sum {j in J} D[j] * x[i, j] <= U[i] * y[i];

# Customer limit per facility is respected
subject to CustomerLimit {i in I}:
    sum {j in J} x[i, j] <= C[i] * y[i];

# Truck allocation respects facility capacity
subject to TruckCapacity {i in I}:
    sum {k in K} u[k] * v[i, k] >= sum {j in J} D[j] * x[i, j];

# Truck count limit per facility
subject to TruckLimit {i in I}:
    sum {k in K} v[i, k] <= M[i];
