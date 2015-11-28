function [ extractResult ] = ISSextractAfterPhoto( folderPath )
%ISSEXTRACTAFTERPHOTO Summary of this function goes here
%   This will extract watermark for only one images in the given folder.
%   Execute exmaple:
%       extractResult = ISSextractAfterPhoto('/Users/blue/Documents/MATLAB/104_1/MMSEC/HW1/experiment/attacked_image/12_photo/airplane/')

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
	lambda = str2num(parsedImgFileName{8});
	% lambda = str2num( parsedImgFileName{8}(1:(end-4)) );

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
	% oriImage = imread([ folderPath parsedFolderPath{end-1} '.bmp']);
	oriImage = imread([ '/Users/blue/Documents/MATLAB/104_1/MMSEC/HW1/some_test_images/' parsedFolderPath{end-1} '.bmp']);
	extractResult(idx, 4) = psnr(SuspImage, oriImage);
	extractResult(idx, 5) = ber;
end

%% Saving
save([folderPath 'extractResult.mat'], 'extractResult');


toc

end

