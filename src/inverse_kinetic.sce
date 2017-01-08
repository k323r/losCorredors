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
cwd = get_absolute_file_path('inverse_kinetic.sce')
getd(cwd);

// GET DATA PATH
data_path = uigetfile(["*.mdf", "Output from ImageJ"], cwd + "/../data/Laufen/felix/","Select CSV data",%t);



for i = 1 : size(data_path, 2)

    // READ DATA
    
    [toes, ankle, knee, hip, shoulder, elbow, hand, neck] = readFromMDF(data_path(i))
    
    [foot, leg, thigh, leg_total, upperarm, forearm, arm_total, trunk] = createLimbs(toes, ankle, knee, hip, shoulder, elbow, hand, neck)
    
       
    // ANALYZE DATA
    
    joints = [toes, ankle, knee, hip, shoulder, elbow, hand, neck]
    
    // Calculate angles on certain joints
    ankle.angle = LawOfCosines(knee, ankle, toes)
    knee.angle = LawOfCosines(hip, knee, ankle)
    hip.angle = LawOfCosines(shoulder, hip, knee)
    elbow.angle = LawOfCosines(shoulder, elbow, hand)
    
    // Calculate speeds, acceleration, abs speed, abs acc, smoothed speed (double moving mean)
    foot = anal(foot)
    leg = anal(leg)
    thigh = anal(thigh)
    leg_total = anal(leg_total)
    upperarm = anal(upperarm)
    forearm = anal(forearm)
    arm_total = anal(arm_total)
    
    // Create Container for iteration
    //limbs = [foot, leg, thigh, leg_total, upperarm, forearm, arm_total]
    
    // Calculate ground reaction force
    
    Waage.x = 2.0
    Waage.y = 0.23
    CoB = 0.23
    
    
    a = 0.03
    b = 0.0575
    
    forcefile = cwd + "../data/Waage/felix/schnell.txt"
    caldir = cwd + "../data/Waage/Kalibrierung/"
    
    //caldir = uigetdir(cwd + "../data/")
    //forcefile = uigetfile("*.txt*", cwd + "../data/", "Select force measurement",%t)
    
    driftfile = caldir + '/Waagendrift_clean.txt';
    offsetDataRaw = readScaleFile(driftfile);
    xCalFile = caldir + '/XKali_clean.txt';
    xCalRaw = readScaleFile(xCalFile)
    yCalFile = caldir + '/YKali_clean.txt';
    yCalRaw = readScaleFile(yCalFile);
    zCalFile = caldir + '/ZKali_clean.txt';
    zCalRaw = readScaleFile(zCalFile);
    
    grfRaw = readScaleFile(forcefile)
    
    
    offsetData = combineChannels(offsetDataRaw, a, b, CoB)
    xCal = combineChannels(xCalRaw, a, b, CoB)
    yCal = combineChannels(yCalRaw, a, b, CoB)
    zCal = combineChannels(zCalRaw, a, b, CoB)
    grfSum = combineChannels(grfRaw, a, b, CoB)
    
//    grf = calculateGRF(cwd, 770, CoB.x)
//    grf.x = CoB.x
    
    
    // Calculate Inverse Kinetics
//    
//    ankle.Fx = foot.mass * foot.acc.x - grf.Fx
//    ankle.Fy = foot.mass * (foot.acc.y - g) - grf.Fy
//    ankle.M = foot.MoI * foot.angacc - ankle.Fy * (ankle.x - foot.x) ...
//              - ankle.Fx * (foot.y - ankle.y) - grf.Fx * ( foot.y - grf.y ) - grf.Fy * (grf.x - foot.x)
//              
//              
//    knee.Fx = leg.mass * leg.acc.x + ankle.Fx
//    knee.Fy = leg.mass * (leg.acc.y - g) + ankle.Fy
//    knee.M = ankle.M + leg.MoI * leg.angacc - knee.Fy * (knee.x - leg.x)...
//             - knee.Fx * (leg.y - knee.y) + ankle.Fx * (leg.y - ankle.y) + ankle.Fy * (ankle.x - leg.y)
//             
//    hip.Fx = thigh.mass * thigh.acc.x + knee.Fx
//    hip.Fy = thigh.mass * (thigh.acc.y - g) + knee.Fy
//    hip.M = knee.M + thigh.MoI * thigh.angacc - hip.Fy * (hip.x - thigh.x)...
//             - hip.Fx * (thigh.y - hip.y) + knee.Fx * (thigh.y - knee.y) + knee.Fy * (knee.x - thigh.y)
             
//    scf(99)
//    plot2d([knee.Fx, knee.Fy])
end
