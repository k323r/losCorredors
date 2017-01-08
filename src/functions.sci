//********************************************
//              NUMERICS
//********************************************

// Ableiten per Vorwärtsdifferenz, erster Wert wird gesetzt
// Übergabe: 1 Spaltige Matrix, Skalares Delta-t
// Rückgabe: 1 Spaltige Matrix
function [fdiff] = ForwardDiff (values, delta)
    fdiff(1) = (values(2) - values(1)) / delta;
    for i = 2 : size(values, 1)
        fdiff(i, 1) = (values(i) - values(i - 1)) / delta;
    end
endfunction

// Ableiten per Rückwärtsdifferenz, letzter Wert wird gesetzt
// Übergabe: 1 Spaltige Matrix, Skalares Delta-t
// Rückgabe: 1 Spaltige Matrix
function [bdiff] = BackwardDiff (values, delta)
    endofdata = size(values,1)
    for i = 1 : endofdata - 1
        bdiff(i) = (values(i + 1) - values(i)) / delta;
    end
    bdiff(endofdata) = (values(endofdata) - values(endofdata - 1)) / delta;
endfunction

// Ableiten per Zentraldifferenz, Mittelwert aus Vorwärts und Rückwärtsdifferenz
// Übergabe: 1 Spaltige Matrix, Skalares Delta-t
// Rückgabe: 1 Spaltige Matrix
function [cdiff]= CentralDiff (values, delta)
    cdiff = (BackwardDiff(values, delta) + ForwardDiff(values, delta)) / 2
endfunction

// Vektorielle Größe in Skalare Größe umwandeln
// Übergabe: Struct mit 1 Spalte x und 1 Spalte y Werten
// Rückgabe: Matrix mit 1 Spalte absoluten Werten
function [scalarValues] = GetScalar(jointData)
    for i = 1 : size(jointData.x, 1)
        scalarValues(i) = sqrt(jointData.x(i)^2 + jointData.y(i)^2);
    end
endfunction

// Gleitenden Mittelwert eines Datensatzes berechnen
// Übergabe: Eine 1 spaltige Matrix
// Rückgabewert: Eine 1 spaltige Matrix
// Erster und letzter Wert werden nicht verändert, Länge der Matrix wird 
// beibehalten
function [movingMean] = MovingMean (values)
    movingMean(1) = values(1);
    endofdata = size(values,1)
    for i = 2 : endofdata - 1
        movingMean(i) = (values(i-1) + values(i) + values(i+1)) / 3;
    end
    movingMean(endofdata) = values(endofdata);
endfunction

// Gewichteter Mittelwert eines Datensatzes berechnen
// Übergabe: Eine 1 spaltige Matrix, drei Gewichtungswerte für vorhergehenden
//           aktuellen und nachfolgenden Wert
// Rückgabe: Eine 1 spaltige Matrix 
function [weightedMovingMean] = WeightedMovingMean (values, weightA, weightB, weightC)
    weightedMovingMean(1) = values(1);
    endofdata = size(values,1)
    for i = 2 : endofdata - 1
        weightedMovingMean(i) = (values(i-1) * weightA + values(i) * weightB + values(i+1) * weightC) / (weightA + weightB + weightC);
    end
    weightedMovingMean(endofdata) = values(endofdata);
endfunction

function [weightedMovingMean] = WeightedMovingMean4 (values, weightA, weightB, weightC, weightD, weightE)
    weightedMovingMean(1) = values(1);
    weightedMovingMean(2) = values(2);
    endofdata = size(values,1);
    for i = 3 : endofdata - 2
        weightedMovingMean(i) = (values(i - 2) * weightA + values(i - 1) * weightB + values(i) * weightC + values(i + 1) * weightD + values(i + 2) * weightE) / (weightA + weightB + weightC + weightD + weightE);
    end
    weightedMovingMean(endofdata - 1) = values(endofdata - 1);
    weightedMovingMean(endofdata) = values(endofdata);
endfunction

// Abstand zwischen zwei Punkten über Satz des Pythagoras
// Übergabe: Zwei 2 Spaltige Matrizen
// Rückgabe: Eine 1 Spaltige Matrix mit Skalaren Entfernungswerten
function [limbLength] = GetLimbLength (proximalJoint, distalJoint)
    for i = 1 : size(proximalJoint.x, 1)
        dx = distalJoint.x(i) - proximalJoint.x(i);
        dy = distalJoint.y(i) - proximalJoint.y(i);
        limbLength(i) = sqrt((dx)^2 + (dy)^2);
    end
endfunction

