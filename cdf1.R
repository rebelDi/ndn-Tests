library(data.table)
library(mltools)

#
data1 <- read.csv("pro-1secChoicePercentage.csv", header=F, sep="\t")
data2 <- read.csv("re-1secChoicePercentage.csv", header=F, sep="\t")


#
# Define colors to be used for cars, trucks, suvs
#plot_colors <- c("darkorange", "blue", "black")
plot_colors <- c("darkorange", "blue")
plot_type <- c(1,2,4)
# Processing latency cdf for Topo1 (CDF1.eps)
pdf(file="ChoicePercenatge-1sec.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#
M <- cbind(data1[,2], data2[,2])
print(data1[,1][27])
barplot(t(M*100), ylim=c(0,100), col=plot_colors, border="black", beside = TRUE)#, main=heading) 
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
legend("topright", inset=.02, c("Proactive", "Reactive"), fill=plot_colors, cex=1.6)

#
dev.off()
#


data1 <- read.csv("pro-100secSortedLatencies_normal.csv", header=F, sep="\t")
data2 <- read.csv("re-100secSortedLatencies_normal.csv", header=F, sep="\t")

pdf(file="LAT_CDF-100sec.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#
plot(data1[,1], data1[,2], type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading) 
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=5, col=plot_colors[1]) 
lines(data2[,1], data2[,2], lty=plot_type[2], lwd=5, col=plot_colors[2]) 
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
legend("bottomright", cex=1.6, lwd=3, bty = "n", lty=plot_type[1:2],
       c("Proactive", "Reactive"), col=plot_colors)
#
dev.off()
#



data1 <- read.csv("pro-1secOverhead.csv", header=F, sep="\t")
data2 <- read.csv("re-1secOverhead.csv", header=F, sep="\t")

pdf(file="Overhead-1sec.pdf", paper="special", width=7, height=4)
#
par(mar=c(3.3, 4.5, 1.5, 0.3))
par(mgp = c(2, 1, 0))
#
par(font.axis=1)
par(las=1)
#
plot(data2[,1], data2[,2], type="l", lty=plot_type[3], axes=TRUE, ann=FALSE, cex.axis=1.3, col="white")#, main=heading)
lines(data1[,1], data1[,2], lty=plot_type[1], lwd=5, col=plot_colors[1])
lines(data2[,1], data2[,2], lty=plot_type[2], lwd=5, col=plot_colors[2])
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
legend("bottomright", cex=1.6, lwd=3, bty = "n", lty=plot_type[1:2],
       c("Proactive", "Reactive"), col=plot_colors)
#
dev.off()
#

