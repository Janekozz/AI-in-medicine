% Team Assignment #4. Part 1
% Jane Kozz, Tracy Robinson, and Brandon Scott
% Prints each team member's name and favorite movie/TV show
team = {
'Jane Kozz', 'Prison Break';
'Tracy Robinson', 'Legally Blonde';
'Brandon Scott', 'Breaking Bad'
};
for k = 1:size(team,1)
name = team{k,1};
fav = team{k,2};
fprintf('My name is %s. %s is one of my favorite movies/TV shows.\n', name, fav);
end