function [cusumSumPos] = posCUSUM (values, threshold)
    cusumSumPos (1) = 0
    len = size(values,1)
    for i = 2 : len
        cusumSumPos(i) = max(0, cusumSumPos(i - 1) + values(i) - threshold)
    end
endfunction

function [cusumSumNeg] = negCUSUM (values, threshold)
    cusumSumNeg (1) = 0
    len = size(values,1)
    for i = 2 : len
        cusumSumNeg(i) = -1 * min(0, -1*(cusumSumNeg(i - 1) - values(i) + threshold))
    end
endfunction

function [cusumSum] = CUSUM (values, threshold)
    cusumSum(1) = 0
    len = size(values,1)
    for i = 2 : len
        cusumSum(i) = cusumSum(i - 1) + values(i) - threshold
    end
endfunction

//********************************************
//              LOKO-FUNCTIONS
//********************************************

// Massenschwerpunkt eines Körperteils berechnen per Anthroprometrie
// Übergabe: Zwei 2 Spaltige Matrizen und skalarer Wert aus Tabelle
// Rückgabe: Eine Zweispaltige Matrix mit Koordinaten des Masseschwerpunkts
function [CoM] = CalcCoM(proximalJoint, distalJoint, anthrof)
    for i = 1 : size(proximalJoint.x,1)
        dx = distalJoint.x(i) - proximalJoint.x(i);
        dy = distalJoint.y(i) - proximalJoint.y(i);
        CoM.x(i) = dx * anthrof + proximalJoint.x(i);
        CoM.y(i) = dy * anthrof + proximalJoint.y(i);
    end
endfunction

// Translative Geschwindigkeit eines Punktes / Gelenks berechnen per Zentraldiff
// Übergabe: Eine 2 Spaltige Matrix mit Ortskoordinaten
// Rückgabe: Eine 2 Spaltige Matrix mit Geschwindigkeitsvektoren
function [speed]= CalcSpeed (joint)
    speed.x = CentralDiff(joint.x, DELTA_T);
    speed.y = CentralDiff(joint.y, DELTA_T);
endfunction

// Translative Beschleunigung eines Punktes per Zentraldifferenz
// Übergabe: Eine 2 spaltige Matrix mit Ortskoordinaten
// Rückgabe: Eine 2 spaltige Matrix mit Beschleunigungsvektoren
function [transAcc] = CalcAcceleration (joint)
    speed = CalcSpeed(joint);
    transAcc = CalcSpeed(speed);
endfunction


// Winkel der am mittleren Gelenk von drei übergebenen Gelenken anliegt
// Übergabe: Drei 2 spaltige Matrizen mit Koordinaten
// Rückgabe: Eine 1 spaltige Matrix mit skalaren Winkelwerten (Einheit Grad)
function [angle] = CalcAngle(proximalJoint, middleJoint, distalJoint)
    dxProx = proximalJoint.x - middleJoint.x;
    dyProx = proximalJoint.y - middleJoint.y;
    dxDist = middleJoint.x - distalJoint.x;
    dyDist = middleJoint.y - distalJoint.y;
    angle = (atan(dyProx, dxProx) - atan(dxDist, dyDist)) * 180 / PI;
    //if angle > 180 then angle = 360 - angle
    //end
endfunction

function [angle] = LawOfCosines(A, B, C)
    aT = GetLimbLength(B, C)
    bT = GetLimbLength(A, C)
    cT = GetLimbLength(A, B)
    for i = 1 : size(aT, 1)
        a = aT(i)
        b = bT(i)
        c = cT(i)
        angle(i) = acos((b*b - a*a - c*c) / (-2 * a * c)) * 180 / PI
    end
  
endfunction


// Winkelgeschwindigkeit am mittleren Gelenk von drei übergebenen Gelenken
// Übergabe: Drei 2 spaltige Matrizen mit Koordinaten
// Rückgabe: Eine 1 spaltige Matrix mit skalaren Winkelgeschw.werten (Einheit Grad/s)
function [angSpeed]= CalcAngSpeed (proximalJoint, middleJoint, distalJoint)
    angle = CalcAngle(proximalJoint, middleJoint, distalJoint);
    angSpeed = CentralDiff(angle, DELTA_T);
endfunction

function [limb] = anal(limb)
    limb.speed = CalcSpeed(limb)
    limb.acc = CalcAcceleration(limb)
    limb.absspeed = GetScalar(limb.speed)
    limb.absacc = GetScalar(limb.acc)
    limb.smoothspeed = MovingMean(MovingMean(limb.absspeed))
endfunction

