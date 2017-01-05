clear(); // Löschen aller Variablen
clearglobal(); // Löschen aller globalen Variablen

//********************************************
//              CONSTANTS
//********************************************

PI = 3.14;


//********************************************
//      READ IN THE FUNCTIONS.SCI FIlE 
//  containing numiercal and plotting routines
//********************************************

// not sure what's the cleaner way, but i'll go with getd()
getd("./")
//exec('./functions.sci');

//********************************************
//              DATA-IMPORT
//********************************************

// Öffnendialog starten
data_path = uigetfile("*.*","","Select CSV data",%t);

// Einlesen der Daten
delimiter = " ";                                // Ist klar
regex_ignore = '/(Track).*$/';                  // Löschen aller mit "Track" beginnenden Zeilen
header = 5;                                     // Anzahl an Zeilen im Kopf
data = csvRead(data_path, delimiter, [], [], [], regex_ignore, [], header);

// Meta-Daten der Bilder
numberOfTracks = size(data,1) / max(data(:, 2))           // Number of Tracks
numberOfImages = max(data(:, 2))                          // Number of Images per Track
DELTA_T = 0.02;                                 // 50 FPS
CALIBRATION = 300;                              // Pix per m is correct, get the cal ratio from user via dialog box
Y_RESOLUTION = 576 / 300;                             // Höhe in Pixeln

// Kalibrieren
data = data / CALIBRATION;

// Eingelesenen Datensatz gemäß der Logik beim Tracken in 8 Datensätze unterteilen
// Jeder Datensatz wird logisch in x und y Werte unterteilt
// Gelenk.x und Gelenk.y enthalten jeweils eine 1 spaltige Matrix mit Koordinatenwerten
// Multiplikation mit -1 der y-Werte um "natürliches Koordinatensystem" zu erhalten
for i = 1 : numberOfTracks                                 
    if i == 1 then                
        toes.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        toes.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_RESOLUTION;
    elseif i == 2 then
        ankle.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        ankle.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_RESOLUTION;
    elseif i == 3 then
        knee.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        knee.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_RESOLUTION;
    elseif i == 4 then
        hip.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        hip.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_RESOLUTION;
    elseif i == 5 then
        shoulder.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        shoulder.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_RESOLUTION;
    elseif i == 6 then
        elbow.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        elbow.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_RESOLUTION;
    elseif i == 7 then
        hand.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        hand.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_RESOLUTION;
    elseif i == 8 then
        neck.x = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 3);
        neck.y = data(numberOfImages*(i - 1) + 1:i*numberOfImages , 4) * (-1) + Y_RESOLUTION;
    end
end



plot (toes.x, toes.y, 'or');
// plot(knee.x,knee.y,'or'); // Plot x, y, ?

//savetarget = uiputfile("*.txt*");
/*
data_tmp = [toes.x(1),toes.y(1);ankle.x(1),ankle.y(1);knee.x(1),knee.y(1);hip.x(1),hip.y(1);neck.x(1),neck.y(1);shoulder.x(1),shoulder.y(1);elbow.x(1),elbow.y(1);hand.x(1),hand.y(1)];
plot(data_tmp(:,1), data_tmp(:,2))
e = gce();
h_stick = e.children;

a = gca();
a.data_bounds=[0,0;2,2];

for i = 1 : size(toes.x,1)
    drawlater
    data_tmp = [toes.x(i),toes.y(i);ankle.x(i),ankle.y(i);knee.x(i),knee.y(i);hip.x(i),hip.y(i);neck.x(i),neck.y(i);shoulder.x(i),shoulder.y(i);elbow.x(i),elbow.y(i);hand.x(i),hand.y(i)];
    h_stick.data = data_tmp;
    sleep(1);
    drawnow
    disp(i)
end
*/

//fprintfMat(savetarget, UsS); // Speichern fprintfMat(Zielpfad, Daten)
