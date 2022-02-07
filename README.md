# proteinortho_curves


[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.2559281.svg)](https://doi.org/10.5281/zenodo.2559281)



This script creates accumulation curves for pan- and core-genomes calculated with Proteinortho ([Lechner et al. 2011](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-12-124).)

 <img src="https://user-images.githubusercontent.com/47421170/152796728-8fb9250f-b14f-4739-adc9-23a83572c056.png" width="1000" >

## Requirements
- R 
- R package "ggplot2"
- R package "grid"
- R package "optparse"
- Proteinortho output calculated with "-singles" option

```
Versions I use:
- proteinortho v5.16b
- R version 3.6.3
- ggplot2_3.3.5
- optparse_1.6.6
```


## Usage


```bash
proteinortho_curves.r [options]
```

### Calculations and first plot

Proteinortho must have been run using the "-singles" option!

```bash
proteinortho_curves.r -p <your_project_name>.proteinortho -i <number_of_iterations> 
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
proteinortho_curves.r -d TRUE -t <output_prefix>_proteinortho_curves.txt 
-o <output_prefix> [plot parameters]
```

Output:

    <output_prefix>_proteinortho_curves.png

If you don't want Pan- and Core-Genome size text on the plot, set --x_pan_text and --y_pan_text to a higher number (above 2) and the text should not be visible 

## Options/Plot Parameters Overview

```bash
Options:
	-p PROTEINORTHO, --proteinortho=PROTEINORTHO
		Output from proteinortho <myproject.proteinortho>

	-i ITERATIONS, --iterations=ITERATIONS
		Number of iterations to perform [default=10]

	-d DRAW_ONLY, --draw_only=DRAW_ONLY
		Draw plot from a previously calculated table [default=FALSE]

	-t TABLE, --table=TABLE
		When -d TRUE, previously calculated output from proteinortho_curves.r <proteinortho_curves.txt>

	-o OUTPUT, --output=OUTPUT
		Name of output file(s) [default=proteinortho_curves]

	--plot_width=PLOT_WIDTH
		Width of the plot [default=10]

	--plot_height=PLOT_HEIGHT
		Height of the plot [default=7]

	--pan_color=PAN_COLOR
		Color of the pan-genome boxplots [default=#82c6b8]

	--pan_text_color=PAN_TEXT_COLOR
		Color of the pan-genome text [default=#0d9a7e]

	--core_color=CORE_COLOR
		Color of the core-genome boxplots [default=#c35b8e]

	--core_text_color=CORE_TEXT_COLOR
		Color of the pan-genome text [default=#8b104e]

	--plot_title=PLOT_TITLE
		Title of the plot [default=Proteinortho Pan- and Core-Genome Size]

	--plot_title_size=PLOT_TITLE_SIZE
		Size of the title of the plot [default=12]

	--x_axis_title=X_AXIS_TITLE
		Title of the x axis [default=Number of genomes]

	--y_axis_title=Y_AXIS_TITLE
		Title of the y axis [default=Number of orthologs]

	--axis_title_size=AXIS_TITLE_SIZE
		Size of the x and y axis titles [default=10]

	--axis_text_size=AXIS_TEXT_SIZE
		Size of the x and y axis text [default=8]

	--axis_text_mode=AXIS_TEXT_MODE
		How many tick marks to show on x axis. 1=all, 2=every second, etc [default=1]

	--x_pan_text=X_PAN_TEXT
		Relative x position of the pan-genome text [default=0.84]

	--y_pan_text=Y_PAN_TEXT
		Relative y position of the pan-genome text [default=0.5]

	--x_core_text=X_CORE_TEXT
		Relative x position of the core-genome text [default=0.84]

	--y_core_text=Y_CORE_TEXT
		Relative y position of the core-genome text [default=0.46]

	--pan_core_text_size=PAN_CORE_TEXT_SIZE
		Relative size of the pan- and core-genome text [default=1]

	-h, --help
		Show this help message and exit
```
