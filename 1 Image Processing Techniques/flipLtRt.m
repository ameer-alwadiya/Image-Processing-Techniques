function newIm = flipLtRt(im)
% newIm is impage im flipped from left to right

[nr,nc,np]= size(im);    % dimensions of im
newIm= zeros(nr,nc,np);  % initialize newIm with zeros
newIm= uint8(newIm);     % Matlab uses unsigned 8-bit int for color values


for r= 1:nr
    for c= 1:nc
        for p= 1:np
            newIm(r,c,p)= im(r,nc-c+1,p);
        end
    end
end

%% or another soultion:
% efficient way:
% function newIm = flipLtRt(im)
%     % newIm is image im flipped from left to right
% 
%     [nr, nc, np] = size(im); % dimensions of im
%     newIm = zeros(nr, nc, np, 'like', im); % initialize newIm with zeros
% 
%     for p = 1:np
%         % Flip each color channel horizontally
%         newIm(:, :, p) = im(:, end:-1:1, p);
%     end
% 
%     newIm = uint8(newIm); % Convert to uint8
% end