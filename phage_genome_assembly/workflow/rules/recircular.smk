"""
Recircularise the phage genomes so they start with terminase large subunit
"""
#rule to map the contig against the terminase subunit
rule terminase_search:
    input:
        contigs = os.path.join(GENOMEDIR, "{sample}.fasta"),
    output:
        tsv = os.path.join(OUTDIR, "recircular", "{sample}-terminase.tsv"),
    log:
        os.path.join(logs, "terminase_{sample}.log")
    conda: "../envs/blast.yaml"
    threads: 10
    resources:
        mem_mb=64000
    shell:
        """
            #makeblastdb -in /home/nala0006/db/terminase_seq.fasta -parse_seqids -dbtype prot -out /home/nala0006/db/terminase
            blastx -db /home/nala0006/db/terminase -query {input} -num_threads {threads} -outfmt 6 -out {output.tsv} 
        """

#rotate phage to start with terminase gene 
rule rotate_phage:
    input:
        contigs = os.path.join(GENOMEDIR, "{sample}.fasta"),
        tsv=os.path.join(OUTDIR, "recircular", "{sample}-terminase.tsv"),
    output:
        fa = os.path.join(OUTDIR, "recircular", "{sample}.fasta"),
    log:
        os.path.join(logs, "rotate_{sample}.log")
    conda: "../envs/graph.yaml"
    shell:
        """
            export PYTHONPATH=/home/nala0006/opt/EdwardsLab:$PYTHONPATH
            python phages/phages.workflow/scripts/rotate-phage.py -f {input.contigs} -l {input.tsv} --force > {output.fa} 2> {log}
        """

#reverse compliment as needed 
rule rc_phage:
    input:
        contigs = os.path.join(OUTDIR, "recircular", "{sample}.fasta"),
    output:
        fa = os.path.join(OUTDIR, "recircular-rc", "{sample}.fasta")
    params:
        indir= os.path.join(OUTDIR, "recircular"),
        outdir= os.path.join(OUTDIR, "recircular-rc")
    log:
        os.path.join(logs, "rc_{sample}.log")
    conda: "../envs/graph.yaml"
    shell:
        """
            export PYTHONPATH=/home/nala0006/opt/EdwardsLab:$PYTHONPATH
            python phages/phages.workflow/scripts/reverse_complement_fasta.py -d {params.indir} -k 8 -o {params.outdir} 2> {log}
        """
