%Fs--------------------------------------------------------------------
%
%script   setupCryoNew
% set up parameters for CryoDet<xyz>.slx
% Original 2-3-2016 / SSmith
% Copied & Modlfied for new AMC HW Alg / JED May 2017
%
% Update History:

%   <07-31-2017 JED>: added simulink_period var
%   <09-22-2017 SRS>: change notch BW to 4 MHz, Nlines = 16
%
%--------------------------------------------------------------------

format compact
setupVers = 21; % just a number that goes into a status register

Fadc = 307.2e6  % ADC clock  frequency / NEW AMC System
Ts = 1/Fadc  % ADC sample rate

Fclk = Fadc  % same rate for new HW (non-Demo HW)
Tclk = 1/Fclk

%--added simulink_period var in order to make clock probe work / JED 07-31-2017
simulink_period = Ts;

%--pass-thru signal (sin/cos) generator freq parametee / added JED 08-08-2017
Fgen = 20e6;

% Simulate resonator notches in simulink
BW = 4e6  % Notch bandwidth in Hz

Fnotch = 70e6, Q = Fnotch/BW, wNotch = 2*pi*Fnotch
a = 0.1  % transmission at minimum
notch = tf( [1 a*wNotch/Q wNotch^2], [1 wNotch/Q wNotch^2])
figure(1), bode(notch); grid, title('Simulted resonator transfer function Notch 1')

% Simulate another resonator notch in simulink
Fnotch2 = 70.3e6,  Q = Fnotch2/BW, wNotch = 2*pi*Fnotch2
a = 0.2  % transmission at minimum
notch2 = tf( [1 a*wNotch/Q wNotch^2], [1 wNotch/Q wNotch^2])
figure(2), bode([notch; notch2]); grid, title('Simulted resonator transfer functions Notch 1 & 2')

% Simulate more resonator notches in simulink
Fnotch3 = 80.0e6, Q = Fnotch3/BW, wNotch = 2*pi*Fnotch3
a = 0.1  % transmission at minimum
notch3 = tf( [1 a*wNotch/Q wNotch^2], [1 wNotch/Q wNotch^2])
figure(3), bode([notch3]); grid, title('Simulted resonator transfer functions Notch 3')

Fnotch4 = 80.2e6, Q = Fnotch4/BW, wNotch = 2*pi*Fnotch4
a = 0.1  % transmission at minimum
notch4 = tf( [1 a*wNotch/Q wNotch^2], [1 wNotch/Q wNotch^2])
figure(4), bode([notch4]); grid, title('Simulted resonator transfer functions Notch 4')


freqBits = 24  % number of bits for frequency (24 bits ==> 18 Hz LSB freq resolution)
IQbits = 16  %number of bits for DDS I&Q
%IQbits = 15  % number of bits for DDS I&Q (16 bits takes up too much BRAM)
Nlines = 16   % max number of resonator lines per ADC
freqBusAddrBits = 4  %number of bits of address space for a frequency bus

%white noise generator paramters
noiseLen = 128   % length of vector of random phases for white noise generator
noiseSteps = 32  %every noiseSteps clocks (of 185 MHz) change random phase shift (try 37 later)
noise = exp(2i*pi*rand(1, noiseLen)); %complex random phases