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
global fusionDone value VISPoints IRPoints x y
handles.output = hObject;
guidata(hObject, handles);
set(handles.sldChangeImage, 'Min', 1);
set(handles.sldChangeImage, 'Value', 1);
value=get(handles.sldChangeImage, 'Value');
set(handles.sldChangeImage, 'Max', 6);
set(handles.sldChangeImage, 'SliderStep', [1/(6-1) , 10/(6-1) ]);
set(handles.axesVIS, 'visible', 'off');
set(handles.axesIR, 'visible', 'off');
set(handles.axesIRVIS, 'visible', 'off')
set(handles.axesStatisticHands, 'visible', 'off');
set(handles.axesStatisticPoint, 'visible', 'off');
set(handles.btnSelectPointsVIS, 'Enable', 'off');
set(handles.btnSelectPointsIR, 'Enable', 'off');
set(handles.btnApply, 'Enable', 'off');
set(handles.btnSelectPoint, 'Enable', 'off');
set(handles.btnAnalyze, 'Enable', 'off');
set(handles.btnChangePoint, 'Enable', 'off');
x(1:6) = -1;
y(1:6) = -1;
VISPoints = [];
IRPoints = [];
fusionDone=false;

function varargout = HTOMain_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function btnReadVIS_Callback(hObject, eventdata, handles)
global imagesVIS
try
    imagesVIS=ReadImages('*.JPG');
    axes(handles.axesVIS);
    imshow(imagesVIS{1});
    set(handles.btnSelectPointsVIS, 'Enable', 'on');
catch
    msgbox('Anulowano wczytywanie serii zdjêæ!', 'B³¹d','error');
end

function btnReadIR_Callback(hObject, eventdata, handles)
global imagesIR
try
    imagesIR=ReadImages('*.png');
    axes(handles.axesIR);
    imshow(imagesIR{1});
    set(handles.btnSelectPointsIR, 'Enable', 'on');
catch
    msgbox('Anulowano wczytywanie serii zdjêæ!', 'B³¹d','error');
end

function btnApply_Callback(hObject, eventdata, handles)
fusionImage(handles);

function sldChangeImage_Callback(hObject, eventdata, handles)
global imagesVIS imagesIR value fusionDone x y
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
        if(x(value)>-1)
            hold on;
            plot(x(value),y(value),'.y', 'Markersize', 15);
        end
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
global VISPoints value imagesVIS
figure
imshow(imagesVIS{value})
[x_vis(1), y_vis(1)] = ginput(1);
hold on
plot(x_vis(1),y_vis(1),'.y', 'Markersize', 15)
[x_vis(2), y_vis(2)] = ginput(1);
plot(x_vis(2),y_vis(2),'.y', 'Markersize', 15)
[x_vis(3), y_vis(3)] = ginput(1);
plot(x_vis(3),y_vis(3),'.y', 'Markersize', 15)
[x_vis(4), y_vis(4)] = ginput(1);
plot(x_vis(4),y_vis(4),'.y', 'Markersize', 15)
close
for i=1:1:4
    VISPoints = [VISPoints; x_vis(i) y_vis(i)];
end

function btnSelectPointsIR_Callback(hObject, eventdata, handles)
global IRPoints value imagesIR
figure
imshow(imagesIR{value})
[x_ir(1), y_ir(1)] = ginput(1);
hold on
plot(x_ir(1),y_ir(1),'.y', 'Markersize', 15)
[x_ir(2), y_ir(2)] = ginput(1);
plot(x_ir(2),y_ir(2),'.y', 'Markersize', 15)
[x_ir(3), y_ir(3)] = ginput(1);
plot(x_ir(3),y_ir(3),'.y', 'Markersize', 15)
[x_ir(4), y_ir(4)] = ginput(1);
plot(x_ir(4),y_ir(4),'.y', 'Markersize', 15)
close
for i=1:4
    IRPoints = [IRPoints; x_ir(i) y_ir(i)];
end

function btnSelectPoint_Callback(hObject, eventdata, handles)
global value fusionDone x y
if(fusionDone==true)
    [xx,yy]=ginput(1);
    x(1:6)=xx;
    y(1:6)=yy;
    imageFusion=imread(sprintf('fusion%d.jpg', value));
    axes(handles.axesIRVIS);
    imshow( imageFusion, 'initialMagnification', 'fit');
    hold on;
    plot(x(value),y(value),'.y', 'Markersize', 15);
else
    msgbox('Nie wykonano fuzji zdjêæ!!', 'Warning','error');
end

function btnAnalyze_Callback(hObject, eventdata, handles)
global x y imagesIR
pointsRGBfusion=[];
for i=1:length(imagesIR)
    %imageFusion=imread(sprintf('fusion%d.jpg', i));
    imageFusion=imagesIR{i};
    pointsRGBfusion(i,:) = [imageFusion(round(x(i)),round(y(i)),1), ...
        imageFusion(round(x(i)),round(y(i)),2), ...
        imageFusion(round(x(i)),round(y(i)),3)];
    
    scaleBar=[imageFusion(5,:,1); imageFusion(5,:,2); imageFusion(5,:,3)];
    
    for j=1:size(scaleBar,2);
        if(abs(double(scaleBar(1,j))-double(pointsRGBfusion(i,1)))<=20 && ...
                abs(double(scaleBar(2,j))-double(pointsRGBfusion(i,2)))<=20 && ...
                abs(double(scaleBar(3,j))-double(pointsRGBfusion(i,3)))<=20)
            index=j;
            break;
        end
    end
    temperature(i)=(50*index)/240;
end
time = [0, 3, 5, 7, 12];

axes(handles.axesStatisticHands);
plot(time, temperature(2:end), '-r');



function btnChangePoint_Callback(hObject, eventdata, handles)
global value fusionDone x y
if(fusionDone==true)
    [xx,yy]=ginput(1);
    x(value)=xx;
    y(value)=yy;
    imageFusion=imread(sprintf('fusion%d.jpg', value));
    axes(handles.axesIRVIS);
    imshow( imageFusion, 'initialMagnification', 'fit');
    hold on;
    plot(x(value),y(value),'.y', 'Markersize', 15);
else
    msgbox('Nie wykonano fuzji zdjêæ!!', 'Warning','error');
end
