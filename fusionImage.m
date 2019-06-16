function [] = fusionImage(handles)
global imagesVIS imagesIR falseColorOverlay fusionDone value VISPoints IRPoints
falseColorOverlay={};
for i=1:length(imagesIR)
    fusionDone=true;
    %vis_points = [2.805500000000001e+03 1.389500000000001e+03; 4.257500000000001e+03 1.179500000000001e+03; 3.417500000000001e+03 2.403500000000001e+03; 4.083500000000000e+03 2.295500000000000e+03];
    %ir_points = [20.0000 68.0000; 209.0000 50.0000; 88.5925 197.7254; 173.6792 187.5520];
    % im_vis = imread('images/_MG_1464.JPG');
    % im_ir = imread('images/IMGT0450.PNG');
    im_hands_vis = imagesVIS{i};
    im_hands_ir = imagesIR{i};
    tform = fitgeotrans(VISPoints, IRPoints, 'similarity');
    fusion = imwarp(im_hands_vis, tform, 'OutputView', imref2d(size(im_hands_ir)));
    axes(handles.axesIRVIS);
    falseColorOverlay{i} = imfuse(im_hands_ir, fusion, 'ColorChannels', [2 1 2]);
    imwrite(falseColorOverlay{i}, sprintf('fusion%d.jpg',i));
end
imshow( falseColorOverlay{value}, 'initialMagnification', 'fit');
end

