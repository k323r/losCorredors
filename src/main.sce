clear(); // Löschen aller Variablen
clearglobal(); // Löschen aller globalen Variablen

global PI = 3.14;

cwd = get_absolute_file_path('main.sce')
getd(cwd);

// GET DATA PATH
//data_path = uigetfile(["*.mdf", "Output from ImageJ"], cwd + "/../data/","Select CSV data",%t);

// For testing only
data_path = cwd + "/../data/aljoscha/5_kmh.mdf"

// READ DATA

[toes, ankle, knee, hip, shoulder, elbow, hand, neck] = readFromMDF(data_path)

// ANALYZE DATA

toes.speed = CalcSpeed(toes)
ankle.speed = CalcSpeed(ankle)
knee.speed = CalcSpeed(knee)
hip.speed = CalcSpeed(hip)
shoulder.speed = CalcSpeed(shoulder)
arm.speed = CalcSpeed(arm)
hand.speed = CalcSpeed(hand)
neck.speed = CalcSpeed(neck)

// smooth data

// PLOT DATA
// Leon writes functions

// Statistics? Correlation

// WRITE RESULTS
// Make results directory
// Save results as text files / Images
