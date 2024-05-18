function All(filename,registername)
    colorcodes = [26 28 43; 93 38 93; 178 62 83; 239 125 88; 255 205 118; 168 240 112; 54 184 101; 36 113 121; 42 54 112; 59 93 201; 65 166 246; 115 239 247; 244 244 244; 149 176 195; 86 107 134; 50 60 87];
    PNG_converter(filename,colorcodes);
    PNGtoVerilog("new_"+filename+".png",colorcodes,registername);