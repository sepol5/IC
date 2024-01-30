function mostra()
x=imread('0_star.png')
%imshow(I)
title('Input Image')
 y=imbinarize(x)
 %figure,imshow(I1)
 title('binary Image')
%imshow(x);
%title('Original Image')
y1=imresize(x,0.5);
imshow(y);
%title('resize Image')
end