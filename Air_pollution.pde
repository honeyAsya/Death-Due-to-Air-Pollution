import org.gicentre.geomap.*;
import org.gicentre.utils.stat.*;
import controlP5.*;

ControlP5 cp5;


GeoMap geoMap;
XYChart lineChart;

String choice = "World";

Table data;
float [] death;
String[] codes;
float[] year;
Table average;
float chosed_year;
float chosed_death;

Table tabCountry;
color minColor, maxColorWORST, maxColorBEST;
float dataMax;
String selectedButton;

String airColumn = "Air pollution (total) (deaths per 100,000)";
float pollutionLow, pollutionHigh;
PImage high, low;



void setup() {
  fullScreen();
  
  high = loadImage("bad.png");
  low = loadImage("good.png"); 
  
  data = loadTable("data/complete_data.csv", "header");
  
  background(240);
  
  PFont pfont = createFont("Arial",20,true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont);
   
  cp5 = new ControlP5(this);
  
  cp5.addButton("WORST")
     .setPosition(60,50)
     .setSize(200,90)
     ;
     
  cp5.getController("WORST")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     .setSize(24)
     ;
     
  cp5.addButton("BEST")
     .setPosition(60,150)
     .setSize(200,90)
     ;
     
  cp5.getController("BEST")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     .setSize(24)
     ;
     
  cp5.addButton("NORMAL")
   .setPosition(60,250)
   .setSize(200,90)
   ;
   
  cp5.getController("NORMAL")
     .getCaptionLabel()
     .setFont(font)
     .toUpperCase(false)
     .setSize(24)
     ;
  
  geoMap = new GeoMap((width-height)/2, 0, height, height/2, this);

  geoMap.readFile("world");   // Read shapefile.

    
  String[] average = loadStrings("data/average_deaths.csv"); //average death each year
  year = new float[average.length-1];
  death = new float[average.length-1];
  
  for (int i=0; i<average.length-1; i++) {
    
    String[] tokens_average = average[i+1].split(",");
    year[i]  = Float.parseFloat(tokens_average[0]); 
    death[i] = Float.parseFloat(tokens_average[1]);  
    }
    
  lineChart = new XYChart(this);
  
  lineChart.setData(year, death); //char for the whole world

  
  // Axis formatting and labels.
  lineChart.getXData();
  lineChart.getYData();
  lineChart.showXAxis(true);
  lineChart.showYAxis(true); 

  lineChart.setMinY(0);
  lineChart.setXFormat("0000"); // Years 
  // Symbol colors
  lineChart.setPointColour(color(180,50,50, 150));
  lineChart.setPointSize(8);
  lineChart.setLineWidth(2);
  lineChart.setXAxisLabel("\nYears");


  tabCountry = loadTable("average_country.csv");  // Read data.
 
  // Find largest data value so we can scale colors.
  dataMax = 0;
  for (TableRow row : tabCountry.rows())
  {
    dataMax = max(dataMax, row.getFloat(1));
  }
  minColor = color(255);   // white
  maxColorWORST = color(200, 0, 0);    // red
  maxColorBEST = color(0, 200, 0);  // green
  
 NORMAL();
 mousePressed();
  
}

void draw(){
  NORMAL();
  // Find the country at mouse position and draw in different color.
  int id = geoMap.getID(mouseX, mouseY);
 
  if (id != -1) {
      // clear previous highlighted land color
     mapColor();
      stroke(0,400);
      fill(180, 120, 120);   // Highlighted land color.
      geoMap.draw(id);
  }
  
  
}

void mapColor() {
  
    if (selectedButton == "NORMAL") {
      NORMAL();
      
    } else if (selectedButton == "WORST") {
      WORST();
      
    } else if (selectedButton == "BEST") {
      BEST();
    } 
}


void WORST() {   
  NORMAL();
  selectedButton = "WORST";
   find_worst();

   
}

