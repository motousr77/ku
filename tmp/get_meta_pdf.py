import sys
from pdfminer.pdfparser import PDFParser
from pdfminer.pdfdocument import PDFDocument

file_name = ""
if len(sys.argv) > 1:
    file_name = sys.argv[1]
else:
    print(sys.argv[0])
    print(sys.stderr.write('Input argument / path to folder'))

fp = open(file_name, 'rb')
parser = PDFParser(fp)
doc = PDFDocument(parser)

print(doc.info)  # The "Info" metadata
