//Open image stack containing objects masks

path = File.openDialog("Select the file to import");
open(path);
ObjectsMask = getImageID();
getDimensions(width, height, channels, slices, frames);

run("3D Distance Map", "map=EDT image=Test mask=Same threshold=0");
run("Fire");
setMinAndMax(0, 12);
save(path+"_EDT.tiff");
selectImage(ObjectsMask);
close();


run("Point Tool...", "type=Hybrid color=Yellow size=[Large] label");
run("Set Measurements...", "mean min median display redirect=None decimal=3");


// ask for the excel table to be imported
fileName = File.openDialog("Select the table to import");
allText = File.openAsString(fileName);
tmp = split(fileName,".");
// get file format {txt, csv}
posix = tmp[lengthOf(tmp)-1];
// parse text by lines
text = split(allText, "\n");

// define array for points
var xpoints = newArray;
var ypoints = newArray; 
var zslice = newArray;

// in case input is in CSV format
 if (posix=="csv") {
	print("importing CSV point set...");
	//these are the column indexes
	hdr = split(text[0]);
	iX = 17; iY = 18; iZ = 19;
	// loading and parsing each line
	for (i = 1; i < (text.length); i++){
	   line = split(text[i],",");
	   setOption("ExpandableArrays", true);   
	   xpoints[i] = parseInt(line[iX]);
	   ypoints[i] = parseInt(line[iY]);
	   zslice[i] = parseInt(line[iZ]);
	   print("p("+i+") ["+xpoints[i]+"; "+ypoints[i]+"; "+zslice[i]+"]");

z = zslice[i];
	Stack.setSlice(z);
x = xpoints[i];
y = ypoints[i];	
	makePoint(x, y);
	run("Enlarge...", "enlarge=10");
	roiManager("add");
	    
	} 

roiManager("deselect");
roiManager("save", path+"ROIset_IRTC.zip");

roiManager("measure");

String.copyResults -;
saveAs("Results", path+"EDTradius_IRTC.txt");
close();
