function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 07-Jul-2019 14:07:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in new.
function new_Callback(hObject, eventdata, handles)

layers=getappdata(0,'layers');
net=feedforwardnet(layers);
setappdata(0,'net',net);

switch net.trainFcn
       case 'trainlm'
           set(handles.func_train, 'Value', 1);
       case 'trainbfg'
           set(handles.func_train, 'Value', 2);
       case 'traingd'
           set(handles.func_train, 'Value', 3);
end

 switch net.layers{get(handles.layer,'Value')}.transferFcn
       case 'logsig'
           set(handles.actfunc, 'Value', 1);
       case 'hardlim'
           set(handles.actfunc, 'Value', 2);
       case 'purelin'
           set(handles.actfunc, 'Value', 3);
 end
if strcmp(net.divideFcn,'')
set(handles.all,'Value',1);
set(handles.vtrain,'Enable','off');
set(handles.vval,'Enable','off');
set(handles.vtest,'Enable','off');
else
set(handles.all,'Value',0);
set(handles.vtrain,'Enable','on');
set(handles.vval,'Enable','on');
set(handles.vtest,'Enable','on');
set(handles.vtrain,'Value',net.divideParam.trainRatio*100+1);
set(handles.vval,'value',net.divideParam.valRatio*100+1);
set(handles.vtest,'Value',net.divideParam.testRatio*100+1);
end    
    msgbox('Rede criada com sucesso','Success','modal');



% hObject    handle to new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function new_CreateFcn(hObject, eventdata, handles)
% hObject    handle to new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in hidenlayers.
function hidenlayers_Callback(hObject, eventdata, handles)
% hObject    handle to hidenlayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns hidenlayers contents as cell array
%        contents{get(hObject,'Value')} returns selected item from hidenlayers
x=get(handles.hidenlayers, 'Value');
tlayer='1';
layers(1)=10;

for i=2:x
tlayer = char(tlayer,num2str(i));
layers(i)=10;
end

set(handles.layer,'String',tlayer);
disp(i);
tlayer = char(tlayer,num2str(x+1));
set(handles.tlayer,'String',tlayer);
set(handles.numeroneurons,'Value',layers(1));
set(handles.layer,'Value', 1);
set(handles.tlayer,'Value', 1);
setappdata(0,'layers',layers);

% --- Executes during object creation, after setting all properties.
function hidenlayers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hidenlayers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'Value', 1);
layers(1)=10;
setappdata(0,'layers',layers);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in layer.
function layer_Callback(hObject, eventdata, handles)
% hObject    handle to layer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns layer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from layer
layers=getappdata(0,'layers');
disp(layers);
set(handles.numeroneurons,'Value', layers(get(hObject, 'Value')))

% --- Executes during object creation, after setting all properties.
function layer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'Value', 1);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in numeroneurons.
function numeroneurons_Callback(hObject, eventdata, handles)
% hObject    handle to numeroneurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns numeroneurons contents as cell array
%        contents{get(hObject,'Value')} returns selected item from numeroneurons
layers=getappdata(0,'layers');
layers(get(handles.layer, 'Value'))=get(hObject, 'Value');
setappdata(0,'layers',layers);

% --- Executes during object creation, after setting all properties.
function numeroneurons_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numeroneurons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
set(hObject,'Value', 10);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in func_train.
function func_train_Callback(hObject, eventdata, handles)
% hObject    handle to func_train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns func_train contents as cell array
%        contents{get(hObject,'Value')} returns selected item from func_train

net=getappdata(0,'net');
switch get(hObject,'Value')
    case 1
        net.trainFcn='trainlm';
    case 2
        net.trainFcn='trainbfg';
    case 3
        net.trainFcn='traingd';
end
setappdata(0,'net',net);


