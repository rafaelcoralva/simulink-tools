function plotting_preprocessed_ecg(preprocessed_ecg, raw_ecg, fs)
% Inside of Wrapped ECG Preprocessing Plotting Function to plot the raw and
% preprocessed ECGs.

t = 0:1/fs:((length(preprocessed_ecg)-1))/fs;

fig_ecg_preprocessing = figure; 
ax(1) = subplot(2,1,1); plot(t,raw_ecg); ylabel('Amplitude (V)'); box off; title('Raw ECG'); 
ax(2) = subplot(2,1,2); plot(t,preprocessed_ecg,'r'); ylabel('Amplitude (mV)'); title('Preprocessed ECG'); xlabel('Time (sec)'); box off; linkaxes(ax,'x')

end

