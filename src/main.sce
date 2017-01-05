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
forerarm.mass = 0.016 * proband_mass
arm_total.mass = 0.050 * proband_mass
trunk.mass = 0.497 * proband_mass

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
