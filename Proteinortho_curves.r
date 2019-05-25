#!/usr/bin/Rscript

################################################################
#                                                              #
#                         by Isabel                            #  
#                         25.05.2019                           #
#         Usage: ./proteinortho_curves.r [options]             #
#        See ./proteinortho_curves.r -h for options            #
#                                                              #
################################################################

library(ggplot2)
library(grid)
library(optparse)

option_list=list(
  make_option(c("-p","--proteinortho"), action="store", default=NA, type="character", help="Output from proteinortho <myproject.proteinortho>"),
  make_option(c("-i", "--iterations"), action="store", default=10, type="integer", help="Number of iterations to perform [default=%default]"),
  make_option(c("-d","--draw_only"), action="store", default=FALSE, type="logical", help="Draw plot from a previously calculated table [default=%default]"),
  make_option(c("-t","--table"), action="store", default=NA, type="character", help="When -d TRUE, previously calculated output from proteinortho_curves.r <proteinortho_curves.txt>"),
  make_option(c("-o","--output"), action="store", default="proteinortho_curves", type="character", help="Name of output file(s) [default=%default]"),
  make_option(c("-b","--errorbars"), action="store", default=FALSE, type="logical", help="Set -b TRUE to draw median with error bars instead of boxplots"),
  make_option(c("--plot_width"), action="store", default=10, type="numeric", help="Width of the plot [default=%default]"),
  make_option(c("--plot_height"), action="store", default=7, type="numeric", help="Height of the plot [default=%default]"),
  make_option(c("--pan_color"), action="store", default="#267285", type="character", help="Color of the pan-genome boxplots [default=%default]"),
  make_option(c("--pan_text_color"), action="store", default="#267285", type="character", help="Color of the pan-genome text [default=%default]"),
  make_option(c("--core_color"), action="store", default="#8b104e", type="character", help="Color of the core-genome boxplots [default=%default]"),
  make_option(c("--core_text_color"), action="store", default="#8b104e", type="character", help="Color of the pan-genome text [default=%default]"),
  make_option(c("--plot_title"), action="store", default="Proteinortho Pan- and Core-Genome Size", type="character", help="Title of the plot [default=%default]"),
  make_option(c("--plot_title_size"), action="store", default=12, type="integer", help="Size of the title of the plot [default=%default]"),
  make_option(c("--x_axis_title"), action="store", default="number of genomes", type="character", help="Title of the x axis [default=%default]"),
  make_option(c("--y_axis_title"), action="store", default="number of orthologs", type="character", help="Title of the y axis [default=%default]"),
  make_option(c("--axis_title_size"), action="store", default=10, type="integer", help="Size of the x and y axis titles [default=%default]"),
  make_option(c("--axis_text_size"), action="store", default=8, type="integer", help="Size of the x and y axis text [default=%default]"),
  make_option(c("--axis_text_mode"), action="store", default=1, type="integer", help="How many tick marks to show on x axis. 1=all, 2=every second, etc [default=%default]"),
  make_option(c("--x_pan_text"), action="store", default=0.84, type="numeric", help="Relative x position of the pan-genome text [default=%default]"),
  make_option(c("--y_pan_text"), action="store", default=0.5, type="numeric", help="Relative y position of the pan-genome text [default=%default]"),
  make_option(c("--x_core_text"), action="store", default=0.84, type="numeric", help="Relative x position of the core-genome text [default=%default]"),
  make_option(c("--y_core_text"), action="store", default=0.46, type="numeric", help="Relative y position of the core-genome text [default=%default]"),
  make_option(c("--pan_core_text_size"), action="store", default=1, type="numeric", help="Relative size of the pan- and core-genome text [default=%default]")
  )

opt_parser=OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

# check non-optional input
if (is.na(opt$proteinortho) && opt$draw_only==FALSE){
  stop("Proteinortho output is needed when -d FALSE", call.=FALSE)
  print_help(opt_parser)
} else if (is.na(opt$table) && opt$draw_only==TRUE){
  stop("proteinortho_curves.r output is needed when -d TRUE", call.=FALSE)
  print_help(opt_parser)
  
}

