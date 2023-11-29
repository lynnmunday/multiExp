# This beginning part is probably good.
[StochasticTools]
[]

[Samplers]
  [omega_sampler]
    type = InputMatrix
    #omega;
    matrix = '2; 3; 5'
    min_procs_per_row = 1
    execute_on = 'PRE_MULTIAPP_SETUP'
  []
[]

[MultiApps]
  [forward]
    type = SamplerFullSolveMultiApp
    input_files = forward.i
    sampler = omega_sampler
    ignore_solve_not_converge = true
    mode = normal    #This is the only mode that works.  batch-reset will only transfer data to first sample
    min_procs_per_app = 1
  []
[]

[Controls]
  [cmdLine]
    type = MultiAppSamplerControl
    multi_app = forward
    sampler = omega_sampler
    param_names = 'omega'
  []
[]

#this is for getting controllable parameters down to the forward problem
[Reporters]
  [controllable_params]
    type = ConstantReporter
    real_vector_names = 'vals'
    real_vector_values = '0 4'
  []
[]

[Transfers]
  # Regardless of method, we will use this transfer
  # regular transfer of the same controllable parameters to all subapps
  [toForward]
    type = MultiAppReporterTransfer
    to_multi_app = forward
    from_reporters = 'controllable_params/vals'
    to_reporters = 'vals/vals'
    execute_on = 'TIMESTEP_BEGIN'
  []
[]

##---------------------------------------
# These are doing it for simple stuff with only two parameters
# (otherwise there would be too many gradients to pass like this)
[Transfers]
  [objectives_for_each_omega]
    type = SamplerPostprocessorTransfer
    from_multi_app = forward
    sampler = omega_sampler
    to_vector_postprocessor = objective_vpp
    from_postprocessor = 'obj_pp'
  []
[]

[VectorPostprocessors]
  [objective_vpp]
    type = StochasticResults
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Postprocessors]
  [sum_objectives]
    type = VectorPostprocessorReductionValue
    value_type = sum
    vectorpostprocessor = objective_vpp
    vector_name = objectives_for_each_omega:obj_pp
    execute_on = 'initial timestep_end'
  []
[]

##---------------------------------------
# This will be more the more general way I need a way to sum the reporter values returned
[Transfers]
  #these have to be collected from all of the subapps.
  [fromForward]
    type = SamplerReporterTransfer
    from_multi_app = forward
    sampler = omega_sampler
    stochastic_reporter = storage
    from_reporter = 'obj_pp/value grad_f/grad_f'
  []
[]
[Reporters]
  [storage]
    type = StochasticReporter
    execute_on = 'initial timestep_end'
    parallel_type = ROOT
  []
  [row_sum]
    type = VectorOfVectorRowSum
    name = sum
    reporter_vector_of_vectors = "storage/fromForward:grad_f:grad_f"
  []
[]
##---------------------------------------

[Outputs]
  console = true
  execute_on = timestep_end
  json = true
  csv = true
  file_base = sampler_subapp
[]
