function varargout = guid(varargin)
% GUID MATLAB code for guid.fig
%      GUID, by itself, creates a new GUID or raises the existing
%      singleton*.
%
%      H = GUID returns the handle to a new GUID or the handle to
%      the existing singleton*.
%
%      GUID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUID.M with the given input arguments.
%
%      GUID('Property','Value',...) creates a new GUID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guid_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guid_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guid

% Last Modified by GUIDE v2.5 29-Nov-2015 23:26:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guid_OpeningFcn, ...
                   'gui_OutputFcn',  @guid_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guid is made visible.
function guid_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guid (see VARARGIN)

% Initialization variables
global threshold_pars
threshold_pars = struct;
threshold_pars.flatten_mode = 'max'; 
threshold_pars.normalisefl = false; 
threshold_pars.method = 'manual'; 
threshold_pars.gammaval = 0.7; 
threshold_pars.threshold_value = 130; 
threshold_pars.n_erosion_steps = 0;
threshold_pars.n_dilation_steps = 0;
threshold_pars.min_region_size = 788;

handles.affine_init = false;
handles.enforcepositive_init = false;

handles.descriptor_pars = struct('use_affine', handles.affine_init, 'enforce_positive', handles.enforcepositive_init);

global training_data

handles.mode_init = 'classify';

handles.neighbours_init = 1;

handles.disttype_init = 'SAD';

