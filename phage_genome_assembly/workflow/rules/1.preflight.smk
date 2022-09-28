"""
Add your preflight checks as pure Python code here.
e.g. Configure the run, declare directories, validate the input files etc.
"""


"""CONFIGURATION
parsing the config to variables is not necessary, but it looks neater than typing out config["someParam"] every time.
"""

READDIR = config['input']
OUTDIR = config['output']
print(f"Output files will be saved to directory, {OUTDIR}\n")
logs = os.path.join(OUTDIR,'logs')

"""CHECK IF CUSTOM DATABASE DIRECTORY"""
if config['customDatabaseDirectory'] is None:
    databaseDir = os.path.join(workflow.basedir, 'databases')
else:
    databaseDir = config['customDatabaseDirectory']
DATABASES = config['customDatabaseDirectory']
print(f"Databases are being saved in, {DATABASES} \n")


if config ['sequencing'] == 'paired':
    QCDIR = os.path.join(OUTDIR, 'prinseq')
    print(f"Illumina QC is run using prinseq, and the output files are saved to, {QCDIR}\n")
    SAMPLES,EXTENSIONS, = glob_wildcards(os.path.join(READDIR, '{sample}_R1{extn}'))
    if len(SAMPLES) == 0:
        sys.stderr.write(f"We did not find any fastq files in {SAMPLES}. Is this the right read dir?\n")
        sys.stderr.write(f"If the files are there, but running into an error, check filepaths\n")
        sys.exit(0)
    if len(set(EXTENSIONS)) != 1:
        sys.stderr.write("FATAL: You have more than one type of file extension\n\t")
        sys.stderr.write("\n\t".join(set(EXTENSIONS)))
        sys.stderr.write("\nWe don't know how to handle these\n")
        sys.exit(0)

    FQEXTN = EXTENSIONS[0]
    PATTERN_R1 = '{sample}_R1' + FQEXTN
    PATTERN_R2 = '{sample}_R2' + FQEXTN

elif config['sequencing'] == 'longread':
    QCDIR = os.path.join(OUTDIR, 'filtlong')
    print(f"Nanopore fastq files run through QC using filtlong, the outputs are saved to, {QCDIR}\n")
    SAMPLES,EXTENSIONS, =glob_wildcards(os.path.join(READDIR, '{sample}.{extn}'))
    if len(SAMPLES) ==0:
        sys.stderr.write(f"We did not find any fastq files in {SAMPLES2}. Is this the right read dir?\n")
        sys.stderr.write(f"If the files are there, but running into an error, check filepaths\n")
        sys.exit(0)
    if len(set(EXTENSIONS)) != 1:
        sys.stderr.write("FATAL: You have more than one type of file extension\n\t")
        sys.stderr.write("\n\t".join(set(EXTENSIONS2)))
        sys.stderr.write("\nWe don't know how to handle these\n")
        sys.exit(0)

    FQEXTN = EXTENSIONS[0]
    PATTERN = '{sample}.'+FQEXTN

ASSEMBLY = os.path.join(OUTDIR, 'assembly')
print(f"Saving the assemblies here, {ASSEMBLY}\n")


"""DIRECTORIES/FILES etc.
Declare some directories for pipeline intermediates and outputs.
"""
stderrDir = os.path.join(OUTDIR, 'errorLogs')

#saving the prefix that will be added to all the sample names from the config file 
#help point out the files that were generated by the workflow
#SAMPLE_ID=re.sub('\W+','', config['sample_id'])

"""ONSTART/END/ERROR
Tasks to perform at various stages the start and end of a run.
"""
onstart:
    """Cleanup old log files before starting"""
    if os.path.isdir(stderrDir):
        oldLogs = filter(re.compile(r'.*.log').match, os.listdir(stderrDir))
        for logfile in oldLogs:
            os.unlink(os.path.join(stderrDir, logfile))

onsuccess:
    """Print a success message"""
    sys.stderr.write('\n\nphage_genomes finished successfully!\n\n')

onerror:
    """Print an error message"""
    sys.stderr.write('\n\nERROR: phage_genomes failed to finish.\n\n')

