% Computer Assignment 2: Part 1
% By: Matthew Mancuso

clear; clc;

windowLen = 0.050; % 50ms, see decodePhoneNumber.mat
frequencyTolerance = 0.05; % 5%, see decodePhoneNumber.mat
showGraphs = 1;

phoneNumber1 = decodePhoneNumber('phone1.wav', ...
    windowLen, frequencyTolerance, showGraphs);
phoneNumber2 = decodePhoneNumber('phone2.mat', ...
    windowLen, frequencyTolerance, showGraphs);

disp(phoneNumber1);
disp(phoneNumber2);