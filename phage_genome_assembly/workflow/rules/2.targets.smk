"""
Declare your targets here!
A separate file is ideal if you have lots of target files to create, or need some python logic to determine
the targets to declare. This example shows targets that are dependent on the input file type.
"""
allTargets =[]
genomes=[]

#QC_QA
if config['sequencing'] == 'paired':
    allTargets.append(expand(os.path.join(QCDIR, "{sample}_good_out_R1.fastq"), sample=SAMPLES))
    allTargets.append(expand(os.path.join(QCDIR, "{sample}_good_out_R2.fastq"), sample=SAMPLES))
elif config['sequencing'] == 'longread':
    allTargets.append(expand(os.path.join(QCDIR, "{sample}-filtlong.fastq"), sample=SAMPLES2))


#assembly
if config['sequencing'] == 'longread':
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-nanopore-unicycler", "assembly.fasta"), sample=SAMPLES2))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-nanopore-unicycler", "assembly.gfa"), sample=SAMPLES2))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-flye", "assembly.fasta"), sample=SAMPLES2))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-flye", "assembly_graph.gfa"), sample=SAMPLES2))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-flye", "assembly_info.txt"), sample=SAMPLES2))
elif config['sequencing'] == 'paired':
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-spades", "contigs.fasta"), sample=SAMPLES))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-spades", "assembly_graph_with_scaffolds.gfa"), sample=SAMPLES))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-spades", "contigs.paths"), sample=SAMPLES))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-megahit", "{sample}.contigs.fa"), sample=SAMPLES))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-megahit", "{sample}.fastg"), sample=SAMPLES))

#added assembler but not using it 
#allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-metaspades", "contigs.fasta"), sample=SAMPLES))

#coverage
if config['sequencing'] == 'paired':
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-spades", "{sample}-contigs.tsv"), sample=SAMPLES))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-megahit", "{sample}-contigs.tsv"), sample=SAMPLES))
elif config['sequencing'] == 'longread':
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-nanopore-unicycler", "{sample}-contigs.tsv"), sample=SAMPLES2))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-flye", "{sample}-contigs.tsv"), sample=SAMPLES2))

#viralverify
if config['sequencing'] == 'paired':
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-viralverify-spades", "contigs_result_table.csv"), sample=SAMPLES))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-viralverify-megahit", "{sample}.contigs_result_table.csv"), sample=SAMPLES))
elif config['sequencing'] == 'longread':
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-viralverify-unicycler_nano", "assembly_result_table.csv"), sample=SAMPLES2))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-viralverify-flye", "assembly_result_table.csv"), sample=SAMPLES2))

#graph components 
if config['sequencing'] == 'paired':
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-spades", "graph_seq_details_spades.tsv"), sample=SAMPLES))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-megahit", "graph_seq_details_megahit.tsv"), sample=SAMPLES))
elif config['sequencing'] == 'longread':
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-nanopore-unicycler", "graph_seq_details_unicycler.tsv"), sample=SAMPLES2))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-flye", "graph_seq_details_flye.tsv"), sample=SAMPLES2))

#assembly stats
if config['sequencing'] == 'paired':
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-assembly-stats_spades.tsv"), sample=SAMPLES))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-assembly-stats_megahit.tsv"), sample=SAMPLES))
elif config['sequencing'] == 'longread':
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-assembly-stats_unicycler.tsv"), sample=SAMPLES2))
    allTargets.append(expand(os.path.join(ASSEMBLY, "{sample}-assembly-stats_flye.tsv"), sample=SAMPLES2))

"""
#recircularize the phage contigs to start with terminase subunit 
genomes.append(expand(os.path.join(OUTDIR, "recircular", "{sample}-terminase.tsv"), sample=PHAGE))
genomes.append(expand(os.path.join(OUTDIR, "recircular", "{sample}.fasta"), sample=PHAGE))
genomes.append(expand(os.path.join(OUTDIR, "recircular-rc", "{sample}.fasta"),sample=PHAGE))

#coverage depths across the phage contigs
genomes.append(expand(os.path.join(OUTDIR, "coverage", "{sample}-illuminaReads.tsv"), sample=PHAGEIL))
genomes.append(expand(os.path.join(OUTDIR, "coverage", "{sample}-illuminaReads-bam", "coverm-genome.{sample}_good_out_R1.fastq.bam"), sample=PHAGEIL))
genomes.append(expand(os.path.join(OUTDIR, "coverage", "{sample}-illuminaReads-bam", "{sample}-Ill-bedtools-genomecov.tsv"), sample=PHAGEIL))

genomes.append(expand(os.path.join(OUTDIR, "coverage", "{sample}-NanoReads.tsv"), sample=PHAGENANO))
genomes.append(expand(os.path.join(OUTDIR, "coverage", "{sample}-NanoReads-bam", "coverm-genome.{sample}-filtlong.fastq.bam"), sample=PHAGENANO))
genomes.append(expand(os.path.join(OUTDIR, "coverage", "{sample}-NanoReads-bam", "{sample}-Nano-bedtools-genomecov.tsv"), sample=PHAGENANO))

"""