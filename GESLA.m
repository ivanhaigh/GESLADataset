function [dt,sl,f1,f2,lat,lon] = GESLA(file)
% Function to load data in GESLA-3 files
% INPUT: 
%    file -> name of the individual file in GESLA format
% OUTPUT:
%    dt-> time in datenum 
%    sl -> tide gauge sea level measurements (with or wo flag corrections)
%    f1 -> flag - column 4
%    f2 -> flag - column 5
%    lat -> latitude
%    lon -> longitude
% 
% Removes wrong values as defined in metadata
% Removes NULL values as defined in metadata
%... Marta Marcos and Ivan Haigh, September 2021...

headerlength=41;
%...Import data and metadata
A=importdata(file,' ',headerlength);

%...Transform time to datenum format 
date=datenum(A.textdata(headerlength+1:end,1),'yyyy/mm/dd');
hour=datenum(A.textdata(headerlength+1:end,2),'HH:MM:SS');
hour=hour-floor(hour(1));
dt=date+hour;

%...Read sea level observations 
sl=A.data(:,1);

% remove incorrect values (according to flag in column 5)
f1=A.data(:,2);
f2=A.data(:,3);
sl(f2==0)=NaN;

%...Read lat & lon
line=cellfun(@(x)strfind(x,'LATITUDE'),A.textdata(1:headerlength,1),'UniformOutput',0);
line=cellfun(@isempty,line);
line=find(line~=1);
lat=A.textdata(line,1);
lat=extractAfter(lat,'# LATITUDE');
lat=str2double(char(lat));
line=cellfun(@(x)strfind(x,'LONGITUDE'),A.textdata(1:headerlength,1),'UniformOutput',0);
line=cellfun(@isempty,line);
line=find(line~=1);
lon=A.textdata(line,1);
lon=extractAfter(lon,'# LONGITUDE');
lon=str2double(char(lon));

end
