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
[height width ~] = size(InputImage);

blkSizeList = [4, 8, 16, 32, 64]';
blkSizeListLen = length(blkSizeList);
capacityList = floor(height./blkSizeList) .* floor(width./blkSizeList);

lambda_head = 0.1;
lambda_tail = 1;
lambda_slot = 20;
lambda = linspace(lambda_head, lambda_tail, lambda_slot);
lambdaLenth = length(lambda);
alpha = 0.5;

mPSNR = zeros(lambdaLenth, blkSizeListLen);
ber = zeros(lambdaLenth, blkSizeListLen);

for blkSizeIdx = 1:blkSizeListLen
	blkSize = blkSizeList(blkSizeIdx);

	for idx = 1:lambdaLenth
		[mPSNR(idx, blkSizeIdx) ber(idx, blkSizeIdx) ] = measuring( InputImage, alpha, blkSize, lambda(idx) );
		disp( [num2str(round(((blkSizeIdx-1)*lambdaLenth + idx)*100/(blkSizeListLen*lambdaLenth))), '%'] );
	end

	
	%% Ploting normal PSNR figure
	psnrFig = figure;
	hold on;
	set(psnrFig, 'Visible', 'off');
	title(['block size = ', num2str(blkSize), '  capacity = ', num2str(capacityList(blkSizeIdx)), '  alpha = ', num2str(alpha)]);
	xlabel('lambda');
	ylabel('PSNR');
	plot(lambda, mPSNR(:, blkSizeIdx), 'r');
	psnrImageFileName = ['experiment\sliding_lambda\psnr\a_' num2str(alpha) '_b_' num2str(blkSize) '_l_' num2str(lambda_head) '_' num2str(lambda_tail) '_' num2str(lambda_slot) '_psnr.png'];
	saveas(psnrFig, psnrImageFileName);


	%% Ploting normal BER figure
	berFig = figure;
	hold on;
	set(berFig, 'Visible', 'off');
	title(['block size = ', num2str(blkSize), '  capacity = ', num2str(capacityList(blkSizeIdx)), '  alpha = ', num2str(alpha)]);
	xlabel('lambda');
	ylabel('bit error rate');
	plot(lambda, ber(:, blkSizeIdx), 'b');
	berImageFileName = ['experiment\sliding_lambda\ber\a_' num2str(alpha) '_b_' num2str(blkSize) '_l_' num2str(lambda_head) '_' num2str(lambda_tail) '_' num2str(lambda_slot) '_ber.png'];
	saveas(berFig, berImageFileName);

end

%% For saving
dataFileName = ['lambda_' num2str(lambda_head) '_' num2str(lambda_tail) '_' num2str(lambda_slot) '.mat'];
save(dataFileName);


%% Ploting multi-PSNR figure
multipsnrFig = figure;
hold on;
set(multipsnrFig, 'Visible', 'off');
title(['alpha = ', num2str(alpha)]);
xlabel('lambda');
ylabel('PSNR');

plot(lambda, mPSNR(:, 1), '-', lambda, mPSNR(:, 2), '-o', lambda, mPSNR(:, 3), '-*', lambda, mPSNR(:, 4), '-s', lambda, mPSNR(:, 5), '-^');
legend(['block size = ' num2str(blkSizeList(1)) ' capacity = ' num2str(capacityList(1))], ['block size = ' num2str(blkSizeList(2)) ' capacity = ' num2str(capacityList(2))], ['block size = ' num2str(blkSizeList(3)) ' capacity = ' num2str(capacityList(3))], ['block size = ' num2str(blkSizeList(4)) ' capacity = ' num2str(capacityList(4))], ['block size = ' num2str(blkSizeList(5)) ' capacity = ' num2str(capacityList(5))] );
multipsnrImageFileName = ['experiment\sliding_lambda\psnr\a_' num2str(alpha) '_b_' num2str(blkSize) '_l_' num2str(lambda_head) '_' num2str(lambda_tail) '_' num2str(lambda_slot) '_multipsnr.png'];
saveas(multipsnrFig, multipsnrImageFileName);


%% Ploting multi-BER figure
multiberFig = figure;
hold on;
set(multiberFig, 'Visible', 'off');
title(['alpha = ', num2str(alpha)]);
xlabel('lambda');
ylabel('bit error rate');

plot(lambda, ber(:, 1), '-', lambda, ber(:, 2), '-o', lambda, ber(:, 3), '-*', lambda, ber(:, 4), '-s', lambda, ber(:, 5), '-^');
legend(['block size = ' num2str(blkSizeList(1)) ' capacity = ' num2str(capacityList(1))], ['block size = ' num2str(blkSizeList(2)) ' capacity = ' num2str(capacityList(2))], ['block size = ' num2str(blkSizeList(3)) ' capacity = ' num2str(capacityList(3))], ['block size = ' num2str(blkSizeList(4)) ' capacity = ' num2str(capacityList(4))], ['block size = ' num2str(blkSizeList(5)) ' capacity = ' num2str(capacityList(5))] );

multiberImageFileName = ['experiment\sliding_lambda\ber\a_' num2str(alpha) '_b_' num2str(blkSize) '_l_' num2str(lambda_head) '_' num2str(lambda_tail) '_' num2str(lambda_slot) '_multiber.png'];
saveas(multiberFig, multiberImageFileName);

toc

