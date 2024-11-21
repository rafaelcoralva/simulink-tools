function [num_p,num_q,num_r,num_s,num_t] = BioSigKit_ECG_Count_Detection(fs, preprocessed_ecg, ecg_algo)
% Function to call BioSigKit wrapper and use the MTEO to count and return the number of P,Q,R,S,
% and T peaks of an input ECG.

BioSigKitAnalysis = RunBioSigKit(preprocessed_ecg,fs,0); % Run BioSigKit wrapper.

if ecg_algo == 1
    BioSigKitAnalysis.PanTompkins;   % Run BioSigKit Pan-Tompkins algorithm to detect R peaks.
elseif ecg_algo == 2
    BioSigKitAnalysis.PhaseSpaceAlg;    % Run BioSigKit Phase space algorithm to detect R peaks.
elseif ecg_algo == 3
    BioSigKitAnalysis.FilterBankQRS; % Run BioSigKit filter bank algorithm to detect R peaks.
elseif ecg_algo == 4
    BioSigKitAnalysis.StateMachine;  % Run BioSigKit State Machine algorithm to detect QRST peaks.
elseif ecg_algo == 5
    BioSigKitAnalysis.MTEO_qrstAlg;      % Run BioSigKit MTEO algorithm to detect PQRST peaks.
end

ecg_results = BioSigKitAnalysis.Results; % Saving the PQRST label sample times.

detected_waves = fieldnames(ecg_results);

if sum(contains(detected_waves,'P'))
    num_p = length(ecg_results.P);
else
    num_p = 0;
end

if sum(contains(detected_waves,'Q'))
    num_q = length(ecg_results.Q);
else
    num_q = 0;
end

if sum(contains(detected_waves,'R'))
    num_r = length(ecg_results.R);
else
    num_r = 0;
end

if sum(contains(detected_waves,'S'))
    num_s = length(ecg_results.S);
else
    num_s = 0;
end

if sum(contains(detected_waves,'T'))
    num_t = length(ecg_results.T);
else
    num_t = 0;
end

end

