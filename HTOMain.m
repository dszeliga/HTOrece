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
global fusionDone
handles.output = hObject;
guidata(hObject, handles);
set(handles.sldChangeImage, 'Min', 1);
set(handles.sldChangeImage, 'Value', 1);
set(handles.sldChangeImage, 'Max', 5);
set(handles.sldChangeImage, 'SliderStep', [1/(5-1) , 10/(5-1) ]);
set(handles.axesVIS, 'visible', 'off');
set(handles.axesIR, 'visible', 'off');
set(handles.axesIRVIS, 'visible', 'off')
set(handles.axesStatisticHands, 'visible', 'off');
set(handles.axesStatisticPoint, 'visible', 'off');
fusionDone=false;

function varargout = HTOMain_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function btnReadVIS_Callback(hObject, eventdata, handles)
global imagesVIS
try
    imagesVIS=ReadImages('*.JPG');
    axes(handles.axesVIS);
    imshow(imagesVIS{1});
catch
    msgbox('Anulowano wczytywanie serii zdjêæ!', 'B³¹d','error');
end

function btnReadIR_Callback(hObject, eventdata, handles)
global imagesIR
try
    imagesIR=ReadImages('*.png');
    axes(handles.axesIR);
    imshow(imagesIR{1});
catch
    msgbox('Anulowano wczytywanie serii zdjêæ!', 'B³¹d','error');
end

function btnApply_Callback(hObject, eventdata, handles)
fusionImage(handles);

function sldChangeImage_Callback(hObject, eventdata, handles)
global imagesVIS imagesIR value fusionDone
try
    if(fusionDone==true)
        value=get(hObject, 'Value');
        axes(handles.axesIR);
        imshow(imagesIR{value});
        axes(handles.axesVIS);
        imshow(imagesVIS{value});
        imageFusion=imread(sprintf('fusion%d.jpg', value));
        axes(handles.axesIRVIS);
        imshow( imageFusion, 'initialMagnification', 'fit');
    else
        value=get(hObject, 'Value');
        axes(handles.axesIR);
        imshow(imagesIR{value});
        axes(handles.axesVIS);
        imshow(imagesVIS{value});
    end
catch
    msgbox('Nie wczytano serii zdjêæ!', 'B³¹d','error');
    set(handles.sldChangeImage, 'Value', 1)
end

function sldChangeImage_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function btnSelectPointsVIS_Callback(hObject, eventdata, handles)

function btnSelectPointsIR_Callback(hObject, eventdata, handles)

function btnSelectPoint_Callback(hObject, eventdata, handles)
global value falseColorOverlay fusionDone x y
if(fusionDone==true)
    [x,y]=ginput(1);
    value=get(hObject, 'Value');
    imageFusion=imread(sprintf('fusion%d.jpg', value));
    axes(handles.axesIRVIS);
    imshow( imageFusion, 'initialMagnification', 'fit');
    hold on;
    plot(x,y,'.y', 'Markersize', 15);
else
    msgbox('Nie wykonano fuzji zdjêæ!!', 'Warning','error');
end

function btnAnalyze_Callback(hObject, eventdata, handles)
global x y imagesIR
pointsRGBfusion=[];
for i=1:length(imagesIR)
imageFusion=imread(sprintf('fusion%d.jpg', i));
pointsRGBfusion(:,i) = [imageFusion(round(x),round(y),1), ...
    imageFusion(round(x),round(y),2), ...
    imageFusion(round(x),round(y),3)];
end