handles.refspectra = get_refspectra
handles.s = struct('matching_pars', struct('k', handles.neighbours_init', 'disttype', handles.disttype_init));
training_data = init_database(handles.refspectra, handles.s, handles.mode_init);
assignin ('base','td',training_data);


% Choose default command line output for guid
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guid wait for user response (see UIRESUME)
 %uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guid_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in db.
function db_Callback(hObject, eventdata, handles)
% hObject    handle to db (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.progress, 'String', ' ');
guidata(hObject,handles);
clearvars -global training_data;
global training_data
training_data = init_database(handles.refspectra, handles.s, handles.mode_init);
training_data = build_database(handles.images, handles.refspectra, handles.descriptor_pars);
set(handles.progress, 'String', 'Done!');
assignin ('base','td',training_data);

% --- Executes on button press in match.
function match_Callback(hObject, eventdata, handles)
% hObject    handle to match (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.match_progress, 'String', '');
clearvars -global result_data;
global training_data
global result_data
match_db(handles.images2, handles.refspectra, training_data, handles.descriptor_pars);
set(handles.match_progress, 'String', 'Done!');
result_data

% --- Executes on selection change in disttype.
function disttype_Callback(hObject, eventdata, handles)
% hObject    handle to disttype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns disttype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from disttype
global training_data
disttype = get(handles.disttype, 'Value');
switch disttype
    case 1
        training_data.pars.matching_pars.disttype = 'SAD';
        guidata(hObject,handles);
    case 2
        training_data.pars.matching_pars.disttype = 'SSE';
        guidata(hObject,handles);
    case 3
        training_data.pars.matching_pars.disttype = 'Euclidean';
        guidata(hObject,handles);
    case 4
        training_data.pars.matching_pars.disttype = 'correlation';
        guidata(hObject,handles);
    otherwise
        error(['Unknown distance type: ' handles.disttype]);
end
assignin ('base','td',training_data);
% --- Executes during object creation, after setting all properties.
function disttype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to disttype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function neighbours_Callback(hObject, eventdata, handles)
% hObject    handle to neighbours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neighbours as text
%        str2double(get(hObject,'String')) returns contents of neighbours as a double
global training_data
guidata(hObject,handles);
handles.neighbours = str2double(get(handles.neighbours, 'String'));
training_data.pars.matching_pars.k = handles.neighbours;
assignin ('base','td', training_data);


% --- Executes during object creation, after setting all properties.
function neighbours_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neighbours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in affine.
function affine_Callback(hObject, eventdata, handles)
% hObject    handle to affine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of affine

if (get(handles.affine,'Value') == get(handles.affine,'Max'))
	handles.descriptor_pars.use_affine = true;
    guidata(hObject,handles);
else
	handles.descriptor_pars.use_affine = false;
    guidata(hObject,handles);
end

% --- Executes on button press in forcepositive.
function forcepositive_Callback(hObject, eventdata, handles)
% hObject    handle to forcepositive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of forcepositive

if (get(handles.forcepositive,'Value') == get(handles.forcepositive,'Max'))
	handles.descriptor_pars.enforce_positive = true;
    guidata(hObject,handles);
else
	handles.descriptor_calc.enforce_positive = false;
    guidata(hObject,handles);
end


function mode_Callback(hObject, eventdata, handles)
% hObject    handle to mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mode as text
%        str2double(get(hObject,'String')) returns contents of mode as a double
global training_data
mode = get(handles.mode, 'Value');
switch mode
    case 1
        training_data.mode = 'classify';
        guidata(hObject,handles);
    case 2
        training_data.mode = 'estimate';
        guidata(hObject,handles);
    otherwise
        error(['Unknown mode: ' handles.mode]);
end
assignin ('base','td',training_data)
% --- Executes during object creation, after setting all properties.
function mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in flattenmode.
function flattenmode_Callback(hObject, eventdata, handles)
% hObject    handle to flattenmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns flattenmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from flattenmode

global threshold_pars
flattenmodeval = get(handles.flattenmode, 'Value');

switch flattenmodeval
    case 1
        threshold_pars.flatten_mode = 'sum';
    case 2
        threshold_pars.flatten_mode = 'max';
end

assignin ('base','tp',threshold_pars)


% --- Executes during object creation, after setting all properties.
function flattenmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flattenmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in normalise.
function normalise_Callback(hObject, eventdata, handles)
% hObject    handle to normalise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalise
global threshold_pars
if (get(handles.normalise,'Value') == get(handles.normalise,'Max'))
	threshold_pars.normalisefl = true;
else
	threshold_pars.normalisefl = false;
end
assignin ('base','tp',threshold_pars)

% --- Executes on selection change in method.
function method_Callback(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from method
global threshold_pars
methodval = get(handles.method, 'Value');

switch methodval
    case 1
        threshold_pars.method = 'manual';
    case 2
        threshold_pars.method = 'automatic';
end
assignin ('base','tp',threshold_pars)

% --- Executes during object creation, after setting all properties.
function method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gammaval_Callback(hObject, eventdata, handles)
% hObject    handle to gammaval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gammaval as text
%        str2double(get(hObject,'String')) returns contents of gammaval as a double

global threshold_pars
gammaval = str2double(get(handles.gammaval, 'String'));
threshold_pars.gammaval = gammaval;
assignin ('base','tp', threshold_pars);


% --- Executes during object creation, after setting all properties.
function gammaval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dilation_Callback(hObject, eventdata, handles)
% hObject    handle to dilation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dilation as text
%        str2double(get(hObject,'String')) returns contents of dilation as a double

global threshold_pars
dilation = str2double(get(handles.dilation, 'String'));
threshold_pars.n_dilation_steps = dilation;
assignin ('base','tp', threshold_pars);

% --- Executes during object creation, after setting all properties.
function dilation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dilation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thresholdval_Callback(hObject, eventdata, handles)
% hObject    handle to thresholdval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thresholdval as text
%        str2double(get(hObject,'String')) returns contents of thresholdval as a double

global threshold_pars
thresholdval = str2double(get(handles.thresholdval, 'String'));
threshold_pars.threshold_value = thresholdval;
assignin ('base','tp', threshold_pars);

% --- Executes during object creation, after setting all properties.
function thresholdval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thresholdval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function erosion_Callback(hObject, eventdata, handles)
% hObject    handle to erosion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of erosion as text
%        str2double(get(hObject,'String')) returns contents of erosion as a double

global threshold_pars
erosion = str2double(get(handles.erosion, 'String'));
threshold_pars.n_erosion_steps = erosion;
assignin ('base','tp', threshold_pars);

% --- Executes during object creation, after setting all properties.
function erosion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to erosion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minregion_Callback(hObject, eventdata, handles)
% hObject    handle to minregion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minregion as text
%        str2double(get(hObject,'String')) returns contents of minregion as a double

global threshold_pars
minregion = str2double(get(handles.minregion, 'String'));
threshold_pars.min_region_size = minregion;
assignin ('base','tp', threshold_pars);

% --- Executes during object creation, after setting all properties.
function minregion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minregion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dbimagefiles.
function dbimagefiles_Callback(hObject, eventdata, handles)
% hObject    handle to dbimagefiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns dbimagefiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from dbimagefiles

global image_type

switch(image_type)
    case 'real'
        %%select images used to generate database
        handles.images = get_Images;
    case 'synthetic'
        %%select images used to generate database
        handles.images = get_Dataset;
end

set(handles.dbimagefiles, 'Value', 1);
set(handles.dbimagefiles, 'String', '');
assignin ('base','images', handles.images);
for k = 1 : length(handles.images)
  dbimagefiles{k} = handles.images{k};
end
set(handles.dbimagefiles, 'String', dbimagefiles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function dbimagefiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dbimagefiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in sampleimagefiles.
function sampleimagefiles_Callback(hObject, eventdata, handles)
% hObject    handle to sampleimagefiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sampleimagefiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sampleimagefiles

global image_type

switch(image_type)
    case 'real'
        %%select images used to generate database
        handles.images2 = get_Images;
    case 'synthetic'
        %%select images used to generate database
        handles.images2 = get_Dataset;
end

set(handles.sampleimagefiles, 'Value', 1);
set(handles.sampleimagefiles, 'String', '');
assignin ('base','images2', handles.images2);
for k = 1 : length(handles.images2)
  sampleimagefiles{k} = handles.images2{k};
end
set(handles.sampleimagefiles, 'String', sampleimagefiles);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function sampleimagefiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleimagefiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function progress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over progress.
function progress_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to progress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in use_synthimg.
function use_synthimg_Callback(hObject, eventdata, handles)
% hObject    handle to use_synthimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of use_synthimg
global image_type
if (get(handles.use_synthimg,'Value') == get(handles.use_synthimg,'Max'))
	image_type = 'synthetic';
else
	image_type = 'real';
end

assignin ('base','image_type', image_type)



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ptool.
function ptool_Callback(hObject, eventdata, handles)
% hObject    handle to ptool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

SUBPLOT
