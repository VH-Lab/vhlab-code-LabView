function [framestack]=ReadInFramesSpecified(filename,whichtrials,nstim)
fid=fopen(filename)

%ndata=256*256*2*nsec;

thestarttime=fread(fid,4,'ulong')
size_x= fread(fid,1,'int16')
size_y= fread(fid,1,'int16')
frame_rate= fread(fid,1,'int16')
bin_duration =fread(fid,1,'int16')
nsec=fread(fid,1,'uint16')
bit_depth1= fread(fid,1,'int16')
fpos=ftell(fid);
ntrials=fread(fid,1,'int32');
% if (strcmp(whichtrials,'all')~=1)
% ntrials=nstim*max(whichtrials);
% end
ntrials
fseek(fid,25-4,0);

framestack= cell(ntrials,(nsec*(frame_rate/bin_duration)));
size(framestack)
for k=1:ntrials
    %read trial header
    intcheck=fread(fid,1,'int32');%%should be -9999
    trial=fread(fid,1,'uint32','l');%trial #, starting with 0
    stimnum=fread(fid,1,'int32');%
    trial_times=fread(fid,24,'char');%24
    fseek(fid,25,0);

    for m=1:(2*nsec)%wwas -0
        framestack{k,m}=[];
        %         framestack{k,m}=fread(fid,[size_x size_y],'double','l');
        %Modified by Pablo to read int16 instead of double - 25-Setp-2008
        framestack{k,m}=fread(fid,[size_x size_y],'int16','l');
        fseek(fid,8,0);
    end
    fseek(fid,-8,0);
end
