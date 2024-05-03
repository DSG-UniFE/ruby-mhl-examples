require 'forwardable'
require 'mhl' 

require 'mhl/rechenberg_controller'
# Let' define the problem

logger = Logger.new(STDOUT)


knapsack = lambda do |picked|
  names = ["book", "sunglasses", "tablet", "camera",
    "moleskine", "pen", "duct tape", "swiss army knife"]
  values = [100, 80, 35, 100, 80, 100, 10, 25]
  weights = [8, 1, 6, 12, 3, 1, 1, 5]
  weightlimit = 15

  objects = {names: names, values: values, weights: weights} 
  values = objects[:values]
  weights = objects[:weights]
  sum = 0
  sw = 0
  picked.each_with_index do |pick, i|
    sum += pick * values[i]
    sw += pick * weights[i]
  end 
  if sw > weightlimit
    return 0 
  else 
    return sum 
  end
end

solver_conf = {
    population_size: 128,
    genotype_space_type: :bitstring,
    mutation_probability: 0.5,
    genotype_space_conf: {
        bitstring_length: 8,
        #mutation_threshold: 0.8,
        recombination_type: :intermediate,
        constraints: Array.new(8){{from: 0, to: 1}}
      }, 
  exit_condition: lambda {|gen, best| gen >= 50  },
  logger: logger,
  log_level: :info
}
ga_solver = MHL::GeneticAlgorithmSolver.new(solver_conf)

best = ga_solver.solve(knapsack)
warn "Best: #{best[:fitness]} genotype: #{best[:genotype]}"




