# graphembed-analysis
Repo for installing and analyzing results from [graphembed](https://github.com/jean-pierreBoth/graphembed?tab=readme-ov-file) crate

# Install

## prebuilt binaries for Linux
```bash
wget https://github.com/jianshu93/graphembed/releases/download/v0.1.2/graphembed_Linux_x86-64_v0.1.1.zip
unzip graphembed_Linux_x86-64_v0.1.1.zip
chmod a+x ./graphembed
./graphembed -h

### put this binary into you system/user path

```

## If you have conda installed on Linux
```bash
conda install -c bioconda graphembed
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
graphembed --csv ./BlogCatalog.txt --symetric true embedding -o embed_output sketching --dim 128 --decay 0.3 --nbiter 5 --symetric

#### sketching via HOPE algorithm, only for small datasets (e.g., less than 10,000 nodes)
graphembed --csv ./BlogCatalog.txt --symetric true embedding -o embed_output hope precision --epsil 0.1 --maxrank 1000 --blockiter 3

### accuracy evaluation and benchmark via the validation subcommand
#### sketching
graphembed --csv ./BlogCatalog.txt --symetric true validation --nbpass 1  --skip 0.2 --centric sketching --symetric --dim 128 --decay 0.3 --nbiter 5
#### HOPE
graphembed --csv ./BlogCatalog.txt --symetric true validation --nbpass 1  --skip 0.2 --centric hope precision --epsil 0.1 --maxrank 1000 --blockiter 3


## asymetric graph (directed graph)
## download data
wget https://github.com/jianshu93/graphembed/releases/download/v0.1.1/wiki-Vote.txt

### embedding alone (no accuracy evaluation and benchmark)
#### sketching via nodesketch algorithm
graphembed --csv ./wiki-Vote.txt --symetric false embedding -o embed_output sketching --dim 128 --decay 0.3 --nbiter 5
#### sketching via HOPE algorithm, only for small datasets (e.g., less than 10,000 nodes)
graphembed --csv ./wiki-Vote.txt --symetric false embedding -o embed_output hope precision --epsil 0.1 --maxrank 5 --blockiter 3


### accuracy evaluation and benchmark via the validation subcommand
#### sketching
graphembed --csv ./wiki-Vote.txt --symetric false validation --nbpass 1  --skip 0.2 --centric sketching  --dim 128 --decay 0.3 --nbiter 5
#### HOPE
graphembed --csv ./wiki-Vote.txt --symetric false validation --nbpass 1  --skip 0.2 --centric hope precision --epsil 0.1 --maxrank 1000 --blockiter 3


## weighted graph (directed or not)


```
