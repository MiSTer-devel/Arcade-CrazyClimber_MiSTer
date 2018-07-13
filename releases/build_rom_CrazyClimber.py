import zipfile

stZipFile='cclimber.zip'
stROMFile='a.cclimb.rom'

lsExpectedFiles=['cc11', 'cc10', 'cc09', 'cc08', 'cc07', 'cc06', 'cc05', 'cc04', 'cc03', 'cc02', 'cc01', 'cc13', 'cc12']

print('Opening ZIP file',stZipFile)
fZipFile=zipfile.ZipFile(stZipFile,'r')

lsMissingFiles=[]
for stInputFile in lsExpectedFiles:              
    print('Checking %-12s'%stInputFile,end=' ')
    if stInputFile in fZipFile.namelist():                   
        print('ok')                             
    else:
        print('not found')
        lsMissingFiles.append(stInputFile)
        
if lsMissingFiles==[]:
    with open(stROMFile,'wb') as fOutputFile:
        for stInputFile in lsExpectedFiles:
           print('Copying %-13s'%stInputFile,end=' ')
           with fZipFile.open(stInputFile,'r') as fZipSingleFile:
               fOutputFile.write(fZipSingleFile.read())
               print('done')
        print('Target ROM',stROMFile,'created')
else:
    print(len(lsMissingFiles),"files missing:",end=' ')
    print(*lsMissingFiles,sep=', ')
    print('No ROM file created')
