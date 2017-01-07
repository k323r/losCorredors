clear(); // Löschen aller Variablen
clearglobal(); // Löschen aller globalen Variablen

// Set up working variables
global PI
PI = 3.1415
global DELTA_T
DELTA_T = 0.02

// Set up proband varibales
proband_mass = 85

// Current working directory, load all functions from .sci filess
cwd = get_absolute_file_path('compare_kinematics.sce')
getd(cwd);

treadmillPath = "../data/Laufen/aljoscha/4_kmh.mdf"
trackPath = "../data/Waage/Kraftmessungen_Loko_WS16/Aljoscha/angenehm.mdf"

treadmill = []
track = []

[treadmill.toes, treadmill.ankle, treadmill.knee, treadmill.hip, treadmill.shoulder, treadmill.elbow, treadmill.hand, treadmill.neck] = readFromMDF(treadmillPath)
[track.toes, track.ankle, track.knee, track.hip, track.shoulder, track.elbow, track.hand, track.neck] = readFromMDF(trackPath)

