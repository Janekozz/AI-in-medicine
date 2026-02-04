% Patient data
Age = [25
45
35
50
40
60
29
34
41
55
48
42
38
46
52
53
49
37
44
30
56
54
33
47
31
62
27
51
59
57];

BMI = [22.5
28.7
24.2
29.1
27.8
31.2
23.1
25.6
26.9
30
28
27.5
25
29.5
31
30.5
28.8
24.7
27.9
23.6
32.1
30.3
26.5
29.7
24.9
31.3
22.9
28.4
29.2
30.1];

SBP = [85
95
90
105
100
110
88
92
98
108
99
101
93
107
113
106
94
89
102
84
112
109
91
104
87
115
86
103
111
114];

y = [0
1
0
1
1
1
0
0
1
1
1
1
0
1
1
1
1
0
1
0
1
1
0
1
0
1
0
1
1
1];

% Conbine into matrix
X = [Age BMI SBP];

% Train KNN
Mdl = fitcknn(X,y,'NumNeighbors',5,'Standardize',1);

% Cross-validation accuracy
acc = 1 - kfoldLoss(crossval(Mdl,'Kfold',5));
fprintf('Cross-validated accuracy: %.2f%%\n', acc*100);

% Example prediction: Age=44 BMI=24.4 SBP=90
newPatient = [44 24.4 90];
pred = predict(Mdl,newPatient);

fprintf('Prediction for patient [Age=%d, BMI=%.1f, SBP=%d]: %d\n', ...
    newPatient(1), newPatient(2), newPatient(3), pred);

