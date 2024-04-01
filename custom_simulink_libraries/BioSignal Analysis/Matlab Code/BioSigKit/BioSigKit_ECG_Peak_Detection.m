function [ecg_P,ecg_Q,ecg_R,ecg_S,ecg_T] = BioSigKit_ECG_Peak_Detection(fs, preprocessed_ecg, ecg_algo)
% Function to call BioSigKit wrapper and use the MTEO to detect and the return the  sample positions of P,Q,R,S,
% and T peaks of an input ECG.

BioSigKitAnalysis = RunBioSigKit(preprocessed_ecg,fs,0); % Run BioSigKit wrapper.

if ecg_algo == 1
    BioSigKitAnalysis.PanTompkins;      % Run BioSigKit Pan-Tompkins algorithm to detect R peaks.
elseif ecg_algo == 2
    BioSigKitAnalysis.PhaseSpaceAlg;    % Run BioSigKit Phase space algorithm to detect R peaks.
elseif ecg_algo == 3
    BioSigKitAnalysis.FilterBankQRS;    % Run BioSigKit filter bank algorithm to detect R peaks.
elseif ecg_algo == 4
    BioSigKitAnalysis.StateMachine;     % Run BioSigKit State Machine algorithm to detect QRST peaks.
elseif ecg_algo == 5
    BioSigKitAnalysis.MTEO_qrstAlg;     % Run BioSigKit MTEO algorithm to detect PQRST peaks.
end

ecg_results = BioSigKitAnalysis.Results; % Saving the PQRST label sample times.

detected_waves = fieldnames(ecg_results);

if sum(contains(detected_waves,'P'))
    ecg_P = ecg_results.P;
else
    ecg_P = [];
end

if sum(contains(detected_waves,'Q'))
    ecg_Q = ecg_results.Q;
else
    ecg_Q = [];
end

if sum(contains(detected_waves,'R'))
    ecg_R = ecg_results.R;
else
    ecg_R = [];
end

if sum(contains(detected_waves,'S'))
    ecg_S = ecg_results.S;
else
    ecg_S = [];
end

if sum(contains(detected_waves,'T'))
    ecg_T = ecg_results.T;
else
    ecg_T = [];
end

end

