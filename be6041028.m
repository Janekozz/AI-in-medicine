% ==== Decision Tree on GCL.csv (accuracy, sensitivity, specificity) ====
% Jane Kozz – BE 604 / DT assignment
% Example AI prompt used: "Write MATLAB to train a decision tree on GCL.csv with
% features A..AA and labels AB; report accuracy, sensitivity, specificity and plot
% confusion matrix."

% Features: columns A..AA -> 1..27
% Labels: column AB -> 28 (values observed: 0,1,2)
% We report: overall accuracy + per-class sensitivity/specificity (one-vs-rest)
% For Q4 it's show the confusion matrix for max_depth=100.

clear; clc; close all;

%% 1) Load data
T = readtable('GCL.csv','TextType','string');
X = T{:,1:27};
y = categorical(T{:,28}); % robust for numeric or text labels

% --- OPTIONAL: For binary metrics on 0/1 only:
% T = T(T{:,28}==0 | T{:,28}==1,:); X = T{:,1:27}; y = categorical(T{:,28});

classes = categories(y);

%% 2) Train/test split (80/20 holdout)
rng(7);
cv = cvpartition(y,'HoldOut',0.2);
Xtr = X(training(cv),:); ytr = y(training(cv),:);
Xte = X(test(cv),:); yte = y(test(cv),:);

%% Helper: convert "max_depth" to MATLAB MaxNumSplits
maxSplitsFromDepth = @(d,n) min(2^d - 1, n - 1);

%% ---- Q3: max_depth = 50 ----
depth = 50;
ms = maxSplitsFromDepth(depth, size(Xtr,1));
tree50 = fitctree(Xtr, ytr, 'MaxNumSplits', ms, 'SplitCriterion','gdi');
yhat50 = predict(tree50, Xte);

% Overall accuracy
acc50 = mean(yhat50 == yte);

% Per-class sensitivity/specificity (one-vs-rest)
metrics = table('Size',[numel(classes) 3],...
'VariableTypes',["string","double","double"],...
'VariableNames',["Class","Sensitivity","Specificity"]);
for k = 1:numel(classes)
pos = classes{k};
y_true_bin = (yte == pos);
y_pred_bin = (yhat50 == pos);
TP = sum(y_true_bin & y_pred_bin);
TN = sum(~y_true_bin & ~y_pred_bin);
FP = sum(~y_true_bin & y_pred_bin);
FN = sum(y_true_bin & ~y_pred_bin);
sens = TP / max(1,(TP+FN)); % recall
spec = TN / max(1,(TN+FP));
metrics.Class(k) = string(pos);
metrics.Sensitivity(k) = sens;
metrics.Specficity(k) = spec;
end

fprintf('\n=== Q3 (max_depth = %d) ===\n', depth);
fprintf('Overall Accuracy: %.3f\n', acc50);
disp('Per-class Sensitivity/Specificity (one-vs-rest):');
disp(metrics);

%% ---- Q4: max_depth = 100 (confusion matrix) ----
depth = 100;
ms = maxSplitsFromDepth(depth, size(Xtr,1));
tree100 = fitctree(Xtr, ytr, 'MaxNumSplits', ms, 'SplitCriterion','gdi');
yhat100 = predict(tree100, Xte);

C = confusionmat(yte, yhat100, 'Order', categorical(classes, classes)); % rows=true, cols=pred

fprintf('\n=== Q4 (max_depth = %d) ===\n', depth);
disp('Confusion matrix [rows=true, cols=pred]:');
disp(array2table(C, 'VariableNames',"pred_"+classes, 'RowNames',"true_"+classes));

figure;
confusionchart(yte, yhat100, 'Title', 'Confusion Matrix (max\_depth = 100)', ...
'RowSummary','row-normalized','ColumnSummary','column-normalized');
