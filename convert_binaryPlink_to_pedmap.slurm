#!/bin/bash

#SBATCH -J plink_binary_to_pedmap
#SBATCH -o logs/plink_binary_to_pedmap_%j.out
#SBATCH --cpus-per-task=5
#SBATCH --array=1-1
#SBATCH --partition=batch
#SBATCH -e logs/plink_binary_to_pedmap_%j.error
#SBATCH --mail-user=v.juanillas@irri.org
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --requeue

## load modules

SOFTWARE_DIR="/home/vjuanillas/scratch1/software"

## does not accespt symbolic link
## copy instead
cp /data/3kgenomes/snp-sets-3krg/base_filtered_v0.7.bed.gz .
cp /data/3kgenomes/snp-sets-3krg/base_filtered_v0.7.bim.gz .
cp /data/3kgenomes/snp-sets-3krg/base_filtered_v0.7.fam.gz .

## decompress
gunzip base_filtered_v0.7.bed.gz
gunzip base_filtered_v0.7.bim.gz
gunzip base_filtered_v0.7.fam.gz

## convert binary (bed/bim/fam) to text (ped/map) plink files
$SOFTWARE_DIR/plink-1.07-x86_64/plink --noweb --bfile  base_filtered_v0.7 --recode --out base_filtered_v0.7_txt


## separate per chromosome
for i in $(seq 12);
do
	$SOFTWARE_DIR/plink-1.07-x86_64/plink --noweb --bfile  base_filtered_v0.7 --chr $i --recode --out base_filtered_v0.7_chr$i
done

