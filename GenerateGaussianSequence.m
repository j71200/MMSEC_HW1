function GenerateGaussianSequence(seqnum, seqlen)
% Generate N(0, 1) distributed random sequences and write to files, eg. Gaussian223.seq
% Parameters:
% (1) seqnum: # of sequences
% (2) seqlen: length of each sequence

for i = 1 : seqnum
	% create random sequnce file, e.g. Gaussian234.seq
	[fid message]=fopen(strcat('Gaussian', int2str(i), '.seq'), 'w');
	if (fid==-1)
		disp(message);
	end
    
	% generate N(0,1) sequence, whose length is determined by seqlen
	seq=randn(seqlen,1);
    
	% write to file
	fprintf(fid, '%g\n', seq);
    
	% close file
	fclose(fid);
end


