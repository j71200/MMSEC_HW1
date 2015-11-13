% Execute ISS embed and extract process
close all
clear('all');


%% Set path of images
    InputImage_Dir = 'some_test_images/';
    InputImage_Name1 = 'airplane.bmp';
    InputImage_Name2 = 'baboon.bmp';
    InputImage_Name3 = 'fruits.bmp';
    InputImage_Name4 = 'peppers.bmp';
    InputImage_Path = [InputImage_Dir InputImage_Name1];
	
	WMImage_Dir = 'watermarked_images/';
    WMImage_Name = 'peppers_wm.bmp';
    WMImage_Path = [WMImage_Dir WMImage_Name];
	
	AttackedImage_Dir = 'attacked_images/';
    AttackedImage_Name = 'peppers_att.bmp';
    AttackedImage_Path = [AttackedImage_Dir AttackedImage_Name];
	

%% ISSembed process	
	% Preprocessing - read original image
	% hint: imread()
	InputImage = imread(InputImage_Path);
	figure
	imshow(InputImage);

	
	% Prepoorcessing - generate watermark (n*1 +-1 vector)
	% hint: randn()+sign() or self-define
	% wmSize = 50;
	% watermark = sign(randn(wmSize, 1));
	

	% Watermark embedding settings - set alpha, lambda, blkSize, pattern
	% hint: randn()+sign() to generate pattern
	alpha = 1;
	lambda = 1;
	blkSize = 8;
	% TODO: patternSize should small than the middle band
	% patternSize = 20;
	patternSize = ceil(blkSize^2/3);
	pattern = sign(randn(patternSize, 1));
	
	% Generate watermark (fulfill the image)
	[height width dimension] = size(InputImage);
	wmSize = floor(height/blkSize) * floor(width/blkSize);
	watermark = sign(randn(wmSize, 1));

	% Improved Spread Spectrum Embed
	% hint: ImprovedSpreadSpectrumEmbed()
	WMImage = ImprovedSpreadSpectrumEmbed(InputImage, watermark, pattern, alpha, lambda, blkSize);
	figure
	imshow(WMImage)

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
	extractWM = ImprovedSpreadSpectrumExtract(SuspImage, pattern, blkSize, wmSize);
	% [watermark extractWM]
	
%% Measurement
	% Measuring capacity
	% hint: capacity = wmSize
	capacity = wmSize;
	display(capacity);
	
	
	% Measuring fidelity
	% hint: PSNR() psnr between (original image) and (watermarked or attacked image)
	psnr = psnr(WMImage, InputImage);
	display(psnr);
	
	
	% Measuring robustness
	% hint: calculate bit error rate
	ber = nnz(extractWM - watermark) / wmSize;
	display(ber);
	
