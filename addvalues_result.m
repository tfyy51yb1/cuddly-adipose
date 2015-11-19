function result_array = addvalues_result(current_image, result)

[~, grade, ~] = fileparts(current_image);
grade = str2num(grade(end:end));

A{1} = current_image
A{2} = getfield(result, 'value')
A{3} = getfield(result, 'votes')
A{4} = getfield(result, 'matchidx')
A{6} = getfield(result, 'distances')
A{7} = getfield(result, 'descriptor')
A{5} = grade


global result_data
result_data = [result_data; A]
end