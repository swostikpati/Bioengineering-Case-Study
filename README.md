# Bioengineering Case Study Apnea Detection using Electrocardiography (ECG) - Signal Processing
## Problem Identification and Statement
Breathing monitoring is an essential diagnostic tool and a crucial safety measure when high risk
apnea is present. Direct monitoring of breathing is not always possible, hence secondary sources
of information, such as heart arrhythmia (unexpected heart rate changes) are essential to track
apnea events. The objective of the program is to process Electrocardiography (ECG) signals
from standardized medical datasets, use them to derive relevant diagnostic information like the
heart rate value, etc., and use this information to estimate the occurrence of apneas.

## Gathering of Information and Input/Output Description
### Relevant Information:
The diagnosis of sleep apnea is difficult, and it often involves a trained medical staff to watch
overnight the sleep cycle of a patient. Developing systems that can allow the diagnosis of sleep
apnea in a cost effective way is therefore crucial. The direct measurement of chest movement
tends to carry high noise given the similar frequency of other body movements, making this
technique ineffective. However, the potential to use heart arrythmia to detect apnea events is a
promising approach.

ECG signals are one of the most feature rich and non-intrusive ways to detect various cardiac
disorders. Cost effective and powerful embedded ECG devices are now widely available.
Additionally, a lot of research has been carried into determining the relationship between apnea
events and heart rate.

[Picture]

Sleep apneas are detected using sleep tests where heart rate, blood oxygen levels, airflow,
breathing patterns, etc. are monitored (Reference: Mayo Clinic: Sleep Apnea). In case of our
study we are using hours of monitored ECG data that is taken while the person is sleeping.
Corresponding to this, annotated files containing information about apnea occurrence or not are
present for the entire length of the sleep in intervals of every minute. We analyze the ECG data to
find out how the presence of apneas impacts the heart’s parameters (average heart rate,
maximum and minimum heart rates, etc). The analysis is two fold: time-domain analysis and
frequency domain analysis. This is done in order to reinforce our observations from both studies
Based on inspection of the two studies, we then devise an algorithm to detect episodes of sleep
apnea based on just the ECG data.

The ECG data is stored as binary values in a .dat file with 16 bits per sample, 100 samples per
second frequency, and conversion voltage of 200 A/D units per millivolt. The information about
each data file is present in separate header files.

### Input/output Description:
The program then obtains the information about the ECG file (sampling frequency, etc.) from the
header file and then takes the ECG data from the data file. The file containing the annotated data
is also required to be provided as input. The output of the program is multi-fold. Each function is
tested using different outputs - graphs. There are also separate plots to depict the results of the
time-domain analysis and frequency domain analysis. Finally, the accuracy of the algorithm
devised is also shown to the user.

## Test Cases
The data set chosen for the purpose of analysis is a03.dat.

### Test Case 1: To test Interpolation
To test the interpolation function we plot two seconds of data before and after interpolation. The
initial sampling frequency changes from 100Hz to 500 Hz. For plotting two seconds of data
before and after sampling, many more data points need to be plotted in case of the interpolated
data than in case of normal data.

### Test Case 2: To test Filtration of Data
To test the filtration function (low-pass filter function), we plot two seconds of data before and
after filtering. The raw data consists of a lot of noise and therefore has sharp edges. The filtered
data should consist of much smoother edges and peaks.

### Test Case 3: Time-domain analysis (Average Heart Rate Plot)
The average heart rate vs time graph should show heart rate values within the normal heart rate
range of an average human being. The graph of the apnea values should oscillate between two
numbers to indicate the presence or the absence of an apnea. The apnea data plotted on top of the
heart rate data should show some relationship.

### Test Case 4: Power vs Frequency Spectrum
The power vs frequency spectrum graph is obtained after applying the Fast Fourier
transformation of the data to a frequency of 4Hz. The graph will be present from -4/2 to +4/2
hertz and will be symmetric about the point 0.

### Test Case 5: Frequency-Domain Analysis (Power Density Plot)
The frequency domain analysis is done by plotting the power density graph for the entire four
hours of data. The graph(a color plot) should be darker around regions of high power and lighter
around regions of low power. The average heart rate graph and the apnea graph is also plotted on
top of the power density. These heart rate graph should align itself with the frequency graph. The
apnea data plotted over the primary graphs should show some relationship.

### Test Case 6: Algorithmic Efficiency
To test the overall efficiency of the algorithm devised, we first run the heart rate values obtained
from the same ECG file through the algorithm. We then compare the presence of apneas as
detected by the algorithm with the values from the annotated file. An efficiency of 70% or more
is considered to be decent.

## Results and Analysis
[To be updated]
