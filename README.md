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
./proteinortho_curves.r -p <your_project_name>.proteinortho -i <number_of_iterations> 
-o <output_prefix> [plot parameters]
```
Output:

    <output_prefix>_proteinortho_curves.txt
    <output_prefix>_proteinortho_curves.png

-i parameter:

In each iteration the script randomly permutates the columns (strains) of the proteinortho output. It then adds the strains in the new order of
the columns to the Core- and Pan-genome calculations. The number of iterations is usually 100 and it should not be lower than 10. 

### Plotting existing calculations

As the calculations can take quite some time, depending on the number of iterations, this is the way to redraw the plot for an
existing proteinortho_curves table and experiment with the plot parameters. 

```bash
./proteinortho_curves.r -d TRUE -t <output_prefix>_proteinortho_curves.txt 
-o <output_prefix> [plot parameters]
```

Output:

    <output_prefix>_proteinortho_curves.png

If you don't want Pan- and Core-Genome size text on the plot, set --x_pan_text and --y_pan_text to a higher number (above 2) and the text should not be visible 
