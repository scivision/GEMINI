function simdate = simdt(fid)

simdate = zeros(1,6);    %datevec-style array

simdatetmp = fread(fid,4,'real*8');

simdate(1:4) = simdatetmp;

end