function assign_idxs_pqrst_to_workspace(assigned_var)
% Function to assign the 'assigned_var' to the base workspace and name it 'num_cycles'.
assignin('base','out_ecg_idxs_pqrst',assigned_var)
end