function [ mPSNR, ber ] = SSmeasuring( InputImage, alpha, blkSize )
%MEASURING Summary of this function goes here
%   Detailed explanation goes here

%% ISSembed process
	% Preprocessing - read original image
	% hint: imread()
	% InputImage = imread(InputImage_Path);

	
	% Prepoorcessing - generate watermark (n*1 +-1 vector)
	% hint: randn()+sign() or self-define
	% wmSize = 50;
	% watermark = sign(randn(wmSize, 1));
	

	% Watermark embedding settings - set alpha, blkSize, pattern
	% hint: randn()+sign() to generate pattern
	% alpha = 1;
	% blkSize = 8;
	% TODO: patternSize should small than the middle band
	patternSize = ceil(blkSize^2/3);
	pattern = sign(randn(patternSize, 1));
	
	% Generate watermark (fulfill the image)
	[height width ~] = size(InputImage);
	wmSize = floor(height/blkSize) * floor(width/blkSize);
	watermark = sign(randn(wmSize, 1));

	% Improved Spread Spectrum Embed
	% hint: ImprovedSpreadSpectrumEmbed()
	WMImage = SpreadSpectrumEmbed(InputImage, watermark, pattern, alpha, blkSize);
	% figure
	% imshow(WMImage)

	% Save watermarked image
	% hint: imwrite()
	% TODO:
	% imwrite()
	
	
%% Attack watermarked image
	% Read watermarked image
	% Attack
	% Save attacked image
	% hint: imread(), imwrite()


	
%% ISSextract process
	% Preprocessing - read attacked image
	% TODO:
	% hint: imread()
	
	
	
	% Watermark extraction settings - set pattern, blkSize, wmSize
	% hint: ImprovedSpreadSpectrumExtract()
	SuspImage = WMImage;
	extractWM = SpreadSpectrumExtract(SuspImage, pattern, blkSize, wmSize);
	% [watermark extractWM]
	
%% Measurement
	% Measuring capacity
	% hint: capacity = wmSize
	% capacity = wmSize;
	% display(capacity);
	
	
	% Measuring fidelity
	% hint: PSNR() psnr between (original image) and (watermarked or attacked image)
	mPSNR = psnr(WMImage, InputImage);
	% display(psnr);
	
	
	% Measuring robustness
	% hint: calculate bit error rate
	ber = nnz(extractWM - watermark) / wmSize;
	% display(ber);

end

