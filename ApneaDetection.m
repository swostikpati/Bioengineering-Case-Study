%%Reading Data from the file
%Opening the header files
fheader = fopen('a03.hea','r');
test = fscanf(fheader, '%s',2); %To skip values
%Opening the ECG data file
fid = fopen('a03.dat','r');
ECG = fread(fid, 'int16');
%Extracting the sampling frequency
samplingfreq = fscanf(fheader, '%f',1);

%%Extracting four hours of information and Interpolating

%Extracting 4 hours of data from the ECG data
nECG = ECG(1:1440000);

N =  samplingfreq; %Storing the sampling frequency in N
t = 1/N: 1/N: 14400; 
t = t.';


N2 = 500; %Creating new Sampling frequency for interpolation
t2 = 1/N2: 1/N2: 14400;
t2 = t2.';
rECG = interp1(t, nECG, t2); %Interpolating from 100Hz to 500 Hz

%Plotting two seconds of data before and after interpolating
figure
plot (t(1:200),nECG(1:200));
figure
plot (t2(1:1000),rECG(1:1000));
figure
plot (t(1:200),nECG(1:200));
hold on;
plot (t2(1:1000),rECG(1:1000));
title('Test Case 1: Interpolation')
xlabel('Time (in seconds)');
ylabel('Signal Amplitude (in volts)');
legend('Sampling Frequency - 100Hz','Sampling Frequency - 500HZ');
hold off;

%%Filtering the data using a low-pass filter

%Designing a low pass filter
d = designfilt('lowpassfir', 'Filterorder', 20, 'CutoffFrequency', 11, 'SampleRate', N2);
fECG = filter(d, rECG); %Applying the low pass filter

%Plotting two seconds of data before and after filtering
figure
plot (t2(5000:6000),rECG(5000:6000));
hold on;
plot (t2(5000:6000),fECG(5000:6000));
title('Test Case 2: Filtration')
xlabel('Time (in seconds)');
ylabel('Signal Amplitude (in volts)');
legend('Raw','Filtered');
hold off;

%%Time-Domain Analysis 

%Creating empty arrays
avghr = [];
maxhr = [];
minhr = [];

HR = [];
Peaks = [];

%Setting start and end points
s = 1;
e = 1;

for i=1:30000:7200000

    %Reading through each 60 seconds of data for the four hours
    newArr = fECG(i:i+29999);
    for j=2:length(newArr)-1
        %Condition for calculating peaks
        if (newArr(j)>100 && (abs(newArr(j) - newArr(j-1)) >= 0.5) && (newArr(j)>newArr(j+1)) && (newArr(j)>newArr(j-1)))
            Peaks = [Peaks, j];
            e = e+1;
        end
    end

    for k = s+1:e-1
        %Measuring the RR-values and the subsequent Heart Rate values
        diff = Peaks(k) - Peaks(k-1);
        HR = [HR, 60/(diff*0.002)];

    end
    
    %Appending heart rate information into corresponding arrays
    avghr = [avghr, mean(HR)];
    maxhr = [maxhr, max(HR)];
    minhr = [minhr, min(HR)];

    %Empyting the HR array
    HR = [];
    %Assiging new start point
    s=e;

end

%Creating time axis
t3 = [1:240];
t3 = t3.';

%Reading data from annotated files
apnf = fopen('a03.apn.txt', 'r');
if(apnf == -1)
    error('File couldn''t be opened');
end
%Skipping data
data= fscanf(apnf, '%s',3);

%Creating array to store annotated values in forms of numbers
apnea = [];
for i = 1:240
    data= fscanf(apnf, '%s',1);
    if(data == 'N')
        apnea = [apnea, 50]; %Assigning 50 for non-apnea
    end
    if(data == 'A')
        apnea = [apnea, 100]; %assiging 100 for apnea
    end
    data = fscanf(apnf, '%s',1); %Skipping values

end

%plotting the average heart rate graph and the apnea data graph
figure
plot(t3(2:240),avghr(2:240));
hold on;
plot(t3(2:240), apnea(2:240));
title('Test Case 3: Time-Domain Analysis')
xlabel('Time (in mins)');
ylabel('Average Heart Rate (in BPM)');
legend('Average Heart Rate','Presence of Apneas');
hold off;

%%Downsampling and Frequency vs Power Spectrum

%Assigning new sampling frequency of 4Hz
nfs = 4;
r2ECG = resample(nECG, nfs, N); %Resampling the data
r2ECG60 = r2ECG(1:240); %extracting 60 seconds of data
ff60 = fft(r2ECG60); %applying fft
Num1 = length(ff60);
freq = -nfs/2:nfs/Num1:nfs/2-nfs/Num1; %defining the x-axis
%Storing power spectral density info
PSDX = (1/nfs*Num1)*abs(ff60).^2; 
PSDX = PSDX(1:Num1/2);

%plotting the graphs
figure
plot(freq,ff60);
title('Test Case 4: Frequency vs Power Spectrum')
xlabel('Frequency (in Hz)');
ylabel('Power (in volts)');

%%Frequency-Domain Analysis 
PSDarr = []; 
%Performing the analysis for every 60 seconds in the 4 hour period
for i=1:240:57600
    newFreq = r2ECG(i:i+239);
    ffn  = fft(newFreq);
    NumN = length(ffn);
    freqN = -nfs/2:nfs/NumN:nfs/2 - nfs/NumN;
    PSDn = (1/nfs*NumN)*abs(ffn).^2;
    PSDn = PSDn(1:NumN/2);
    PSDarr = [PSDarr,[PSDn]]; %appending the PSDn array into the PSDarr

end

%Colour Plotting the information
figure
pcolor(PSDarr);
hold on;
plot(t3,avghr,'r');
plot(t3,apnea, 'y');
title('Test Case 5: Frequency-Domain Analysis')
xlabel('Time (in minutes)');
ylabel('Frequency (in Hz)');
legend('Power Density Graph','Averge Heart Rate','Presence of Apneas');
hold off;

%%Algorithm Design and Efficiency Calculation

check =[];
threshold = 63; %threshold value for apnea detection based on observation
for i=1:240
    if avghr(i)<=threshold
        check = [check, 100];
    else
        check = [check, 50];
    end
end

%Algorithm efficiency
eff = 0;
for i=1:240
    if apnea(i) == check(i);
        eff = eff+1;
    end
end
%Diplaying final efficiency in percentage
finaleff = eff*100/240

