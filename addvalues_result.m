function result_array = addvalues_result(current_image, result)

[~, grade, ~] = fileparts(current_image);
grade = str2num(grade(6:6));

A{1} = getfield(result, 'image');
A{2} = getfield(result, 'value');
A{3} = getfield(result, 'votes');
A{4} = getfield(result, 'matchidx');
A{5} = getfield(result, 'distances');
A{6} = getfield(result, 'descriptor');
A{7} = grade;

global result_array
result_array = [result_array; A];
end