function calculateAllAngles()
    ankle.angle = LawOfCosines(knee, ankle, toes)
    knee.angle = LawOfCosines(hip, knee, ankle)
    hip.angle = LawOfCosines(shoulder, hip, knee)
    elbow.angle = LawOfCosines(shoulder, elbow, hand)   
endfunction


// WAAAAAAAAGENSTUFF
// BECAUSE IT SUCKS DONKEY BALLS IN HELL
// IRGENDWANN SCHREIBE ICH MAL NOCH NE DOKU WAS DIE FUNKTIONUEN TUEN 
// ABER NICHT JETZT

function [scaledrift] = calcScaleDrift(data)
    [ scaleOffsetXSLOPE, scaleOffsetXOFFSET, scaleOffsetXSIGMA ]= reglin( data(:,1)', data(:,2)' );
    [ scaleOffsetYSLOPE, scaleOffsetYOFFSET, scaleOffsetYSIGMA ]= reglin( data(:,1)', data(:,3)' );
    [ scaleOffsetZSLOPE, scaleOffsetZOFFSET, scaleOffsetZSIGMA ]= reglin( data(:,1)', data(:,4)' );
    scaledrift.x = scaleOffsetXSLOPE
    scaledrift.y = scaleOffsetYSLOPE
    scaledrift.z = scaleOffsetZSLOPE
endfunction

function [voltageToForce] = convertVoltageToForce(xCal, yCal, zCal)
    
    kg = [0, 1, 3.6, 7.75];  //kalibrationsgewichte
    
    meanVoltageX = [ mean(xCal(5000:6000, 2)), mean(xCal(10000:11000, 2)), mean(xCal(15000:16000, 2)), mean(xCal(20000:21000, 2)) ];
    meanVoltageY = [ mean(yCal(5000:6000, 3)), mean(yCal(10000:11000, 3)), mean(yCal(15000:16000, 3)), mean(yCal(20000:21000, 3)) ];
    meanVoltageZ = [ mean(zCal(5000:6000, 4)), mean(zCal(10000:11000, 4)), mean(zCal(20000:21000, 4)), mean(zCal(30000:31000, 4)) ];

    [ scaleVoltageXSLOPE, scaleVoltageXOFFSET, scaleVoltageXSIGMA ] = reglin( meanVoltageX, kg );
    [ scaleVoltageYSLOPE, scaleVoltageYOFFSET, scaleVoltageYSIGMA ] = reglin( meanVoltageY, kg );
    [ scaleVoltageZSLOPE, scaleVoltageZOFFSET, scaleVoltageZSIGMA ] = reglin( meanVoltageZ, kg );

    voltageToForce.x = scaleVoltageXSLOPE;
    voltageToForce.y = scaleVoltageYSLOPE;
    voltageToForce.z = scaleVoltageZSLOPE;
    
endfunction

function [offset] = getOffset (data)
    offset.x = mean(data(400:500,2))
    offset.y = mean(data(400:500,3))
    offset.z = mean(data(400:500,4))
endfunction


function [smoothData] = calculateForces (data, scaledrift, voltageToForce)
    
    offsetX = mean(data(100:200,2))
    offsetY = mean(data(100:200,3)) 
    offsetZ = mean(data(100:200,4))

    smoothData.t = data(:,1)
    smoothData.x = WeightedMovingMean4(((data(:,2) - (data(:,1) * scaledrift.x + offsetX  )) * voltageToForce.x), 0.0, 1, 1, 1, 0.0)
    smoothData.y = WeightedMovingMean4(((data(:,3) - (data(:,1) * scaledrift.y + offsetY  )) * voltageToForce.y), 0.25, 0.5, 0.75, 0.5, 0.25)
    smoothData.z = WeightedMovingMean4(((data(:,4) - (data(:,1) * scaledrift.z + offsetZ  )) * voltageToForce.z), 0.25, 0.5, 0.75, 0.5, 0.25)
    smoothData.offsetX = offsetX
    smoothData.offsetY = offsetY
    smoothData.offsetZ = offsetZ
endfunction

function plotForces (data, num, title, resolution )
    plotHandle = scf(num)
    plot(data.t, data.x, 'r')
    plot(data.t, data.y, 'g')
    plot(data.t, data.z, 'b')
    plotHandle.figure_size = resolution
    plotHandle.figure_name = title
    axes = gca()
    xlabel(axes, "Zeit [s]")
    ylabel(axes, "Gewicht [kg]")    
    xs2svg(plotHandle, title+'.svg')
endfunction



//********************************************
//              DATA-IMPORT
//********************************************

// Öffnendialog starten

