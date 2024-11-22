function plotting_preprocessed_sig(preprocessed_sig, raw_sig, fs)
% Inside of Wrapped Signal Preprocessing Plotting Function to plot the raw and
% preprocessed signal.

t = 0:1/fs:((length(preprocessed_sig)-1))/fs;

fig_sig_preprocessing = figure; 
ax(1) = subplot(2,1,1); plot(t,raw_sig); ylabel('Amplitude'); box off; title('Raw Signal'); 
ax(2) = subplot(2,1,2); plot(t,preprocessed_sig,'r'); ylabel('Amplitude'); title('Preprocessed Signal'); xlabel('Time (sec)'); box off; linkaxes(ax,'x')

end

