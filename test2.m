y1 = percentages;
y2 = grade_wrong;
y3 = [G0; G1; G2; G3; G4];

figure
subplot(3,1,1)
pie3(y1)
legend('correct','smaller','higher')


subplot(3,1,2)
hist(y2)


subplot(3,1,3)
bar(y3)
xlabel('ActualGrade')
ylabel('Grade')
set(gca,'Xticklabel',{'G0', 'G1', 'G2', 'G3', 'G4'});