# Phage genome toolkit 
Phage genome assembly and annotation 

Pure isolate phages seqeunced on Illumina (paired end) and Nanopore (long read) sequencing technology are processed through the following steps
  - quality control (Illumina: prinseq++, Nanopore: Filtlong)
  - assembly (Illumina: SPAdes and Megahit, Nanopore: Flye and Unicycler)
  - assembly statistics: 
      - read coverage of each contig (CoverM), 
      - contig classification as bacterial/plasmid/viral (viral verify)
      - number of graph components (assembly graph files, python scripts added here)
  
The final ouput is tab separated file providing the summary for each sample assembly, with contig features.


## Install 
Steps for installing this workflow 

    git clone https://github.com/npbhavya/phage-genomes.git
    cd phage-genomes
    python setup.py install 
    #confirm the workflow is installed by running the below command 
    phage_genome_assembly --help
  
 
## Installing databases
  This workflow requires the Pfam35.0 database to run viral_verify for contig classification. This is done automagically when the below command is run. 
  
    phage_genome_assembly install database 
    
## Running the workflow
Only one command needs to be submitted to run all the above steps: QC, assembly and assembly stats

    #For illumina reads, place the reads both forward and reverse reads to one directory
    phage_genome_assembly run --input test/illumina-subset --output example --profile slurm 

    #For nanopore reads, place the reads, one file per sample in a directory
    phage_genome_assembly run --input test/nanopore-subset --preprocess longread --output example 

    #To run either of the commands on the cluster, add --profile slurm to the command. For instance here is the command for longreads/nanopore reads 
    phage_genome_assembly run --input test/nanopore-subset --preprocess longread --output example --profile slurm 

## Output
For each sample there should be a tab separated file for each assembler. For instance if test nanopore reads were run through the workflow, then there should be two files within the example/assembly directory
  - reads-assembly-stats_flye.tsv
  - reads-assembly-stats_unicycler.tsv

Each of these files shold contain the 12 columns with the folowing titles and results for each contig assembled. This was a test run, so only one contig was assembled. 

|1    | 2     |    3                                     | 4       |  5       | 6         |  7        |   8      |  9     |  10       |  11 | 12      |
|-----|-------|------------------------------------------|---------|----------|-----------|-----------|----------|--------|-----------|-----|---------|
|Index| Contig| assembly.fasta/reads-filtlong.fastq Mean |Length_x |Circular_x|Connections|Contig name|Prediction|Length_y|Circular_y|Score|Pfam hits|
|0    |contig_1|43.97074                                 |100739   |False     |0          |contig_1   |Virus     |100739  |-         |40.06|Glucosaminidase HNH_3 UDG Asp_protease_2 NUMOD4 GIY-YIG Band_7 Ribonuc_red_lgC DUF1599 Radical_SAM Helicase_C DUF3799 dUTPase Thy1 Toprim_2 NUMOD1 DUF5675 DNA_pol_A_exo1 VWA ThiF AAA_33 NUMOD3 DNA_pol_A |

