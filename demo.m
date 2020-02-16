% Generate Boundary for Chan-Vese method
% Copyright 2019 by thanh.dnh.cs@gmail.com
% Chan-Vese method is implemented by prof. Wu of Tuft University
% ==========================================

close all;
clear all;
path = 'C:\Users\dnhth\Desktop\Segmentation_Chan_Vese';
Inputs=dir(strcat(path, '\input\*.jpg'));
pause('on');

len = length(Inputs);
numd = 5;

fileids = strings(numd*length(Inputs),1);
methods = strings(numd*length(Inputs),1);
sobels = zeros(numd*length(Inputs),1);
prewitts = zeros(numd*length(Inputs),1);
roberts = zeros(numd*length(Inputs),1);
cannys = zeros(numd*length(Inputs),1);
circles = zeros(numd*length(Inputs),1);

for k=1:len
I = imread(strcat(Inputs(k).folder, '\' , Inputs(k).name));
channel = [1,1];
ch = strsplit(Inputs(k).name, '-');

switch(ch{1})
    case 'r'
        channel = [1,1];
    case 'rg'
        channel = [1,2];
    case 'gb'
        channel = [2,3];
    case 'g'
        channel = [2, 2];
    case 'b'
        channel = [3, 3];
end

for i=1:4
   if(i==1)
       mask1 = GenerateBoundaries(I(:,:,channel(1)), 'sobel');
       if(channel(1)~=channel(2))
           mask2 = GenerateBoundaries(I(:,:,channel(2)), 'sobel');
       else
           mask2 = mask1;
       end
       mask(:,:,1)=mask1;
       mask(:,:,2)=mask2;
       pre = '_sobel';
   elseif(i==2)
       mask1 = GenerateBoundaries(I(:,:,channel(1)), 'prewitt');
       if(channel(1)~=channel(2))
           mask2 = GenerateBoundaries(I(:,:,channel(2)), 'prewitt');
       else
           mask2 = mask1;
       end
       mask(:,:,1)=mask1;
       mask(:,:,2)=mask2;
       pre = '_prewitt';
   elseif(i==3)
       mask1 = GenerateBoundaries(I(:,:,channel(1)), 'roberts');
       if(channel(1)~=channel(2))
           mask2 = GenerateBoundaries(I(:,:,channel(2)), 'roberts');
       else
           mask2 = mask1;
       end
       mask(:,:,1)=mask1;
       mask(:,:,2)=mask2;
       pre = '_roberts';
   elseif(i==4)
       mask1 = GenerateBoundaries(I(:,:,channel(1)), 'approxcanny');
       if(channel(1)~=channel(2))
           mask2 = GenerateBoundaries(I(:,:,channel(2)), 'approxcanny');
       else
           mask2 = mask1;
       end
       mask(:,:,1)=mask1;
       mask(:,:,2)=mask2;
       pre = '_canny';
   else
       mask = 'whole';
       pre = '_circle';
   end
   methods(numd*(k-1)+i)=pre;
   
   % =============================================
   % from lib: chanvese(I,mask,num_iter,mu,method)
   [res, st] = chanvese(I,mask,5000,0.1, 'chan'); 
   
   fname = strsplit(Inputs(k).name,'.');
   imwrite(res, strcat(path, '\output\', fname{1}, pre, '.', fname{2}));
   fileids(numd*(k-1)+i)=Inputs(k).name;
   if(i==1)
       sobels(numd*(k-1)+i)=st;
   elseif(i==2)
       prewitts(numd*(k-1)+i)=st;
   elseif(i==3)
       roberts(numd*(k-1)+i)=st;
   elseif(i==4)
       cannys(numd*(k-1)+i)=st;
   elseif(i==5)
       circles(numd*(k-1)+i)=st;
   end
end

end
exporter = [fileids methods sobels prewitts roberts cannys circles];
xlswrite(strcat(path,'\output\result.xlsx'), exporter);
