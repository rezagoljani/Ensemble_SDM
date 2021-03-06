
library(biomod2)

sp_nm=spp_nm[1]
i=1
for (sp_nm in spp_nm){
  workspace_name=paste(sp_nm,"_FB_modelfitting.RData", sep = "") #set name of file to save all workspace data after model run
  load(workspace_name)
  myBiomodModelEval <- getModelsEvaluations(myBiomodModelOut)    
  dimnames(myBiomodModelEval)
  #######Loading datasets#######
  for (eval_stat in eval_stats){
    myBiomodModelEval[eval_stat,"Testing.data",,,]
    Spp_eval<- data.frame(myBiomodModelEval[eval_stat,"Testing.data",,,])
    Spp_eval=cbind(matrix(sp_nm,dim(Spp_eval)[1],1),rownames(Spp_eval),Spp_eval)
    
    if (i==1){
      assign(paste0("all_eval_mat_",eval_stat),Spp_eval)
      #all_eval_mat=Spp_eval
    }else{
      jnk=rbind(get(paste0("all_eval_mat_",eval_stat)),Spp_eval)
      assign(paste0("all_eval_mat_",eval_stat),jnk)      
    }
  }
  
  ## getting the variable importance ##
  getModelsVarImport(myBiomodModelOut)
  Spp_VariImp<- data.frame(getModelsVarImport(myBiomodModelOut))
  Spp_VariImp=cbind(matrix(sp_nm,dim(Spp_VariImp)[1],1),rownames(Spp_VariImp),Spp_VariImp)
  if (i==1){
    all_var_imp_mat=Spp_VariImp
  }else{
    all_var_imp_mat=rbind(all_var_imp_mat,Spp_VariImp)
  }
  
  i=i+1
}
FileName<-paste("all_VariImp.csv")
write.table(all_var_imp_mat, file = FileName, sep=",", row.names = FALSE)
all_var_imp_mean=all_var_imp_mat[,1:2]
all_var_imp_mean=cbind(all_var_imp_mean, meanVarImp=apply(all_var_imp_mat[,3:dim(all_var_imp_mat)[2]],1,mean, na.rm=T))
names(all_var_imp_mean)=c("species","var","meanVarImp")
row.names(all_var_imp_mean) <- NULL 
library(reshape2)
library(plyr)
all_var_imp_mean=dcast(all_var_imp_mean, species ~ var, value.var="meanVarImp")
FileName<-paste("all_VariImp_mean.csv")
write.table(all_var_imp_mean, file = FileName, sep=",", row.names = FALSE)

for (eval_stat in eval_stats){
  FileName<-paste0("all_eval_mat_",eval_stat,".csv")
  write.table(get(paste0("all_eval_mat_",eval_stat)), file = FileName, sep=",", row.names = FALSE)

  tmp_eval_map=get(paste0("all_eval_mat_",eval_stat))
  names(tmp_eval_map)[c(1:2)]=c("species","model")
  tmp_eval_map <- reshape(tmp_eval_map, timevar=c("model"), 
                  idvar=c("species"), dir="wide")
  tmp_eval_map2=tmp_eval_map[,1]
  tmp_eval_map2=data.frame(species=tmp_eval_map2, meanEval=apply(tmp_eval_map[,2:dim(tmp_eval_map)[2]],1,mean, na.rm=T))
  row.names(tmp_eval_map2) <- NULL 
  
  #jnk=names(tmp_eval_map)[c(3:dim(tmp_eval_map)[2])]
  #all_var_imp_mean=dcast(all_var_imp_mean, species ~ model, value.var=jnk, na.rm=T)
  FileName<-paste0("all_eval_mean_mat_",eval_stat,".csv")
  write.table(tmp_eval_map2, file = FileName, sep=",", row.names = FALSE)
}
