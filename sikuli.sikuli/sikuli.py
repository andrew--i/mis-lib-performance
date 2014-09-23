from datetime import datetime
from subprocess import call
import random

def clearCache():    
        logPerfomance("START DELETING CACHE")
        click("1410522373955.png")
        click("1410522609628.png")
        click("1410522750490.png")
        click("1410522783369.png")
        click("1410522808899.png")
        click("1410522841725.png")
        click("1410522865301.png")
        logPerfomance("END DELETING CACHE")    
       
        
    
def logPerfomance(msg):
    log_msg = "PERF_LOG|" + msg + "|" + str(datetime.now())
    print(log_msg)
    logFile.write(log_msg+"\r\n")
    call(["java","-jar","flashMemoryUsage.jar",'mem_'+msg+'_'+str(random.random())+'_'+logFileName])
        
def closeBrowser():
    logPerfomance("START CLOSGIN BROWSER")    
    click("1410523689098.png")
    logPerfomance("END CLOSGIN BROWSER")    
    logFile.close()

def openWebApp():
    logPerfomance("START OPENING WEB APP")
    click("1411459814636.png")
    type("http://localhost:8080"+Key.ENTER)
    wait("1411460020147.png", 90)
    
    logPerfomance("END OPENING WEB APP")

def openFirefox():
    App.open("C:\\Program Files (x86)\\Mozilla Firefox\\firefox.exe")

def openModule1():
    logPerfomance("START OPENING MODULE1")    
    click("1411460020147.png")
    wait("1411460223723.png")    
    logPerfomance("END OPENING MODULE1")    
       
def openModule2():
    logPerfomance("START OPENING MODULE2")    
    click("1411460280956.png")
    wait("1411460297085.png")    
    logPerfomance("END OPENING MODULE2")    

for i in range(1, 6):    
    openFirefox()
    logFileName = "current_"+ str(i) + ".txt"
    logFile = open(logFileName, "w+")
    clearCache()
    openWebApp()
    openModule2()
    openModule1()
    closeBrowser()


