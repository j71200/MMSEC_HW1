function extractWM = ImprovedSpreadSpectrumExtract(SuspImage, pattern, blkSize, wmSize)
	% Extract watermark from an image according to improved spread spectrum watermarking algorithm

	% Parameters:
	% (1) SuspImage: Suspicious image (M*N*3 unsigned integer matrix)
	% (2) pattern: extract pattern (m*1  +-1 vector)
	% (3) blkSize: block size for block DCT (positive integer)
	% (4) wmSize: length of watermark (positive integer)
	%
	% Output:
	% (1) extractWM: extract watermark (n*1  +-1 vector)


	% preprocessing - change color space and get image size
	% hint: rgb2ycbcr()
	%			Transform RGBImage to YCbCrImage
	%		size()
	%			get imageSize
	YCbCr_SuspImage = rgb2ycbcr(SuspImage);
	Y_SuspImage = YCbCr_SuspImage(:,:,1);
	imageSize = size(Y_SuspImage);

	
	% Preprocessing - preparing zigzag scan index
	% hint: use ZigzagOrder.m
	%		You can use the following code to get scan index
	%			zzOrder = ZigzagOrder(blkSize);
	%			zzOrder = reshape(zzOrder, 1, []);
	%			[~, zzOrder]= sort(zzOrder,'ascend');
	%			% zzOrder(i) means the position of i-th coefficient in zigzag order
	%		Specify extract position(the same as embedding process)
	zzOrder = ZigzagOrder(blkSize);
	zzOrder = reshape(zzOrder, 1, []);
	[~, zzOrder]= sort(zzOrder,'ascend');


	% Do blockDCT
	blockIdx = 0;
	if wmSize > 0
		isWatermarkEnd = false;
	else
		isWatermarkEnd = true;
	end

	extractWM = zeros(wmSize, 1);
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
			% Ex: tmpBlock = Y_SuspImage(iStart:iEnd, jStart:jEnd);
			blockIdx = blockIdx + 1;
			if blockIdx > wmSize;
				isWatermarkEnd = true;
				break;
			end
			tmpBlock = Y_SuspImage(iStart:iEnd, jStart:jEnd);
			
			
			% Extract each bit of watermark:
			% hint:
			%		dct2()
			%		reshape()
			%			reshape block into a blkSize^2*1 vector
			%		use spepcified embedding position to extract s
			%		sim = <s,u>/<u,u>
			%			where s,u is a vector
			%		extract watermark bit
			%			extract bit = sign(sim)
			
			suspBlock = dct2(tmpBlock);
			midBandStartIdx = ceil(blkSize^2/3);

			wmBlock = dct2(tmpBlock);
			% TODO: Assume middle band is exactly one third of the block
			midBandStartIdx = ceil(blkSize^2/3);
			s = wmBlock(zzOrder( midBandStartIdx : midBandStartIdx + length(pattern) - 1 ))';
			sim = (s'*pattern)/(pattern'*pattern);
			b_extracted = sign(sim);
			
			extractWM(blockIdx) = b_extracted;
			end
	end

end