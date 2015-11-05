% This is a test of a dummy database initialisation, insertion and matching
% Note that the inclusion of refspectra and pars in the database struct is
% just to make it simpler to store them. The only fields that are required
% are the number of neighbours used in matching, and the distance type used

refspectra = {}; % we don't need them for this example, set to empty
pars = struct; 
pars.matching_pars.k = 5; %use 5 nearest neighbours to classify
pars.matching_pars.disttype = 'SAD'; %use sum of absolute distance to find neighbours

%% Classification example
% classification of odd and even numbers
% a number is assigned to class 0 if it is odd, and class 1 if it is even
mode = 'classify';
db = init_database(refspectra, pars, mode);

% generate nsamples integer numbers between 0 and 10. Use linspace to make
% sure all are included
nsamples = 500;
x_train = round(linspace(0, 10, nsamples));
x_labels = mod(x_train, 2) == 0; %even numbers get a label of 1, odd numbers get a label of 0

% The number is now the "descriptor" of itself, and for each number, there
% is a label.
% Insert samples one at a time
for k=1:numel(x_train)
    db = insert_sample(db, x_train(k), x_labels(k));
end

% Generate a new sequence and classify the numbers using the database
x_eval = round(rand(1, nsamples)*10);
x_eval_true_labels = mod(x_eval, 2) == 0;

% classify each new number using the database
x_eval_labels = [];
for k=1:numel(x_eval)
    result = match_sample(x_eval(k), db);
    x_eval_labels = [x_eval_labels result.value];    
end

%Show the result
odd_idx = find(x_eval_labels == 0); %find those numbers classified as odd
even_idx = find(x_eval_labels == 1); %find those numbers classified as even
figure(12);clf;
hold on;
h1 = plot(odd_idx, x_eval(odd_idx), 'r+', 'LineWidth', 2);
h2 = plot(even_idx, x_eval(even_idx), 'g+', 'LineWidth', 2);
hold off;
tags = {'Odd numbers', 'Even numbers'};
legend([h1 h2], tags);

