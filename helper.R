library (ggplot2)

getPlot =  function (typ) {
    if (typ=="w") {
        p = windChillPlot()
    }
    else {
        p = heatIndexPlot()
    }
    p
}

heatIndexPlot = function () {
    library (ggplot2)
    df = NULL
    df = data.frame()
    
    for (rh in c(10,20,30,40,50,60,70,80,90)) {
        for (t in 70:105) {
            ci = calcComfort(t,rh,10)
            df = rbind(df,c(rh,t,ci))
        }
    }
    colnames(df) = c("Humidity","Temperature","ComfortIndex")
    plt <- ggplot(
        data=df, aes(x=Temperature, y=ComfortIndex, 
                     group=Humidity, color = Humidity)) +
        ggtitle ("Heat Comfort Index") +
        labs(x = "Temperature (df)", y ="Comfort Index") +
        geom_line() +
        geom_point () +
        scale_colour_gradient(low="blue",high="red")
    plt
}
windChillPlot = function () {
    dfwc = NULL
    dfwc = data.frame()

    for (ws in c(5,10,15,20,25,30,35,40,45,50,55,60)) {
        for (t in -15:40) {
            ci = calcComfort(t,20,ws)
            dfwc = rbind(dfwc,c(ws,t,ci))
        }
    }
    colnames(dfwc) = c("WindSpeed","Temperature","ComfortIndex")

    plt <- ggplot(
        data=dfwc, aes(x=Temperature, y=ComfortIndex, 
                       group=WindSpeed, color = WindSpeed)) +
        ggtitle ("Windspeed Comfort Index") +
        labs(x = "Temperature (df)", y ="Comfort Index") +
        geom_line() +
        geom_point () +
        scale_colour_gradient(low="orange",high="blue")            
}    

calcComfort = function (t,rh,ws)
# see http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3801457/    
  {

nt = t
if (t<=40) {
    nt = windChill(t,ws)
}
else {
    nt = steadmanAdj(t,rh)
} 
    if (t <80) {
    # first adjustment - prior to heat index
#        nt
    }
    else {
        # calculate heat index
        nt = heatIdx(t,rh)  
        if (rh<=13 && t <= 112) {
            nt = nt + adjLowH (nt, rh)
            #nt
        }
        else if (t <= 87 && rh > 85) {
            nt = nt + adj8587(nt,rh)
            
      }
}
round(nt,1)
}

windChill = function (t,ws) {
if (ws <=3) {
    t
    }
else {
    35.74 + 0.6215*t - 35.75*ws^0.16 + 0.4275*t*(ws^0.16)
    }
    
}
heatIdx = function (t,rh) {
#    -42.379 + 2.04901523*t + 10.14333127*rh - 0.22475541*t*rh - 6.83783e-3*t 2 - 5.481717x10-2R 2 + 1.22874x10-3T 2R + 8.5282x10-4TR2 - 1.99x10-6T 2R
    -42.379 + 2.04901523*t + 10.14333127*rh - 0.22475541*t*rh - 0.00683783*t^2 - 0.05481717*rh*rh + .00122874*t*t*rh + 0.00085282*t*rh*rh - 0.00000199*t*t*rh*rh
}
steadmanAdj = function (t,rh) {
    -10.3 + 1.1*t + 0.047 * rh
}
adjLowH = function (t,rh) {
    ((13 - rh)/4) * ((17-(t-95))/17)^0.5
}

adj8587 = function (t,rh) {
    0.02 * (rh - 85) * (87 - t) 
}    

convertF2C = function(df) {
    round((df-32)*5/9,1)
    
} 