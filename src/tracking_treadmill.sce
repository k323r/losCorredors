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
absolute_path = get_absolute_file_path('tracking_treadmill.sce')
getd(absolute_path);
//exec('./functions.sci');

//********************************************
//              DATA-IMPORT
//********************************************

// Öffnendialog starten
//data_path = uigetfile("*.*","","Select CSV data",%t);

data_path = absolute_path + "/../data/aljoscha/5_kmh.mdf"


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

toes.speed = CalcSpeed(toes)
disp(toes.speed.x)
disp(toes.speed.y)
toes.speed.x = MovingMean(toes.speed.x)
toes.speed.x = MovingMean(toes.speed.y)
disp(toes.speed.x)
disp(toes.speed.y)

plot (toes.x, toes.y, 'or');
plot(toes.speed.x, toes.speed.y);
// plot(knee.x,knee.y,'or'); // Plot x, y, ?

//savetarget = uiputfile("*.txt*");


//fprintfMat(savetarget, UsS); // Speichern fprintfMat(Zielpfad, Daten)
