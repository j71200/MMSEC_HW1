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

%% Ploting multi-PSNR figure
figure
hold on;
title('lambda = 1');
xlabel('alpha');
ylabel('PSNR');

alphaList = [0.2, 0.3, 0.4, 0.5, 0.6]';
blkSizeList = [4, 8, 16, 32, 64]';
capacityList = floor(height./blkSizeList) .* floor(width./blkSizeList);
idxOfBlksize4  = [1, 6, 11, 16, 21];
idxOfBlksize8  = [2, 7, 12, 17, 22];
idxOfBlksize16 = [3, 8, 13, 18, 23];
idxOfBlksize32 = [4, 9, 14, 19, 24];
idxOfBlksize64 = [5, 10, 15, 20, 25];

plot(alphaList, extractResult(idxOfBlksize4, 4), '-', alphaList, extractResult(idxOfBlksize8, 4), '-o', alphaList, extractResult(idxOfBlksize16, 4), '-*', alphaList, extractResult(idxOfBlksize32, 4), '-s', alphaList, extractResult(idxOfBlksize64, 4), '-^');
legend(['block size = ' num2str(blkSizeList(1)) ' capacity = ' num2str(capacityList(1))], ['block size = ' num2str(blkSizeList(2)) ' capacity = ' num2str(capacityList(2))], ['block size = ' num2str(blkSizeList(3)) ' capacity = ' num2str(capacityList(3))], ['block size = ' num2str(blkSizeList(4)) ' capacity = ' num2str(capacityList(4))], ['block size = ' num2str(blkSizeList(5)) ' capacity = ' num2str(capacityList(5))] );


%% Ploting multi-BER figure
figure;
hold on;
title('lambda = 1');
xlabel('alpha');
ylabel('bit error rate');

plot(alphaList, extractResult(idxOfBlksize4, 5), '-', alphaList, extractResult(idxOfBlksize8, 5), '-o', alphaList, extractResult(idxOfBlksize16, 5), '-*', alphaList, extractResult(idxOfBlksize32, 5), '-s', alphaList, extractResult(idxOfBlksize64, 5), '-^');
legend(['block size = ' num2str(blkSizeList(1)) ' capacity = ' num2str(capacityList(1))], ['block size = ' num2str(blkSizeList(2)) ' capacity = ' num2str(capacityList(2))], ['block size = ' num2str(blkSizeList(3)) ' capacity = ' num2str(capacityList(3))], ['block size = ' num2str(blkSizeList(4)) ' capacity = ' num2str(capacityList(4))], ['block size = ' num2str(blkSizeList(5)) ' capacity = ' num2str(capacityList(5))] );


toc

end

