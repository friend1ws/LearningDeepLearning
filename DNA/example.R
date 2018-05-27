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


x_train <- array(0, c(40000, 800, 1))
y_train <- c()
for(i in 1:10000) {
  x_train[i,,1] <- DNAseq2vector(insertMotifSeqRandom(generateRandomDNASeq(200), "AGGGTACGTT", 1))
  y_train <- c(y_train, 1)
}
for(i in 1:10000) {
  x_train[i + 10000,,1] <- DNAseq2vector(insertMotifSeqRandom(generateRandomDNASeq(200), "CCTGGGAGGT", 1))
  y_train <- c(y_train, 1)
}
for(i in 1:10000) {
  x_train[i + 20000,,1] <- DNAseq2vector(insertMotifSeqRandom(generateRandomDNASeq(200), "GTCCGACGTG", 1))
  y_train <- c(y_train, 0)
}
for(i in 1:10000) {
  x_train[i + 30000,,1] <- DNAseq2vector(insertMotifSeqRandom(generateRandomDNASeq(200), "AAAACCAGTG", 1))
  y_train <- c(y_train, 0)
}






model <- keras_model_sequential() 
model %>% 
  layer_conv_1d(filters = 10, kernel_size = 40,  padding = "same", activation = "relu", strides = 4, input_shape = list(800, 1)) %>%
  layer_max_pooling_1d(pool_size = 20, padding = "same") %>%
  layer_flatten() %>%
  layer_dense(units = 1, activation = 'sigmoid')
  


model %>% compile(
  loss = 'binary_crossentropy',
  optimizer = "adam",
  metrics = c('accuracy')
)

history <- model %>% fit(
  x = x_train, y = y_train, 
  epochs = 300, 
  validation_split = 0.2
)

