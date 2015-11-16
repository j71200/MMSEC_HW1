function [ ] = ISSembed( InputImagePath )
%ISSEMBED Summary of this function goes here
%   Detailed explanation goes here

tic

InputImage = imread(InputImagePath);
[height width ~] = size(InputImage);
lambda = 1;


blkSizeList = [4, 8, 16, 32, 64]';
blkSizeListLen = length(blkSizeList);
alphaList = [0.2, 0.3, 0.4, 0.5, 100]';
alphaListLen = length(alphaList);

for blkSizeIdx = 1:blkSizeListLen
	blkSize = blkSizeList(blkSizeIdx);
	patternSize = ceil(blkSize^2/3);
	wmSize = floor(height/blkSize) * floor(width/blkSize);

	for alphaIdx = 1:alphaListLen

		disp([ num2str(100*((blkSizeIdx-1)*blkSizeListLen + alphaIdx)/(blkSizeListLen*alphaListLen)) '%']);

		alpha = alphaList(alphaIdx);
		pattern = sign(randn(patternSize, 1));
		
		watermark = sign(randn(wmSize, 1));

		WMImage = ImprovedSpreadSpectrumEmbed(InputImage, watermark, pattern, alpha, lambda, blkSize);

		OutputWMImagePath = [InputImagePath(1:end-4) '_wm_a_' num2str(alpha) '_b_' num2str(blkSize) '_l_' num2str(lambda) '.png'];

		imwrite(WMImage, OutputWMImagePath);

	end
end

toc


end

