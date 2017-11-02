import requests
from bs4 import BeautifulSoup


missing_genes = [_.strip() for _ in open("DATA/missingGenesAll.txt", 'r').readlines()]


skip = True
skip_until_gene = '100507051'
with open("DATA/missedGenes.scraped.tsv", 'a') as ofile:
    for gene in missing_genes:
        print(gene)
        if gene == skip_until_gene:
            skip = False
        if skip:
            continue
        url = "https://www.ncbi.nlm.nih.gov/gene/{}".format(gene)
        print(url)
        page = requests.get(url)
        soup = BeautifulSoup(page.text, 'html.parser')

        gContext = soup.find("table", class_="jig-ncbigrid")
        if gContext:
            gContext = gContext.find_all("td")
            geneCoord = gContext[4].prettify().partition('(')[2].partition(')')[0].split('..')
        else:
            gContext = soup.find("dd", class_="rs-range").find_all("span")
            geneCoord = str(gContext[0]).partition('>')[2].partition('<')[0].split('..')

        print(geneCoord)

        ofile.write('\t'.join([gene] + geneCoord + ['\n']))
