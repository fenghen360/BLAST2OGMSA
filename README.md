# BLAST2OGMSA
Whole organelle genome-wide alignment construction method, which ultilizes BLAST tool, to facilitate phylogeny analysis.

# What is BLAST2OGMSA?

　　BLAST2OGMSA is a new and highly efficient pipeline that used homologous blocks searching method to construct multi-gene alignment. It can automatically recognize locally collinear blocks (LCB) among organelle genomes and excavate phylogeny informative regions to construct multi-gene involved alignment in few hours.<br/>
　　Because the traditional way of constructing multi-gene alignments, which was utilized in organelle phylogenomics analysis, is a time-consuming process. Therefore, for the purpose of improving the efficiency of sequence matrix construction derived from multitudes of organelle genomes, we developed a time-saving and accurate method that would be utilized in phylogenomics studies. <br/>
　　In this pipeline, the core conserved fragment (conserved coding genes, functional non-coding regions and rRNA) will be picked out and integrated into a long sequence from the same genome. This method avoids the bothering sequence alignment procedure of every single gene and can generate phylogeny informative and high quality data matrix. Usually, instead of week-long manual work, it only takes less than an hour to construct the HomBlocks matrix with around two dozens of organelle genomes. In addition, HomBlocks produces optimal partition schemes of sequences and sequence evolution models for RAxML, which are important in downstream phylogeny analysis.<br/>

## Conventional way for construction of multi-gene alignment from organelle genomes

　　Almost all studies regarding of organelle genomics are accustomed to making phylogeny analyses by taking advantage of multiple genes in improvements of phylogentic resolution. But, usually, every single set of orthology genes is required to be pre-aligned, then concatenation will be performed among these common aligned genes. Although some softwares, like Sequence Matrix, can facilitate the procedure of sequence extraction or concatenation, constructing multi-gene alignments derived from organelle genomes is a complex process and prone to induce artificial errors. Despite that, the most concerning point for researches is how long this alignment procedure will take. In general, with the help of some bioinformatics tools, it will take at least two weeks to make genome-wide alignments using common genes among 30 higher plant chloroplast genomes (about 150kb long with at least 100 common genes). Thus, the phenomenon that the number of genes used in phylogeny were decreased below 70 is common in papers of plant chloroplast genomes. And reseachers have to be patient and cautious, because single gene alignment with artificial errors can lead to undetectable misplacement in the final alignments. Generally speaking, organelle phylogenomic analysis provides exact tools to detect genetic relationships, but the construction of multi-gene alignments does not sound convenient.  <br/>


## Reasons why alignment cannot be established using whole organelle genomes
　　The evolution of organelle genomes is dynamic and diverse in gene content, structure and sequnce divergence. Thus, basically speaking, these genomes cannot be aligned directly using the whole genome sequences as shown by picture below.<br/>

