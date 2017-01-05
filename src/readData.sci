//********************************************
//              DATA-IMPORT
//********************************************

// Öffnendialog starten


function [toes, ankle, knee, hip, shoulder, elbow, hand, neck] = readFromMDF(path)

// Einlesen der Daten
delimiter = " ";                                // Ist klar
regex_ignore = '/(Track).*$/';                  // Löschen aller mit "Track" beginnenden Zeilen
header = 5;                                     // Anzahl an Zeilen im Kopf
data = csvRead(data_path, delimiter, [], [], [], regex_ignore, [], header);

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