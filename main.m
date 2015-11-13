close all
clear('all');
clc

tic

InputImage_Dir = 'some_test_images/';
InputImage_Name1 = 'airplane.bmp';
InputImage_Name2 = 'baboon.bmp';
InputImage_Name3 = 'fruits.bmp';
InputImage_Name4 = 'peppers.bmp';
InputImage_Path = [InputImage_Dir InputImage_Name1];

InputImage = imread(InputImage_Path);


blkSizeList = [4, 8, 16, 32, 64]';

alpha = linspace(0.1, 100, 100);
lambda = 1;

for blkSizeIdx = 1:5
	blkSize = blkSizeList(blkSizeIdx);
	[height width ~] = size(InputImage);
	capacity = floor(height/blkSize) * floor(width/blkSize);

	mPSNR = zeros(100, 1);
	ber = zeros(100, 1);

	for idx = 1:100
		[mPSNR(idx) ber(idx) ] = measuring( InputImage, alpha(idx), blkSize, lambda );
		disp( (blkSizeIdx-1)*100 + idx );
	end

	psnrFig = figure;
	hold on;
	set(psnrFig, 'Visible', 'off');
	title(['block size = ', num2str(blkSize), '  capacity = ', num2str(capacity), '  lambda = ', num2str(lambda)]);
	xlabel('alpha');
	ylabel('PSNR');
	plot(alpha, mPSNR, 'r');
	psnrImageFileName = ['experiment\sliding_alpha\a_0_b_', num2str(blkSize), '_l_', num2str(lambda), '_psnr.png'];
	saveas(psnrFig, psnrImageFileName);

	berFig = figure;
	hold on;
	set(berFig, 'Visible', 'off');
	title(['block size = ', num2str(blkSize), '  capacity = ', num2str(capacity), '  lambda = ', num2str(lambda)]);
	xlabel('alpha');
	ylabel('bit error rate');
	plot(alpha, ber, 'b');
	berImageFileName = ['experiment\sliding_alpha\a_0_b_', num2str(blkSize), '_l_', num2str(lambda), '_ber.png'];
	saveas(berFig, berImageFileName);

end

toc

