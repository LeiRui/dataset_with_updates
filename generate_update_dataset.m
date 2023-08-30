clear all;close all;clc
format long g
filename = 'D:\desktop\d1.xlsx';
sheet = 1;
data = xlsread(filename,sheet);
arrivalTime=data(:,1);
sendTime=data(:,12);
durationMetric=data(:,17);
%figure,plot(arrivalTime(1:100),sendTime(1:100))

% make some observations
a=diff(arrivalTime);
median(a); % 41ms
b=diff(sendTime);
median(b); % 58ms

% set continuous query parameters
step=10*50; % 500ms
k_factor=4;
lookBack=k_factor*step;% so most of the groups will be computed k_factor times. now()-2s ~ now()
group=step;% 500ms

startRightEnd=arrivalTime(40);
res_t=[];
res_v=[];
i=1;
while true
    x2=startRightEnd+(i-1)*step;
    if x2>arrivalTime(end)
        break
    end
    x1=x2-lookBack;
    sumRes=zeros(1,k_factor);
    cntRes=zeros(1,k_factor);
    for j=1:1:length(arrivalTime)
        % find all points with arrivalTime smaller than x2
        if arrivalTime(j)>=x2
            break
        end
        % group points by their sendTime
        for k=1:1:k_factor 
            tmp1=x1+(k-1)*group;
            tmp2=x1+k*group;
            if sendTime(j)>=tmp1 && sendTime(j)<tmp2
                sumRes(k)=sumRes(k)+durationMetric(j);
                cntRes(k)=cntRes(k)+1;
            end
        end
    end
    % record results for this moment
    for k=1:1:k_factor
        tmp1=x1+(k-1)*group;
        res_t=[res_t;tmp1];
        res_v=[res_v;sumRes(k)/cntRes(k)];
    end
    i=i+1;
end
scatter(res_t,res_v,'MarkerFaceColor','r','MarkerEdgeColor','r',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)
xlabel('t')
ylabel('v')
%saveas(gcf,'D:\desktop\scatter_plot_showing_updates.png')

M=[res_t,res_v];
fid = fopen('D:\desktop\result.csv','wt');
fprintf(fid, '%s,%s\n', 'Time','Value');  % header
dlmwrite('D:\desktop\result.csv',M,'precision',20)
fclose(fid);