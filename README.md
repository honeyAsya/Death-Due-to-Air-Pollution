# Death Due to Air Pollution

### Data dramatization with Processing


###### Our data dramatization project concerns air pollution problems. A large number of people have been dying annually, so we made our mind to draw public attention to this problem

# Data

Data source: https://www.kaggle.com/datasets/akshat0giri/death-due-to-air-pollution-19902017


We have used Python for preliminary analysis. The first file contains extracted uninteresting columns and deleted null, the second one contains averaged deaths for each country for all years and the third one contains averaged deaths for the whole world for each year


# Code

### We have used the following libraries:

* controlP5 - for interactive buttons

* giCentre geoMap - for drawing the world map

* giCentre utilities - for charts


### The most important variables

`String[] average = loadStrings("data/average_deaths.csv");`

This file contains averaged deaths for the whole world for each year is needed for an overall chart. We are using here string array for parsing float rows.

`Table tabCountry;`
`tabCountry = loadTable("average_country.csv");`

This file contains averaged deaths for each country for all years. It's needed for finding the largest data value so that we can scale colors

In the function `dataDivide()` we are going to find a messure by which we are going to compare which indicators have gotten better and which have gotten worse

The function `NORMAL()` show you a start screen and if you'll clicked on the button "NORMAL" or on the ocean, you'll return to the start screen

![](https://github.com/honeyAsya/Death-Due-to-Air-Pollution-Data-dramatization/blob/main/start%20screen.png "Start screen")

Thanks to the function `mousePressed()` you can see a chart for choosed country. If we don't have data about this country, you'll not see the chart and those countries will be highlighted in grey when the "BEST" or "WORST" button is selected.
![](https://github.com/honeyAsya/Death-Due-to-Air-Pollution-Data-dramatization/blob/main/Worst.png)
![](https://github.com/honeyAsya/Death-Due-to-Air-Pollution-Data-dramatization/blob/main/Best.png)
![](https://github.com/honeyAsya/Death-Due-to-Air-Pollution-Data-dramatization/blob/main/Example%20of%20choosing.png)

### Thank you for reading! I hope it's useful for you and it'll help you for your data visualization/dramatization projects!