function [toes, ankle, knee, hip, shoulder, elbow, hand, neck] = readFromMDF(path)

// Einlesen der Daten
delimiter = " ";                                // Ist klar
regex_ignore = '/(Track).*$/';                  // Löschen aller mit "Track" beginnenden Zeilen
header = 5;                                     // Anzahl an Zeilen im Kopf
data = csvRead(path, delimiter, [], [], [], regex_ignore, [], header);

// Meta-Daten der Bilder
numberOfTracks = size(data,1) / max(data(:, 2))           // Number of Tracks
numberOfImages = max(data(:, 2))                          // Number of Images per Track
DELTA_T = 0.02;                                 // 50 FPS
CALIBRATION = 227; // 300;                              // Pix per m is correct, get the cal ratio from user via dialog box
Y_RESOLUTION = 479; //576 / 300;                             // Höhe in Pixeln  576!!! 479 bei FElix

// Kalibrieren
data = data / CALIBRATION;
Y_OFFSET = Y_RESOLUTION / CALIBRATION

// Eingelesenen Datensatz gemäß der Logik beim Tracken in 8 Datensätze unterteilen
// Jeder Datensatz wird logisch in x und y Werte unterteilt
// Gelenk.x und Gelenk.y enthalten jeweils eine 1 spaltige Matrix mit Koordinatenwerten
// Multiplikation mit -1 der y-Werte um "natürliches Koordinatensystem" zu erhalten
for i = 1 : numberOfTracks                                 
    if i == 1 then                
        toes.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        toes.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_OFFSET;
    elseif i == 2 then
        ankle.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        ankle.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_OFFSET;
    elseif i == 3 then
        knee.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        knee.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_OFFSET;
    elseif i == 4 then
        hip.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        hip.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_OFFSET;
    elseif i == 5 then
        shoulder.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        shoulder.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_OFFSET;
    elseif i == 6 then
        elbow.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        elbow.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_OFFSET;
    elseif i == 7 then
        hand.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        hand.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_OFFSET;
    elseif i == 8 then
        neck.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        neck.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_OFFSET;
    end
end


endfunction

function [relangle] = calcLimbangle(jointA, jointB)
    
    for i = 1 : size(jointA.x, 1)
    
        dx = jointA.x(i) - jointB.x(i)
        dy = jointA.y(i) - jointB.y(i)
        PI = 3.1415
        hyp = sqrt(dx.^2 + dy.^2)
        angle = asin(dy/hyp)
        if dx < 0 & dy > 0  then
            relangle(i) = PI - angle
        elseif dx < 0 & dy < 0 then
            relangle(i) = PI + angle
        elseif dx > 0 & dy < 0 then
            relangle(i) = 2 * PI - angle
        else relangle(i) = angle
        end
    end
endfunction

