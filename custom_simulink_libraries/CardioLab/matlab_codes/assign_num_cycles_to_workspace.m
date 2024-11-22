function assign_num_cycles_to_workspace(assigned_var)
% Function to assign the 'assigned_var' to the base workspace and name it 'num_cycles'.
assignin('base','out_ecg_analysis_num_cycles',assigned_var)
end