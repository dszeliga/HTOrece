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
global imagesVIS imagesIR
vis_points = [2.805500000000001e+03 1.389500000000001e+03; 4.257500000000001e+03 1.179500000000001e+03; 3.417500000000001e+03 2.403500000000001e+03; 4.083500000000000e+03 2.295500000000000e+03];
ir_points = [20.0000 68.0000; 209.0000 50.0000; 88.5925 197.7254; 173.6792 187.5520];
im_vis = imread('images/_MG_1464.JPG');
im_ir = imread('images/IMGT0450.PNG');
value=get(hObject, 'Value');
im_hands_vis = imagesVIS{value};
im_hands_ir = imagesIR{value};
tform = fitgeotrans(vis_points, ir_points, 'similarity');
fusion = imwarp(im_hands_vis, tform, 'OutputView', imref2d(size(im_hands_ir)));
axes(handles.axesIRVIS);
falseColorOverlay = imfuse(im_hands_ir, fusion);
imshow( falseColorOverlay, 'initialMagnification', 'fit');


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
