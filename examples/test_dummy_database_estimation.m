% This is a test of a dummy database initialisation, insertion and matching
% Note that the inclusion of refspectra and pars in the database struct is
% just to make it simpler to store them. The only fields that are required
% are the number of neighbours used in matching, and the distance type used

refspectra = {}; % we don't need them for this example, set to empty
pars = struct; 
pars.matching_pars.k = 5; %use 5 nearest neighbours to estimate
pars.matching_pars.disttype = 'SAD'; %use sum of absolute distance to find neighbours

%% Classification example
% estimation of square of a number by lookup
% The parameter "value" of a number is defined to be its square
mode = 'estimate';
db = init_database(refspectra, pars, mode);

% generate nsamples integer numbers between 0 and 5. Use linspace to make
% sure all are included
nsamples = 100;
x_train = round(linspace(0, 5, nsamples));
x_values = x_train.^2; % every number get a "value" of its square

% The number is now the "descriptor" of itself, and for each number, there
% is a label.
% Insert samples one at a time
for k=1:numel(x_train)
    db = insert_sample(db, x_train(k), x_values(k));
end

% Generate a new sequence and estimate the squares using the database
x_eval = round(rand(1, nsamples)*5);
x_eval_true_values = x_eval.^2;

% Estimate the square of each new number using the database
x_eval_values = [];
for k=1:numel(x_eval)
    result = match_sample(x_eval(k), db);
    x_eval_values = [x_eval_values result.value];    
end

% sort the number so it's easier to see the result
[~, idx] = sort(x_eval, 'ascend');

%Show the result
figure(12);clf;
hold on;
h1 = plot(x_eval(idx), 'ro', 'LineWidth', 2);
h2 = plot(x_eval_values(idx), 'g+', 'LineWidth', 2);
hold off;
tags = {'Input number', 'Squared value from database'};
legend([h1 h2], tags);

