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
data_path = cwd + "/../data/Laufen/felix/4/4.mdf"

// READ DATA

[toes, ankle, knee, hip, shoulder, elbow, hand, neck] = readFromMDF(data_path)

[foot, leg, thigh, leg_total, upperarm, forearm, arm_total, trunk] = createLimbs(toes, ankle, knee, hip, shoulder, elbow, hand, neck)

// Calc Pendulum

Pendulum_T = 2 * PI * sqrt(mean(GetLimbLength(leg_total, hip)) / 9.81)

Lauf_T = size(ankle.x, 1) * DELTA_T

disp(Pendulum_T)
disp(Lauf_T)

// ANALYZE DATA

foot = anal(foot)
leg = anal(leg)
thigh = anal(thigh)
leg_total = anal(leg_total)
upperarm = anal(upperarm)
forearm = anal(forearm)
arm_total = anal(arm_total)
trunk = anal(trunk)

// smooth data

// PLOT DATA

drawStickFigure()

// Leon writes functions

// Statistics? Correlation

// WRITE RESULTS
// Make results directory
// Save results as text files / Images
