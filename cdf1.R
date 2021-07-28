library(data.table)
library(mltools)

#
data1 <- read.csv("pro-1-1-01ChoicePercentage.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01ChoicePercentage.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01ChoicePercentage.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01ChoicePercentage.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01ChoicePercentage.csv", header=F, sep="\t")

main_legend <- c("Pro1-1-01", "Pro1-5-01", "Pro1-10-01", "Pro1-15-01", "Rea1-1-01")
#
# Define colors to be used for cars, trucks, suvs
#plot_colors <- c("darkorange", "blue", "black")
plot_colors <- c("darkorange", "green", "red", "yellow", "blue")
plot_type <- c(1,2,4)
# Processing latency cdf for Topo1 (CDF1.eps)
pdf(file="ChoicePercentage-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#
M <- cbind(data1[,2], data2[,2], data3[,2], data4[,2], data5[,2])
print(data1[,1][27])
x <- c(1:10);

barplot(t(M*100), ylim=c(0,100), names=x, col=plot_colors, border="black", beside = TRUE)#, main=heading) 
par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Rank", col.lab="black", cex.lab=1.5, font=2)
#
par(mgp = c(3, 2.5, 1))
title(ylab="Percentage of Requests", col.lab="black", las=1, cex.lab=1.5, font=2)

#
legend("topright", inset=.02, main_legend, fill=plot_colors, cex=1.6)

#
dev.off()
#

data1 <- read.csv("pro-1-1-01ChoiceDist.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01ChoiceDist.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01ChoiceDist.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01ChoiceDist.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01ChoiceDist.csv", header=F, sep="\t")

name <- c("PEC", "Infra")

pdf(file="PEC-Infra-block10.pdf", paper="special", width=7, height=4)

matr <- (rbind(c(data1[1,2], data2[1,2], data3[1,2], data4[1,2], data5[1,2]),
	       c(1-data1[1,2], 1-data2[1,2], 1-data3[1,2], 1-data4[1,2], 1-data5[1,2])
			                     ))
barplot(prop.table(matr,2), names=main_legend, col=plot_colors, border="black")
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Scenario", col.lab="black", cex.lab=1.5, font=2)
#
par(mgp = c(3, 2.5, 1))
title(ylab="Ratio", col.lab="black", las=1, cex.lab=1.5, font=2)

legend("bottomright", inset=.02, name, fill=plot_colors, cex=1.6)

dev.off()

name <- c("Direct Discovery", "BS Discovery")
pdf(file="ByPass-block10.pdf", paper="special", width=7, height=4)

matr <- (rbind(c(data1[3,2], data2[3,2], data3[3,2], data4[3,2], data5[3,2]),
	       c(1-data1[3,2], 1-data2[3,2], 1-data3[3,2], 1-data4[3,2], 1-data5[3,2])
			                                                   ))
barplot(prop.table(matr,2), names=main_legend, col=plot_colors, border="black")
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Scenario", col.lab="black", cex.lab=1.5, font=2)
#
par(mgp = c(3, 2.5, 1))
title(ylab="Ratio", col.lab="black", las=1, cex.lab=1.5, font=2)

legend("topright", inset=.02, name, fill=plot_colors, cex=1.6)

dev.off()

data1 <- read.csv("pro-1-1-01BestDist.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01BestDist.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01BestDist.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01BestDist.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01BestDist.csv", header=F, sep="\t")

name <- c("PEC", "Infra")
pdf(file="Proportion-Best-Choice-block10.pdf", paper="special", width=7, height=4)

matr <- (rbind(c(data1[1,2], data2[1,2], data3[1,2], data4[1,2], data5[1,2]),
	                                     c(1-data1[1,2], 1-data2[1,2], 1-data3[1,2], 1-data4[1,2], 1-data5[1,2])
					                                                                                ))
barplot(prop.table(matr,2), names=main_legend, col=plot_colors, border="black")
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Scenario", col.lab="black", cex.lab=1.5, font=2)
#
par(mgp = c(3, 2.5, 1))
title(ylab="Ratio", col.lab="black", las=1, cex.lab=1.5, font=2)

legend("bottomright", inset=.02, name, fill=plot_colors, cex=1.6)

dev.off()


data1 <- read.csv("pro-1-1-01SortedLatencies_normal.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01SortedLatencies_normal.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01SortedLatencies_normal.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01SortedLatencies_normal.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01SortedLatencies_normal.csv", header=F, sep="\t")

pdf(file="LAT_CDF-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#
plot(data1[,1], data1[,2], type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading) 
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1]) 
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2]) 
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Latency (Seconds)", col.lab="black", cex.lab=1.5, font=2)
#
par(mgp = c(3, 2.5, 1))
title(ylab="CDF", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("bottomright", cex=1.6, lwd=2, bty = "n", lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), main_legend, col=plot_colors)
#
dev.off()
#

