function [ extractResult ] = ISSextract( folderPath )
%ISSEXTRACT Summary of this function goes here
%   This will extract watermark for all images in the given folder.
%   Execute exmaple:
%       extractResult = ISSextract('/Users/blue/Documents/MATLAB/104_1/MMSEC/HW1/experiment/watermarked_image/wm/airplane/')

% folderPath = '/Users/blue/Documents/MATLAB/104_1/MMSEC/HW1/experiment/watermarked_image/wm/airplane/';

tic

load('data.mat');

imgFileNameList = dir( [ folderPath ['*wm*'] ]);
[totalNumOfFile, ~] = size(imgFileNameList);
extractResult = zeros(totalNumOfFile, 5);

for idx = 1:totalNumOfFile
	disp([ num2str(100*idx/totalNumOfFile) '%']);

	imageName = imgFileNameList(idx).name;
	SuspImage = imread([folderPath imageName]);
	[height width ~] = size(SuspImage);

	parsedImgFileName = strsplit(imageName, '_');
	alpha = str2num(parsedImgFileName{4});
	blkSize = str2num(parsedImgFileName{6});
	lambda = str2num( parsedImgFileName{8}(1:(end-4)) );

	patternSize = ceil(blkSize^2/3);
	pattern = pattern_1366bit(1:patternSize);
	wmSize = floor(height/blkSize) * floor(width/blkSize);
	watermark = watermark_16384bit(1:wmSize);

	extractWM = ImprovedSpreadSpectrumExtract(SuspImage, pattern, blkSize, wmSize);

	ber = nnz(extractWM - watermark) / wmSize;
	extractResult(idx, 1) = alpha;
	extractResult(idx, 2) = blkSize;
	extractResult(idx, 3) = lambda;
	parsedFolderPath = strsplit(folderPath, '/');
	oriImage = imread([ folderPath parsedFolderPath{end-1} '.bmp']);
	extractResult(idx, 4) = psnr(SuspImage, oriImage);
	extractResult(idx, 5) = ber;
end

%% permuting
permuteIndices = [ 3,  5,  1,  2,  4, ...
                   8, 10,  6,  7,  9, ...
                  13, 15, 11, 12, 14, ...
                  18, 20, 16, 17, 19, ...
                  23, 25, 21, 22, 24];
tmpExtractResult = extractResult;
extractResult = tmpExtractResult(permuteIndices, :);

%% Saving
save([folderPath 'extractResult.mat'], 'extractResult');

%% Ploting
figure




toc

end

