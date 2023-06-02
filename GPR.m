clc;clear;close all;
%data process
data1 = readcell('sap_sorted_and_converted.csv');
stock1 = cell2mat(data1(:,2));

% 把2016-1-4到2023-4-28的数据作为训练集
trainX = (1722:1843)';
trainY = stock1(1722:1843);

%把2023-5-1到2023-5-31的数据作为测试集
testX = (1843:1865)';
testYreal = stock1(1843:1865);

% 高斯过程回归的训练
%gpr model
gprMdl = fitrgp(trainX, trainY, ...
    'KernelFunction','matern32','BasisFunction','pureQuadratic',...
    'FitMethod','sr','PredictMethod','fic', ...
    'Standardize',true,'ComputationMethod','v', ...
    'ActiveSetMethod','likelihood','Optimizer','quasinewton', ...
    'OptimizeHyperparameters','auto');
[testYpd,~,limit] = predict(gprMdl,testX);
Lower=limit(:,1);
Upper=limit(:,2);%testYpd预测值，limit为上限和下限
%计算误差
erravg=sum(abs(testYpd-testYreal)./testYreal)/length(testYreal);
disp('平均绝对误差为');disp(erravg);
% 计算测试集实际值在上下限的概率
y3=(testYreal-Lower>0)&(Upper-testYreal>0);
errarea=sum(y3)/length(y3);
disp('实际值在预测上下限区间的概率为');disp(errarea);
%作图
figure;
plot(trainX,trainY,'b');xlabel('时间/天');ylabel('收盘价格/美元')
hold on;
plot(testX,testYreal,'b');
plot(testX,testYpd,'m');
fill([testX;flipud(testX)], [Lower;flipud(Upper)],[0.93333, 0.83529, 0.82353],'edgealpha', '0', 'facealpha', '.5');
legend('train','testreal','testpd','uncertainty');