data1 <- read.csv("pro-1-1-01Overhead.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01Overhead.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01Overhead.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01Overhead.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01Overhead.csv", header=F, sep="\t")

pdf(file="Overhead-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#
plot(data5[,1], data5[,2], xlim=c(0,200), ylim=c(0,130), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
num <- 20
average=filter(data2, rep(1/num,num))
data2[,2]=average[,2]
average=filter(data3, rep(1/num,num))
data3[,2]=average[,2]
average=filter(data4, rep(1/num,num))
data4[,2]=average[,2]
average=filter(data5, rep(1/num,num))
data5[,2]=average[,2]


lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
par(mgp = c(3, 2.5, 1))
title(ylab="Updates", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
         main_legend, col=plot_colors)
#
dev.off()
#

data1 <- read.csv("pro-1-1-01InfraAvail.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01InfraAvail.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01InfraAvail.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01InfraAvail.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01InfraAvail.csv", header=F, sep="\t")

pdf(file="Infra-availability-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#
#data1[,2] <- data1[,2] - 1
#data2[,2] <- data2[,2] - 1
#data3[,2] <- data3[,2] - 1
#data4[,2] <- data4[,2] - 1
#data5[,2] <- data5[,2] - 1

plot(data5[,1], data5[,2], xlim=c(0,199), ylim=c(0.9,2.2), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
par(mgp = c(3, 2.5, 1))
title(ylab="Number of options", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
                main_legend, col=plot_colors)
#
dev.off()

data1 <- read.csv("pro-1-1-01PECAvail.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01PECAvail.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01PECAvail.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01PECAvail.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01PECAvail.csv", header=F, sep="\t")

pdf(file="PEC-availability-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#
#data1[,2] <- data1[,2] - 1
#data2[,2] <- data2[,2] - 1
#data3[,2] <- data3[,2] - 1
#data4[,2] <- data4[,2] - 1
#data5[,2] <- data5[,2] - 1

plot(data5[,1], data5[,2], xlim=c(0,199), ylim=c(0.9,5), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
#
par(mgp = c(3, 2.5, 1))
title(ylab="Number of options", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
                       main_legend, col=plot_colors)
#
dev.off()

data1 <- read.csv("pro-1-1-01InfraUtilRates.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01InfraUtilRates.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01InfraUtilRates.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01InfraUtilRates.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01InfraUtilRates.csv", header=F, sep="\t")

pdf(file="Infra-utility-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#

plot(data5[,1], data5[,2], xlim=c(0,199), ylim=c(16, 60), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
#
par(mgp = c(3, 2.5, 1))
title(ylab="Percentage", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
                       main_legend, col=plot_colors)
#
dev.off()

data1 <- read.csv("pro-1-1-01PECUtilRates.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01PECUtilRates.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01PECUtilRates.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01PECUtilRates.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01PECUtilRates.csv", header=F, sep="\t")

pdf(file="PEC-utility-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#

plot(data5[,1], data5[,2], xlim=c(0,199), ylim=c(15,50), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
#
par(mgp = c(3, 2.5, 1))
title(ylab="Percentage", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
                       main_legend, col=plot_colors)
#
dev.off()

data1 <- read.csv("pro-1-1-01LossRate.txt", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01LossRate.txt", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01LossRate.txt", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01LossRate.txt", header=F, sep="\t")
data5 <- read.csv("re-1-1-01LossRate.txt", header=F, sep="\t")

pdf(file="Success-rate-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#

plot(data5[,1], data5[,2], xlim=c(0,199), ylim=c(0,1.1), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
#
par(mgp = c(3, 2.5, 1))
title(ylab="Percentage", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
                       main_legend, col=plot_colors)
#
dev.off()


data1 <- read.csv("pro-1-1-01InfraUtilAll.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01InfraUtilAll.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01InfraUtilAll.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01InfraUtilAll.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01InfraUtilAll.csv", header=F, sep="\t")

pdf(file="InfraUtilAll-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#

plot(data5[,1], data5[,2], xlim=c(0,199), ylim=c(20, 50), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
#
par(mgp = c(3, 2.5, 1))
title(ylab="Percentage", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
                              main_legend, col=plot_colors)
#
dev.off()



data1 <- read.csv("pro-1-1-01InfraUtilMax.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01InfraUtilMax.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01InfraUtilMax.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01InfraUtilMax.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01InfraUtilMax.csv", header=F, sep="\t")

pdf(file="InfraUtilMax-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#

plot(data5[,1], data5[,2], xlim=c(0,199), ylim=c(20, 100), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
#
par(mgp = c(3, 2.5, 1))
title(ylab="Percentage", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
                              main_legend, col=plot_colors)
#
dev.off()


data1 <- read.csv("pro-1-1-01InfraUtilMin.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01InfraUtilMin.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01InfraUtilMin.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01InfraUtilMin.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01InfraUtilMin.csv", header=F, sep="\t")

pdf(file="InfraUtilMin-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#

plot(data5[,1], data5[,2], xlim=c(0,199), ylim=c(14, 40), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
#
par(mgp = c(3, 2.5, 1))
title(ylab="Percentage", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
                              main_legend, col=plot_colors)
#
dev.off()


data1 <- read.csv("pro-1-1-01PECUtilAll.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01PECUtilAll.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01PECUtilAll.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01PECUtilAll.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01PECUtilAll.csv", header=F, sep="\t")

pdf(file="PECUtilAll-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#

plot(data5[,1], data5[,2], xlim=c(0,199), ylim=c(15, 40), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
#
par(mgp = c(3, 2.5, 1))
title(ylab="Percentage", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
                              main_legend, col=plot_colors)
#
dev.off()




data1 <- read.csv("pro-1-1-01PECUtilMax.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01PECUtilMax.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01PECUtilMax.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01PECUtilMax.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01PECUtilMax.csv", header=F, sep="\t")

pdf(file="PECUtilMax-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#

plot(data5[,1], data5[,2], xlim=c(0,199), ylim=c(0, 110), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
#
par(mgp = c(3, 2.5, 1))
title(ylab="Percentage", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
                              main_legend, col=plot_colors)
#
dev.off()


data1 <- read.csv("pro-1-1-01PECUtilMin.csv", header=F, sep="\t")
data2 <- read.csv("pro-1-5-01PECUtilMin.csv", header=F, sep="\t")
data3 <- read.csv("pro-1-10-01PECUtilMin.csv", header=F, sep="\t")
data4 <- read.csv("pro-1-15-01PECUtilMin.csv", header=F, sep="\t")
data5 <- read.csv("re-1-1-01PECUtilMin.csv", header=F, sep="\t")

pdf(file="PECUtilMin-block10.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#

plot(data5[,1], data5[,2], xlim=c(0,199), ylim=c(10, 40), type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=2, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[1], lwd=2, col=plot_colors[2])
lines(data3[,1], data3[,2], lty=plot_type[1], lwd=2, col=plot_colors[3])
lines(data4[,1], data4[,2], lty=plot_type[1], lwd=2, col=plot_colors[4])
lines(data5[,1], data5[,2], lty=plot_type[2], lwd=2, col=plot_colors[5])

par(xpd=TRUE)
#
box()
# Label the x and y axes with dark green text
par(mgp = c(2.2, 1, 2))
title(xlab="Seconds", col.lab="black", cex.lab=1.5, font=2)
#
#
par(mgp = c(3, 2.5, 1))
title(ylab="Percentage", col.lab="black", las=1, cex.lab=1.5, font=2)
#
legend("top", cex=0.7, lwd=2, lty=c(plot_type[1], plot_type[1], plot_type[1], plot_type[1], plot_type[2]), horiz=TRUE,
                              main_legend, col=plot_colors)
#
dev.off()

