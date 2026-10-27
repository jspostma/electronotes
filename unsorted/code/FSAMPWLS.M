function h = fsampwls(N,M,f,a,w)
%    function h = fsampwls(N,M,f,a,w)
%
%         Frequency Sampling with Weighted Least Squares
%
%                 (MATLAB filter input format)
%    N = length
%    M = number of freq. samples
%    f = frequency vector on 0-1 with 1 = half the sampling freq.
%    a = amplitude vector
%    w = weights 
%
%    Example:  h=fsampwls(21,41,[0 .3 .3 1],[1 1 0 0],[1 100])
%
%    [ Note: M must be greater than N for the weighting to
%      work.  If M=N then the error is minimized to exactly
%      zero for any choice of weighting. ]
%
%    B. Hutchins            Fall 1995, Fall 2006
%           fixed Fall 2006 for N even, M odd case
%

i=0:M-1;
wi=2*pi*i/M;
%-------------------generate phase-----------------
ph=exp(-j*wi*(N-1)/2);  % use as is for N odd
if mod(N,2)==0;  %if N is even
    
    if mod(M,2)==0; % if M is even
       ps=[ones(1,M/2) -ones(1,M/2)];
    end
    
    if mod(M,2)==1; % if M is odd
       ps=[ones(1,(M+1)/2) -ones(1,(M+1)/2-1)];
    end  
    
 ph=ph.*ps;  
end

%----generate default amplitude and weight vectors--------
for n=1:M
       if wi(n) < f(2)*pi; mask(n)=a(2);ww(n)=w(1);
          elseif wi(n) > (2*pi-f(2)*pi); mask(n)=a(2);ww(n)=w(1);
          else mask(n)=a(3);ww(n)=w(2);
       end
end
mask;
H=mask.*ph;
ww=diag(ww); 

%----------------------------------------------------
k=0:N-1;
arg=-j*(wi'*k);
E=exp(arg);

h=(inv(E'*ww*E))*(E'*ww*H.');
h=real(h);

figure(1);
stem(k,h) 
MH=abs(freqz(h,1,500));
MH=MH/MH(1);
figure(2);
plot([0:.001:.499],MH)
grid
 
db=20*log10(MH);
figure(3)
plot([0:.001:.499],db)
axis([-.05 .55 -50 10]);
grid
figure(3) 
 


