# localrules: trimal_dna, trimal_protein

rule trimal_dna:
    input:
        fna_list=directory(mafft_dir_path / "fna_tmp" / "{N}")
    output:
        temp(directory(trimal_dir_path / "fna_tmp" /"{N}"))
    params:
        trimal_path=config["trimal_path"],
        options=config["trimal_dna_params"]
    log:
        std=log_dir_path / "trimal_dna/{N}.log",
        cluster_log=cluster_log_dir_path / "trimal_dna/{N}.cluster.log",
        cluster_err=cluster_log_dir_path / "trimal_dna/{N}.cluster.err"
    benchmark:
        benchmark_dir_path / "trimal_dna/{N}.benchmark.txt"
    resources:
        cpus=config["trimal_threads"],
        time=config["trimal_time"],
        mem=config["trimal_mem_mb"]
    shell:
        "mkdir -p {output}; "
        "for FILE in `ls {input.fna_list}/*`; do "
        "{params.trimal_path}/trimal -in ${{FILE%.*}}.fna -out {output}/$(basename ${{FILE%.*}}.fna) {params.options} "
        "1> {log.std} 2> {log.std}; "
        "{params.trimal_path}/trimal -in {output}/$(basename ${{FILE%.*}}.fna) -out {output}/$(basename ${{FILE%.*}}.fna) -nogaps "
        "1> {log.std} 2> {log.std}; "
        "done"


rule trimal_protein:
    input:
        faa_list=directory(mafft_dir_path / "faa_tmp" / "{N}")
    output:
        temp(directory(trimal_dir_path / "faa_tmp" /"{N}"))
    params:
        trimal_path=config["trimal_path"],
        options=config["trimal_protein_params"]
    log:
        std=log_dir_path / "trimal_protein/{N}.log",
        cluster_log=cluster_log_dir_path / "trimal_protein/{N}.cluster.log",
        cluster_err=cluster_log_dir_path / "trimal_protein/{N}.cluster.err"
    benchmark:
        benchmark_dir_path / "trimal_protein/{N}.benchmark.txt"
    resources:
        cpus=config["trimal_threads"],
        time=config["trimal_time"],
        mem=config["trimal_mem_mb"]
    shell:
        "mkdir -p {output}; "
        "for FILE in `ls {input.faa_list}/*`; do "
        "{params.trimal_path}/trimal -in ${{FILE%.*}}.faa -out {output}/$(basename ${{FILE%.*}}.faa) {params.options} "
        "1> {log.std} 2>&1; "
        "{params.trimal_path}/trimal -in {output}/$(basename ${{FILE%.*}}.faa) -out {output}/$(basename ${{FILE%.*}}.faa) -nogaps "
        "1> {log.std} 2>&1; "
        "done"