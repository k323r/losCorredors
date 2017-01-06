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

langsamFile = '../data/Waage/Kraftmessungen_Loko_WS16/Aljoscha/langsam.txt';
langsamRaw = fscanfMat(langsamFile);

normalFile = '../data/Waage/Kraftmessungen_Loko_WS16/Aljoscha/angenehm.txt';
normalRaw = fscanfMat(normalFile);

schnellFile = '../data/Waage/Kraftmessungen_Loko_WS16/Aljoscha/schnell.txt';
schnellRaw = fscanfMat(schnellFile);

// FORMATTING OF THE RAW FILE:
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
//combine the channels into a global data structure
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

langsam(:,1) = langsamRaw(:,1);
langsam(:,2) = langsamRaw(:,2) + langsamRaw(:,3);
langsam(:,3) = langsamRaw(:,4) + langsamRaw(:,5);
langsam(:,4) = langsamRaw(:,6) + langsamRaw(:,7) + langsamRaw(:,8) + langsamRaw(:,9);

normal(:,1) = normalRaw(:,1);
normal(:,2) = normalRaw(:,2) + normalRaw(:,3);
normal(:,3) = normalRaw(:,4) + normalRaw(:,5);
normal(:,4) = normalRaw(:,6) + normalRaw(:,7) + normalRaw(:,8) + normalRaw(:,9);

schnell(:,1) = schnellRaw(:,1);
schnell(:,2) = schnellRaw(:,2) + schnellRaw(:,3);
schnell(:,3) = schnellRaw(:,4) + schnellRaw(:,5);
schnell(:,4) = schnellRaw(:,6) + schnellRaw(:,7) + schnellRaw(:,8) + schnellRaw(:,9);

// calculate linear regression of the scale
[ scaleOffsetXSLOPE, scaleOffsetXOFFSET, scaleOffsetXSIGMA ]= reglin( offsetData(:,1)', offsetData(:,2)' );
[ scaleOffsetYSLOPE, scaleOffsetYOFFSET, scaleOffsetYSIGMA ]= reglin( offsetData(:,1)', offsetData(:,3)' );
[ scaleOffsetZSLOPE, scaleOffsetZOFFSET, scaleOffsetZSIGMA ]= reglin( offsetData(:,1)', offsetData(:,4)' );
//
//scf(0)
//plot(offsetData(:,1), offsetData(:,4))
//plot(offsetData(:,1), (offsetData(:,4) - (offsetData(:,1)*scaleOffsetZSLOPE + scaleOffsetZOFFSET)))


// add labels n stuff to the plot and save it!
// plot(offsetData(:,1),[offsetData(:,2) scaleOffsetSLOPE * offsetData(:,1) + scaleOffsetYOFFSET])
// plot( offsetData(:,1), [offsetData(:,2) - scaleOffsetSLOPE * offsetData(:,1) - scaleOffsetYOFFSET] )

// messwerte (in VOLT) welche mit den gewichten korreliert werden müssen

//plot(xCal(5000:6000, 1), xCal(5000:6000, 2))
//plot(xCal(5000:6000, 1), (xCal(5000:6000, 2) - (xCal(5000:6000)*scaleOffsetXSLOPE + scaleOffsetXOFFSET)))

