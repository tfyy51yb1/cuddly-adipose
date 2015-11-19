% function [imgdata, metadata] = readASIraw(filename)
% This function reads an ASI RAW image file
% INPUT: 
% filename - string containing file name and path (eg '/home/myuser/myfile.raw')
% 
% OUTPUT:
% imgdata - MxNxD uint8 image data (M rows, N columns, D spectral bands)
% metadata - struct containing image information fields:
%               date: capture date
%               time: capture time
%               exp: exposure time (I think)
%               step: (I don't know what this is)
%               X: 1x2 matrix of start and end X positions
%               cols: number of columns
%               Y: 1x2 matrix of start and end X positions
%               rows: number of rows
%               virtfrm: (I don't know what this is)
%               nbands: number of spectral bands
%
% Marcus Wallenberg, 2015
function [imgdata, metadata] = readASIraw(filename, resample_size)
read_offset = 254; %size of leading metadata
fid = fopen(filename, 'r');
header_data = fread(fid, [1 read_offset], '*char'); %read header as char
fclose(fid);
fid = fopen(filename, 'r');
data = fread(fid, '*uint16', 0, 'l'); %read data as uint16, little-endian
fclose(fid);

strdata = strsplit(header_data, '@');
strdata = regexprep(strdata{end}, ',' ,' ');
strdata = regexprep(strdata, char(0) ,' ');
strdata = regexprep(strdata, '(' ,' ');
strdata = regexprep(strdata, ')' ,' ');
strdata = regexprep(strdata, '-' ,' ');
strdata = strsplit(strdata, ' ');
keepidx = true(size(strdata));
for k=1:numel(strdata)
    if isempty(strdata{k})
        keepidx(k) = false;
    end
end
strdata = strdata(keepidx);
metadata = struct;
metadata.date = strdata{1};
metadata.time = strdata{2};
metadata.exp = str2double(strdata{3});
metadata.frm = str2double(strdata{5});
metadata.step = str2double(strdata{8});
metadata.X = [str2double(strdata{10}), str2double(strdata{11})];
metadata.cols = str2double(strdata{12});
metadata.Y = [str2double(strdata{14}), str2double(strdata{15})];
metadata.rows = str2double(strdata{16});
metadata.virtfrm = str2double(strdata{19});
metadata.nbands = floor(numel(data)/(metadata.cols*metadata.rows));
npix = metadata.cols*metadata.rows;


imgdata = reshape(data(end - npix*(metadata.nbands) + 1:end), metadata.nbands, metadata.cols, metadata.rows);
data = [];

imgdata = imgdata(5:end, :, :);
metadata.nbands = metadata.nbands - 4;

imgdata = flipud(imgdata); %reverse channel order to be increasing in wavelength

%spectral dimension rescaling
if exist('resample_size', 'var')
    imgdata = imresize(imgdata, [resample_size(3), size(imgdata, 2)], 'bilinear');
end

imgdata = permute(imgdata, [3 2 1]);

if exist('resample_size', 'var')
    if sum(isnan(resample_size(1:2))) < 2
        imgdata = imresize(imgdata, [resample_size(1), resample_size(2)], 'bilinear');        
    end
end
