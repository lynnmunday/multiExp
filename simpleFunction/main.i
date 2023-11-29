[Optimization]
[]

[OptimizationReporter]
  type = GeneralOptimization
  parameter_names = 'vals'
  num_values = '2'
  objective_name = obj_value
[]

[Problem]
  solve = false
[]
[Executioner]
  type = Optimize
  tao_solver = taobqnktr
  petsc_options_iname = '-tao_gatol'
  petsc_options_value = '1e-8 '
  verbose = true
[]

[MultiApps]
  [forward_sampler]
    type = FullSolveMultiApp
    input_files = sampler_subapp.i
    execute_on = FORWARD
  []
[]

[Transfers]
  [toForward]
    type = MultiAppReporterTransfer
    to_multi_app = forward_sampler
    from_reporters = 'OptimizationReporter/vals'
    to_reporters = 'controllable_params/vals'
  []

  [fromForward]
    type = MultiAppReporterTransfer
    from_multi_app = forward_sampler
    from_reporters = 'sum_objectives/value
                      row_sum/sum'
    to_reporters = 'OptimizationReporter/obj_value
                    OptimizationReporter/grad_vals'
  []
[]

[Reporters]
  [optinfo]
    type = OptimizationInfo
  []
[]

[Outputs]
  csv = true
  [json]
    type = JSON
    execute_system_information_on = none
  []
[]