//meanVoltageX = [ mean((xCal(5000:6000, 2) - (xCal(5000:6000, 1)*scaleOffsetXSLOPE + scaleOffsetXOFFSET))), mean((xCal(10000:11000, 2) - (xCal(10000:11000, 1)*scaleOffsetXSLOPE + scaleOffsetXOFFSET))), mean((xCal(15000:16000, 2) - (xCal(15000:16000, 1)*scaleOffsetXSLOPE + scaleOffsetXOFFSET))), mean((xCal(20000:21000, 2) - (xCal(20000:21000, 1)*scaleOffsetXSLOPE + scaleOffsetXOFFSET))) ];
//meanVoltageY = [ mean((yCal(5000:6000, 3) - (yCal(5000:6000, 1)*scaleOffsetYSLOPE + scaleOffsetYOFFSET))), mean((yCal(10000:11000, 3) - (yCal(10000:11000, 1)*scaleOffsetYSLOPE + scaleOffsetYOFFSET))), mean((yCal(15000:16000, 3) - (yCal(15000:16000, 1)*scaleOffsetYSLOPE + scaleOffsetYOFFSET))), mean((yCal(20000:21000, 3) - (xCal(20000:21000, 1)*scaleOffsetYSLOPE + scaleOffsetYOFFSET))) ];
//meanVoltageZ = [ mean((zCal(5000:6000, 4) - (zCal(5000:6000, 1)*scaleOffsetZSLOPE + scaleOffsetZOFFSET))), mean((zCal(10000:11000, 4) - (zCal(10000:11000, 1)*scaleOffsetZSLOPE + scaleOffsetZOFFSET))), mean((zCal(15000:16000, 4) - (xCal(15000:16000, 1)*scaleOffsetZSLOPE + scaleOffsetZOFFSET))), mean((zCal(20000:21000, 4) - (xCal(20000:21000, 1)*scaleOffsetZSLOPE + scaleOffsetZOFFSET))) ];
//
// old version
meanVoltageX = [ mean(xCal(5000:6000, 2)), mean(xCal(10000:11000, 2)), mean(xCal(15000:16000, 2)), mean(xCal(20000:21000, 2)) ];
meanVoltageY = [ mean(yCal(5000:6000, 3)), mean(yCal(10000:11000, 3)), mean(yCal(15000:16000, 3)), mean(yCal(20000:21000, 3)) ];
meanVoltageZ = [ mean(zCal(5000:6000, 4)), mean(zCal(10000:11000, 4)), mean(zCal(20000:21000, 4)), mean(zCal(30000:31000, 4)) ];

kg = [0, 1, 3.6, 7.75];  //kalibrationsgewichte

[ scaleVoltageXSLOPE, scaleVoltageXOFFSET, scaleVoltageXSIGMA ] = reglin( meanVoltageX, kg );
[ scaleVoltageYSLOPE, scaleVoltageYOFFSET, scaleVoltageYSIGMA ] = reglin( meanVoltageY, kg );
[ scaleVoltageZSLOPE, scaleVoltageZOFFSET, scaleVoltageZSIGMA ] = reglin( meanVoltageZ, kg );

langsamSmooth.offsetX = mean(langsam(400:500,2))
langsamSmooth.offsetY = mean(langsam(400:500,3))
langsamSmooth.offsetZ = mean(langsam(400:500,4))

langsamSmooth.t = langsam(:,1)
langsamSmooth.x = WeightedMovingMean4(((langsam(:,2) - (langsam(:,1) * scaleOffsetXSLOPE + langsamSmooth.offsetX  )) * scaleVoltageXSLOPE), 0.0, 1, 1, 1, 0.0)
langsamSmooth.y = WeightedMovingMean4(((langsam(:,3) - (langsam(:,1) * scaleOffsetYSLOPE + langsamSmooth.offsetY  )) * scaleVoltageYSLOPE), 0.25, 0.5, 0.75, 0.5, 0.25)
langsamSmooth.z = WeightedMovingMean4(((langsam(:,4) - (langsam(:,1) * scaleOffsetZSLOPE + langsamSmooth.offsetZ  )) * scaleVoltageZSLOPE), 0.25, 0.5, 0.75, 0.5, 0.25)

normalSmooth.offsetX = mean(normal(300:400,2))
normalSmooth.offsetY = mean(normal(300:400,3))
normalSmooth.offsetZ = mean(normal(300:400,4))

normalSmooth.t = normal(:,1)
normalSmooth.x = WeightedMovingMean4(((normal(:,2) - (normal(:,1) * scaleOffsetXSLOPE + normalSmooth.offsetX  )) * scaleVoltageXSLOPE), 0.25, 0.5, 0.75, 0.5, 0.25)
normalSmooth.y = WeightedMovingMean4(((normal(:,3) - (normal(:,1) * scaleOffsetYSLOPE + normalSmooth.offsetY  )) * scaleVoltageYSLOPE), 0.25, 0.5, 0.75, 0.5, 0.25)
normalSmooth.z = WeightedMovingMean4(((normal(:,4) - (normal(:,1) * scaleOffsetZSLOPE + normalSmooth.offsetZ  )) * scaleVoltageZSLOPE), 0.25, 0.5, 0.75, 0.5, 0.25)

schnellSmooth.offsetX = mean(schnell(300:400,2))
schnellSmooth.offsetY = mean(schnell(300:400,3))
schnellSmooth.offsetZ = mean(schnell(300:400,4))

