function varargout = HTOMain(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HTOMain_OpeningFcn, ...
                   'gui_OutputFcn',  @HTOMain_OutputFcn, ...
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

function HTOMain_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
set(handles.axesVIS, 'visible', 'off')
set(handles.axesIR, 'visible', 'off')
set(handles.axesIRVIS, 'visible', 'off')

function varargout = HTOMain_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function btnReadVIS_Callback(hObject, eventdata, handles)
global imagesVIS
imagesVIS=ReadImages('*.JPG');
axes(handles.axesVIS);
imshow(imagesVIS{1});

function btnReadIR_Callback(hObject, eventdata, handles)
global imagesIR
imagesIR=ReadImages('*.png');
axes(handles.axesIR);
imshow(imagesIR{1});
function btnApply_Callback(hObject, eventdata, handles)


% --- Executes on slider movement.
function sldChangeImage_Callback(hObject, eventdata, handles)
global imagesVIS imagesIR

value=get(hObject, 'Value');
axes(handles.axesIR);
imshow(imagesIR{value});
axes(handles.axesVIS);
imshow(imagesVIS{value});

% --- Executes during object creation, after setting all properties.
function sldChangeImage_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
    set(handles.sldChangeImage, 'Min', 1);
    set(handles.sldChangeImage, 'Value', 1)
    set(handles.sldChangeImage, 'Max', 5);
    set(handles.sldChangeImage, 'SliderStep', [1/(5-1) , 10/(5-1) ]);
    
    
end