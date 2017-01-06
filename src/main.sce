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
data_path = uigetfile(["*.mdf", "Output from ImageJ"], cwd + "/../data/Laufen/felix/","Select CSV data",%t);

// For testing only
//data_path = cwd + "/../data/Laufen/felix/4/4.mdf"

speeds = ["1 kmh", "2 kmh", "3 kmh", "4 kmh", "5 kmh", "6 kmh", "7 kmh"]

for i = 1 : size(data_path, 2)


    // READ DATA
    
    [toes, ankle, knee, hip, shoulder, elbow, hand, neck] = readFromMDF(data_path(i))
    
    [foot, leg, thigh, leg_total, upperarm, forearm, arm_total, trunk] = createLimbs(toes, ankle, knee, hip, shoulder, elbow, hand, neck)
    
    timesteps = size(ankle.x, 1)
    
    // Calc Pendulum
    
    Pendulum_T = 2 * PI * sqrt(mean(GetLimbLength(leg_total, hip)) / 9.81)
    
    Cycle_T = timesteps * DELTA_T
    
    
    // ANALYZE DATA
    
    joints = [toes, ankle, knee, hip, shoulder, elbow, hand, neck]
    
    limbs = [foot, leg, thigh, leg_total, upperarm, forearm, arm_total]
    
    for k = 1 : size(joints, 2)
        joints(k) = anal(joints(k))
    end
    
    for k = 1 : size(limbs, 2)
        limbs(k) = anal(limbs(k))
    end    
    
    // smooth data
    
    scf(0)
    ax = gca()
    
    time = linspace(0, Cycle_T, timesteps)
    
   
    
    for j = 1 : size(limbs, 2)
        subplot(size(limbs, 2), 1, j);
                    
            plot2d(time / Cycle_T, limbs(j).smoothspeed);    //nowcolor]);
            ax2 = gca()
            e = gce()
            graph = e.children(1)
            graph.foreground = limbs(j).color
            ax2.title.text = limbs(j).name
    end
    
    
    savetarget = uiputfile("*.txt*", cwd + "../results/");


    fprintfMat(savetarget, [limbs(2).smoothspeed, limbs(2).absacc]); // Speichern fprintfMat(Zielpfad, Daten)
    
    // PLOT DATA
    
   
    
    
    
    // drawStickFigure()
    
    sleep(1000)

end

function plotTrajectory(joint)
        // plot x - y curve of joint
endfunction
    
function plotKinematics(limb)
        
endfunction
// Leon writes functions

// Statistics? Correlation

// WRITE RESULTS
// Make results directory
// Save results as text files / Images
