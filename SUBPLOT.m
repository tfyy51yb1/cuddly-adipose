y1 = percentages;
y2 = grade_wrong;
y3 = stack;

figure
subplot(3,5,[1 2 3 6 7 8])
pie3(y1)
legend('correct','smaller','higher')
colormap(summer)

subplot(3,5,[4 5 9 10])
hist(y2)
xlabel('Diff from correct value')
ylabel('amount')

subplot(3,5,[11 12 13 14 15])
bar(y3)
xlabel('Actual Grade')
ylabel('Grade')
set(gca,'Xticklabel',{'G0', 'G1', 'G2', 'G3', 'G4'});