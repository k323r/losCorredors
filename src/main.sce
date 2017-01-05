clear(); // Löschen aller Variablen
clearglobal(); // Löschen aller globalen Variablen

global PI
PI = 3.1415

global DELTA_T
DELTA_T = 0.02

proband_mass = 83

cwd = get_absolute_file_path('main.sce')
getd(cwd);

// GET DATA PATH
// data_path = uigetfile(["*.mdf", "Output from ImageJ"], cwd + "/../data/","Select CSV data",%t);

// For testing only
data_path = cwd + "/../data/Laufen/felix/laufband/4/4.mdf"

// READ DATA

[toes, ankle, knee, hip, shoulder, elbow, hand, neck] = readFromMDF(data_path)

[foot, leg, thigh, leg_total, upperarm, forearm, arm_total, trunk] = createLimbs(toes, ankle, knee, hip, shoulder, elbow, hand, neck)

// Calc Pendulum

Pendulum_T = 2 * PI * sqrt(mean(GetLimbLength(leg_total, hip)) / 9.81)

Lauf_T = size(ankle.x, 1) * DELTA_T

disp(Pendulum_T)
disp(Lauf_T)

// ANALYZE DATA

toes.speed = CalcSpeed(toes)
ankle.speed = CalcSpeed(ankle)
knee.speed = CalcSpeed(knee)
hip.speed = CalcSpeed(hip)
shoulder.speed = CalcSpeed(shoulder)
elbow.speed = CalcSpeed(elbow)
hand.speed = CalcSpeed(hand)
neck.speed = CalcSpeed(neck)


// smooth data

// PLOT DATA

//drawStickFigure()

// Leon writes functions

// Statistics? Correlation

// WRITE RESULTS
// Make results directory
// Save results as text files / Images