schnellSmooth.t = schnell(:,1)
schnellSmooth.x = WeightedMovingMean4(((schnell(:,2) - (schnell(:,1) * scaleOffsetXSLOPE + schnellSmooth.offsetX  )) * scaleVoltageXSLOPE), 0.25, 0.5, 0.75, 0.5, 0.25)
schnellSmooth.y = WeightedMovingMean4(((schnell(:,3) - (schnell(:,1) * scaleOffsetYSLOPE + schnellSmooth.offsetY  )) * scaleVoltageYSLOPE), 0.25, 0.5, 0.75, 0.5, 0.25)
schnellSmooth.z = WeightedMovingMean4(((schnell(:,4) - (schnell(:,1) * scaleOffsetZSLOPE + schnellSmooth.offsetZ  )) * scaleVoltageZSLOPE), 0.25, 0.5, 0.75, 0.5, 0.25)

plotLangsam = scf(0)
plot(langsamSmooth.t, langsamSmooth.x, 'r')
plot(langsamSmooth.t, ((langsam(:,2) - (langsam(:,1) * scaleOffsetXSLOPE + langsamSmooth.offsetX  )) * scaleVoltageXSLOPE), 'rx')
plot(langsamSmooth.t, langsamSmooth.y, 'g')
plot(langsamSmooth.t, ((langsam(:,3) - (langsam(:,1) * scaleOffsetYSLOPE + langsamSmooth.offsetY  )) * scaleVoltageYSLOPE), 'gx')
plot(langsamSmooth.t, langsamSmooth.z, 'b')
plot(langsamSmooth.t, ((langsam(:,4) - (langsam(:,1) * scaleOffsetZSLOPE + langsamSmooth.offsetZ  )) * scaleVoltageZSLOPE), 'bx')
plotLangsam.figure_size = [1366,768]
plotLangsam.figure_name = "langsam"
axes = gca()
xlabel(axes, "Zeit [s]")
ylabel(axes, "Gewicht [kg]")
xs2svg(plotLangsam, 'langsam.svg')

plotNormal = scf(1)
plot(normalSmooth.t, normalSmooth.x, 'r')
plot(normalSmooth.t, ((normal(:,2) - (normal(:,1) * scaleOffsetXSLOPE + normalSmooth.offsetX  )) * scaleVoltageXSLOPE), 'rx')
plot(normalSmooth.t, normalSmooth.y, 'g')
plot(normalSmooth.t, ((normal(:,3) - (normal(:,1) * scaleOffsetYSLOPE + normalSmooth.offsetY  )) * scaleVoltageYSLOPE), 'gx')
plot(normalSmooth.t, normalSmooth.z, 'b')
plot(normalSmooth.t, ((normal(:,4) - (normal(:,1) * scaleOffsetZSLOPE + normalSmooth.offsetZ  )) * scaleVoltageZSLOPE), 'bx')
plotNormal.figure_size = [1366,768]
plotNormal.figure_name = "normal"
axes = gca()
xlabel(axes, "Zeit [s]")
ylabel(axes, "Gewicht [kg]")
xs2svg(plotNormal, 'normal.svg')

plotSchnell = scf(2)
plot(schnellSmooth.t, schnellSmooth.x, 'r')
plot(schnellSmooth.t, ((schnell(:,2) - (schnell(:,1) * scaleOffsetXSLOPE + schnellSmooth.offsetX  )) * scaleVoltageXSLOPE), 'rx')
plot(schnellSmooth.t, schnellSmooth.y, 'g')
plot(schnellSmooth.t, ((schnell(:,3) - (schnell(:,1) * scaleOffsetYSLOPE + schnellSmooth.offsetY  )) * scaleVoltageYSLOPE), 'gx')
plot(schnellSmooth.t, schnellSmooth.z, 'b')
plot(schnellSmooth.t, ((schnell(:,4) - (schnell(:,1) * scaleOffsetZSLOPE + schnellSmooth.offsetZ  )) * scaleVoltageZSLOPE), 'bx')
plotSchnell.figure_size = [1366,768]
plotSchnell.figure_name = "schnell"
axes = gca()
xlabel(axes, "Zeit [s]")
ylabel(axes, "Gewicht [kg]")
xs2svg(plotSchnell, 'schnell.svg')
