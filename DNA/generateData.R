ACGT_vec <- function(nuc) {
  if (nuc == "A") {
    return(c(1, 0, 0, 0))
  } else if (nuc == "C") {
    return(c(0, 1, 0, 0)) 
  } else if (nuc == "G") {
    return(c(0, 0, 1, 0)) 
  } else if (nuc == "T") {
    return(c(0, 0, 0, 1)) 
  } else if (nuc == "N") {
    return(c(0, 0, 0, 0))
  }
}

vec_ACG <- function(nuc) {
  if (nuc == c(1, 0, 0, 0)) {
    return(c(1, 0, 0, 0))
  } else if (nuc == "C") {
    return(c(0, 1, 0, 0)) 
  } else if (nuc == "G") {
    return(c(0, 0, 1, 0)) 
  } else if (nuc == "T") {
    return(c(0, 0, 0, 1)) 
  } else if (nuc == "N") {
    return(c(0, 0, 0, 0))
  }
}



DNAseq2vector <- function(DNAseq) {
  as.vector(sapply(strsplit(DNAseq, split = "")[[1]], ACGT_vec))
}

vector2DNAseq <- function(vector) {
  
}


generateRandomDNASeq <- function(nsize) {
  paste0(c("A", "C", "G", "T")[sample(x = 4, size = nsize, replace = TRUE)], collapse="")
}

insertMotifSeqRandom <- function(DNAseq, motif, num = 2) {
  for (i in 1:num) {
    start <- sample(x = nchar(DNAseq) - nchar(motif) + 1, size = 1)
    end <- start + nchar(motif) - 1
    substr(DNAseq, start, end) <- motif
  }
  return(DNAseq)
}


x_train <- c()
y_train <- c()
for(i in 1:1000) {
  x_train <- rbind(x_train, DNAseq2vector(insertMotifSeqRandom(generateRandomDNASeq(200), "AGGGTACGT", 3)))
  y_train <- c(y_train, 1)
}
for(i in 1:1000) {
  x_train <- rbind(x_train, DNAseq2vector(generateRandomDNASeq(200)))
  y_train <- c(y_train, 0)
}

