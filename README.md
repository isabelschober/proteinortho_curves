# proteinortho_curves
Draw pan- and core-genome curves from proteinortho output

## Requirements
- R 
- R package "ggplot2"
- R package "grid"
- R package "optparse"
- Proteinortho output calculated with "-singles" option

## Usage

```bash
./proteinortho_curves.r [options]
```

### Calculations and first plot


```bash
../proteinortho_curves.r -p <your_project_name>.proteinortho -i <number_of_iterations> 
-o <output_prefix> [plot parameters]
```