if (opt$draw_only==FALSE){
  # set number of iterations
  iterations=as.integer(opt$iterations)

  # read in proteinortho output
  proteinortho=read.table(opt$proteinortho, header=F, sep="\t",stringsAsFactors=FALSE)
  # get proteinortho table with only relevant columns
  table_all=proteinortho[,4:ncol(proteinortho)]
  
  # initialize output data frame
  out=data.frame(matrix(ncol=3,nrow=ncol(table_all)*iterations))
  colnames(out)=c("nrGenomes","sizeCore","sizePan")
  
  coln=1
  
  for (iteration in 1:iterations){
    cat("\nIteration ", iteration, "  ")
    # get shuffled proteinortho table
    table_all_shuffle=table_all[,sample(ncol(table_all))]
    
    for (n in 1:ncol(table_all_shuffle)){
      # get subtable of shuffled proteinortho table with only the n first columns
      table=table_all_shuffle[,1:n, drop=F]
      northo=0
      npan=0
      # count how many ortholog groups are present in at least one of the first n columns -> npan
      # count how many ortholog groups are present in all the first n columns -> northo
      for (i in 1:nrow(table)){
        nstrains_prot=0
        nstrains_star=0
        for (j in 1:ncol(table)){
          # locus_tag in cell (no *), ortholog group present
          if (table[i,j]!="*" && table[i,j]!="*\n"){
            nstrains_prot=nstrains_prot+1
          }
          # * in cell, ortholog group not present
          else if (table[i,j]=="*" || table[i,j]=="*\n"){
            nstrains_star=nstrains_star+1
          }
        }
        if (nstrains_prot==ncol(table)){
          northo=northo+1
        }
        if (nstrains_star!=ncol(table)){
          npan=npan+1
        }
      }
      # fill into output table
      out[coln,1]=sprintf("%03d",n)
      out[coln,2]=northo
      out[coln,3]=npan
      coln=coln+1
      cat(".")
    }
  }
  cat("\n")
  # write output table
  write.table(out, file=paste(opt$output,"_proteinortho_curves.txt", sep=""), sep="\t", row.names=F, quote=F)
  cols=ncol(table_all)
  
} else if (opt$draw_only==TRUE){
  # read input table
  out=read.table(opt$table, sep="\t", header=T, colClasses=c("character","integer","integer"))
  # get number of genomes in the input
  cols=as.integer(max(out$nrGenomes))
}

# x axis tick marks
# if not every x axis tick mark should be printed, print "" instead
mylabs=seq(cols)
for (n in seq(1:cols)){
  if ((as.integer(mylabs[n])%%opt$axis_text_mode)!=0){
    mylabs[n]=""
  }
}

# draw curves
gg=ggplot()
if(opt$errorbars==FALSE){
  gg=gg+geom_boxplot(data=out, aes(x=out$nrGenomes, y=out$sizePan), fill=opt$pan_color)
  gg=gg+geom_boxplot(data=out, aes(x=out$nrGenomes, y=out$sizeCore), fill=opt$core_color)
} else if(opt$errorbars==TRUE){
  gg=gg+geom_point(data=out, mapping=aes(x=out$nrGenomes, y=out$sizePan), fill=opt$pan_color, stat = "summary",fun.y=median, color=opt$pan_color)
  gg=gg+geom_point(data=out, mapping=aes(x=out$nrGenomes, y=out$sizeCore), fill=opt$core_color, stat = "summary",fun.y=median, color=opt$core_color)
  gg=gg+geom_errorbar(data=out, mapping=aes(x=out$nrGenomes, y=out$sizePan), color=opt$pan_color,
                stat = "summary",
                fun.ymin = min,
                fun.ymax = max,
                fun.y = median)
  gg=gg+geom_errorbar(data=out, mapping = aes(x=out$nrGenomes, y=out$sizeCore), color=opt$core_color,
                      stat = "summary",
                      fun.ymin = min,
                      fun.ymax = max,
                      fun.y = median)
}
gg=gg+ggtitle(opt$plot_title)
gg=gg+ylab(opt$y_axis_title)
gg=gg+xlab(opt$x_axis_title)
gg=gg+scale_x_discrete(labels=mylabs)
pan_grob=grid.text(paste0("Pan-genome: ",out[nrow(out),3]),x=opt$x_pan_text, y=opt$y_pan_text, gp=gpar(col=opt$pan_text_color,cex=opt$pan_core_text_size), draw=F)
core_grob=grid.text(paste0("Core-genome: ",out[nrow(out),2]),x=opt$x_core_text, y=opt$y_core_text, gp=gpar(col=opt$core_text_color,cex=opt$pan_core_text_size), draw=F)
gg=gg+annotation_custom(pan_grob)
gg=gg+annotation_custom(core_grob)
gg=gg + theme(
  plot.title = element_text(margin=margin(b=6), size=opt$plot_title_size))
gg=gg + theme(
  axis.title.x = element_text(margin=margin(t=6), size=opt$axis_title_size),
  axis.title.y = element_text(margin=margin(r=6), size=opt$axis_title_size))
gg=gg + theme(
  axis.text.x = element_text(size=opt$axis_text_size),
  axis.text.y = element_text(size=opt$axis_text_size))
ggsave(filename=paste(opt$output,"_proteinortho_curves.png", sep=""), scale=1, width=opt$plot_width, height=opt$plot_height)

cat("\nDone!\n")
