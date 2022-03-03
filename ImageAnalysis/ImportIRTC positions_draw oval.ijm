
getDimensions(width, height, channels, slices, frames);
run("Properties...", "channels=1 slices=slices frames=1 unit=um pixel_width=0.542 pixel_height=0.542 voxel_depth=5");

run("Dilate", "stack");
run("Dilate", "stack");
run("Dilate", "stack");
run("Dilate", "stack");
run("Dilate", "stack");

newImage("HyperStack", "8-bit color-mode", width, height, channels, slices, frames);
run("Properties...", "channels=1 slices=slices frames=1 unit=um pixel_width=0.542 pixel_height=0.542 voxel_depth=5");

// ask for a file to be imported
fileName = File.openDialog("Select the file to import");
allText = File.openAsString(fileName);
tmp = split(fileName,".");
// get file format {txt, csv}
posix = tmp[lengthOf(tmp)-1];
// parse text by lines
text = split(allText, "\n");


run("Point Tool...", "type=Hybrid color=Yellow size=[Extra Large] label");
selectWindow("HyperStack");

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

	drawOval(x, y, 10, 10);
	//roiManager("Add");
	
		    
	} 

run("Fill Holes", "stack");
