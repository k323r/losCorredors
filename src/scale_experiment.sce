// CLEAR PATH
clear();
clearglobal();

// LOAD Functions
getd('./');

// get path to the offset measurement file:
// driftfile = uigetfile();
// /home/asander/Projekte/losCorredors/data/Waage/Kraftmessungen_Loko_WS16

driftfile = '../data/Waage/Kalibrierung/Waagendrift_clean.txt';
offsetDataRaw = fscanfMat(driftfile);

// xCalFile = uigetfile();
xCalFile = '../data/Waage/Kalibrierung/XKali_clean.txt';
xCalRaw = fscanfMat(xCalFile);

// yCalFile = uigetfile();
yCalFile = '../data/Waage/Kalibrierung/YKali_clean.txt';
yCalRaw = fscanfMat(yCalFile);

zCalFile = '../data/Waage/Kalibrierung/ZKali_clean.txt';
zCalRaw = fscanfMat(zCalFile);

// FORMATTING OF THE FILE RAW FILE:
//Channel
//1 time
//2 x1+x2
//3 x3+x4
//4 y1+y4
//5 y2+y3
//6:89 z1:z4

// INDEXING OFF THE DATA STRUCTURES
// 2 -> X
// 3 -> Y
// 4 -> Z -> main axis, hence four channels

// OFFSET AND DRIFT
// combine the channels into a global data structure
offsetData(:,1) = offsetDataRaw(:,1);
offsetData(:,2) = offsetDataRaw(:,2) + offsetDataRaw(:,3);
offsetData(:,3) = offsetDataRaw(:,4) + offsetDataRaw(:,5);
offsetData(:,4) = offsetDataRaw(:,6) + offsetDataRaw(:,7) + offsetDataRaw(:,8) + offsetDataRaw(:,9);

// X AXIS CALIBRATION
// combine the channels into a global data structure
xCal(:,1) = xCalRaw(:,1);
xCal(:,2) = xCalRaw(:,2) + xCalRaw(:,3);
xCal(:,3) = xCalRaw(:,4) + xCalRaw(:,5);
xCal(:,4) = xCalRaw(:,6) + xCalRaw(:,7) + xCalRaw(:,8) + xCalRaw(:,9);

// Y AXIS CALIBRATION
// combine the channels into a global data structure
yCal(:,1) = yCalRaw(:,1);
yCal(:,2) = yCalRaw(:,2) + yCalRaw(:,3);
yCal(:,3) = yCalRaw(:,4) + yCalRaw(:,5);
yCal(:,4) = yCalRaw(:,6) + yCalRaw(:,7) + yCalRaw(:,8) + yCalRaw(:,9);

// Z AXIS CALIBRATION
// combine the channels into a global data structure
zCal(:,1) = zCalRaw(:,1);
zCal(:,2) = zCalRaw(:,2) + zCalRaw(:,3);
zCal(:,3) = zCalRaw(:,4) + zCalRaw(:,5);
zCal(:,4) = zCalRaw(:,6) + zCalRaw(:,7) + zCalRaw(:,8) + zCalRaw(:,9);


// calculate linear regression of the scale
[ scaleOffsetXSLOPE, scaleOffsetXOFFSET, scaleOffsetXSIGMA ]= reglin( offsetData(:,1)', offsetData(:,2)' );
[ scaleOffsetYSLOPE, scaleOffsetYOFFSET, scaleOffsetYSIGMA ]= reglin( offsetData(:,1)', offsetData(:,3)' );
[ scaleOffsetZSLOPE, scaleOffsetZOFFSET, scaleOffsetZSIGMA ]= reglin( offsetData(:,1)', offsetData(:,4)' );

// add labels n stuff to the plot and save it!
// plot(offsetData(:,1),[offsetData(:,2) scaleOffsetSLOPE * offsetData(:,1) + scaleOffsetYOFFSET])
// plot( offsetData(:,1), [offsetData(:,2) - scaleOffsetSLOPE * offsetData(:,1) - scaleOffsetYOFFSET] )

// messwerte (in VOLT) welche mit den gewichten korreliert werden müssen
meanVoltageX = [ mean(xCal(5000:6000, 2)), mean(xCal(10000:11000, 2)), mean(xCal(15000:16000, 2)), mean(xCal(20000:21000, 2)) ]; 
meanVoltageY = [ mean(yCal(5000:6000, 3)), mean(yCal(10000:11000, 3)), mean(yCal(15000:16000, 3)), mean(yCal(20000:21000, 3)) ];
meanVoltageZ = [ mean(zCal(5000:6000, 4)), mean(zCal(10000:11000, 4)), mean(zCal(20000:21000, 4)), mean(zCal(30000:31000, 4)) ];

kg = [0, 1, 3.6, 7.75]; // kalibrationsgewichte

[ scaleVoltageXSLOPE, scaleVoltageXOFFSET, scaleVoltageXSIGMA ] = reglin( meanVoltageX, kg );
[ scaleVoltageYSLOPE, scaleVoltageYOFFSET, scaleVoltageYSIGMA ] = reglin( meanVoltageY, kg );
[ scaleVoltageZSLOPE, scaleVoltageZOFFSET, scaleVoltageZSIGMA ] = reglin( meanVoltageZ, kg );

// plot(xCal(:,2))
// plot( (xCal(:,2) - (xCal(:,1)*scaleOffsetXSLOPE + scaleOffsetXOFFSET)) * scaleVoltageXSLOPE);
// plot( (yCal(:,3) - (yCal(:,1)*scaleOffsetYSLOPE + scaleOffsetYOFFSET)) * scaleVoltageYSLOPE);
// plot( (zCal(:,4) - (zCal(:,1)*scaleOffsetZSLOPE + scaleOffsetZOFFSET)) * scaleVoltageZSLOPE);
// plot(xCal(:,1), xCal(:,2))
// plot(xCal(:,1)

