[![install with bioconda](https://img.shields.io/badge/install%20with-bioconda-brightgreen.svg?style=flat)](http://bioconda.github.io/recipes/graphembed/README.html)
![](https://anaconda.org/bioconda/graphembed/badges/license.svg)
![](https://anaconda.org/bioconda/graphembed/badges/version.svg)
![](https://anaconda.org/bioconda/graphembed/badges/latest_release_relative_date.svg)
![](https://anaconda.org/bioconda/graphembed/badges/platforms.svg)
[![install with conda](https://anaconda.org/bioconda/graphembed/badges/downloads.svg)](https://anaconda.org/bioconda/graphembed)



# graphembed-analysis
Repo for installing and analyzing results from [graphembed](https://github.com/jean-pierreBoth/graphembed?tab=readme-ov-file) crate

# Install

## prebuilt binaries for Linux
```bash
wget https://github.com/jianshu93/graphembed/releases/download/v0.1.4/graphembed_Linux_x86-64_v0.1.4.zip
unzip graphembed_Linux_x86-64_v0.1.4.zip
chmod a+x ./graphembed
./graphembed -h

### put this binary into you system/user path

```

## If you have conda installed on Linux
```bash
conda install -c bioconda -c conda-forge graphembed
```

## If you are macOS with homebrew installed
```bash
brew tap jianshu93/graphembed
brew update
brew install graphembed
```

# Usage
```bash
### First download test data
wget https://github.com/jianshu93/graphembed/releases/download/v0.1.1/BlogCatalog.txt

## symetric graph
### embedding alone (no accuracy evaluation and benchmark)

#### sketching via nodesketch algorithm
graphembed --csv ./BlogCatalog.txt --symetric true embedding -o embed_output sketching --dim 128 --decay 0.3 --nbiter 5

#### sketching via HOPE algorithm, only for small datasets (e.g., less than 10,000 nodes)
graphembed --csv ./BlogCatalog.txt --symetric true embedding -o embed_output hope rank --targetrank 128 --nbiter 5

### accuracy evaluation and benchmark via the validation subcommand
#### sketching
RUST_LOG=info graphembed --csv ./BlogCatalog.txt --symetric true validation --nbpass 1  --skip 0.2 --centric sketching --dim 128 --decay 0.3 --nbiter 5
#### HOPE
RUST_LOG=info graphembed --csv ./BlogCatalog.txt --symetric true validation --nbpass 1  --skip 0.2 --centric hope rank --targetrank 128 --nbiter 5



## asymetric graph (directed graph)
## download data
wget https://github.com/jianshu93/graphembed/releases/download/v0.1.1/wiki-Vote.txt

### embedding alone (no accuracy evaluation and benchmark)
#### sketching via nodesketch algorithm
graphembed --csv ./wiki-Vote.txt --symetric false embedding -o embed_output sketching --dim 128 --decay 0.3 --nbiter 5
#### sketching via HOPE algorithm, only for small datasets (e.g., less than 10,000 nodes)
graphembed --csv ./wiki-Vote.txt --symetric false embedding -o embed_output hope rank --targetrank 128 --nbiter 5


### accuracy evaluation and benchmark via the validation subcommand
#### sketching
RUST_LOG=info graphembed --csv ./wiki-Vote.txt --symetric false validation --nbpass 1  --skip 0.2 --centric sketching  --dim 128 --decay 0.3 --nbiter 5
#### HOPE
RUST_LOG=info graphembed --csv ./wiki-Vote.txt --symetric false validation --nbpass 1  --skip 0.2 --centric hope rank --targetrank 128 --nbiter 5


## weighted graph (directed or not)


```
## Benchmark analysis
1. Install MongoDB Database Tools here: https://www.mongodb.com/docs/database-tools/installation/installation-linux/
```bash
### Use the copy in the release page
wget https://github.com/jianshu93/graphembed-analysis/releases/download/v0.0.1/mongodb-database-tools-rhel93-x86_64-100.10.0.tgz
tar -zxvf mongodb-database-tools-rhel93-x86_64-100.10.0.tgz
cd mongodb-database-tools-rhel93-x86_64-100.10.0/bin
chmod a+x ./*
### add to path
echo 'export PATH="'$PWD':$PATH"' >> ~/.bashrc
source ~/.bashrc
./bsondump --help

### for MacOS, simply install via homebrew
brew tap mongodb/brew
brew install mongodb-database-tools
```
2. Run graphembed for your dataset
3. Transfrom from BSON output file to JSON output format
```bash
bsondump --bsonFile=in.bson  --outFile=out.json
```


### Performance note
By default, graphembed relies on [Intel Math Kernel Library](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl.html) (intel-mkl-static feature) as the BLAS backend to make full use of x86 CPU performance on Linux machines. However, it is possible to use the open source [OpenBLAS](https://www.openblas.net) (openblas-static feature) as the BLAS backend. Our tests showed that OpenBLAS is slightly slower than Intel MKL on x86-64 Linux. On x86-64/Intel MacOS, OpenBLAS/Intel-MKL performance is significantly decreased compared to Linux but still supported (openblas-system/intel-mkl-system feature). We also provide the native BLAS framework support from MacOS called [Accelerate Framework](https://developer.apple.com/documentation/accelerate) (macos-accelerate feature). On aarch64 MacOS (M1, M2, M3 and M4 series chips), only the OpenBLAS and Accelerate Framework backend is supported (macos-accelerate feature). Again, performance decreased for both compared to Linux. 


## References

