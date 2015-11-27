library(shiny)
library(ape)
library(picante)
library(phytools)

source("helpers.R")

trees = read.nexus("data/oenothera_evansetal.mrbayes.posterior.tre")
mytraits = read.table("data/oenothera_evansetal.txt",header=T,row.names=1)

mytrait.cor.table = cor.table(mytraits)



# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically
  #     re-executed when inputs change
  #  2) Its output type is a plot
  pic.me = function(x){
    names(x) = rownames(mytraits)
    mytree= make.rooted.ultrametric(trees[[input$treenum]])
    pic(x,mytree)
  }

  output$treePlot <- renderPlot({
    phy = make.rooted.ultrametric(trees[[input$treenum]])
    plot(phy)})
  
  output$traitTable = renderDataTable({
    x = cbind(rownames(mytraits),mytraits); colnames(x)[1] = "Species"
    x
    })
  output$pdfviewer <- renderText({
    return(paste('<iframe style="height:600px; width:100%" src="', input$pdfurl, '"></iframe>', sep = ""))
  })
  output$simpleRegression = renderPlot({
    plot(mytraits[,input$independent]~mytraits[,input$dependent],xlab=input$dependent,ylab=input$independent,pch=16,cex=2,main="Uncorrected Regression")
    abline(lm(mytraits[,input$independent]~mytraits[,input$dependent]))
    })
    output$r.text = renderText({
      r = mytrait.cor.table$r[input$independent,input$dependent]
      paste("The correlation coefficient is",round(r,3))
      })
    output$p.text = renderText({
      P = mytrait.cor.table$P[input$independent,input$dependent]
      paste("The P-value is",round(P,8))
      })
    output$picRegression = renderPlot({
      independent.trait = mytraits[,input$independent.pic];names(independent.trait) = rownames(mytraits)
      dependent.trait = mytraits[,input$dependent.pic];names(dependent.trait) = rownames(mytraits)
      
      independent.pic = pic(independent.trait,make.rooted.ultrametric(trees[[input$treenum]]))
      dependent.pic = pic(dependent.trait,make.rooted.ultrametric(trees[[input$treenum]]))
       
      plot(independent.pic~dependent.pic,xlab=paste(input$dependent,"PIC"),ylab=paste(input$independent,"PIC"),pch=16,cex=2,main="Phylogenetic Regression")
      abline(lm(independent.pic~dependent.pic))
    })
    output$r.pic.text = renderText({
      pic.table = apply(mytraits,2,pic.me)
      pic.cor.table = cor.table(pic.table)
      
      r = pic.cor.table$r[input$independent.pic,input$dependent.pic]
      paste("The correlation coefficient is",round(r,3))
    })
    output$p.pic.text = renderText({
      pic.table = apply(mytraits,2,pic.me)
      pic.cor.table = cor.table(pic.table)
      
      P = pic.cor.table$P[input$independent.pic,input$dependent.pic]
      paste("The P-value is",round(P,8))
    })
    
    output$my.phenogram = renderPlot({
      trait = mytraits[,input$phenogram.trait]; names(trait) = rownames(mytraits)
      phenogram(make.rooted.ultrametric(trees[[input$treenum]]),trait,main=paste("Tree Number:",input$treenum))
    },width=600)
    
    output$phylosignal = renderText({
      my.trait = mytraits[,input$phenogram.trait]; names(my.trait ) = rownames(mytraits)
      my.tree = make.rooted.ultrametric(trees[[input$treenum]])
      capture.output(phylosig(my.tree,my.trait,test=input$do.test,method = input$statistic))
    })
    
    
#     output$pagel.text = renderText({
#       my.trait = mytraits[,input$phenogram.trait]; names(my.trait ) = rownames(mytraits)
#       my.tree = make.rooted.ultrametric(trees[[input$treenum]])
#       my.lambda = phylosig(my.tree,my.trait,"lambda")[['lambda']]
#       paste("Pagel's lambda:",signif(my.lambda,4))
#     })
#     output$blomberg.text = renderText({
#       my.trait = mytraits[,input$phenogram.trait]; names(my.trait ) = rownames(mytraits)
#       my.tree = make.rooted.ultrametric(trees[[input$treenum]])
#       my.k = phylosig(my.tree,my.trait)
#       paste("Blomberg's K:",signif(my.k,4))
#     })
    })  

  
