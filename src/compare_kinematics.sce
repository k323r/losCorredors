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

treadmillPath = cwd + "/../data/Laufen/aljoscha/6_kmh.mdf"
trackPath = cwd + "/../data/Waage/Kraftmessungen_Loko_WS16/Aljoscha/angenehm.mdf"

treadmill = []
treadmillStationary = []

track = []
trackStationary = []

[treadmill.toes, treadmill.ankle, treadmill.knee, treadmill.hip, treadmill.shoulder, treadmill.elbow, treadmill.hand, treadmill.neck] = readFromMDF(treadmillPath)
[track.toes, track.ankle, track.knee, track.hip, track.shoulder, track.elbow, track.hand, track.neck] = readFromMDF(trackPath)

treadmillStationary.toes.x = treadmill.toes.x - treadmill.neck.x
treadmillStationary.toes.y = treadmill.toes.y - treadmill.neck.y

treadmillStationary.ankle.x = treadmill.ankle.x - treadmill.neck.x
treadmillStationary.ankle.y = treadmill.ankle.y - treadmill.neck.y

treadmillStationary.knee.x = treadmill.knee.x - treadmill.neck.x
treadmillStationary.knee.y = treadmill.knee.y - treadmill.neck.y

treadmillStationary.hip.x = treadmill.hip.x - treadmill.neck.x
treadmillStationary.hip.y = treadmill.hip.y - treadmill.neck.y

treadmillStationary.shoulder.x = treadmill.shoulder.x - treadmill.neck.x
treadmillStationary.shoulder.y = treadmill.shoulder.y - treadmill.neck.y

treadmillStationary.elbow.x = treadmill.elbow.x - treadmill.neck.x
treadmillStationary.elbow.y = treadmill.elbow.y - treadmill.neck.y

treadmillStationary.hand.x = treadmill.hand.x - treadmill.neck.x
treadmillStationary.hand.y = treadmill.hand.y - treadmill.neck.y

treadmillStationary.neck.x = treadmill.neck.x - treadmill.neck.x
treadmillStationary.neck.y = treadmill.neck.y - treadmill.neck.y


trackStationary.toes.x = track.toes.x - track.neck.x
trackStationary.toes.y = track.toes.y - track.neck.y

trackStationary.ankle.x = track.ankle.x - track.neck.x
trackStationary.ankle.y = track.ankle.y - track.neck.y

trackStationary.knee.x = track.knee.x - track.neck.x
trackStationary.knee.y = track.knee.y - track.neck.y

trackStationary.hip.x = track.hip.x - track.neck.x
trackStationary.hip.y = track.hip.y - track.neck.y

trackStationary.shoulder.x = track.shoulder.x - track.neck.x
trackStationary.shoulder.y = track.shoulder.y - track.neck.y

trackStationary.elbow.x = track.elbow.x - track.neck.x
trackStationary.elbow.y = track.elbow.y - track.neck.y

trackStationary.hand.x = track.hand.x - track.neck.x
trackStationary.hand.y = track.hand.y - track.neck.y

trackStationary.neck.x = track.neck.x - track.neck.x
trackStationary.neck.y = track.neck.y - track.neck.y

scf(0)
plot(track.toes.x, track.toes.y)
plot(track.neck.x, track.neck.y)
plot(track.toes.x, track.toes.y)
plot(track.neck.x, track.neck.y)

scf(1)
plot(treadmillStationary.toes.x, treadmillStationary.toes.y, 'r')
plot(treadmillStationary.ankle.x, treadmillStationary.ankle.y, 'r')
plot(treadmillStationary.knee.x, treadmillStationary.knee.y, 'r')
plot(treadmillStationary.hip.x, treadmillStationary.hip.y, 'r')
plot(treadmillStationary.shoulder.x, treadmillStationary.shoulder.y, 'r')
plot(treadmillStationary.elbow.x, treadmillStationary.elbow.y, 'r')
plot(treadmillStationary.hand.x, treadmillStationary.hand.y, 'r')
plot(treadmillStationary.neck.x, treadmillStationary.neck.y, 'r')

plot(trackStationary.toes.x, trackStationary.toes.y, 'b')
plot(trackStationary.ankle.x, trackStationary.ankle.y, 'b')
plot(trackStationary.knee.x, trackStationary.knee.y, 'b')
plot(trackStationary.hip.x, trackStationary.hip.y, 'b')
plot(trackStationary.shoulder.x, trackStationary.shoulder.y, 'b')
plot(trackStationary.elbow.x, trackStationary.elbow.y, 'b')
plot(trackStationary.hand.x, trackStationary.hand.y, 'b')
plot(trackStationary.neck.x, trackStationary.neck.y, 'b')
