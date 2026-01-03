clear all; 
close all; 
clc;                       
%% Hardware Accelerator for Convolution - Image Response Test

% 1. Input Image Load   
input_rgb = imread('test_image.jpg'); 

% Grayscale conversion 
if size(input_rgb, 3) == 3
    I = rgb2gray(input_rgb);
else
    I = input_rgb;
end


I = double(I); % For Math operations double conversion

% 2. Define Your Kernel 
kernel = [ -1 -1 -1; 
           -1  8 -1; 
           -1 -1 -1 ];

% 3. Convolution Operation (Hardware Logic Simulation)
[rows, cols] = size(I);
output_img = zeros(rows, cols);

% Padding 
padded_I = padarray(I, [1, 1], 0);

% Sliding Window Logic (Exactly like your Hardware Line Buffers)
for i = 1:rows
    for j = 1:cols
        % 3x3 window extract karna
        window = padded_I(i:i+2, j:j+2);
        
        % Multiply and Accumulate (MAC)
        result = sum(sum(window .* kernel));
        
        % Output Pixel (Pixel value range 0-255)
        output_img(i,j) = result;
    end
end

% 4. Post-Processing
output_img = uint8(abs(output_img)); % For Negative values 

% 5. Results Display
figure('Name', 'Hardware Accelerator Verification');

subplot(1,2,1);
imshow(uint8(I));
title('Original Input Image');

subplot(1,2,2);
imshow(output_img);
title('Accelerator Output (Convolution)');

fprintf('Testing Complete. Image response generated successfully.\n');