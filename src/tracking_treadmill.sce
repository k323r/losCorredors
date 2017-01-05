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
cwd = get_absolute_file_path('tracking_treadmill.sce')
getd(cwd);
exec(cwd + '/readData.sci')
//exec('./functions.sci');

//********************************************
//              DATA-IMPORT
//********************************************

// Öffnendialog starten
data_path = uigetfile(["*.mdf", "Output from ImageJ"], cwd + "/../data/","Select CSV data",%t);

// For testing only
//data_path = absolute_path + "/../data/aljoscha/5_kmh.mdf"

for i = 1 : size(data_path, 1)
    [toes, ankle, knee, hip, shoulder, elbow, hand, neck] = readFromMDF(data_path(i))
end

//scf(0);
//plot(toes.x,toes.y);
//toes.speed = CalcSpeed(toes)  //FIXME es fehlt das DeltaT

//toes.speed.x = MovingMean(toes.speed.x)
//toes.speed.x = MovingMean(toes.speed.y)

//plot (toes.x, toes.y, 'or');
//plot(toes.speed.x, toes.speed.y);
// plot(knee.x,knee.y,'or'); // Plot x, y, ?#
scf(1);clf();

data_tmp = [toes.x(1),toes.y(1);ankle.x(1),ankle.y(1);knee.x(1),knee.y(1);hip.x(1),hip.y(1);neck.x(1),neck.y(1);shoulder.x(1),shoulder.y(1);elbow.x(1),elbow.y(1);hand.x(1),hand.y(1)];
plot(data_tmp(:,1), data_tmp(:,2))
e = gce();
h_stick = e.children;

a = gca();
a.data_bounds=[0,0;2,2];

for i = 1 : size(toes.x,1)
    drawlater
    data_tmp = [toes.x(i),toes.y(i);ankle.x(i),ankle.y(i);knee.x(i),knee.y(i);hip.x(i),hip.y(i);neck.x(i),neck.y(i);shoulder.x(i),shoulder.y(i);elbow.x(i),elbow.y(i);hand.x(i),hand.y(i)];
    h_stick.data = data_tmp;
    sleep(100);
    drawnow
    disp(i)
end









//savetarget = uiputfile("*.txt*");


//fprintfMat(savetarget, UsS); // Speichern fprintfMat(Zielpfad, Daten)
