//Opens stack
filepath = getDirectory("Choose a Directory");
run("Image Sequence...", "open=[filepath] number=4 file=TileScan sort");
getDimensions(width, height, channels, slices, frames);
x = slices/4;
run("Stack to Hyperstack...", "order=xyztc channels=4 slices=x frames=1 display=Color");
run("Properties...", "channels=4 frames=1 unit=um pixel_width=0.4599988 pixel_height=0.45990988 voxel_depth=10000.0000000");
stack = getImageID();
makeRectangle(0, 0, 1253, 936);
run("Duplicate...", "duplicate channels=1-4");
saveAs("Tiff", filepath+"Stack_cropped");
getTitle();
selectImage(stack);
run("Close");
selectImage("Stack_cropped.tif");

//Performs segmentation on mCherry channel
run("Duplicate...", "duplicate channels=3");
mCh = getImageID();
selectImage(mCh);
run("Subtract Background...", "rolling=50 stack");
run("Gaussian Blur...", "sigma=1 scaled stack");
setAutoThreshold("MaxEntropy dark no-reset");
setOption("BlackBackground", true);
run("Convert to Mask", "method=MaxEntropy background=Dark calculate black");
run("Convert to Mask", "method=MaxEntropy background=Dark");
run("Analyze Particles...", "size=80-800 circularity=0.40-1.00 display exclude clear summarize add stack");
saveAs("Tiff", filepath+"mCh_seg_MANUAL");
selectImage(mCh);
run("Close");
//roiManager("save", filepath+"ROIset_MANUAL.zip");

//Let user find real CTCs
waitForUser("Select CTCs");

//Measures signal intensities in ROIs for each channel
//copies results in clipboard and can directly be pasted in excel, also saves the results
run("Clear Results"); 
Stack.setChannel(1);
roiManager("measure");
saveAs("Results", filepath+"DAPI_MANUAL.txt");
String.copyResults;
waitForUser("Copy DAPI to master excel sheet");
run("Clear Results"); 

Stack.setChannel(2);
roiManager("measure");
saveAs("Results", filepath+"GFP_MANUAL.txt");
String.copyResults;
waitForUser("Copy GFP to master excel sheet");

run("Clear Results"); 
Stack.setChannel(3);
roiManager("measure");
saveAs("Results", filepath+"mCh_MANUAL.txt");
String.copyResults;
waitForUser("Copy mCh to master excel sheet");

run("Clear Results"); 
Stack.setChannel(4);
roiManager("measure");
saveAs("Results", filepath+"CD45_MANUAL.txt");
String.copyResults;
waitForUser("Copy CD45 to master excel sheet");
roiManager("save", filepath+"ROIset_MANUAL.zip");
//Measurement of background intensities

roiManager("Delete");
run("Clear Results"); 

run("Duplicate...", "duplicate channels=4");
makeRectangle(20,20, 50, 50);
waitForUser("Draw 5 background ROIS and add to ROImanager by pressing t");
close();
roiManager("save", filepath+"ROIset_background_MANUAL.zip");

selectImage("Stack_cropped.tif");
Stack.setChannel(1);
roiManager("measure");
Stack.setChannel(2);
roiManager("measure");
Stack.setChannel(3);
roiManager("measure");
Stack.setChannel(4);
roiManager("measure");

String.copyResults;
saveAs("Results", filepath+"Background_MANUAL.txt");
waitForUser("Copy background into excel sheet");

close();

