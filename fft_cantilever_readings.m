close all
clear all
clc

load('Cantilever_readings_800N_5.mat');         % Cantilever ADC readings from Arduino
signal_volt = num * (5.0 / 1023);               % Cantilever readings in volt

row = 2330;                                     % Silicon density in kg/m3
l = 0.008;                                      % Lenght of Cantilever in meter
w = 0.0015;                                     % Width of Cantilever in meter
h = 0.00005;                                    % Height of Cantilever in meter
volume = l * w * h;                             % Volume of Cantilever
mass = row * volume;                            % Mass of Cantilever

L = size(signal_volt,1);                        % Length of signal
Fs = 8000;                                      % Sampling frequency
t = 0:112:112*L-1;                              % Time vector

plot(t,signal_volt);                            % Plot of Cantilever signal
title('Cantilever Signal')
xlabel('Time (us)')
ylabel('Voltage (v)')

Y = fft(signal_volt);                           % FFT of Cantilever signal
P2 = abs(Y/L);                                  % Two-sided Amplitude spectrum
P1 = P2(1:L/2+1);                               % Single-sided Amplitude spectrum
P1(2:end-1) = 2*P1(2:end-1);                    % Even valued signal lenght L

f = Fs*(0:(L/2))/L;                             % Frequency domain
figure
plot(f,P1)                                      % Plot single-sided amplitude spectrum
title('Single-Sided Amplitude Spectrum of Cantilever')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

for i = 1:2
    P1(i) = 0;
end

max_amplitude = max(P1);                        % Maximum Amplitude of the Single-sided spectrum
half_power_amplitude = max_amplitude / sqrt(2); % -3dB Amplitude

j = 1;

for i = 1:length(P1)-1
    
    factor = P1(i) - P1(i+1);
    if factor > 0
        factor1 = factor / 100;
        P3(j:1:j+100) = P1(i) : -factor1 : P1(i+1);
        j = j + 101;
    end
    if factor < 0
        factor1 = factor / 100;
        P3(j:1:j+100) = P1(i) : -factor1 : P1(i+1);
        j = j + 101;
    end      
  
end

f1 = Fs*(0:(length(P3)-1))/length(P3);
f2 = f1/2;

[C, I] = max(P3);
k=1;

for i = 50:I
    
    if P3(i) > half_power_amplitude
        freq_1(k) = f2(i);
       break 
    end
end

for i = I:length(P3)
    
    if P3(i) < half_power_amplitude
        freq_2(k) = f2(i);
       break 
    end 
    
end

bandwidth = freq_2 - freq_1;

damping = bandwidth * mass;

display(damping)




