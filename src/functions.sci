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

function [angle] = lawOfCosines(A, B, C)
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