function  [foot, leg, thigh, leg_total, upperarm, forearm, arm_total, trunk] = createLimbs(toes, ankle, knee, hip, shoulder, elbow, hand, neck)
    // Create Limbs

    foot = CalcCoM(ankle, toes, 0.5)
    leg = CalcCoM(knee, ankle, 0.433)
    thigh = CalcCoM(hip, knee, 0.433)
    leg_total = CalcCoM(hip, ankle, 0.447)
    upperarm = CalcCoM(shoulder, elbow, 0.436)
    forearm = CalcCoM(elbow, hand, 0.430)
    arm_total = CalcCoM(shoulder, hand, 0.5) // Nicht ganz richtig, da anthro Daten zwischen Ellenbogen und Finger anliegen
    trunk = CalcCoM(shoulder, hip, 0.5)
    
    
    // Calculate angles
    foot.angle = calcLimbangle(ankle, toes)
    leg.angle = calcLimbangle(knee, ankle)
    thigh.angle = calcLimbangle(hip, knee)
    leg_total.angle = calcLimbangle(hip, ankle)
    upperarm.angle = calcLimbangle(shoulder, elbow)
    forearm.angle = calcLimbangle(elbow, hand)
    arm_total.angle = calcLimbangle(shoulder, hand)
    trunk.angle = calcLimbangle(shoulder, hip)
    
    // Add names
    
    foot.name = "foot"
    leg.name = "leg"
    thigh.name = "thigh"
    leg_total.name = "total leg"
    upperarm.name = "upper arm"
    forearm.name = "forearm"
    arm_total.name = "total arm"
    trunk.name = "trunk"
    
    // Add colors
    
    foot.color = color("red")
    leg.color = color("green")
    thigh.color = color("blue")
    leg_total.color = color("purple")
    upperarm.color = color("orange")
    forearm.color = color("darkgreen")
    arm_total.color = color("brown")
    trunk.color = color("yellow")
    
    // Add masses
    
    foot.mass = 0.0145 * proband_mass
    leg.mass = 0.0465 * proband_mass
    thigh.mass = 0.100 * proband_mass
    leg_total.mass = 0.161 * proband_mass
    upperarm.mass = 0.027 * proband_mass
    forearm.mass = 0.016 * proband_mass
    arm_total.mass = 0.050 * proband_mass
    trunk.mass = 0.497 * proband_mass
 
    
    // Add limb lengths
    
    foot.length = mean(GetLimbLength(ankle, toes))
    leg.length = mean(GetLimbLength(knee, ankle))
    thigh.length = mean(GetLimbLength(hip, knee))
    leg_total.length = mean(GetLimbLength(hip, ankle))
    upperarm.length = mean(GetLimbLength(shoulder, elbow))
    forearm.length = mean(GetLimbLength(elbow, hand))
    arm_total.length = mean(GetLimbLength(shoulder, hand))
    trunk.length = mean(GetLimbLength(shoulder, hip))
    
    // Add radii of gyration
    
    foot.RoG = foot.length * 0.475
    leg.RoG = leg.length * 0.302
    thigh.RoG = thigh.length * 0.323
    leg_total.RoG = leg_total.length * 0.326
    upperarm.RoG = upperarm.length * 0.322
    forearm.RoG = forearm.length * 0.302
    arm_total.RoG = arm_total.length * 0.368
    
    // Add moments of inertia
    
    foot.MoI = foot.mass * foot.RoG^2
    leg.MoI = leg.mass * leg.RoG^2
    thigh.MoI = thigh.mass * thigh.RoG^2
    leg_total.MoI = leg_total.mass * leg_total.RoG^2
    upperarm.MoI = upperarm.mass * upperarm.RoG^2
    forearm.MoI = forearm.mass * forearm.RoG^2
    arm_total.MoI = arm_total.mass * arm_total.RoG^2

endfunction

function [forcesRaw] = readScaleFile (filepath)
    data = fscanfMat(filepath);
    index = 1
    while data(index,1) < 3.20
        index = index + 1
    end
    forcesRaw = data( index:length(data(:,1)),: ) // -> no wonder no one likes matlab/scilab! wtf is this shit
endfunction

function [forces] = combineChannels (data, a, b, CoB)
  
    for i = 1 : size(data, 1)
    
    forces(i,1) = data(i,1);
    forces(i,2) = data(i,2) + data(i,3);
    forces(i,3) = data(i,4) + data(i,5);  
    forces(i,4) = data(i,6) + data(i,7) + data(i,8) + data(i,9);
    forces(i,5) = (( data(i,6) + data(i,7) ) / ( data(i,6) + data(i,7) + data(i,8) + data(i,9) ))*2*b - b + CoB
    end
endfunction

function [grfSum] = calculateGRF(cwd, startfrom, CoB)

    a = 0.03
    b = 0.0575
    
    caldir = uigetdir(cwd + "../data/")
    forcefile = uigetfile("*.txt*", cwd + "../data/", "Select force measurement",%t)
    
    driftfile = caldir + '/Waagendrift_clean.txt';
    offsetDataRaw = readScaleFile(driftfile);
    xCalFile = caldir + '/XKali_clean.txt';
    xCalRaw = readScaleFile(xCalFile)
    yCalFile = caldir + '/YKali_clean.txt';
    yCalRaw = readScaleFile(yCalFile);
    zCalFile = caldir + '/ZKali_clean.txt';
    zCalRaw = readScaleFile(zCalFile);
    
    grfRaw = readScaleFile(forcefile)
    
    
    offsetData = combineChannels(offsetDataRaw, a, b, CoB)
    xCal = combineChannels(xCalRaw, a, b, CoB)
    yCal = combineChannels(yCalRaw, a, b, CoB)
    zCal = combineChannels(zCalRaw, a, b, CoB)
    grfSum = combineChannels(grfRaw, a, b, CoB)
    
    
//    scaledrift = calcScaleDrift(offsetData)
//    voltageToForce = convertVoltageToForce(xCal, yCal, zCal)
//    
//    grf = calculateForces(grfSum, scaledrift, voltageToForce)
    
//     Extract Force Data, start from user chosen point, increment of 2 to match force balance sampling (100 hz) with camera fps (50 hz)
//    grf.Fx = grfSum(startfrom:2:,3)
//    grf.Fy = grfSum(startfrom:2:,4)
//    grf.y = grfSum(startfrom:2:,5)
//
endfunction
