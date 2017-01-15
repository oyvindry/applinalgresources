%% Exercises from Exercises from Linear algebra, signal processing, and wavelets. A unified approach.\\ Matlab version
% 
% Author: \O yvind Ryan
% 
% Date: Jan 15, 2017
% 
% % Mapping from exercise labels to numbers: label2numbers = {'symfuncex': '1.35', 'ex:playwithdifferentfs': '1.9', 'exsq1': '1.12', 'triwavetrunk': '1.16', 'puresoundex': '1.3', 'ex:fourierseriespolynomials': '1.22', 'ex:playwithnoise': '1.10', 'ex:fourierpuretoneshortened': '1.24', 'example:listen_different_channels': '1.1', 'triangleexercise': '1.11', 'ex:fourierpuretone2stk': '1.25', 'squarewaveex': '1.4', 'soundbackwards': '1.2'}
% 
% 
% % Externaldocuments: applinalg, applinalg
% 
% Table of contents:
% 
%  Sound and Fourier series 
%      Example 1.1: Listen to different channels 
%      Example 1.2: Playing the sound backwards 
%      Example 1.3: Playing pure tones. 
%      Example 1.4: The square wave 
%      Exercise 1.9: Playing with different sample rates 
%      Exercise 1.10: Play sound with added noise 
%      Exercise 1.11: Playing the triangle wave 
%      Example 1.12: Fourier coefficients of the square wave 
%      Exercise 1.16: Playing the Fourier series of the triangle wave 
%      Exercise 1.22: Fourier series for polynomials 
%      Example 1.24: Complex Fourier coefficients of a simple function 
%      Example 1.25: Complex Fourier coefficients of composite function 
%      Example 1.35: Periodic extension 
%  Digital sound and Discrete Fourier analysis 
% 
% 
% 
%% Sound and Fourier series
% 
% 
% % --- begin exercise ---
% 
%% Example 1.1: Listen to different channels
% 
% % keywords = ipynb; m; fourierseries
% 
% 
% 
[x, fs] = audioread('sounds/castanets.wav');
% 
% Our audio sample file actually has two sound channels. 
% In such cases |x| is actually a matrix with two columns, and each column represents a sound channel. 
% To listen to each channel we can run the following code. 
% 
playerobj=audioplayer(x(:, 1), fs);
playblocking(playerobj);
% 
playerobj=audioplayer(x(:, 2), fs);
playblocking(playerobj);
% You may not hear a difference between the two channels. 
% There may still be differences, however, they may only be notable when the channels are sent to different loudspeakers. 
% 
% We will later apply different operations to sound. It is possible to apply these operations to the sound channels simultaneously, and we will mostly do this. 
% Sounds we generate on our own, such as pure tones, will mostly be generated in one channel.
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Example 1.2: Playing the sound backwards
% 
% % keywords = ipynb; m; fourierseries
% 
% At times a popular game has been to play music backwards to try and find secret messages. 
% In the old days of analog music on vinyl this was not so easy, but with digital sound it is quite simple; we just need to reverse the samples. 
% To do this we just loop through the array and put the last samples first.
% 
% Let $\bm{x}=(x_i)_{i=0}^{N-1}$ be the samples of a digital sound. Then the samples $\bm{y}=(y_i)_{i=0}^{N-1}$ of the reverse sound are given by
% 
% $$y_i=x_{N-i-1},\text{ for } i=0,1, \dots N-1.$$
% When we reverse the sound samples, we have to reverse the elements in both sound channels. 
% For our audio sample file this can be performed as follows.
% 
N = size(x, 1);
z = x(N:(-1):1, :);
playerobj = audioplayer(z, fs);
playblocking(playerobj);
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Example 1.3: Playing pure tones.
% 
% % keywords = ipynb; m; fourierseries
% 
% To create the samples of a pure tone we can write
% 
f = 440;
antsec = 3;
% 
t = linspace(0, antsec, fs*antsec);
x = sin(2*pi*f*t);
% Here |f| is the frequency, |antsec| the length in seconds, and |fs| the sampling rate. 
% 
% We can now listen to the samples as follows.
% 
playerobj = audioplayer(x, fs);
playblocking(playerobj);
% You should hear a pleasant sound with a very distinct frequency. 
% Most people can only perceive sounds in the range 20 - 20000 Hz: 
% You are encouraged to experiment here to see if your hearing matches this range.
% 
% 
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
%% Example 1.4: The square wave
% 
% % keywords = ipynb; m; fourierseries
% 
% There are many other ways in which a function can oscillate regularly. 
% The _square wave_ is one such, but we will see later that it can not be written as a simple, trigonometric function.
% Given a period $T$ we define the square wave to be $1$ on the first half of each period, and $-1$ on the second half:
% 
% $$f_s(t)=  \begin{cases} 1, & \text{if $0\leq t<T/2$}; \\   -1, & \text{if $T/2 \leq t<T$}. \end{cases}$$
% The square wave with the same period we used for the pure tone can be plotted as follows: 
% 
T=1/440;
t=linspace(0,T,100);
totransl=ones(1,100).*(-1).^(t>=T/2);
figure()
plot([t t+T t+2*T t+3*T t+4*T],repmat(totransl,1,5), 'k-')
% 
% Let us listen also listen to the square wave. We can first create the samples for one period.
% 
samplesperperiod=round(fs/f); % The number of samples for one period
oneperiod = [ones(1,round(samplesperperiod/2)) ...
-ones(1,round(samplesperperiod/2))];
% Then we repeat one period to obtain a sound with the desired length, and play it as follows. 
% 
x=repmat(oneperiod,1,antsec*f);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
% We hear a sound which seems to have the same "base frequency" as $\sin(2\pi 440 t)$,
% but the square wave is less pleasant to listen to: 
% There seems to be some "sharp corners" in the sound, translating into a rather shrieking, piercing sound. 
% We will later explain this by the fact that the square wave can be viewed as a sum of many frequencies, 
% and that many frequencies pollute the sound so that it is not pleasant to listen to.
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
%% Exercise 1.9: Playing with different sample rates
% 
% % keywords = ipynb; m; fourierseries
% 
% If we provide another samples rate |fs| to the |play| functions, 
% the sound card will assume a different time distance between neighboring samples. 
% Play and listen to the audio sample file again, but with three different sample rates: |2*fs|, |fs|, and |fs/2|, 
% where |fs| is the sample rate returned by |audioread|.
% 
% 
% % --- begin solution of exercise ---
% *Solution.* The following code can be used
% 
[x, fs] = audioread('sounds/castanets.wav');
% 
playerobj = audioplayer(x, fs);
playblocking(playerobj);
% 
playerobj = audioplayer(x, 2*fs);
playblocking(playerobj);
% 
playerobj = audioplayer(x, fs/2);
playblocking(playerobj);
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
%% Exercise 1.10: Play sound with added noise
% 
% % keywords = ipynb; m; fourierseries
% 
% To remove noise from recorded sound can be very challenging, but adding noise is simple. 
% There are many kinds of noise, but one kind is easily obtained by adding random numbers to the samples of a sound.
% For this we can use the function
% |rand| as follows.
%  z = x + c*(2*rand(size(x))-1);
% This adds noise to all channels. 
% The function for returning random numbers returns numbers between $0$ and $1$, 
% and above we have adjusted these so that they are between $-1$ and $1$ instead, as for other sound which can be played by the computer.  
% $c$ is a constant (usually smaller than 1) that dampens the noise. 
% 
% Write code which adds noise to the audio sample file, and listen to the result for damping constants |c=0.4| and |c=0.1|. 
% Remember to scale the sound values after you have added noise, since they may be outside $[-1,1]$ then.
% 
% 
% % --- begin solution of exercise ---
% *Solution.* The following code can be used. 
% 
c = 0.1;
% 
z = x + c*(2*rand(size(x))-1);
z = z/max(abs(z));
playerobj = audioplayer(z, fs);
playblocking(playerobj);
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
%% Exercise 1.11: Playing the triangle wave
% 
% % keywords = ipynb; m; fourierseries
% 
% Repeat what you did in Example 1.4, 
% but now for the triangle wave of Example 1.5. 
% Start by generating the samples for one period of the triangle wave, 
% then plot five periods, before you generate the sound over a period of three seconds, and play it.
% Verify that you generate the same sound as in Example 1.5.
% 
% 
% % --- begin solution of exercise ---
% *Solution.* The triangle wave can be plotted as follows: 
% 
totransl=1-4*abs(t-T/2)/T;
figure()
plot([t t+T t+2*T t+3*T t+4*T],repmat(totransl,1,5), 'k-')
% The samples for one period are created as follows.
% 
oneperiod=[linspace(-1,1,round(samplesperperiod/2)) ...
linspace(1,-1,round(samplesperperiod/2))];
x = zeros(1, antsec*f*length(oneperiod));
% Then we repeat one period to obtain a sound with the desired length, and play it as follows. 
% 
x=repmat(oneperiod,1,antsec*f);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
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
%% Example 1.12: Fourier coefficients of the square wave
% 
% % keywords = ipynb; m; fourierseries
% 
% Let us compute the Fourier coefficients of the square wave, 
% as defined by Equation (1.1) in Example 1.4. 
% If we first use Equation (1.8) we obtain
% 
% $$\begin{equation*} a_0=\frac{1}{T}\int_{0}^{T}f_s(t)dt=\frac{1}{T}\int_{0}^{T/2}dt-\frac{1}{T}\int_{T/2}^Tdt=0.\end{equation*}$$
% Using Equation (1.9) we get
% 
% $$\begin{align*} a_n &= \frac{2}{T}\int_0^T f_s(t) \cos(2\pi nt/T)dt \\      &= \frac{2}{T}\int_0^{T/2} \cos(2\pi nt/T)dt-\frac{2}{T}\int_{T/2}^T\cos(2\pi nt/T)dt \\      &= \frac{2}{T}\left[  \frac{T}{2\pi n}\sin(2\pi nt/T) \right]_0^{T/2} - \frac{2}{T}\left[ \frac{T}{2\pi n}\sin(2\pi nt/T) \right]_{T/2}^T \\      &= \frac{2}{T}\frac{T}{2\pi n}((\sin(n\pi)-\sin 0) - (\sin(2n\pi)-\sin(n\pi))=0. \end{align*}$$
% Finally, using Equation (1.10) we obtain
% 
% $$\begin{align*} b_n &= \frac{2}{T}\int_0^T f_s(t) \sin(2\pi nt/T)dt \\      &= \frac{2}{T}\int_0^{T/2} \sin(2\pi nt/T)dt-\frac{2}{T}\int_{T/2}^T\sin(2\pi nt/T)dt \\      &= \frac{2}{T}\left[ -\frac{T}{2\pi n}\cos(2\pi nt/T) \right]_0^{T/2} + \frac{2}{T}\left[ \frac{T}{2\pi n}\cos(2\pi nt/T) \right]_{T/2}^T \\      &= \frac{2}{T}\frac{T}{2\pi n}((-\cos(n\pi)+\cos 0) + (\cos(2n\pi)-\cos(n\pi))) \\      &= \frac{2(1-\cos(n\pi)}{n\pi}\\      & = \begin{cases} 0, & \text{if $n$ is even}; \\ 4/(n\pi), & \text{if $n$ is odd}.\end{cases} \end{align*}$$
% In other words, only the $b_n$-coefficients with $n$ odd in the Fourier series are nonzero. 
% This means that the Fourier series of the square wave is
% 
% $$\frac{4}{\pi}\sin(2\pi t/T) + \frac{4}{3\pi}\sin(2\pi 3t/T) + \frac{4}{5\pi}\sin(2\pi 5t/T) + \frac{4}{7\pi}\sin(2\pi 7t/T) + \cdots.$$
% With $N=20$, there are $10$ trigonometric terms in this sum. 
% The corresponding Fourier series can be plotted over one period with the following code.
% 
T=1/440;
t=linspace(0,T,100);
y=zeros(1,length(t));
for k=1:2:19
y = y + (4/(k*pi))*sin(2*pi*k*t/T);
end
plot(t,y)
% To see that the Fourier coefficients converge to 0, let us also plot the first $100$ values of $b_n$:
% 
k=1:2:101;
plot(k,4./(k*pi),'kx')
%  End fig:sq right
% Begin fig:sq right decorate
axis([0 101 0 1])
% 
% Even though $f$ oscillates regularly between $-1$ and $1$ with period $T$, 
% the discontinuities mean that it is far from the simple $\sin(2\pi t/T)$ 
% which corresponds to a pure tone of frequency $1/T$. 
% Clearly $b_1\sin(2\pi t/T)$ is the dominant term in the Fourier series. 
% This is not surprising since the square wave has the same period as this term, 
% but the additional terms in the Fourier series pollute the pure sound. 
% As we include more and more of these, we gradually approach the square wave.
% 
% There is a connection between how fast the Fourier coefficients go to zero, and how we perceive the sound. A pure sine sound has only one nonzero coefficient,
% while the square wave Fourier coefficients decrease as $1/n$, making the sound less pleasant. This explains what we heard when we listened to the sound in
% Example 1.4. Also, it explains why we heard the same pitch as the pure tone, since the first frequency in the Fourier series has the same
% frequency as the pure tone we listened to, and since this had the highest value. 
% 
% Let us listen to the Fourier series approximations of the square wave. 
% 
x = repmat(x, 1, antsec/T);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
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
%% Exercise 1.16: Playing the Fourier series of the triangle wave
% 
% % keywords = ipynb; m; fourierseries
% 
% 
% *a)* Plot the Fourier series of the triangle wave.
% 
% 
% % --- begin solution of exercise ---
% *Solution.* The following code can be used.
% 
t = linspace(0, T, 100);
x = zeros(1,length(t));
for k = 1:2:19
x = x - (8/(k*pi)^2)*cos(2*pi*k*t/T);
end
figure()
plot(t, x, 'k-')
% 
% % --- end solution of exercise ---
% 
% *b)* Write code so that you can listen to the Fourier series of the triangle wave.  
% How high must you choose $N$ for the Fourier series to be indistuingishable from the square/triangle waves themselves?
% 
% 
% % --- begin solution of exercise ---
% *Solution.* The following code can be used.
% 
x = repmat(x, 1, antsec/T);
playerobj=audioplayer(x, fs);
playblocking(playerobj);
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
%% Exercise 1.22: Fourier series for polynomials
% 
% % keywords = ipynb; m; fourierseries
% 
% Write down difference equations for finding the Fourier coefficients of $f(t)=t^{k+1}$ from those of $f(t)=t^k$, and write a program which uses this recursion. 
% Use the program to verify what you computed in Exercise 1.21.
% 
% 
% % --- begin solution of exercise ---
% *Solution.* Let us define $a_{n,k},b_{n,k}$ as the Fourier coefficients of $t^k$. When $k>0$ and $n>0$, integration by parts gives us the following difference equations:
% 
% $$\begin{align*} a_{n,k} &= \frac{2}{T} \int_0^T t^{k}\cos(2\pi nt/T)dt \\          &=\frac{2}{T}\left( \left[ \frac{T}{2\pi n} t^k\sin(2\pi nt/T) \right]_0^T - \frac{kT}{2\pi n}\int_0^T t^{k-1}\sin(2\pi nt/T)dt\right) \\          &=-\frac{kT}{2\pi n}b_{n,k-1} \\  b_{n,k} &= \frac{2}{T} \int_0^T t^{k}\sin(2\pi nt/T)dt \\          &=\frac{2}{T}\left( \left[ -\frac{T}{2\pi n} t^k\cos(2\pi nt/T) \right]_0^T + \frac{kT}{2\pi n}\int_0^T t^{k-1}\cos(2\pi nt/T)dt\right) \\          &= -\frac{T^k}{\pi n} +  \frac{kT}{2\pi n}a_{n,k-1}. \end{align*}$$
% When $n>0$, these can be used to express $a_{n,k},b_{n,k}$ in terms of $a_{n,0},b_{n,0}$, for which we clearly have $a_{n,0}=b_{n,0}=0$. 
% For $n=0$ we have that $a_{0,k}=\frac{T^k}{k+1}$ for all $k$. The following program computes $a_{n,k},b_{n,k}$ recursively when $n>0$. 
% 
function [ank,bnk] = findfouriercoeffs(n, k, T)
ank=0; bnk=0;
if k > 0
[ankprev,bnkprev] = findfouriercoeffs(n, k-1, T)
ank = -k*T*bnkprev/(2*pi*n);
bnk = -T^k/(pi*n) + k*T*ankprev/(2*pi*n);
end
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
%% Example 1.24: Complex Fourier coefficients of a simple function
% 
% % keywords = ipynb; m; fourierseries
% 
% Let us consider the pure sound $f(t)=e^{2\pi it/T_2}$ with period $T_2$, but let us consider it only on the interval $[0,T]$ instead, where $T<T_2$. 
% Note that this $f$ is not periodic, since we only consider the part $[0,T]$ of the period $[0,T_2]$. The Fourier coefficients are
% 
% $$\begin{align*} y_n &= \frac{1}{T}\int_0^T e^{2\pi it/T_2}e^{-2\pi int/T}dt = \frac{1}{2\pi iT(1/T_2-n/T)} \left[ e^{2\pi it(1/T_2-n/T)}\right]_0^T \\  &= \frac{1}{2\pi i(T/T_2-n)}\left( e^{2\pi iT/T_2} - 1 \right). \end{align*}$$
% Here it is only the term $1/(T/T_2-n)$ which depends on $n$, so that $y_n$ can only be large when $n$ is close $T/T_2$. 
% let us plot $|y_n|$ for two different combinations of $T,T_2$. First for $T/T_2=0.5$, 
% 
n=1:20;
T=0.5;
T2=1;
figure()
plot( n, abs(( exp(2*pi*i*T/T2) - 1 )./(2*pi*i*(T/T2-n))) ,'k-')
% then for $T/T_2=0.9$.
% 
T=0.9;
T2=1;
figure()
plot( n, abs(( exp(2*pi*i*T/T2) - 1 )./(2*pi*i*(T/T2-n))) ,'k-')
% 
% In both examples it is seen that many Fourier coefficients contribute, but this is more visible when $T/T_2=0.5$. When $T/T_2=0.9$, most contribution is seen to be
% in the $y_1$-coefficient. This sounds reasonable, since $f$ then is closest to the pure tone $f(t)=e^{2\pi it/T}$ of frequency $1/T$ (which in turn has $y_1=1$
% and all other $y_n=0$).
% 
% Apart from computing complex Fourier series, there is an important lesson to be learned from this example: In order for a periodic function to be
% approximated by other periodic functions, their period must somehow match.
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Example 1.25: Complex Fourier coefficients of composite function
% 
% % keywords = ipynb; m; fourierseries
% 
% What often is the case is that a sound changes in content over time. Assume that it is equal to a pure tone of frequency $n_1/T$ on $[0,T/2)$, and equal to a pure
% tone of frequency $n_2/T$ on $[T/2,T)$, i.e.
% 
% $$\begin{equation*} f(t) = \begin{cases} e^{2\pi in_1t/T} & \text{on } [0,T_2] \\ e^{2\pi in_2t/T} & \text{ on} [T_2,T) \end{cases}. \end{equation*}$$
%  When $n\neq n_1,n_2$ we have that
% 
% $$\begin{align*} y_n &= \frac{1}{T} \left( \int_0^{T/2} e^{2\pi in_1t/T}e^{-2\pi int/T}dt + \int_{T/2}^T e^{2\pi in_2t/T}e^{-2\pi int/T}dt \right) \\  &= \frac{1}{T}\left( \left[ \frac{T}{2\pi i(n_1-n)}e^{2\pi i(n_1-n)t/T} \right]_0^{T/2}                     + \left[ \frac{T}{2\pi i(n_2-n)}e^{2\pi i(n_2-n)t/T} \right]_{T/2}^T \right) \\  &= \frac{e^{\pi i(n_1-n)}-1}{2\pi i(n_1-n)} + \frac{1-e^{\pi i(n_2-n)}}{2\pi i(n_2-n)}.  \end{align*}$$
% Let us restrict to the case when $n_1$ and $n_2$ are both even. We see that
% 
% $$\begin{equation*} y_n = \begin{cases}           \frac{1}{2}+\frac{1}{\pi i(n_2-n_1)} & n=n_1,n_2\\           0                                    & n\text{ even }, n\neq n_1,n_2\\           \frac{n_1-n_2}{\pi i(n_1-n)(n_2-n)}  & n\text{ odd }       \end{cases} \end{equation*}$$
% Here we have computed the cases $n=n_1$ and $n=n_2$ as above. 
% Let us plot $|y_n|$ in two cases: First for $n_1=10$, $n_2=12$,
% 
lt=39;
n1=10 ;
n2=12;
yn=zeros(lt,1);
yn(n1)=abs(1/2+1/(pi*i*(n2-n1)));
yn(n2)=yn(n1);
nvals=1:2:lt;
yn(nvals)=abs((n1-n2)./(pi*i*(n1-nvals).*(n2-nvals)));
figure()
plot(1:lt,yn,'k-')
% then for $n_1=2$, $n_2=20$.
% 
n1=2;
n2=20;
yn=zeros(lt,1);
yn(n1)=abs(1/2+1/(pi*i*(n2-n1)));
yn(n2)=yn(n1);
nvals=1:2:lt;
yn(nvals)=abs((n1-n2)./(pi*i*(n1-nvals).*(n2-nvals)));
figure()
plot(1:lt,yn,'k-')
% 
% We see that, when $n_1,n_2$ are close, the Fourier coefficients are close to those of a pure tone with $n\approx n_1,n_2$, but that also other
% frequencies contribute. When $n_1,n_2$ are further apart, we see that the Fourier coefficients are like the sum of the two base frequencies, but that other
% frequencies contribute also here.
% 
% 
% 
% 
% 
% 
% 
% There is an important lesson to be learned from this as well: We should be aware of changes in a sound over time, and it may not be smart to use a
% frequency representation over a large interval when we know that there are simpler frequency representations on the smaller intervals. The following example shows
% that, in some cases it is not necessary to compute the Fourier integrals at all, in order to compute the Fourier series.
% 
% % --- end exercise ---
% 
% 
% 
% 
% % --- begin exercise ---
% 
%% Example 1.35: Periodic extension
% 
% % keywords = ipynb; m; fourierseries
% 
% Let $f$ be the function with period $T$ defined by $f(t)=2t/T-1$ for $0\leq t<T$. 
% In each period the function increases linearly from $-1$ to $1$. Because $f$ is discontinuous at the boundaries, we would expect the Fourier
% series to converge slowly. The Fourier series is a sine-series since $f$ is antisymmetric, and we can compute $b_n$ as
% 
% $$\begin{align*}   b_n &= \frac{2}{T}\int_0^T \frac{2}{T}\left(t-\frac{T}{2}\right)\sin(2\pi nt/T)dt = \frac{4}{T^2}\int_0^{T} \left(t-\frac{T}{2}\right)\sin(2\pi nt/T)dt \\        &= \frac{4}{T^2}\int_0^{T} t\sin(2\pi nt/T)dt - \frac{2}{T}\int_0^{T} \sin(2\pi nt/T)dt = -\frac{2}{\pi n}, \end{align*}$$
% so that
% 
% $$\begin{equation*} f_N(t) = - \sum_{n=1}^N \frac{2}{n\pi}\sin(2\pi nt/T),\end{equation*}$$
% which indeed converges slowly to $0$. Let us now instead consider the symmetric extension of $f$. Clearly this is the triangle wave with period $2T$, and the Fourier series of this was
% 
% $$\begin{equation*} (\breve{f})_N(t) = -\sum_{n\leq N\text{, $n$ odd}} \frac{8}{n^2\pi^2}\cos(2\pi nt/(2T)). \end{equation*}$$
% The second series clearly converges faster than the first, since its Fourier coefficients are $a_n=-8/(n^2\pi^2)$ (with $n$ odd), while the Fourier coefficients in the first
% series are $b_n=-2/(n\pi)$. 
% 
% If we use $T=1/440$, the symmetric extension has period $1/220$, which gives a triangle wave where the first term in the Fourier series has frequency 220Hz. 
% Listening to this we should hear something resembling a 220Hz pure tone, since the first term in the Fourier series is the most dominating in the triangle wave.
% Listening to the periodic extension we should hear a different sound. The first term in the Fourier series has frequency 440Hz, but this drounds a bit in the contribution of the other terms in the
% Fourier series, due to the slow convergence of the Fourier series, just as for the square wave.
% 
% Let us plot the Fourier series with $N=7$ terms for $f$. 
% First we do this for the periodic extension of $f$. 
% 
N = 7;
T = 1/440;
t = linspace(0, 4*T, 400);
y=zeros(1,400);
for n=1:7
y = y - (2/(n*pi))*sin(2*pi*n*t/T);
end
figure()
plot(t, y, 'k-')
% Then we do this for the symmetric extension of $f$.
% 
figure()
y=zeros(1,400);
for n = 1:2:N
y = y - 8*cos(2*pi*n*t/(2*T))/( n^2 * pi^2);
end
plot(t, y, 'k-')
% 
% It is clear from the plot that the Fourier series for $f$ itself is
% not a very good approximation, while we cannot differentiate between the Fourier series and the function itself for the symmetric extension.
% 
% % --- end exercise ---
% 
% 
%% Digital sound and Discrete Fourier analysis

