using Tenkai
Eq = Tenkai.EqEuler2D
using StaticArrays
#------------------------------------------------------------------------------
xmin, xmax = 0.0, 10.0
ymin, ymax = 0.0, 10.0

boundary_condition = (periodic, periodic, periodic, periodic)
γ = 1.4

initial_value, exact_solution, final_time = Eq.isentropic_dumbser_data
boundary_value = exact_solution

degree = 4
solver = "lwfr"
solution_points = "gl"
correction_function = "radau"
numerical_flux = Eq.hllc
bound_limit = "yes"
bflux = evaluate

nx, ny = 20, 20
cfl = 0.0
bounds = ([-Inf],[Inf]) # Not used in Euler
tvbM = 10.0
save_iter_interval = 0
save_time_interval = 0.0 # final_time / 10.0
animate = true # Factor on save_iter_interval or save_time_interval
compute_error_interval = 0

cfl_safety_factor = 0.95

#------------------------------------------------------------------------------
grid_size = [nx, ny]
domain = [xmin, xmax, ymin, ymax]
equation = Eq.get_equation(γ)
problem = Problem(domain, initial_value, boundary_value, boundary_condition,
                     final_time, exact_solution)
limiter = setup_limiter_none()
scheme = Scheme(solver, degree, solution_points, correction_function,
                   numerical_flux, bound_limit, limiter, bflux)
param = Parameters(grid_size, cfl, bounds, save_iter_interval,
                   save_time_interval, compute_error_interval,
                   animate = animate,
                   cfl_safety_factor = cfl_safety_factor)
#------------------------------------------------------------------------------
problem, scheme, param = ParseCommandLine(problem, param, scheme, equation,
                                          ARGS)
#------------------------------------------------------------------------------
sol = Tenkai.solve(equation, problem, scheme, param);

print(sol["errors"])

return sol;
