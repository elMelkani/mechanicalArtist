%clear all
clc
 
mat = imread('smallTri.png');
M = rgb2gray(mat);

arduino=serial('COM3','BaudRate',9600);
 
fopen(arduino);
arduino.Timeout = 40;

shapeOfM = size(M);
rows = shapeOfM(1);
columns = shapeOfM(2);

%Assume rows and colums are 60 each
R = 60;

Xmat = zeros(60,60);
Ymat = zeros(60,60);
yMax = 0;
yMin = 99999;
xMax = 0;
xMin = 99999;

for theta = 0:1:59
    for alpha = 70:1:129
        X = R*cos(pi*theta/180) + R*cos(pi*(theta + alpha)/180);
        Y = 60 - ( R*sin(pi*theta/180) + R*sin(pi*(theta + alpha)/180) - R);
        if Y > yMax
            yMax = Y;
        end
        if Y < yMin
            yMin = Y;
        end
        if X > xMax
            xMax = X;
        end
        if X < xMin
            xMin = X;
        end
        Xmat(theta+1,alpha-69) = X;
        Ymat(theta+1,alpha-69) = Y;
    end
end
Ymat = Ymat - yMin + 1;
Ymat = 60*Ymat/(yMax - yMin + 1);
Xmat = Xmat - xMin + 1;
Xmat = 60*Xmat/(xMax - xMin + 1);

Ymat = round(Ymat);
Xmat = round(Xmat);

newArray = zeros(60,60);

done = 0;

for theta = 0:1:59
    for alpha = 70:1:129
        if M(Xmat(theta+1,alpha-69), Ymat(theta+1,alpha-69)) > 200
            fwrite(arduino,uint8(0),'uint8'); %pen up
            newArray(theta+1,alpha-69) = 0;
        else
            fwrite(arduino,uint8(1),'uint8'); %pen down
            newArray(theta+1,alpha-69) = 1;
        end
        %newArray(Xmat(theta+1,alpha-69), Ymat(theta+1,alpha-69)) = newArray(Xmat(theta+1,alpha-69), Ymat(theta+1,alpha-69)) + 1;
    end
    pause(4.5);
    disp(theta);
    %done = fread(arduino,1,'uint8');
end

fclose(arduino);
