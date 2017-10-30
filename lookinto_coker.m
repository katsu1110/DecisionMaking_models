function lookinto_coker

% contrast
len_frame = 1050;
offset = 100;
co = 1*[zeros(1,offset),ones(1,len_frame),zeros(1,offset)];

%%
% alpha function as a stimulus kernel
tmax = 400;
tau = tmax/10;
t = 0:tmax;
kernel = exp(-t/tau).*(1 - exp(-t/tau));
hn_offset = [ones(1,round(t(end)/3))*0.025, 0.025:-0.025/(round(t(end)*2/3)):0]; % manually tweaked to approximate that in Yates
kernel = kernel - 1.5*hn_offset;
kernel(1:4) = 0;
kernel = 0.01*kernel/max(kernel);

%% visualize
close all;
figure;
lenv = len_frame + 2*offset;
time = [1:lenv] - offset;

% kernel
subplot(2,3,1)
plot(t, kernel)
hold on;
plot(t, 0.5*kernel)
xlim([t(1) t(end)])
ylabel('kernel')

% original & convolved shape
subplot(2,3,2)
plot(time, co)
hold on;
c = conv(kernel, co);
plot(time, c(1:lenv))
hold on;
c2 = conv(0.5*kernel, co);
plot(time, c2(1:lenv))
xlim([time(1) time(end)])
ylabel('original & convolved')
plot_binline;

% nonlinearity
subplot(2,3,3)
fr = exp(c(1:lenv));
plot(time, fr)
hold on;
fr2 = exp(c2(1:lenv));
plot(time, fr2)
xlim([time(1) time(end)])
ylabel('nonlinearity')
plot_binline;

% cumsum
subplot(2,3,4)
cms = cumsum(fr,2);
plot(time, cms)
hold on;
cms2 = cumsum(fr2, 2);
plot(time, cms2)
xlim([time(1) time(end)])
ylabel('cumsum')
plot_binline;

% diff
subplot(2,3,5)
d = cms - cms2;
plot(time, d)
hold on;
xlim([time(1) time(end)])
ylabel('diff cumsum')
plot_binline;

% diff cumsum
subplot(2,3,6)
slope = zeros(1, 7);
begin = 101;
for i = 1:7
    slope(i) = (d(begin+150) - d(begin))/150;
    begin = begin + 150;
end
plot(1:7, slope, 'o')
xlim([0.5 7.5])
ylabel('slope of cumsum')



% bin range
function plot_binline
yy = get(gca, 'YLim');
begin = 1;
for i = 1:8
    hold on;
    plot(begin*[1 1], yy, '-g')
    begin = begin + 150;
end
ylim(yy)