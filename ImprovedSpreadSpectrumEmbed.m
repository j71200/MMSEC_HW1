function WMImage = ImprovedSpreadSpectrumEmbed(InputImage, watermark, pattern, alpha, lambda, blkSize)
	% Embed watermark into an image according to improved spread spectrum watermarking algorithm

	% Parameters:
	% (1) InputImage: Cover image	(M*N*3 unsign integer matrix)
	% (2) watermark: wm sequence (n*1  +-1 vector)
	% (3) pattern: extract pattern (m*1  +-1 vector)
	% (4) alpha: the strength of the watermark (positive real number around 0.1~100)
	% (5) lambda: the parameter of interference from cover image (positive real number around 1)
	% (6) blkSize: specify block size for block DCT (positive integer)
	%
	% Output:
	% (1) WMImage: Watermarked image (M*N*3 unsign integer matrix)



	% Preprocessing - change color space and get image size
	% hint: rgb2ycbcr()
	%			Transform RGBImage to YCbCrImage
	%		size()
	%			get imageSize
	YCbCr_InputImage = rgb2ycbcr(InputImage);
	Y_WMImage = YCbCr_InputImage(:,:,1);
	imageSize = size(Y_WMImage);


	% Preprocessing - preparing zigzag scan index
	% hint: use ZigzagOrder.m
	%		You can use the following code to get scan index
	%			zzOrder = ZigzagOrder(blkSize);
	%			zzOrder = reshape(zzOrder, 1, []);
	%			[~, zzOrder]= sort(zzOrder,'ascend');
	%			% zzOrder(i) means the position of i-th coefficient in zigzag order
	%		Decide what position you want to embed message
	zzOrder = ZigzagOrder(blkSize);
	zzOrder = reshape(zzOrder, 1, []);
	[~, zzOrder]= sort(zzOrder,'ascend');

	% Do blockDCT
	blockIdx = 0;
	if length(watermark) > 0
		isWatermarkEnd = false;
	else
		isWatermarkEnd = true;
	end
	
	for i = 1 : floor(imageSize(1)/blkSize)
		if isWatermarkEnd
			break;
		end
		iStart =  1 + (i-1) * blkSize;
		iEnd = iStart + blkSize - 1;
		for j = 1 : floor(imageSize(2)/blkSize)
			jStart = 1 + (j-1) * blkSize;
			jEnd = jStart + blkSize - 1;
			
			% Extract block information
			% Ex: tmpBlock = Y_Image(iStart:iEnd, jStart:jEnd);
			blockIdx = blockIdx + 1;
			if blockIdx > length(watermark);
				isWatermarkEnd = true;
				break;
			end
			tmpBlock = Y_WMImage(iStart:iEnd, jStart:jEnd);
			
			
			% Embedding each bit of watermark into each block:
			% hint:
			%		dct2()
			%		reshape()
			%			reshape block into a blkSize^2*1 vector
			%		Embed data into block
			%			s = x + (alpha*b - lamda*<x,u>/<u,u>)u
			%				where s,x,u is a vector
			%		idct2()
			wmBlock = dct2(tmpBlock);
			% TODO: Assume middle band is exactly one third of the block
			midBandStartIdx = ceil(blkSize^2/3);
			x = wmBlock(zzOrder( midBandStartIdx : midBandStartIdx + length(pattern) - 1 ))';
			b = watermark(blockIdx);
			s = x + (alpha*b - lambda*(x'*pattern)/(pattern'*pattern))*pattern;
			wmBlock(zzOrder( midBandStartIdx : midBandStartIdx + length(pattern) - 1 )) = s;
			wmBlock = idct2(wmBlock);
			
			
			% Write watermarked block to Y_WMImage
			% Ex: Y_WMImage(iStart:iEnd, jStart:jEnd) = wmBlock;
			Y_WMImage(iStart:iEnd, jStart:jEnd) = wmBlock;
			
			
			end
	end


	% Transform back to RGB color space
	% hint: ycbcr2rgb()
	YCbCr_InputImage(:,:,1) = Y_WMImage;
	WMImage = ycbcr2rgb(YCbCr_InputImage);
	

end