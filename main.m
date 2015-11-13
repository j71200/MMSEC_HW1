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

alpha_head = 0.1;
alpha_tail = 100;
alpha_slot = 100;
alpha = linspace(alpha_head, alpha_tail, alpha_slot);
alphaLenth = length(alpha);
lambda = 1;

mPSNR = zeros(alphaLenth, blkSizeListLen);
ber = zeros(alphaLenth, blkSizeListLen);

for blkSizeIdx = 1:blkSizeListLen
	blkSize = blkSizeList(blkSizeIdx);

	for idx = 1:alphaLenth
		[mPSNR(idx, blkSizeIdx) ber(idx, blkSizeIdx) ] = measuring( InputImage, alpha(idx), blkSize, lambda );
		disp( [num2str(round(((blkSizeIdx-1)*alphaLenth + idx)*100/(blkSizeListLen*alphaLenth))), '%'] );
	end

	
	%% Ploting normal PSNR figure
	psnrFig = figure;
	hold on;
	set(psnrFig, 'Visible', 'off');
	title(['block size = ', num2str(blkSize), '  capacity = ', num2str(capacityList(blkSizeIdx)), '  lambda = ', num2str(lambda)]);
	xlabel('alpha');
	ylabel('PSNR');
	plot(alpha, mPSNR(:, blkSizeIdx), 'r');
	psnrImageFileName = ['experiment\sliding_alpha\psnr\a_' num2str(alpha_head) '_' num2str(alpha_tail) '_' num2str(alpha_slot) '_b_' num2str(blkSize) '_l_' num2str(lambda) '_psnr.png'];
	saveas(psnrFig, psnrImageFileName);
	% Ploting line split PSNR figure
	% plot(...)


	%% Ploting normal BER figure
	berFig = figure;
	hold on;
	set(berFig, 'Visible', 'off');
	title(['block size = ', num2str(blkSize), '  capacity = ', num2str(capacityList(blkSizeIdx)), '  lambda = ', num2str(lambda)]);
	xlabel('alpha');
	ylabel('bit error rate');
	plot(alpha, ber(:, blkSizeIdx), 'b');
	berImageFileName = ['experiment\sliding_alpha\ber\a_' num2str(alpha_head) '_' num2str(alpha_tail) '_' num2str(alpha_slot) '_b_' num2str(blkSize) '_l_' num2str(lambda) '_ber.png'];
	saveas(berFig, berImageFileName);

end

%% For saving
% dataFileName = ['experiment/sliding_alpha/mat/a_0_b_', num2str(blkSize), '_l_', num2str(lambda), '.mat'];
dataFileName = ['alpha_' num2str(alpha_head) '_' num2str(alpha_tail) '_' num2str(alpha_slot) '.mat'];
save(dataFileName);
% save(dataFileName, 'mPSNR', 'ber');


%% Ploting multi-PSNR figure
multipsnrFig = figure;
hold on;
set(multipsnrFig, 'Visible', 'off');
title(['lambda = ', num2str(lambda)]);
% title(['block size = ', num2str(blkSize), '  capacity = ', num2str(capacity), '  lambda = ', num2str(lambda)]);
xlabel('alpha');
ylabel('PSNR');

plot(alpha, mPSNR(:, 1), '-', alpha, mPSNR(:, 2), '-o', alpha, mPSNR(:, 3), '-*', alpha, mPSNR(:, 4), '-s', alpha, mPSNR(:, 5), '-^');
legend(['block size = ' num2str(blkSizeList(1)) ' capacity = ' num2str(capacityList(1))], ['block size = ' num2str(blkSizeList(2)) ' capacity = ' num2str(capacityList(2))], ['block size = ' num2str(blkSizeList(3)) ' capacity = ' num2str(capacityList(3))], ['block size = ' num2str(blkSizeList(4)) ' capacity = ' num2str(capacityList(4))], ['block size = ' num2str(blkSizeList(5)) ' capacity = ' num2str(capacityList(5))] );

multipsnrImageFileName = ['experiment\sliding_alpha\psnr\a_' num2str(alpha_head) '_' num2str(alpha_tail) '_' num2str(alpha_slot) '_l_' num2str(lambda) '_multipsnr.png'];
% multipsnrImageFileName = ['experiment\sliding_alpha\psnr\a_0_b_0_l_', num2str(lambda), '_multipsnr.png'];
saveas(multipsnrFig, multipsnrImageFileName);


%% Ploting multi-BER figure
multiberFig = figure;
hold on;
set(multiberFig, 'Visible', 'off');
title(['lambda = ', num2str(lambda)]);
% title(['block size = ', num2str(blkSize), '  capacity = ', num2str(capacity), '  lambda = ', num2str(lambda)]);
xlabel('alpha');
ylabel('bit error rate');

plot(alpha, ber(:, 1), '-', alpha, ber(:, 2), '-o', alpha, ber(:, 3), '-*', alpha, ber(:, 4), '-s', alpha, ber(:, 5), '-^');
legend(['block size = ' num2str(blkSizeList(1)) ' capacity = ' num2str(capacityList(1))], ['block size = ' num2str(blkSizeList(2)) ' capacity = ' num2str(capacityList(2))], ['block size = ' num2str(blkSizeList(3)) ' capacity = ' num2str(capacityList(3))], ['block size = ' num2str(blkSizeList(4)) ' capacity = ' num2str(capacityList(4))], ['block size = ' num2str(blkSizeList(5)) ' capacity = ' num2str(capacityList(5))] );

multiberImageFileName = ['experiment\sliding_alpha\ber\a_' num2str(alpha_head) '_' num2str(alpha_tail) '_' num2str(alpha_slot) '_l_' num2str(lambda) '_multiber.png'];
% multiberImageFileName = ['experiment\sliding_alpha\ber\a_0_b_0_l_', num2str(lambda), '_multiber.png'];
saveas(multiberFig, multiberImageFileName);

toc

