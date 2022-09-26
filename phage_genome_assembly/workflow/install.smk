"""
phage_genomes
assembly and annotation of phage genomes 

2022, Bhavya Papudeshi

This is an auxiliary Snakefile to install databases or dependencies.
"""


"""CONFIGURATION"""
configfile: os.path.join(workflow.basedir, 'config', 'config.yaml')
configfile: os.path.join(workflow.basedir, 'config', 'databases.yaml')


include: "rules/1.preflight-database.smk"


"""TARGETS"""
allDatabaseFiles = []
for file in config['databaseFiles']:
    allDatabaseFiles.append(os.path.join(databaseDir, file))

"""RUN SNAKEMAKE"""
rule all:
    input:
        allDatabaseFiles


"""RULES"""
rule download_db_file:
    """Generic rule to download a database file."""
    output:
        os.path.join(databaseDir, "{file}")
    params:
        mirror = config['mirror']
    run:
        import urllib.request
        import urllib.parse
        import shutil
        dlUrl1 = urllib.parse.urljoin(params.mirror, wildcards.file)
        dlUrl2 = urllib.parse.urljoin(params.mirror, wildcards.file)
        try:
            with urllib.request.urlopen(dlUrl1) as r, open(output[0],'wb') as o:
                shutil.copyfileobj(r,o)
        except:
            with urllib.request.urlopen(dlUrl2) as r, open(output[0],'wb') as o:
                shutil.copyfileobj(r,o)