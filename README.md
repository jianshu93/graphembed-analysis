# graphembed-analysis
Repo for installing and analyzing results from graphembed crate

# Install
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
## symetric graph
### embedding alone (no accuracy evaluation and benchmark)

#### sketching via nodesketch algorithm
graphembed --csv ./com-youtube.graph.txt --symetric true embedding -o embed_output sketching --dim 128 --decay 0.3 --nbiter 5 --symetric

#### sketching via HOPE algorithm, only for small datasets (e.g., less than 10,000 nodes)
graphembed --csv ./com-youtube.graph.txt --symetric true embedding -o embed_output hope precision --epsil 0.1 --maxrank 5 --blockiter 3

### accuracy evaluation and benchmark via the validation subcommand
graphembed --csv ./com-youtube.graph.txt --symetric true validation --nbpass 1  --skip 0.1 --centric sketching --symetric --dim 128 --decay 0.3 --nbiter 5


## asymetric graph
### embedding alone (no accuracy evaluation and benchmark)

#### sketching via nodesketch algorithm
graphembed --csv ./wiki-vote.graph.txt --symetric false embedding -o embed_output sketching --dim 128 --decay 0.3 --nbiter 5
#### sketching via HOPE algorithm, only for small datasets (e.g., less than 10,000 nodes)
graphembed --csv ./wiki-vote.graph.txt --symetric false embedding -o embed_output hope precision --epsil 0.1 --maxrank 5 --blockiter 3

```
