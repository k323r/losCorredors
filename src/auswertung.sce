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
nOfT = size(data,1) / max(data(:, 2))           // Number of Tracks
nOfI = max(data(:, 2))                          // Number of Images per Track
DELTA_T = 0.02;                                 // 50 FPS
CALIBRATION = 300;                              // Pix per m is correct, get the cal ratio from user via dialog box
Y_RESOLUTION = 576;                             // Höhe in Pixeln

// Kalibrieren
data = data / CALIBRATION;

// Eingelesenen Datensatz gemäß der Logik beim Tracken in 8 Datensätze unterteilen
// Jeder Datensatz wird logisch in x und y Werte unterteilt
// Gelenk.x und Gelenk.y enthalten jeweils eine 1 spaltige Matrix mit Koordinatenwerten
// Multiplikation mit -1 der y-Werte um "natürliches Koordinatensystem" zu erhalten
for i = 1 : nOfT                                 
    if i == 1 then                
        toes.x = data(nOfI*(i - 1) + 1:i*nOfI , 3);
        toes.y = data(nOfI*(i - 1) + 1:i*nOfI , 4) * (-1) + Y_RESOLUTION;
    elseif i == 2 then
        ankle.x = data(nOfI*(i - 1) + 1:i*nOfI , 3);
        ankle.y = data(nOfI*(i - 1) + 1:i*nOfI , 4) * (-1) + Y_RESOLUTION;
    elseif i == 3 then
        knee.x = data(nOfI*(i - 1) + 1:i*nOfI , 3);
        knee.y = data(nOfI*(i - 1) + 1:i*nOfI , 4) * (-1) + Y_RESOLUTION;
    elseif i == 4 then
        hip.x = data(nOfI*(i - 1) + 1:i*nOfI , 3);
        hip.y = data(nOfI*(i - 1) + 1:i*nOfI , 4) * (-1) + Y_RESOLUTION;
    elseif i == 5 then
        shoulder.x = data(nOfI*(i - 1) + 1:i*nOfI , 3);
        shoulder.y = data(nOfI*(i - 1) + 1:i*nOfI , 4) * (-1) + Y_RESOLUTION;
    elseif i == 6 then
        elbow.x = data(nOfI*(i - 1) + 1:i*nOfI , 3);
        elbow.y = data(nOfI*(i - 1) + 1:i*nOfI , 4) * (-1) + Y_RESOLUTION;
    elseif i == 7 then
        hand.x = data(nOfI*(i - 1) + 1:i*nOfI , 3);
        hand.y = data(nOfI*(i - 1) + 1:i*nOfI , 4) * (-1) + Y_RESOLUTION;
    elseif i == 8 then
        neck.x = data(nOfI*(i - 1) + 1:i*nOfI , 3);
        neck.y = data(nOfI*(i - 1) + 1:i*nOfI , 4) * (-1) + Y_RESOLUTION;
    end
end



plot (toes.x, toes.y, 'or');
// plot(knee.x,knee.y,'or'); // Plot x, y, ?

//savetarget = uiputfile("*.txt*");


//fprintfMat(savetarget, UsS); // Speichern fprintfMat(Zielpfad, Daten)
