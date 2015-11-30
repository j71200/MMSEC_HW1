function [ ] = SSembed( InputImagePath )
%SSEMBED Summary of this function goes here
%   This will extract watermark for all images in the given folder.
%   Execute exmaple:
%       SSembed('/Users/blue/Documents/MATLAB/104_1/MMSEC/HW1/experiment/watermarked_image/airplane.bmp')

tic

InputImage = imread(InputImagePath);
[height width ~] = size(InputImage);
lambda = 1;

blkSizeList = [4, 8, 16, 32, 64]';
blkSizeListLen = length(blkSizeList);
alphaList = [0.2, 0.3, 0.4, 0.5, 0.6]';
alphaListLen = length(alphaList);

load('data.mat');

for blkSizeIdx = 1:blkSizeListLen
	blkSize = blkSizeList(blkSizeIdx);
	patternSize = ceil(blkSize^2/3);
	pattern = pattern_1366bit(1:patternSize);
	wmSize = floor(height/blkSize) * floor(width/blkSize);
	watermark = watermark_16384bit(1:wmSize);

	for alphaIdx = 1:alphaListLen

		disp([ num2str(100*((blkSizeIdx-1)*blkSizeListLen + alphaIdx)/(blkSizeListLen*alphaListLen)) '%']);

		alpha = alphaList(alphaIdx);

		WMImage = ImprovedSpreadSpectrumEmbed(InputImage, watermark, pattern, alpha, lambda, blkSize);

		OutputWMImagePath = [InputImagePath(1:end-4) '_wm_a_' num2str(alpha) '_b_' num2str(blkSize) '_l_' num2str(lambda) '.png'];

		imwrite(WMImage, OutputWMImagePath);

	end
end

toc


end

