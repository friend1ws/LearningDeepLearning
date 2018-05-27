#! /usr/local/bin/R

D <- read.table("exon.sorted.filt.uniq.bed", header = FALSE, sep = "\t")

exon_size <- D$V3 - D$V2

png("exon_size_hist.png", width = 12, height = 12, units = "cm", res = 600)

hist(exon_size[exon_size <= 500], breaks = seq(0, 500, 10), col = "lightblue", main = "Histogram of Exon Size", xlab = "Exon Size")

dev.off()