% --- Executes during object creation, after setting all properties.
function func_train_CreateFcn(hObject, eventdata, handles)
% hObject    handle to func_train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in func_act.
function func_act_Callback(hObject, eventdata, handles)
% hObject    handle to func_act (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns func_act contents as cell array
%        contents{get(hObject,'Value')} returns selected item from func_act
net= getappdata(0,'net');
    switch get(hObject,'Value')
       case 1
           net.layers{get(handles.tlayer,'Value')}.transferFcn='logsig';
       case 2 
           net.layers{get(handles.tlayer,'Value')}.transferFcn='tansig';
       case 3 
           net.layers{get(handles.tlayer,'Value')}.transferFcn='purelin';
    end
    setappdata(0,'net',net);

% --- Executes during object creation, after setting all properties.
function func_act_CreateFcn(hObject, eventdata, handles)
% hObject    handle to func_act (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tlayer.
function tlayer_Callback(hObject, eventdata, handles)
% hObject    handle to tlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns tlayer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tlayer
net= getappdata(0,'net');
    switch net.layers{get(handles.tlayer,'Value')}.transferFcn
       case 'logsig'
           set(handles.func_act, 'Value', 1);
       case 'tansig'
           set(handles.func_act, 'Value', 2);
       case 'purelin'
           set(handles.func_act, 'Value', 3);
    end

% --- Executes during object creation, after setting all properties.
function tlayer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in train.
function train_Callback(hObject, eventdata, handles)
% hObject    handle to train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns train contents as cell array
%        contents{get(hObject,'Value')} returns selected item from train
net = getappdata(0,'net');
net.divideParam.trainRatio = (get(hObject,'Value')-1)/100;
setappdata(0,'net',net);

% --- Executes during object creation, after setting all properties.
function train_CreateFcn(hObject, eventdata, handles)
% hObject    handle to train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in val.
function val_Callback(hObject, eventdata, handles)
% hObject    handle to val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns val contents as cell array
%        contents{get(hObject,'Value')} returns selected item from val
net = getappdata(0,'net');
net.divideParam.valRatio = (get(hObject,'Value')-1)/100;
setappdata(0,'net',net);

% --- Executes during object creation, after setting all properties.
function val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns test contents as cell array
%        contents{get(hObject,'Value')} returns selected item from test
net = getappdata(0,'net');
net.divideParam.testRatio = (get(hObject,'Value')-1)/100;
setappdata(0,'net',net);

% --- Executes during object creation, after setting all properties.
function test_CreateFcn(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fich_train.
function fich_train_Callback(hObject, eventdata, handles)
% hObject    handle to fich_train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fich_train
dname = uigetdir();
if isequal(dname,0)
else
set(handles.text35, 'String',dname);
set(handles.train,'Enable','on');
setappdata(0,'trainfile',dname);

f = fullfile(dname,'circle','*.PNG');
jpegFiles = dir(f);
for k = 1:length(jpegFiles)
baseFileName = jpegFiles(k).name;
fullFileName = fullfile(dname,'circle', baseFileName);
fprintf(1, 'Now reading %s\n', fullFileName);
imageArray = imread(fullFileName);
imageArray = imbinarize(imageArray);
a=size(imageArray,2)*size(imageArray,1);

files(k)=convertCharsToStrings(fullfile('circle', baseFileName));
data(1:a,k)=imageArray(:);
targets(1,k)=1;
targets(2,k)=0;
targets(3,k)=0;
targets(4,k)=0;
end
aux=k;
f = fullfile(dname,'square','*.PNG');
jpegFiles = dir(f);
for k = 1:length(jpegFiles)
baseFileName = jpegFiles(k).name;
fullFileName = fullfile(dname,'square', baseFileName);
fprintf(1, 'Now reading %s\n', fullFileName);
imageArray = imread(fullFileName);
imageArray = imbinarize(imageArray);
a=size(imageArray,2)*size(imageArray,1);
files(k+aux)=convertCharsToStrings(fullfile('square', baseFileName));
data(1:a,k+aux)=imageArray(:);
targets(1,k+aux)=0;
targets(2,k+aux)=1;
targets(3,k+aux)=0;
targets(4,k+aux)=0;
end

aux=aux+k;


f = fullfile(dname,'star','*.PNG');
jpegFiles = dir(f);
for k = 1:length(jpegFiles)
baseFileName = jpegFiles(k).name;
fullFileName = fullfile(dname,'star', baseFileName);
fprintf(1, 'Now reading %s\n', fullFileName);
imageArray = imread(fullFileName);
imageArray = imbinarize(imageArray);
a=size(imageArray,2)*size(imageArray,1);

files(k+aux)=convertCharsToStrings(fullfile('star', baseFileName));
data(1:a,k+aux)=imageArray(:);
targets(1,k+aux)=0;
targets(2,k+aux)=0;
targets(3,k+aux)=1;
targets(4,k+aux)=0;
end


aux=aux+k;


f = fullfile(dname,'triangle','*.PNG');
jpegFiles = dir(f);
for k = 1:length(jpegFiles)
baseFileName = jpegFiles(k).name;
fullFileName = fullfile(dname,'triangle', baseFileName);
fprintf(1, 'Now reading %s\n', fullFileName);
imageArray = imread(fullFileName);
imageArray = imbinarize(imageArray);
a=size(imageArray,2)*size(imageArray,1);

files(k+aux)=convertCharsToStrings(fullfile('triangle', baseFileName));
data(1:a,k+aux)=imageArray(:);
targets(1,k+aux)=0;
targets(2,k+aux)=0;
targets(3,k+aux)=0;
targets(4,k+aux)=1;
end

setappdata(0,'targets',targets);
setappdata(0,'data',data);
setappdata(0,'files',files);

end
