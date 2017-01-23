%% Exercises from Linear algebra, signal processing, and wavelets. A unified approach.\\ Matlab version
% 
% Author: \O yvind Ryan
% 
% Date: Jan 20, 2017
% 
% % Externaldocuments: applinalg
% % Mapping from exercise labels to numbers: label2numbers = {'basstrebleexercise': '3.39', 'bassex': '3.36', 'mp3example': '3.34', 'echoadd': '3.30', 'movavgex': '3.31', 'example:plotting_simple_freqresp': '3.18', 'example:dropping_filter_coefficients': '3.33'}
% 
% 
% Table of contents:
% 
%  Sound and Fourier series 
%  Digital sound and Discrete Fourier analysis 
%  Operations on digital sound: digital filters 
%      Example 3.18: Plotting a simple frequency response 
%      Example 3.30: Adding echo 
%      Example 3.31: Reducing the treble with moving average filters 
%      Example 3.33: Dropping filter coefficients 
%      Example 3.34: Filters and the MP3 standard 
%      Example 3.36: Reducing the bass using Pascals triangle 
%      Exercise 3.39: Reducing bass and treble 
%  Symmetric filters and the DCT 
% 
% 
% 
%% Sound and Fourier series
%% Digital sound and Discrete Fourier analysis
%% Operations on digital sound: digital filters
% 
% 
% % --- begin exercise ---
% 
%% Example 3.18: Plotting a simple frequency response
% 
% % keywords = ipynbfilters; mfilters
% 
% In Example 3.10 we computed the vector frequency response of the filter defined in formula (3.1). 
% The filter coefficients are here $t_{-1}=1/4$, $t_0=1/2$, and $t_1=1/4$. 
% The continuous frequency response is thus
% 
% $$\begin{equation*} \lambda_S(\omega)=\frac{1}{4}e^{i\omega}+\frac{1}{2} + \frac{1}{4}e^{-i\omega} =\frac{1}{2}+\frac{1}{2}\cos\omega. \end{equation*}$$
% Clearly this matches the computation from Example 3.10. 
% We can plot the frequency response over $[0,2\pi]$ as follows, 
% 
omega=linspace(0, 2*pi, 100);
figure();
plot(omega,0.5+0.5*cos(omega), 'k-')
% and over $[-\pi,\pi]$ as follows.
% 
omega=linspace(-pi, pi, 100);
figure();
plot(omega,0.5+0.5*cos(omega), 'k-')
% 
% 
% Both the continuous frequency response and the vector frequency response for $N=51$ are shown. The right part shows clearly how the high frequencies are softened by
% the filter.
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Example 3.30: Adding echo
% 
% % keywords = ipynbfilters; mfilters
% 
[x, fs] = audioread('sounds/castanets.wav')
d = 10000;
c = 0.5;
% 
% An echo is a copy of the sound that is delayed and softer than the original sound. 
% If $\bm{x}$ is the sound, the sound $\bm{z}$ with samples given by
% 
[N, nchannels] = size(x);
z = zeros(N, nchannels);
z(1:d,:) = x(1:d,:); % No echo at the beginning of the signal
z((d+1):N,:) = x((d+1):N,:)+c*x(1:(N-d),:); % Add echo
z = z/max(max(abs(z))); % Scale so that sound values are within [-1,1].
% will include an echo of the original sound. 
% This is an example of a filtering operation where each output element is constructed from two input elements. 
% |d| is an integer which represents the delay in samples. If you need a delay in $t$ seconds, 
% simply multiply this with the sample rate to obtain the delay $d$ in samples ($d$ needs to be rounded to the nearest integer). 
% $c$ is a constant called the damping factor. 
% Since an echo is usually weaker than the original sound, we usually have that $c<1$. 
% If we choose $c>1$, the echo will dominate in the sound. 
% 
% Let us listen to the sound after adding echo.
% 
playerobj=audioplayer(z,fs);
playblocking(playerobj);
% You are encouraged to experiment and find the range of $d$ where the echo distinguisible from the sound itself, 
% and how low can you choose $c$ in order to still hear the echo.
% 
% Using our compact filter notation, the filter which adds echo can be written as
% 
% $$\begin{equation*}S=\{ \underline{1},0,\ldots,0,c \},\end{equation*}$$
% where the damping factor $c$ appears after the delay $d$. 
% The frequency response of this is $\lambda_S(\omega)=1+ce^{-id\omega}$, which is not real, so that the filter is not symmetric. 
% 
% We can plot the frequency response as follows
% 
omega = linspace(0.01, 2*pi-0.01, 100); 
figure();
plot(omega, abs(1+0.1*exp(-1j*10*omega)), 'k-')
% The deviation from $1$ is controlled by the damping factor $c$, and the oscillation is controlled by the delay $d$.
% 
% 
% 
% 
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Example 3.31: Reducing the treble with moving average filters
% 
% % keywords = ipynbfilters; mfilters
% 
% Let us now take a look at filters which adjust the treble in sound. 
% The fact that the filters are useful for these purposes will be clear when we
% plot the frequency response. 
% A general way of reducing variations 
% in a sequence of numbers is to replace one number by the average of itself and its neighbors, and this is easily done with a digital sound signal. 
% If $\bm{z}=(z_i)_{i=0}^{N-1}$ is the sound signal produced by taking the average of three successive samples, we have that
% 
% $$\begin{equation*} z_n = \frac{1}{3}(x_{n+1} + x_n + x_{n-1}),\end{equation*}$$
% i.e. $S=\{1/3,\underline{1/3},1/3\}$. 
% This filter is also called a _moving average filter_  (with three elements), and it can be written in compact form as. If we set $N=4$, the corresponding circulant
% Toeplitz matrix for the filter is
% 
% $$\begin{equation*} S = \frac{1}{3} \begin{pmatrix} 1 & 1 & 0           & 1 \\  1 & 1 & 1 & 0 \\  0           & 1 & 1 & 1 \\  1 & 0           & 1 & 1            \end{pmatrix} \end{equation*}$$
% The frequency response is
% 
% $$\begin{equation*}\lambda_S(\omega)=(e^{i\omega}+1+e^{-i\omega})/3=(1+2\cos(\omega))/3.\end{equation*}$$
% More generally we can construct the moving average filter of
% $2L+1$ elements, which is $S=\{1,\cdots,\underline{1},\cdots,1\}/(2L+1)$, where there is symmetry around $0$. 
% Clearly then the first column of $S$ is $\bm{s}=(\underbrace{1,\ldots,1}_{L+1\text{ times}},0,\ldots,0,\underbrace{1,\ldots,1}_{L\text{ times}})/(2L+1)$.
% In Example 2.2 we computed that the DFT of the vector $\bm{x}=(\underbrace{1,\ldots,1}_{L+1\text{ times}},0,\ldots,0,\underbrace{1,\ldots,1}_{L\text{ times}})$ had components
% 
% $$\begin{equation*}y_n = \frac{\sin(\pi n(2L+1)/N)}{\sin(\pi n/N)}.\end{equation*}$$
% Since $\bm{s}=\bm{x}/(2L+1)$ and $\lambda_S=\text{DFT}_N\bm{s}$, the frequency response of $S$ is
% 
% $$\begin{equation*}\lambda_{S,n}=\frac{1}{2L+1}\frac{\sin(\pi n(2L+1)/N)}{\sin(\pi n/N)},\end{equation*}$$
% so that
% $$\lambda_S(\omega)=\frac{1}{2L+1}\frac{\sin((2L+1)\omega/2)}{\sin(\omega/2)}.$$
% We clearly have
% $$0\leq\frac{1}{2L+1}\frac{\sin((2L+1)\omega/2)}{\sin(\omega/2)}\leq 1,$$
% and this frequency response approaches $1$ as $\omega\to 0$. 
% The frequency response thus peaks at $0$, and this peak gets narrower and narrower as $L$ increases, i.e. as we use more and more samples in the
% averaging process. This filter thus "keeps" only the lowest frequencies. When it comes to the highest frequencies it is seen that the frequency response is small for $\omega\approx\pi$. 
% In fact it is straightforward to see that $|\lambda_S(\pi)|=1/(2L+1)$. 
% Let us plot the frequency responses for the moving avegerage filters corresponding to $L=1$, $L=5$, and $L=20$. 
% 
omega = linspace(0.01, 2*pi-0.01, 100);
for L = [1 5 20]
figure()
plot(omega, sin((2*L+1)*omega/2)./(sin(omega/2)*(2*L+1)), 'k-')
end
% Unfortunately, the frequency response is far from a filter which keeps some frequencies unaltered, while annihilating others: 
% Although the filter distinguishes between high and low frequencies, it slightly changes the small frequencies. 
% Moreover, the higher frequencies are not annihilated, even when we increase $L$ to high values.
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Example 3.33: Dropping filter coefficients
% 
% % keywords = ipynbfilters; mfilters
% 
% In order to decrease the computational complexity for the ideal low-pass filter in Example 3.32, 
% one can for instance include only the first filter coefficients, i.e.
% 
% $$\begin{equation*}\left\{\frac{1}{N}\frac{\sin(\pi k(2L+1)/N)}{\sin(\pi k/N)}\right\}_{k=-N_0}^{N_0}.\end{equation*}$$
% Hopefully this gives us a filter where the frequency response is not that different from the ideal low-pass filter. 
% Let us set $N=128$, $L=32$, so that the filter removes all frequencies $\omega>\pi/2$. 
% The following code tests this for different vaues of $N_0$.
% 
N = 128;
L = 32;
k=1:(N-1);
filtercoeffs = sin(pi*k*(2*L+1)/N)./(sin(pi*k/N)*N);
omega=linspace(0, 2*pi, 100);
for N0 = [2 4 16 64]
freqresp=((2*L+1)/N)*ones(1,length(omega));
for k = 1:N0
freqresp = freqresp + filtercoeffs(k)*2*cos(omega*k);
end
figure();
plot(omega, freqresp, 'k-')
end
% This shows that we should be careful when we omit filter coefficients: if we drop too many, the frequency response is far away from that of an ideal
% bandpass filter. In particular, we see that the new frequency response oscillates wildly near the discontinuity of the ideal low-pass filter. Such oscillations are
% called _Gibbs oscillations_.
% 
% 
% 
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Example 3.34: Filters and the MP3 standard
% 
% % keywords = ipynbfilters; mfilters
% 
% We mentioned previously that the MP3 standard splits the sound into frequency bands. This splitting is actually performed by particular filters, which we will
% consider now.
% In the example above, we saw that when we dropped the last filter coefficients in the ideal low-pass filter, there were some undesired effects in the frequency
% response of the resulting filter. Are there other and better approximations to the ideal low-pass filter which uses the same number of filter coefficients? This
% question is important, since the ear is sensitive to certain frequencies, and we would like to extract these frequencies for special processing, using as low
% computational complexity as possible. In the MP3-standard, such filters have been constructed. These filters are more advanced than the ones we have seen up to now.
% They have as many as 512 filter coefficients! We will not go into the details on how these filters are constructed, but only show how their frequency responses look. 
% 
% The "prototype filter" used in the MP3 standard can be plotted as follows. 
% 
omega = linspace(-0.7, 0.7, 1000);
wind = mp3ctable();
wind1 = [ repmat(1, 1, 64) repmat(-1, 1, 64)];
wind1 = repmat(wind1, 1, 4);
wind=wind.*wind1;
freqresp = zeros(1, 1000)
for k = 0:511
freqresp = freqresp + wind(k+1)*exp(-1j*omega*k);
end
figure();
plot(omega, abs(freqresp), 'k-')
% We see that this is very close to an ideal low-pass
% filter. Moreover, many of the undesirable effect from the previous example have been eliminated: The oscillations near the discontinuities are much smaller, and
% the values are lower away from $0$. Using Property 4 in Theorem 2.7, it is straightforward to construct filters with similar frequency responses, but
% centered around different frequencies: We simply need to multiply the filter coefficients with a complex exponential, in order to obtain a filter where the
% frequency response has been shifted to the left or right. In the MP3 standard, this observation is used to construct 32 filters, each having a frequency response
% which is a shifted copy of that of the prototype filter, so that all filters together cover the entire frequency range. 
% 5 of these frequency responses can be ploted as follows.
% 
figure()
for s = [3 5 7 9 11]
freqresp = zeros(1,1000);
for k = 0:511
freqresp = freqresp + wind(k+1)*cos(s*(k-16)*pi/64)*exp(-1j*omega*k);
end
plot(omega, abs(freqresp), 'k-')
end
% To understand the effects of the different filters, let us apply them to our sample sound. If you apply all filters in the MP3 standard in successive order with
% the most low-pass filters first, the result will sound like this <http://folk.uio.no/oyvindry/matinf2360/sounds/mp3bands.wav>. You should interpret the result as 
% low frequencies first, followed by the high frequencies. $\pi$ corresponds to the frequency $22.05$KHz (i.e. the highest representable frequency equals half
% the sampling rate on $44.1$KHz. The different filters are concentrated on $1/32$ of these frequencies each, so that the angular frequencies you here are
% $[\pi/64,3\pi/64]$, $[3\pi/64,5\pi/64]$, $[5\pi/64,7\pi/64]$, and so on, in that order.
% 
% In Section 3.3.1 we mentioned that the psycoacoustic model of the MP3 standard applied a window the the sound data, followed by an FFT to that
% data. This is actually performed in parallel on the same sound data. Applying two different operations in parallel to the sound data may seem strange. In the MP3
% standard [1] (p. 109) this is explained by ``the lack of spectral selectivity obtained at low frequencies`` by the filters above. In other words,
% the FFT can give more precise frequency information than the filters can. This more precise information is then used to compute psychoacoustic information such
% as masking thresholds, and this information is applied to the output of the filters.
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Example 3.36: Reducing the bass using Pascals triangle
% 
% % keywords = ipynbfilters; mfilters
% 
% Due to Observation 3.22 and Example 3.35, we can create bass-reducing filters 
% by adding an alternating sign to rows in Pascals triangle. 
% Consider the bass-reducing filter deduced from the fourth row in Pascals triangle:
% 
% $$\begin{equation*}z_n = \frac{1}{16}(x_{n-2}-4x_{n-1}+6x_n-4x_{n+1}+x_{n+2})\end{equation*}$$
% Let us apply this filter to the sound in Figure 3.12. 
% This can be done with the following code.
% 
t=0:(1/4400):0.01;
vals=sin(2*pi*440*t);
arr2 = [ -1/4400 -2/4400 t 0.01+1/4400   0.01+2/4400];
figure();
plot(arr2,conv(vals,[1 -4 6 -4 1]/16),'-ko')
% We observe that the samples oscillate much more than the samples of the original sound. 
% In Exercise 3.39 you will
% be asked to implement reducing the bass in our sample audio file. The new sound will be difficult to hear for large $k$, and we will explain
% why later. For $k=1$ the sound will be like this <http://folk.uio.no/oyvindry/matinf2360/sounds/castanetsbass1.wav>, for $k=2$ it will be like
% this <http://folk.uio.no/oyvindry/matinf2360/sounds/castanetsbass2.wav>. Even if the sound is quite low, you can hear that more of the bass has disappeared
% for $k=2$.
% 
% Let us plot the frequency response we obtain from using row $5$ of Pascal's triangle. 
% 
t=0:(1/4400):0.01;
vals=sin(2*pi*440*t);
arr2 = [ -1/4400 -2/4400 t 0.01+1/4400   0.01+2/4400];
figure();
plot(arr2,conv(vals,[1 -4 6 -4 1]/16),'-ko')
% It is just the frequency response of the corresponding treble-reducing filter shifted with $\pi$. 
% The alternating sign can also be achieved if we write the frequency response
% $\frac{1}{2^k}(1+e^{-i\omega})^k$ from Example 3.35 as $\frac{1}{2^k}(1-e^{-i\omega})^k$, 
% which corresponds to applying the filter $S(\bm{x})=\frac{1}{2}(-x_{n-1}+x_n)$ $k$ times.
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Exercise 3.39: Reducing bass and treble
% 
% % keywords = ipynbfilters; mfilters
% 
% Write code where you reduce the treble and the bass as described in examples 3.35 and 3.36, 
% generate the sounds you heard in these examples, and verify that they are the same.
% In your code, it will be necessary to scale the values after reducing the bass, but not the values after reducing the bass. Explain why this is the case.
% How high must $k$ be in order for you to hear difference from the actual sound? How high can you choose $k$ and still recognize the sound at all?  
% If you solved Exercise 3.9, you can also use the function |filterS| to perform the filtering, 
% rather than sing the |conv| function (the latter disregards circularity).
% 
% 
% % --- begin solution of exercise ---
% *Solution.* The code can look like this, when we reduce the treble. We have used the |conv| function:
% 
t = [1];
for kval=1:k
t = conv(t,[1/2 1/2]);
end
% 
z = conv(t, x(:, 1));
playerobj=audioplayer(z,fs);
playblocking(playerobj);
% If we reduce the bass instead, the code can look like this.
% 
t = [1];
for kval=1:k
t = conv(t,[1/2 -1/2]);
end
% 
z = conv(t, x(:, 1));
z = z/max(abs(z));
playerobj=audioplayer(z,fs);
playblocking(playerobj);
% 
% % --- end solution of exercise ---
% 
% % --- end exercise ---
% 
% 
%% Symmetric filters and the DCT