void find_worst(){               // find the worst indicator and compare it with average value 
  for (int id : geoMap.getFeatures().keySet())
    {
      String countryCode = geoMap.getAttributeTable().findRow(str(id),0).getString("ISO_A3");
      TableRow dataRow = tabCountry.findRow(countryCode, 0);
  
   
      if (dataRow != null)       // Table row matches country code
      {
        float normPollution = dataRow.getFloat(1)/dataMax;

        fill(lerpColor(minColor, maxColorWORST, normPollution));
      }
      else                   // No data found in table.
      {

        fill(150);
      }
      stroke(0,40);
      geoMap.draw(id); // Draw country
    }
}


void BEST() {                
  NORMAL();
  selectedButton = "BEST";
  find_best();

}

void find_best(){                  // // find the best indicator and compare it with average value 
  for (int id : geoMap.getFeatures().keySet())
    {
  
      String countryCode = geoMap.getAttributeTable().findRow(str(id),0).getString("ISO_A3");
      TableRow dataRow = tabCountry.findRow(countryCode, 0);
  
   
      if (dataRow != null)       // Table row matches country code
      {
        float normPollution = dataRow.getFloat(1)/dataMax;

        fill(lerpColor(maxColorBEST, minColor, normPollution));
      }
      else                   // No data found in table.
      {

        fill(150);
      }
    
      stroke(0,40);
      geoMap.draw(id); // Draw country
    }

}

void NORMAL() {
  selectedButton = "NORMAL";

  // background for the map
  fill(202, 226, 245);
  stroke(0,40);
  if(width>=height){ 
    rect((width-height)/2, 0, height, height/2);
  } 
   

  // map
  fill(206,173,146);
  stroke(0,40);
  geoMap.draw(); // Draw the entire map.


}

void dataDivide() {


  float[] airPollution = {};
  FloatDict countryPollution = new FloatDict();
  String country;
  float pollution;

  
  for (TableRow row : data.rows()) {
    country = row.getString("Code");
    pollution = row.getFloat(airColumn);
    countryPollution.set(country, pollution);
  }
  
  for (float f: countryPollution.values()) {
    airPollution = append(airPollution, f);
  }
  

 pollutionLow = airPollution[int(airPollution.length/2)];

}


void mousePressed() {
  
  background(240);
    // background for the map
  fill(202, 226, 245);

  if(width>=height){ 
    rect((width-height)/2, 0, height, height/2); // map boundaries
  } else {
    rect(0,0,width,width/2);
  }  

  // map
  mapColor();
  
  dataDivide();
  
  float[] years = new float[0];
  float[] deaths = new float[0];
  
  int id = geoMap.getID(mouseX, mouseY);
  
  if (id != -1){
    
choice = geoMap.getAttributeTable().findRow(str(id),0).getString("NAME");
String choice_code = geoMap.getAttributeTable().findRow(str(id),0).getString("ISO_A3");

   for (TableRow row : data.matchRows(choice_code, "Code")) {
        if( row.getString("Code").equals(choice_code)){
          
chosed_year = row.getFloat("Year");
chosed_death = row.getFloat(airColumn);
       
        years = append(years, chosed_year);
        deaths = append(deaths, chosed_death);
      }
       
    }

    if (deaths.length>0) {
      
      float lastPollution = deaths[deaths.length-1];
      imageMode(CENTER);
      
      if (lastPollution<=pollutionLow) {
        tint(255, 100);
        image(low,width/2,height/2+300, low.width/2.5, low.height/2.5);
      } else {
        tint(255, 100);
        image(high,width/2,height/2+300, high.width/2, high.height/2);
      }
      lineChart.setData(years, deaths);
    }

  }
  
   else{
   lineChart.setData(year, death);
   choice = "World";

   imageMode(CENTER);
   tint(255, 100);
   image(low,width/2,height/2+300, low.width/2.5, low.height/2.5);
         }

  // show lineChart
  textAlign(LEFT);
  textSize(30);
  lineChart.draw(50,height/2,width-120,(height/2-50)-10);

  
  // Draw a title over the top of the chart.
  fill(120);
  textSize(40);
  text("Air pollution", 90,height/2-10);
  textSize(25);
  text("Deaths per 100 000",90,height/2+20);
  
    
  // show chosen country
  fill(50);
  textSize(50);
  textAlign(CENTER);
  text(choice, width/2, height/2+50);

}
