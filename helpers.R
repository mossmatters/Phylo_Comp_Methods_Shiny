library(ape)
library(picante)
trees = read.nexus("data/oenothera_evansetal.mrbayes.posterior.tre")
mytraits = read.table("data/oenothera_evansetal.txt",header=T,row.names=1)

mytrait.cor.table = cor.table(mytraits)

make.rooted.ultrametric = function(mytree){
  tips.to.drop = setdiff(mytree$tip.label,rownames(mytraits))
  mytree.ingroup = drop.tip(mytree,tips.to.drop)
  mytree.ingroup.di = multi2di(mytree.ingroup)
  mytree.ingroup.di.rooted =root(mytree.ingroup.di,'Oenothera_nuttallii',resolve.root=T) 
  mytree.ingroup.di.rooted.ultrametric = chronopl(mytree.ingroup.di.rooted,lambda=1)  
  phy = multi2di(mytree.ingroup.di.rooted.ultrametric)
  
}

