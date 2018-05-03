function results = SDT_confidence(stmdist, noise)
%% simulation of the signatures of decision confidence
% INPUT: 
% stmdist ... type of stimulus distribution: 
% 'uniform', 'Gaussian'
% noise ... internal noise: default is 22.8
%
% written by Katsuhisa (03.05.18)
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

close all;

% deal with inputs
if nargin < 1; stmdist = 'uniform'; end
if nargin < 2; noise = 22.8; end

% evidence strength
dc = 0:0.5:50;

% stimulus distribution
switch stmdist
    case 'uniform'
        lendc = length(dc);
        weights = ones(1, lendc)/lendc;
    case 'Gaussian'
        weights = gaussmf(dc,[10 25]);
        weights = weights/sum(weights);
end

% signed stimulus
ss = sort(unique([-dc dc]));
sw = [weights weights];
sw(length(weights)) = [];

% ratio of the number of trials in each evidence
ntr = 10^5;

% assign dv
stm = datasample(ss, ntr, 'Weights', sw);

% noisy measurements
dv = arrayfun(@(x) normrnd(x, noise), stm);

% choice
ch = sign(dv);

% confidence
cf = abs(dv);

% accuracy
acc = 1*(ch==sign(stm));

figure;
plot(cf,acc, '.')

% 
% % generate trial-by-trial DV =================
% paramat = zeros(alltr, nst+4);
% begin = 1;
% for s = 1:length(ss)
%     tr = otr*ntr(s);
% 
%     % signed signal strength
%     sig = ss(s)*ones(tr,1);
%     sig(sig==0) = datasample([-1 1],1);
% 
%     % decision variable
%     dvvec = normrnd(ss(s), noise, [tr, nst]);
% %             dv = cumsum(dvvec,2);
% 
%     % choice
%     ch = sign(mean(dvvec,2) - c.*ones(tr,1));
%     ch(ch==0) = datasample([-1 1], 1);
% 
%     % accuracy
%     acc = zeros(tr, 1);
%     acc(sign(ch)==sign(sig)) = 1;
% 
%     % confidence
%     conf = errorfunc(abs(mean(dvvec,2)) - c.*(ones(tr,1)), noise);
% 
%     % insert into matrix    
%     paramat(begin:begin+tr-1, :) = [sig ch acc conf dvvec];
% 
%     begin = begin + tr;
% end
% 
% % % confidence
% % percept = cumsum(abs(paramat(:,5:end)),2);
% % percept = percept(:,end);
% % acc = paramat(:,3);
% % [~,si] = sort(percept);
% % sorted_acc = acc(si);
% % binsize = 100;
% % frameperbin = floor(alltr/binsize);
% % begin = 1;
% % conf = zeros(size(percept));
% % for b = 1:binsize
% %     acc = sorted_acc(begin:begin+frameperbin-1);
% %     acc_conf = length(find(acc==1))/length(acc);
% %     conf(si >= begin & si < begin+frameperbin) = acc_conf;
% %     begin = begin + frameperbin;
% % end
% % paramat(:,4) = conf;
% 
% % % shuffle trials
% % seed = 1220;
% % rng(seed);
% % paramat = paramat(randperm(alltr),:);
% 
% % loop to find signatures of confidence
% cf_ev = nan(2, length(dc));
% pc_ev = nan(2, length(dc));
% dv_cf = zeros(2, nst);
% for d = 1:length(dc)
%     % confidence in the given evidence
%     sig = paramat(:,1);
%     conf = paramat(:, 4);
%     acc = paramat(:, 3);
%     med = median(conf(abs(sig)==dc(d)));
% 
%     pc_ev(2,d) = 100*length(find(acc==1 & abs(sig)==dc(d) & conf >= med))...
%         /length(find(abs(sig)==dc(d) & conf >= med));
%     pc_ev(1,d) = 100*length(find(acc==1 & abs(sig)==dc(d) & conf < med))...
%         /length(find(abs(sig)==dc(d) & conf < med));
% 
%     % correct and error
%     cf_ev(2,d) = mean(conf(acc==1 & abs(sig)==dc(d)));
%     cf_ev(1,d) = mean(conf(acc==0 & abs(sig)==dc(d)));
% 
%     % dv vs confidence
%     dvsl = mean(cumsum(abs(paramat(abs(sig)==dc(d) & conf < med, 5:end)),2),1)...
%         *sum(otr*ntr(abs(ss)==dc(d)));
%     dvsh = mean(cumsum(abs(paramat(abs(sig)==dc(d) & conf >= med, 5:end)),2),1)...
%         *sum(otr*ntr(abs(ss)==dc(d)));
%     dv_cf(1,:) = dv_cf(1,:) + dvsl;
%     dv_cf(2,:) = dv_cf(2,:) + dvsh;
% end
% 
% % percent correct vs confidence
% binsize = 20;
% pc_cf = nan(1, binsize);
% conf = paramat(:,4);
% acc = paramat(:,3);
% 
% [sorted_conf, si] = sort(conf);
% sorted_acc = acc(si);
% frameperbin = floor(alltr/binsize);
% cfx = pc_cf;
% begin = 1;
% for b = 1:binsize
%     cfx(b) = mean(sorted_conf(begin:begin+frameperbin-1));
%     vec = sorted_acc(begin:begin+frameperbin-1);
%     pc_cf(b) = sum(vec==1)/length(vec);
% 
%     begin = begin + frameperbin;
% end
% % else
% %         paramat = 0;
% %         binsize = 100;
% %         pc_cf = linspace(50,100,binsize);
% %         dc = linspace(0.01, 0.49, 20);
% %         cf_ev = zeros(2,100);
% %         cf_ev(1,:) = ;
% %         cf_ev(2,:) = ;
% %         pc_ev = zeros(2,100);
% %         pc_ev(1,:) = cumsum(sort(ones(1,100) - wblrnd(linspace(0,1,100),1)));
% %         pc_ev(2,:) = ;
% %         dv_cf = zeros(2,100);
% %         dv_cf(1,:) = 1:100;
% %         dv_cf(2,:) = 1:100 + 1:100/100;
% %         
% end
%     
% figure;
% % yellow and green
% y = [0.9576    0.7285    0.2285];
% g = [0.1059    0.4706    0.2157];
% plot(cfx, pc_cf, '-k', 'linewidth', 2)
% set(gca, 'box', 'off')
% xlim([50 100])
% xlabel('confidence')
% ylabel('accuracy (%)')
% subplot(2,2,2)
% % plot(dc, cf_ev(1,:), '-','color',y,'linewidth',1)
% % hold on;
% % plot(dc, cf_ev(2,:), '-','color',g,'linewidth',1)
% plot(1:length(dc), cf_ev(1,:), '-','color',0.6*ones(1,3),'linewidth',2)
% hold on;
% plot(1:length(dc), cf_ev(2,:), '-','color',zeros(1,3),'linewidth',2)
% set(gca, 'box', 'off')
% % xlim([min(dc)-0.03 max(dc)+0.03])
% ylabel('confidence')
% xlabel('evidence')
% legend('error', 'correct','location','southwest')
% legend('boxoff')
% subplot(2,2,3)
% % plot(dc, pc_ev(1,:), '-','color',g,'linewidth',1)
% % hold on;
% % plot(dc, pc_ev(2,:),'-','color',y,'linewidth',1)
% plot(1:length(dc), pc_ev(1,:), '-','color',g,'linewidth',2)
% hold on;
% plot(1:length(dc), pc_ev(2,:),'-','color',y,'linewidth',2)
% % xlim([min(dc)-0.03 max(dc)+0.03])
% set(gca, 'box', 'off')
% ylabel('accuracy (%)')
% xlabel('evidence')
% legend('low conf.','high conf.','location','southeast')
% legend('boxoff')
% subplot(2,2,4)
% divide = mean(dv_cf(:));
% plot(1:nst, dv_cf(1,:)/divide, '-','color',g)
% hold on;
% plot(1:nst, dv_cf(2,:)/divide, '-','color',y)
% xlim([0.5 nst+0.5]) 
% xlabel('frames')
% ylabel('abs DV')
% set(gca,'box','off')
% set(gcf, 'position', [807.0000  201.6667  462.6667  425.3333])
% 
% % output
% % para.mat = paramat;
% para.pc_cf = pc_cf;
% para.cf_ev = cf_ev;
% para.pc_ev = pc_ev;
% para.dv_cf = dv_cf;
% 
% function f = errorfunc(x, noise)
% f = 50*(ones(size(x)) + erf(x/(noise*sqrt(2))));