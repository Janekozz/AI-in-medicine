% Load data
D = readmatrix("GCL.csv");

% Separate columns automatically
X = D(:, 1:end-1);
y = D(:, end);

% Split 70/30
cv = cvpartition(size(X, 1), 'HoldOut', 0.3);
tr = training(cv); te = test(cv);

% Standartdize
X = zscore(X);

% KNN with k=3
m3 = fitcknn(X(tr,:), y(tr),"NumNeighbors", 3);
p3 = predict(m3, X(te,:));
C3 = confusionmat(y(te),p3);
acc = trace(C3)/sum(C3,"all");
sens = C3(2,2)/sum(C3(2,:));
spec = C3(1,1)/sum(C3(1,:));
fprintf("k=3 | Acc=%.3f Sens=%.3f Spec=%.3f\n",acc, sens, spec);

% KNN with k=5
m5 = fitcknn(X(tr,:), y(tr),"NumNeighbors", 5);
p5 = predict(m5, X(te,:));
C5 = confusionmat(y(te),p5);
acc = trace(C5)/sum(C5,"all");
sens = C5(2,2)/sum(C5(2,:));
spec = C5(1,1)/sum(C5(1,:));
fprintf("k=5 | Acc=%.3f Sens=%.3f Spec=%.3f\n",acc, sens, spec);