![image](https://github.com/fenghen360/Tutorial/blob/master/pic/alignment2.png)<br/>
　　This is the result picture of Mauve which shows the comparison of plastid genomes of three green algae. As we can see, there is a large invert frament in Ulva sp. when comparing with other sequences (arrow B). The gene content and intergenic region length are also different (arrorw C). Similarly, number of gene introns among the genomes were different (arrow A). The most direct consequence is that they exhibited in different length (arrow D). For aligners, these characteristics can lead to fatal error or being corrupted.  <br/>
　　Organelle genomes within intraspecies are usually conserved both in length and structure. So, in some cases, they can be aligned directly. But in nine cases out of ten, researches of organelle genomes focus on interspecies level, which means the direct alignment is difficult to realize.<br/>
   
## Methodology
The working flow diagram was shown below.<br/>

![image](https://github.com/fenghen360/Tutorial/blob/master/pic/workflow2.png)<br/>

　　HomBlocks utilizes progressiveMauve, which applies anchored alignment algorithm, to identify locally collinear blocks (LCBs) shared by organelle genomes (chloroplast and mitochondrial genomes). The co-exist LCBs among all organelle genomes will be extracted and trimmed to screen the phylogeny informative regions out.<br/>
　　HomBlocks offers four different methods for LCBs trimming: Gblocks, trimAl, noisy and BMGE. Without settings, the default trimming method is Gblocks. <br/>
　　The final alignment that was composed of trimmed LCB could be used in downstream analysis. Additional parameters were provided for users to select the best fit DNA substitution model and optimal partition schemes and models of sequence evolution for RAxML with the final alignment by PartitionFinder.<br/>


## Installation
　　HomBlocks is a pipeline that implemented by Perl 5. <br/>
　　No external installation is needed for HomBlocks.<br/>
　　All the dependencies external executable files are placed under bin directory.<br/>
　　git clone https://github.com/fenghen360/HomBlocks.git　<br/>
　　Or download the zip compressed files into your work directory<br/>
  

```bash
# Decompressing files
unzip HomBlocks-master.zip

# Note that Homblocks.pl is the main program, you can check it's usage by
perl BLAST2OGMSA.pl

# Check wether programs in bin directory are executable. if they are not, change their permission.
cd HomBlocks-master
cd bin
chmod 755 *

# make programes in PartitionFinderV1.1.1 executable
cd ..
cd PartitionFinderV1.1.1
chmod 755 *
chmod 755 PartitionFinder*
cd programs
chmod 755 *
cd ..
cd partfinder
chmod 755 *

```

### Required software

1. perl with version above 5
2. java with version above 1.7 (required by BMGE.jar)

## Tutorial

　　HomBlocks is not complex to use. What it needs are fasta or gebank files (fasta, fas, fa or gb suffix). You must put all these sequences **in a directory**. Like these test sequnces that were put in **Xenarthrans/fasta**.<br/>

To begin with, you can check the usage of HomBlocks without any parameters.<br/>

```bash
# check usage
perl BLAST2OGMSA.pl

# The print of screen should be like this

usage: perl BLAST2OGMSA.pl -method=[Gblocks|trimAl|BMGE|noisy] <file.aln> <seqdump.txt> <species_name> <output.fasta>


```
<br/>
<br/>
#### Running with 36 Xenarthrans mitochondrial genomes as an example

This dataset of example running was referred to this paper:<br/>
**Gibb, G. et al. (2016). Shotgun mitogenomics provides a reference phylogenetic framework and timescale for living xenarthrans. Molecular Biology and Evolution, 33(3), 621-642.**<br/>

Example run with parameters like this:<br/>

```bash
perl HomBlocks.pl --align --path=/public/home/mgb217/HomBlocks/Xenarthrans/fasta/ -out_seq=Xenarthrans.output.fasta  --mauve-out=Xenarthrans.mauve.out
```
<br/>

The meanings of these parameters could be found in the usage of HomBlocks. It should be noted that ```--align``` and ```--path``` must be set at same time.<br/>
Because ```--align``` means that you have no mauve alignments result file for the first time, so set this parameter to run progressiveMauve for LCB detection. Meanwhile,  ```--path``` parameter will define the absolute path of directory in where you put your sequences.<br/>
<br/>
<br/>
Next, HomBlocks will detect the sequences in the directory you defined.<br/>
The printscreen should be like this:<br/>

```bash
Totla 36 files detected!
The list of sequences will be aligned:
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Bradypus_pygmaeus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Bradypus_torquatus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Bradypus_tridactylus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Bradypus_variegatus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Bradypus_variegatus_old.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cabassous_centralis.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cabassous_chacoensis.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cabassous_tatouay.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cabassous_unicinctus_ISEM_T-2291.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cabassous_unicinctus_MNHN_1999-1068.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Calyptophractus_retusus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Chaetophractus_vellerosus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Chaetophractus_villosus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Chlamyphorus_truncatus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Choloepus_didactylus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Choloepus_didactylus_old.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Choloepus_hoffmanni.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Cyclopes_didactylus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_hybridus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_kappleri.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_novemcinctus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_novemcinctus_old.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_pilosus_LSUMZ_21888.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_pilosus_MSB_49990.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_sabanicola.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_septemcinctus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Dasypus_yepesi.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Euphractus_sexcinctus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Myrmecophaga_tridactyla.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Priodontes_maximus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Tamandua_mexicana.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Tamandua_tetradactyla.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Tamandua_tetradactyla_old.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Tolypeutes_matacus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Tolypeutes_tricinctus.fasta
/public/home/mgb217/HomBlocks/Xenarthrans/fasta/Zaedyus_pichiy.fasta
<===========Please re-check.============>

Keep going?
[Press Enter/Ctrl+C]

```

If the number of these sequences is matched, print **Enter** key to continue. Otherwise, print **Ctrl+C** to abort and check whether the suffix of these sequences is correct.<br/>

When the LCB detection process run is complete, HomBlocks will start triming LCBs step.<br/>
After trimming, all filtered module sequences of each species will be concatenated together.<br/>


#### Output files

##### 1. The most important result

This simple run was finished resulting with alignment file named **Xenarthrans.output.fasta**<br/>
Sequences in **Xenarthrans.output.fasta** were already aligned, you can check it by aligners like MEGA, clustalx or UGENE.

![image](https://github.com/fenghen360/Tutorial/blob/master/pic/ugene.png)<br/>

##### 2. The LCB trimming result named module_X.fasta-gb.html and module_X.fasta
And the LCB trimming results: <br/>
　　　　　　　**module_1.fasta** (timmed LCB sequnce) <br/>
　　　　　　　**module_1.fasta-gb.htm** (trimming results from Glbocks. In this case，only one LCB was detectable) <br/>
Your can review the trimming results through web browser.<br/>
The results of trimmer Gblocks (default).<br/>
![image](https://github.com/fenghen360/Tutorial/blob/master/pic/Gblock.png)<br/>
<br/><br/>
The results of trimmer trimAl.
<br/>
![image](https://github.com/fenghen360/Tutorial/blob/master/pic/trimAl.png)<br/>
<br/><br/>
The results of trimmer BMGE.<br/>
![image](https://github.com/fenghen360/Tutorial/blob/master/pic/BMGE.png)<br/>

Note that trimmer noisy produces no visualization result.
And different trimmer applys different strategies and algorithms.
Within interspecies or very closed species organelle genomes, trimAl or BMGE could be a better choice. But BMGE is relative slower than other trimmers.<br/>


## Notes
**1. Please delete all fasta and html files under HomBlocks main directory, if you rerun with result file of progressiveMauve.**<br/>
**2. It's better to use the species names as the names of fasta files. Because the headers in the final alignments will be the names of files rather than the header in every raw fasta sequence. And more important, no blank is allowed in names of these fasta sequences, becasue progressiveMauve will recognize one blank as a parameter. Please use underscore character instead.** <br/>
**3. PartitionFinder only works with the existence of more than 2 LCBs.**<br/>
**4. Parameters of the four trimmers and progressiveMauve can be modified directly in HomBlocks.pl, if you were familiar with them and want to make adjustment for your own data.** <br/>
**5. The runtimes and memory requirements of HomBlocks are highly dependent on the use cases. More genomes, especially chloroplast genomes will take longer time. But several hours are still faster than several days or weeks.** ^_^<br/>

Enjoy it! Please contact with me (fenghen360@126.com) if you have any problems.<br/><br/>
## Acknowledgements

I would like to thank:

1. Chengjie Chen (College of Horticulture, South China Agricultural University)
2. Penghao Yu (Institute of Genetics and Developmental Biology, Chinese Academy of Sciences)
3. Xiwen Xu (College of informatics, HuaZhong agricultual university)

for their help.
