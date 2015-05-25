function varargout = MARIE_RHBMLoad(varargin)
% MARIE_RHBMLOAD MATLAB code for MARIE_RHBMLoad.fig
%      MARIE_RHBMLOAD, by itself, creates a new MARIE_RHBMLOAD or raises the existing
%      singleton*.
%
%      H = MARIE_RHBMLOAD returns the handle to a new MARIE_RHBMLOAD or the handle to
%      the existing singleton*.
%
%      MARIE_RHBMLOAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MARIE_RHBMLOAD.M with the given input arguments.
%
%      MARIE_RHBMLOAD('Property','Value',...) creates a new MARIE_RHBMLOAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MARIE_RHBMLoad_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MARIE_RHBMLoad_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MARIE_RHBMLoad

% Last Modified by GUIDE v2.5 25-Jun-2014 19:52:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MARIE_RHBMLoad_OpeningFcn, ...
                   'gui_OutputFcn',  @MARIE_RHBMLoad_OutputFcn, ...
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


% --- Executes just before MARIE_RHBMLoad is made visible.
function MARIE_RHBMLoad_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MARIE_RHBMLoad (see VARARGIN)

% get initial variables
handles.bodynumber = varargin{1};
handles.folder = varargin{2}; % current DATA folder
update_listbox(handles);

% Choose default command line output for MARIE_RHBMLoad
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MARIE_RHBMLoad wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


% --- Outputs from this function are returned to the command line.
function varargout = MARIE_RHBMLoad_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% --- Executes on button press in RHBM_LoadModel_Button.
function RHBM_LoadModel_Button_Callback(hObject, eventdata, handles)
% hObject    handle to RHBM_LoadModel_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global RHBM;
modelpath = handles.folder;
modelname = get(handles.RHBM_Selected, 'String');

% call the function to import the RHBM
if ~(strcmp(modelname,'No Model Selected'))
    vsmfile = strcat(modelpath,modelname);
    [RHBM] = Import_RHBM(vsmfile);
else
    fprintf(1, '\n\n Warning: No model selected -- navigate and chose a valid model\n\n');
end


uiwait(msgbox('Model Loaded','MARIE', 'custom', imread('Mlogo_blueorange','jpeg')));
uiresume(gcbf);
close(handles.figure1);

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% --- Executes on button press in RHBM_Refresh_Button.
function RHBM_Refresh_Button_Callback(hObject, eventdata, handles)
% hObject    handle to RHBM_Refresh_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

update_listbox(handles);
% Update handles structure
guidata(hObject, handles);

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% --- Executes on button press in Close_Button.
function Close_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Close_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(gcbf);
close(handles.figure1);
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% --- Executes on button press in RHBM_ChandFolder_Button.
function RHBM_ChandFolder_Button_Callback(hObject, eventdata, handles)
% hObject    handle to RHBM_ChandFolder_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% start window to get new path
currentfolder = handles.folder;
currentfolder = uigetdir(currentfolder, 'Select Directory with Coil Models');

% check that return was correct
if (currentfolder ~= 0)
    handles.folder = currentfolder;
end

% check if path has required format
if ispc
    if (handles.folder(end) ~= '\')
        handles.folder = strcat(handles.folder, '\');
    end
else
    if (handles.folder(end) ~= '/')
        handles.folder = strcat(handles.folder, '/');
    end
end

% update the listbox
update_listbox(handles);
% Update handles structure
guidata(hObject, handles);

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% --- Executes on selection change in RHBM_Database.
function RHBM_Database_Callback(hObject, eventdata, handles)
% hObject    handle to RHBM_Database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RHBM_Database contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RHBM_Database

index = get(hObject,'Value');
models = cellstr(get(hObject,'String'));
if ~isempty(models)
    set(handles.RHBM_Selected,'String',models{index});
    % Update handles structure
    guidata(hObject, handles); 
end


% --- Executes during object creation, after setting all properties.
function RHBM_Database_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RHBM_Database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% -------------------------------------------------------------------------
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
function RHBM_Selected_Callback(hObject, eventdata, handles)
% hObject    handle to RHBM_Selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RHBM_Selected as text
%        str2double(get(hObject,'String')) returns contents of RHBM_Selected as a double


% --- Executes during object creation, after setting all properties.
function RHBM_Selected_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RHBM_Selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String','No Model Selected');

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% function to update the listbox with some changes
function update_listbox(handles)

% finds the .vsm files in the given path
kk = 0;
models = [];

% get files of current folder
files = dir(handles.folder);

for ii = 1:length(files)
    % find files with smm or wmm extension
    if ~files(ii).isdir
        s = files(ii).name;
        last = length(s);
        extension = s(last-3:last);
        if (strcmp(extension,'.vmm'))
            % add file to the list
            kk=kk+1;
            models{kk} = files(ii).name;
        end
    end
end

if ~isempty(models)
    set(handles.RHBM_Database,'String',models,'Value',1);
    index_selected = get(handles.RHBM_Database,'Value');
    selected_model = cellstr(get(handles.RHBM_Database,'String'));
    set(handles.RHBM_Selected,'String',selected_model{index_selected});
else
    models{1} = 'No Model Selected';
    set(handles.RHBM_Database,'String',models,'Value',1);
    index_selected = get(handles.RHBM_Database,'Value');
    selected_model = cellstr(get(handles.RHBM_Database,'String'));
    set(handles.RHBM_Selected,'String',selected_model{index_selected});
end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
