library(dada2); packageVersion("dada2")

# set working directory:
wdPath <- getwd()

# Input your dataset specific parameters there
# If you have >2 ASV tables you can adapt the script to include them with 'dataset.value3 = "dataset3"' etc.
directory.value <- "directoryinput"
dataset.value <- "dataset1"
dataset.value2 <- "dataset2"
dataset.value3 <- "dataset3"
runcount.value <- runcount.value.input

# Merge ASV tables from each run into a single table
if (runcount.value == 1){
   st1 <- readRDS(paste0(wdPath, paste("/dada2output/",directory.value,"/ASVtab.nochim", dataset.value, ".RDS", sep = "")))
   st.all <- st1
} else if (runcount.value == 2){
   st1 <- readRDS(paste0(wdPath, paste("/dada2output/",directory.value,"/ASVtab.nochim", dataset.value, ".RDS", sep = "")))
   st2 <- readRDS(paste0(wdPath, paste("/dada2output/",directory.value,"/ASVtab.nochim", dataset.value2, ".RDS", sep = "")))
   st.all <- mergeSequenceTables(st1, st2)
} else if (runcount.value == 3){
   st1 <- readRDS(paste0(wdPath, paste("/dada2output/",directory.value,"/ASVtab.nochim", dataset.value, ".RDS", sep = "")))
   st2 <- readRDS(paste0(wdPath, paste("/dada2output/",directory.value,"/ASVtab.nochim", dataset.value2, ".RDS", sep = "")))
   st3 <- readRDS(paste0(wdPath, paste("/dada2output/",directory.value,"/ASVtab.nochim", dataset.value3, ".RDS", sep = "")))
   st.all <- st.all <- mergeSequenceTables(st1, st2, st3)
} else if (runcount.value == 4){
   st1 <- readRDS(paste0(wdPath, paste("/dada2output/",directory.value,"/ASVtab.nochim", dataset.value, ".RDS", sep = "")))
   st2 <- readRDS(paste0(wdPath, paste("/dada2output/",directory.value,"/ASVtab.nochim", dataset.value2, ".RDS", sep = "")))
   st3 <- readRDS(paste0(wdPath, paste("/dada2output/",directory.value,"/ASVtab.nochim", dataset.value3, ".RDS", sep = "")))
   st4 <- readRDS(paste0(wdPath, paste("/dada2output/",directory.value,"/ASVtab.nochim", dataset.value4, ".RDS", sep = "")))
   st.all <- st.all <- mergeSequenceTables(st1, st2, st3)
}

#### merged FASTA export

# Give sequence headers more manageable names (ASV_1, ASV_2...)
# Get sequences
asv_seqs <- colnames(st.all)
# Create a holding object for new ASV names
asv_headers <- vector(dim(st.all)[2], mode="character")
# Using a for loop, create sequential ASV names
for (i in 1:dim(st.all)[2]) {
asv_headers[i] <- paste(">ASV", i, sep="_")
}
# Create and write out a mew fasta file for the merged ASV table
asv_fasta <- c(rbind(asv_headers, asv_seqs))
# Export fasta file
write(asv_fasta, file=paste0(wdPath,paste("/dada2output/",directory.value,"/ASVs",directory.value,".fasta",sep="")))

##### merged SEQTAB export
# Create ASV dataframe
asv_tab <- t(st.all)
# Rename ASVs with our simplified names
row.names(asv_tab) <- sub(">", "", asv_headers)
# Double check it looks sensible
head(asv_tab)

#add placeholder column, then row.names=FALSE
Taxa <- rownames(asv_tab)
head(Taxa)
data <- cbind(Taxa,asv_tab)
head(data)

write.table(
        data,
        file=paste0(wdPath,paste("/dada2output/",directory.value,"/ASVtable",directory.value,".csv",sep="")),
        sep=",", quote=F, row.names = FALSE)

write.table(
        data,
        file=paste0(wdPath,paste("/dada2output/",directory.value,"/ASVtable",directory.value,".tsv",sep="")),
        sep="\t", quote=F, row.names = FALSE)
