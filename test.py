from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
import requests

url = 'https://www.naukri.com/'
options = Options()
options.add_experimental_option("detach", True)
driver = webdriver.Chrome(options=options)
s = Service(
    'C:\\Users\\Rahib\\Downloads\\chromedriver_win32\\chromedriver.exe')
driver = webdriver.Chrome(service=s)
options.headless = True
driver.maximize_window()
driver.get(url)


industryLinklist = []
complinklist = []
targetCompanyNameList = []
textfile = open('targetCompanies.txt', 'a')

indusrycard = driver.find_elements(
    By.XPATH, '//span[@class="industry-card "]')
for ele in indusrycard:
    industryLinklist.append(ele.get_attribute("link"))

for i in industryLinklist:
    # driver.implicitly_wait(100)
    driver.get(i)
    next = True
    while next:
        driver.implicitly_wait(10)
        compnames = driver.find_elements(
            By.XPATH, '//div[@class="freeTuple"]')
        for com in compnames:
            x = com.get_attribute("data-href")
            if x not in complinklist:
                complinklist.append(x)
        a = driver.find_element(
            By.XPATH, '//a[@class = "fright fs14 btn-secondary next"]')
        b = a.get_attribute("href")
        if b:
            butt = driver.find_element(
                By.XPATH, '//a[@class = "fright fs14 btn-secondary next"]')

            butt.click()

        else:
            next = False


for j in complinklist:
    # driver.implicitly_wait(100)
    ur = "https://www.naukri.com"+j
    driver.get(ur)

    isNextpage = True
    while isNextpage:
        driver.implicitly_wait(20)
        footer = driver.find_elements(
            By.XPATH, '//div[@data-test= "jobTupleFooterDate"]')

        for f in footer:
            driver.implicitly_wait(20)
            y = f.text.split()[0]
            y = "".join(ch for ch in y if ch.isalnum())
            y = list(y)

            driver.implicitly_wait(10)
            if y[-1] == 'd':
                driver.implicitly_wait(10)
                comname = driver.find_element(
                    By.XPATH, '//h1[@class="head-cont"]').text
                if int("".join(y[:-1])) < 15:
                    if comname not in targetCompanyNameList:
                        targetCompanyNameList.append(comname)
                        textfile.write('\n')
                        textfile.write(comname)
                        # targetCompanyNameList.append(comname)
                        isNextpage = False

        driver.implicitly_wait(10)
        c = driver.find_element(
            By.XPATH, '//a[@data-test="nextButton"]')
        d = c. get_attribute("href")
        if d:
            driver.implicitly_wait(10)
            bu = driver.find_element(
                By.XPATH, '//a[@data-test="nextButton"]')
            bu.click()
        else:
            isNextpage = False

textfile.close()