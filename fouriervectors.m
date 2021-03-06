%% Exercises from Linear algebra, signal processing, and wavelets. A unified approach.\\ Matlab version
% 
% Author: \O yvind Ryan
% 
% Date: Jan 20, 2017
% 
% % Externaldocuments: applinalg
% % Mapping from exercise labels to numbers: label2numbers = {'ex:compareextimes': '2.24', 'dftmainex3': '2.18', 'dftmainex2': '2.17', 'ex:interpolant': '2.21', 'dftmainex': '2.16', 'ex:nonrecursivealg': '2.28'}
% 
% 
% Table of contents:
% 
%  Sound and Fourier series 
%  Digital sound and Discrete Fourier analysis 
%      Example 2.16: Using the DFT to adjust frequencies in sound 
%      Example 2.17: Compression by zeroing out small DFT coefficients 
%      Example 2.18: Compression by quantizing DFT coefficients 
%      Exercise 2.21: Implement interpolant 
%      Exercise 2.24: Compare execution time 
%      Exercise 2.28: Non-recursive FFT algorithm 
%  Operations on digital sound: digital filters 
%  Symmetric filters and the DCT 
% 
% 
% 
%% Sound and Fourier series
%% Digital sound and Discrete Fourier analysis
% 
% 
% % --- begin exercise ---
% 
%% Example 2.16: Using the DFT to adjust frequencies in sound
% 
% % keywords = ipynbfouriervectors; mfouriervectors
% 
% Let us test the function |forw_comp_rev_DFT| to listen to the lower frequencies in the audio sample file.
% We start with $L=13000$.
% 
[x, fs] = forw_comp_rev_DFT('L', 13000, 'lower', 1);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
% Then with $L=5000$.
% 
[x, fs] = forw_comp_rev_DFT('L', 5000, 'lower', 1);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
% With $L=13000$ you can hear the disturbance in the sound, but we have not lost that much even if about 90\% of the DFT coefficients are dropped. 
% The quality is much poorer when $L=5000$ (here we keep less than 5\% of the DFT coefficients). 
% However we can still recognize the song, and this suggests that most of the frequency information is contained in the lower frequencies.
% 
% Let us then listen to higher frequencies instead. 
% We start with $L=140000$.
% 
[x, fs] = forw_comp_rev_DFT('L', 140000, 'lower', 0);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
% Then with $L=100000$. 
% 
[x, fs] = forw_comp_rev_DFT('L', 100000, 'lower', 0);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
% 
% We find that we need very high values of $L$ to hear anything, suggesting again that most information is contained in the lowest frequencies.
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Example 2.17: Compression by zeroing out small DFT coefficients
% 
% % keywords = ipynbfouriervectors; mfouriervectors
% 
% We can achieve compression of a sound by setting small DFT coefficients which to zero. The idea is that frequencies with small values at the
% corresponding frequency indices contribute little to our perception of the sound, so that they can be discarded. As a result we obtain a sound with less frequency
% components, which is thus more suitable for compression. To test this in practice, we first need to set a threshold, which decides which frequencies to keep. 
% This can then be sent to the function |forw_comp_rev_DFT| by means of the named parameter |threshold|. 
% The function will now also write to the display the percentage of the DFT coefficients which were zeroed out.
% Let us first listen to the result when |threshold=20|.
% 
[x, fs] = forw_comp_rev_DFT('threshold', 20);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
% Then for |threshold=70|.
% 
[x, fs] = forw_comp_rev_DFT('threshold', 70);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Example 2.18: Compression by quantizing DFT coefficients
% 
% % keywords = ipynbfouriervectors; mfouriervectors
% 
% The previous example is a rather simple procedure to obtain compression. The disadvantage is that it only affects frequencies with low contribution. 
% A more neutral way to obtain compression is to let each DFT index occupy a certain number of bits. This is also called _quantization_, 
% and provides us with compression if the number of bits is less than what actually is used to represent the sound. 
% This is closer to what modern audio standards do.
% |forw_comp_rev_DFT| accepts a name parameter |n|. The effect of this is that a DFT coefficient with bit representation 
% 
% $$...d_2d_1d_0.d_{-1}d_{-2}d_{-3}...$$
% is truncated so that the bits $d_{n-1}$, $d_{n-2}$, $d_{n-2}$ are discarded.
% In other words, high values of $n$ mean more rounding. 
% Let us first listen to the result for |n=3|.
% 
[x, fs] = forw_comp_rev_DFT('n', 3);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
% Then for |n=5|.
% 
[x, fs] = forw_comp_rev_DFT('n', 5);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
% Then for |n=7|.
% 
[x, fs] = forw_comp_rev_DFT('n', 7);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
% You can hear that the sound degrades further when $n$ is increased.
% 
% In practice this quantization procedure is also too simple, since the
% human auditory system is more sensitive to certain frequency information, and should thus allocate a higher number of bits for such frequencies. 
% Modern audio standards take this into account, but we will not go into details on this.
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Exercise 2.21: Implement interpolant
% 
% % keywords = ipynbfouriervectors; mfouriervectors
% 
% Implement code where you do the following:
% 
% * at the top you define the function $f(x)=\cos^6(x)$, and $M=3$,
% 
% * compute the unique interpolant from $V_{M,T}$ (i.e. by taking $N=2M+1$ samples over one period), 
%   as guaranteed by Proposition 2.9,
% 
% * plot the interpolant against $f$ over one period.
% 
% Finally run the code also for $M=4$, $M=5$, and $M=6$. Explain why the plots coincide for $M=6$, but not for $M<6$. Does increasing $M$ above $M=6$ have any effect on the plots?
% 
% 
% % --- begin solution of exercise ---
% *Solution.* The code can look as follows.
% 
f = @(t)cos(t).^6;
M = 5;
T = 2*pi;
N = 2*M + 1;
t = (linspace(0, T, 100))';
x = f((linspace(0, T - T/N, N))');
y = fft(x)/N;
s = y(1)*ones(length(t),1);
for k=1:((N-1)/2)
s = s + 2*real(y(k+1)*exp(2*pi*1i*k*t/T));
end
plot(t, s, 'r', t, f(t), 'g');
legend('Interpolant from V_{M,T}', 'f')
% 
% % --- end solution of exercise ---
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Exercise 2.24: Compare execution time
% 
% % keywords = ipynbfouriervectors; mfouriervectors
% 
% In this exercise we will compare execution times for the different methods for computing the DFT.
% 
% 
% *a)* Write code which compares the execution times for an $N$-point DFT for the following three cases: Direct implementation of the DFT 
% (as in Example 2.4),
% the FFT implementation used in this chapter, and the built-in |fft|-function. Your code should use the sample audio file |castanets.wav|, 
% apply the different DFT implementations to the first $N=2^r$ samples of the file for $r=3$ to $r=15$, store the execution times in a vector, and plot these. You can use 
% the functions |tic| and |toc|
% to measure the execution time.
% 
% 
% *b)* A problem for large $N$ is that there is such a big difference in the execution times between the two implementations. We can address this by using a loglog-plot instead. Plot $N$ against execution
% times using the function |loglog|. How should the fact that the number of arithmetic operations are $8N^2$ and $5N\log_2N$ be reflected in the plot?
% 
% 
% % --- begin solution of exercise ---
% *Solution.* The two different curves you see should have a derivative approximately equal to one and two, respectively.
% 
% % --- end solution of exercise ---
% 
% *c)* It seems that the built-in FFT is much faster than our own FFT implementation, even though they may use similar algorithms. Try to explain what can be the cause of this.
% 
% 
% % --- begin solution of exercise ---
% *Solution.* There may be several reasons for this. 
% One is that Matlab code runs slowly when compared to native code, which is much used in the built-in FFT. Also, the built-in |fft| has been subject to much more optimization than we have
% covered here.
% Another reason is that Matlab functions copy the parameters each time a function is called. When the vectors are
% large, this leads to extensive copying, also since the recursion depth is big.
% 
% % --- end solution of exercise ---
% 
% 
% % --- begin solution of exercise ---
% *Solution.* The code can look as follows.
% 
[x0, fs] = audioread('sounds/castanets.wav');
kvals = 3:15;
slowtime=zeros(1,length(kvals));
fasttime = slowtime; fastesttime = slowtime;
N = 2.^kvals;
for k = kvals
x = x0(1:2^k,1);
tic;
y = DFTImpl(x);
slowtime(k-2) = toc;
tic;
y = FFTImpl(x, @FFTKernelStandard);
fasttime(k-2) = toc;
tic;
y = fft(x);
fastesttime(k-2) = toc;
end
% a.
plot(kvals, slowtime, 'r', ...
kvals, fasttime, 'g', ...
kvals, fastesttime, 'b')
grid on
title('time usage of the DFT methods')
legend('DFT', 'Standard FFT', 'Built-in FFT')
xlabel('log_2 N')
ylabel('time used [s]')
% b.
figure(2)
loglog(N, slowtime, 'r', N, fasttime, 'g', N, fastesttime, 'b')
axis equal
legend('DFT', 'Standard FFT', 'Built-in FFT')
% 
% % --- end solution of exercise ---
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Exercise 2.28: Non-recursive FFT algorithm
% 
% % keywords = ipynbfouriervectors; mfouriervectors
% 
% Use the factorization in (2.18) to write a kernel function |FFTKernelNonrec| 
% for a non-recursive FFT implementation.
% In your code, perform the matrix multiplications in Equation (2.18) 
% from right to left in an (outer) for-loop. For each matrix loop through the different blocks on the diagonal in
% an (inner) for-loop. Make sure you have the right number of blocks on the diagonal, each block being on the form 
% 
% $$I & D_{N/2^k} \\ I & -D_{N/2^k} \end{pmatrix}.$$
% It may be a good idea to start by implementing multiplication with such a simple matrix first as these are the building blocks in the algorithm (also attempt to do this so that everything is computed
% in-place). Also compare the execution times with our original FFT algorithm, as we did in 
% Exercise 2.24, and try to explain what you see in this comparison.
% 
% 
% 
% 
% 
% 
% 
% % --- begin solution of exercise ---
% *Solution.* If you add the non-recursive algorithm to the code from Exercise 2.24, you will see that the non-recursive algorithm performs much better. There may be several
% reasons for this. First of all, there are no recursive function calls. Secondly, the values in the matrices $D_{N/2}$ are constructed once and for all with
% the non-recursive algorithm. Code which compares execution times for the original FFT algorithm, our non-recursive implementation, and the split-radix algorithm of the next
% exercise, can look as follows:
% 
[x0, fs] = audioread('sounds/castanets.wav');
kvals = 3:15;
slowtime = zeros(1,length(kvals));
fasttime = slowtime; fastesttime = slowtime;
N = 2.^(kvals);
for k = kvals
x = x0(1:2^k,1);
tic;
y = FFTImpl(x, @FFTKernelStandard);
slowtime(k-2) = toc;
tic;
y = FFTImpl(x, @FFTKernelNonrec);
fasttime(k-2) = toc;
tic;
y = FFTImpl(x, @FFTKernelSplitradix);
fastesttime(k-2) = toc;
end
plot(kvals, slowtime, 'ro-')
hold on 
plot(kvals,fasttime, 'bo-')
plot(kvals,fastesttime, 'go-')
grid on
title('time usage of the DFT methods')
legend('Standard FFT algorithm', ...
'Non-recursive FFT', ...
'Split radix FFT')
xlabel('log_2 N')
ylabel('time used [s]')
% 
% % --- end solution of exercise ---
% 
% % --- end exercise ---
% 
% 
%% Operations on digital sound: digital filters
%% Symmetric filters and the DCT

