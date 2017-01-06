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
cwd = get_absolute_file_path('main.sce')
getd(cwd);

// GET DATA PATH
data_path = uigetfile(["*.mdf", "Output from ImageJ"], cwd + "/../data/Laufen/felix/","Select CSV data",%t);

// Select subfolder in results/ to save all result text files

savedir = uigetdir(cwd + "../results/")

// For testing only
//data_path = cwd + "/../data/Laufen/felix/4/4.mdf"

// Set up Lists and Matrices

speeds = ["1 kmh", "2 kmh", "3 kmh", "4 kmh", "5 kmh", "6 kmh", "7 kmh"]
colors = [color("red"), color("orange"), color("yellow"), color("purple"),  color("blue"), color("green"), color("darkgreen")]

idealpendulum = []
cycleTime = []
frequency = []
difference = []

// Set up figures

angleComparison = scf(9)
acax = angleComparison.children
acax.title.text = "Vergleich der Winkelverläufe am Knie"
acax.x_label.text = "Schrittzyklus"
acax.y_label.text = "Winkel in Grad"




for i = 1 : size(data_path, 2)

    // READ DATA
    
    [toes, ankle, knee, hip, shoulder, elbow, hand, neck] = readFromMDF(data_path(i))
    
    [foot, leg, thigh, leg_total, upperarm, forearm, arm_total, trunk] = createLimbs(toes, ankle, knee, hip, shoulder, elbow, hand, neck)
    
    
    
    // Calc Pendulum
    
    timesteps = size(ankle.x, 1)
    
    Pendulum_T = 2 * PI * sqrt(mean(GetLimbLength(leg_total, hip)) / 9.81)
    
    Cycle_T = timesteps * DELTA_T
    
    idealpendulum(i) = Pendulum_T
    cycleTime(i) = Cycle_T
    frequency(i) = 1 / Cycle_T
    difference(i) = Pendulum_T / Cycle_T * 100 - 100
    
    
    
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
    limbs = [foot, leg, thigh, leg_total, upperarm, forearm, arm_total]
    
    // smooth data
   
    
    // PLOT DATA
    
    time = linspace(0, Cycle_T, timesteps)
    
    sca(acax)
    plot2d(time / Cycle_T, knee.angle, style = colors(i))
    
  
    // drawStickFigure()
    
    sleep(1000)

end

// Save Pendulum Caluclations

fprintfMat(savedir + "/pendulum.txt",...
           [idealpendulum, cycleTime, frequency, difference],...
           "%5.2f",...
           "Idealpendel_T Beinpendel_T Beinpendel_f rel_diff");





function plotTrajectory(joint)
        // plot x - y curve of joint
endfunction
    
function plotKinematics(limb)
        
endfunction


function plotAngles(i)
    scf(i)
    ax(i) = newaxes()
    plot2d(time / Cycle_T, [ankle.angle,knee.angle,  hip.angle, elbow.angle], style=[color("red"), color("green"), color("blue"), color("purple")]) //,
    ax(i).title.text = "Winkelverläufe, Geschwindigkeit " + speeds(i)
    ax(i).x_label.text = "Entdimensionierter Schrittzyklus"
    ax(i).y_label.text = "Winkel in Grad"
    h1 = legend(["Sprunggelenk", "Kniegelenk", "Hüfte", "Ellenbogen"], [-1], [%t])
endfunction
// Leon writes functions

// Statistics? Correlation

// WRITE RESULTS

    
function saveResults(joints, savetarget)
    
    for i = 1 : joints(size, 1)
        fprintfMat(savetarget, [joints(i).smoothspeed, joints(i).absacc]); // Speichern fprintfMat(Zielpfad, Daten)
    end
endfunction    
    
    
function plotSpeeds()
    scf(10)
    ax = gca()
    
    
    for j = 1 : size(limbs, 2)
    subplot(size(limbs, 2), 1, j);
                
        plot2d(time / Cycle_T, limbs(j).smoothspeed);    //nowcolor]);
        ax2 = gca()
        e = gce()
        graph = e.children(1)
        graph.foreground = limbs(j).color
        ax2.title.text = limbs(j).name
    end
endfunction

    
    
    
    
// Make results directory
// Save results as text files / Images
