###############################
#11.�ra: Adatvizualiz�ci�     #
###############################

####################################Sima scatter plot######################################
#hasznos anyag:
#https://www.statmethods.net/advgraphs/axes.html
library(datasets)
data(iris)
colnames(iris)

szinek <- c("blue","green3","red")
plot(iris$Sepal.Length, iris$Petal.Length, 
     main="Edgar Anderson's Iris Data", 
     xlab = "Sepal.Length",
     ylab = "Petal.Length",
     col = szinek[iris$Species],
     col.axis = 'azure4',
     col.lab = 'azure4',
     col.ticks = "white",
     pch = 19,
     panel.first = grid(col = 'lightgray', lty = 7))
     box(col = "white")
     par(mar=c(4.5, 4.5, 4.5, 7.5), xpd = F)
     legend(8, 7, legend = unique(iris$Species),  col = szinek,
            pch = 19, bty = "n", xpd = T)

#https://benfradet.github.io/blog/2014/04/30/Display-legend-outside-plot-R
#par(mar=): marg� be�ll�t�sa
#panel.first: a vizualiz�ci�k layerekb�l �p�l fel �gy a sorrendet �llthatjuk ut�lagosan.
#sz�nez�s m�sk�pp (unclass): c("blue","green3","red")[unclass(iris$Species)]
#pch: a pontok t�pus�t lehet megadni.

########################################GGplot2###################################################
#http://bl.ocks.org/ramnathv/raw/10012123/example.html
#https://www.mailman.columbia.edu/sites/default/files/media/fdawg_ggplot2.html
library(ggplot2)
data("midwest", package = "ggplot2")
str(midwest)
unique(midwest$county)
nrow(midwest)

#objektumk�nt elmenthet� egy vizualiz�ci�:
#alap (�res)
g <- ggplot(midwest, aes(x=area, y=poptotal))
g
str(g) #lista az objektum
#m�veletek is v�gezhet�ek vele:
#pontok hozz�ad�sa:
g2 <- g + geom_point()
g2
str(g2)
#line�ris regresszi� hozz�ad�sa:
g <- ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() + geom_smooth(method="lm", se = FALSE)  
#se = FALSE hibahat�r leszed�se
g
g <- ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() + geom_smooth(method="loess", se = FALSE)
g
?geom_smooth
#kiugr� �rt�kek kezel�se (leszedni az axis alapj�n, �tsl�l�z�s):
# Ebben az esetben T�RL�M A PONTOKAT:
g + xlim(c(0, 0.1)) + ylim(c(0, 1000000))
# Ebben az esetben zoomulunk: (nem dobjuk el az adatokat)
g <- ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() + geom_smooth(method="lm")  # 
g1 <- g + coord_cartesian(xlim=c(0,0.1), ylim=c(0, 1000000))  # zooms in
plot(g1)
#c�m, label hozz�ad�sa:
g1 + labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")
#sz�n, m�ret:
#sz�nez�s �llam szerint: ehhez kell az aes fv, mely a df-en bel�li oszlopra hivatkozik:
gg <-ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state), size=3) +   
  geom_smooth(method="lm", col="firebrick") +  	
  coord_cartesian(xlim=c(0, 0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")
gg + theme(legend.position="None") 

#form�z�s -> sz�nvil�g �t�ll�t�sa:
?theme
library(RColorBrewer)
gg + scale_colour_brewer(palette = "Dark2")

#labelek �t�ll�t�sa:
gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state), size=3) +  # Set color to vary based on state categories.
  geom_smooth(method="lm", col="firebrick", size=2) + 
  coord_cartesian(xlim=c(0, 0.1), ylim=c(0, 1000000)) + 
  labs(title="Area Vs Population", subtitle="From midwest dataset", y="Population", x="Area", caption="Midwest Demographics")

gg + scale_x_continuous(breaks=seq(0, 0.1, 0.01))
gg + scale_x_continuous(breaks=seq(0, 0.1, 0.01), labels = letters[1:11])

#tengelyek t�kr�z�se:
gg + scale_x_reverse()

#sprintf: (C t�pus� f�gg�ny)
sprintf("%s is %f feet tall\n", "Sven", 7.1)
gg + scale_x_continuous(breaks=seq(0, 0.1, 0.01), labels = sprintf("%1.2f%%", seq(0, 0.1, 0.01))) + scale_y_continuous(breaks=seq(0, 1000000, 200000), 
                                                                                                                       labels = function(x){paste0(x/1000, 'K')})
#be�p�tett t�ma megh�v�sa:
?theme_set
theme_set(theme_dark())
gg
#apply parancs m�gegyszer:
df <- data.frame(a=0:10, b=letters[1:11])
df
paste0(df$a, "%", df$b)
#ez egyenl�:
apply(df, 1, function(x) paste0(x[1], "%", x[2]))
#ez egyenl�:
apply(df, 1, function(x) sprintf("%0.1f%%%s", as.numeric(x[1]), x[2]))
      