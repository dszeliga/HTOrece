function [images] = ReadImages(typeOfImages)

images={};
path = uigetdir(pwd, 'Wybierz folder');
imagefiles = dir(fullfile(path, typeOfImages));
countOfFiles = length(imagefiles);    % Liczba zdjêæ

for i=1:countOfFiles
    currentfilename = imagefiles(i).name;
    currentimage = imread(fullfile(path, currentfilename));
    images{i} = currentimage;
end


end

