clear(); // Löschen aller Variablen
clearglobal(); // Löschen aller globalen Variablen

// Öffnendialog starten
data_path = uigetfile("*.*","","Select CSV data",%t);

// einlesen der Daten
data = fscanfMat(data_path);

numOfTracks = max(data(:,2));
numOfImg = max(data(:,3));

// Spalten
// 2 = TrackID
// 3 = ImageID
// 4 = Xcoord
// 5 = Ycoord


// Trackfolge
// 1 = Ferse
// 2 = Ballen
// 3 = Knöchel
// 4 = Knie

toes = struct('x','y');
heel = struct('x','y');
ankle = struct('x','y');
knee = struct('x','y');

// Bool Anweisung, >, >=, <, <=, ==, ~=
// Größer, Grö.gl., Kleiner, Kl.gl., Gl., ungl.

lowerLimbLength = [];

for i = 1 : numOfImg
    
                                  
    if i == 1 then                
        heel.x = data(10*(i - 1) + 1:i*10 , 4);
        heel.y = data(10*(i - 1) + 1:i*10 , 5) * (-1) + 2;
    elseif i == 2 then
        toes.x = data(10*(i - 1) + 1:i*10 , 4);
        toes.y = data(10*(i - 1) + 1:i*10 , 5) * (-1) + 2;
    elseif i == 3 then
        ankle.x = data(10*(i - 1) + 1:i*10 , 4);
        ankle.y = data(10*(i - 1) + 1:i*10 , 5) * (-1) + 2;
    elseif i == 4 then
        knee.x = data(10*(i - 1) + 1:i*10 , 4);
        knee.y = data(10*(i - 1) + 1:i*10 , 5) * (-1) + 2;
    end
end


disp(ankle.x)       // Equivalent zu print()
disp(ankle.y)

function [distance, CoM] = calcCoM(proximalJoint, distalJoint, anthrof)
    for i = 1 : size(proximalJoint.x,1)
        dx = distalJoint.x(i) - proximalJoint.x(i);
        dy = distalJoint.y(i) - proximalJoint.y(i);
        distance(i) = sqrt((dx)^2 + (dy)^2);
        CoM(i, 1) = dx * anthrof + proximalJoint.x(i);
        CoM(i, 2) = dy * anthrof + proximalJoint.y(i);
    end
endfunction

lowerLimb = [];
centerOfMassLowerLimb = [];

lowerLimb, centerOfMassLowerLimb = calcCoM(knee, ankle, 0.433)

for i = 1:size(ankle.x,1)
    dx = ankle.x(i) - knee.x(i);
    dy = ankle.y(i) - knee.y(i);
    lowerLimbLength(i) = sqrt( (dx)^2 + (dy)^2);
    UsS(i,1) = dx*0.433 + knee.x(i);
    UsS(i,2) = dy*0.433 + knee.y(i);
end

plot(knee.x,knee.y,'or'); // Plot x, y, ?

savetarget = uiputfile("*.txt*");


fprintfMat(savetarget, UsS); // Speichern fprintfMat(Zielpfad, Daten)
