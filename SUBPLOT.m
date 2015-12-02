%SUBPLOT.m
%This module creates a figure-window and displays different graphs 
%that are used as relevant statistics for the main program. 
%This includes a graph that shows the distribution, a graph for displaying
%the difference between the classified and actual grades, and a graph for
%displaying the votes.
%The subplot module retrieves its data from the following functions:
%percentages, grade_wrong and votes.
%Josef Hammar, Marcus Grip, 2015

y1 = percentages;
y2 = grade_wrong;
% y3 = stack;
[A, B] = votes;



figure
subplot(5,5,[1 2 3 6 7 8])
pie3(y1)
legend('correct','smaller','higher')
colormap(summer)

subplot(5,5,[4 5 9 10])
hist(y2)
xlabel('Diff from correct value')
ylabel('amount')


% subplot(5,5,[11 12 13 14 15])
% bar(y3)
% xlabel('Actual Grade')
% ylabel('Grade')
% set(gca,'Xticklabel',{'G0', 'G1', 'G2', 'G3', 'G4'});


subplot(5,5,[16 17 18 19 20 21 22 23 24 25]) 
plot(A, 'color', 'r'); hold on;
bar(B, 'grouped')
xlabel('Image')
ylabel('Voted grades')
