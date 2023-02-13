bag1 = rosbag('OpenSpot.bag');
bag2 = rosbag('OccludedSpot.bag');
bag3 = rosbag('Walk.bag');
bagselect1 = select(bag1,'topic','/gps');
bagselect2 = select(bag2,'topic','/gps');
bagselect3 = select(bag3,'topic','/gps');
msgstruct1 = readMessages(bagselect1,'DataFormat','struct');
msgstruct2 = readMessages(bagselect2,'DataFormat','struct');
msgstruct3 = readMessages(bagselect3,'DataFormat','struct');
msgstruct1{1};
msgstruct2{1};
msgstruct3{1};
x1 = cellfun(@(m)double(m.UTMEasting),msgstruct1);
y1 = cellfun(@(m)double(m.UTMNorthing),msgstruct1);
x2 = cellfun(@(m)double(m.UTMEasting),msgstruct2);
y2 = cellfun(@(m)double(m.UTMNorthing),msgstruct2);
x3 = cellfun(@(m)double(m.UTMEasting),msgstruct3);
y3 = cellfun(@(m)double(m.UTMNorthing),msgstruct3);
xa1 = x1-msgstruct1{1}.UTMEasting;
ya1 = y1-msgstruct1{1}.UTMNorthing;
xa2 = x2-msgstruct2{1}.UTMEasting;
ya2 = y2-msgstruct2{1}.UTMNorthing;
xa3 = x3-msgstruct3{1}.UTMEasting;
ya3 = y3-msgstruct3{1}.UTMNorthing;
figure(1);
scatter(xa1,ya1)
figure(2);
scatter(xa2,ya2)
figure(3);
scatter(xa3,ya3)
east1 = 329132.79;
nort1 = 4687821.81;
east2 = 329180.31;
nort2 = 4687613.10;
xnew1 = east1-x1;
ynew1 = nort1-y1;
xnew2 = east2-x2;
ynew2 = nort2-y2;
xnews1 = xnew1.^2;
ynews1 = ynew1.^2;
xynew1 = xnews1+ynews1;
xnews2 = xnew2.^2;
ynews2 = ynew2.^2;
xynew2 = xnews2+ynews2;
error_open = sqrt(xynew1);
error_occluded = sqrt(xynew2);
figure(4);
histogram(error_open)
figure(5);
histogram(error_occluded)
