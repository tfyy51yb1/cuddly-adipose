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

% Last Modified by GUIDE v2.5 25-Nov-2015 09:33:25

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
handles.affine_init = true;
handles.enforcepositive_init = false;
handles.descriptor_pars = struct('use_affine', handles.affine_init, 'enforce_positive', handles.enforcepositive_init);
global training_data
handle.mode_init = 'classify';
handles.neighbours_init = 3;
handles.disttype_init = 'SAD';
handles.refspectra = get_refspectra
handles.s = struct('matching_pars', struct('k', handles.neighbours_init', 'disttype', handles.disttype_init));
training_data = init_database(handles.refspectra, handles.s, handle.mode_init);
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
set(handles.progress, 'String', '');
global training_data
handles.images = get_Images;
training_data = build_database(handles.images, handles.refspectra, handles.descriptor_pars);
guidata(hObject,handles);
set(handles.progress, 'String', 'Done!');
assignin ('base','td',training_data);

% --- Executes on button press in match.
function match_Callback(hObject, eventdata, handles)
% hObject    handle to match (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global training_data
handles.images2 = get_Images;
result_struct = match_db(handles.images2, handles.refspectra, training_data, handles.descriptor_pars);
result_cell = struct2cell(result_struct);
assignin ('base','result', result_cell);

global result_array
result_array

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

% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6



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
