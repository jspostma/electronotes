import fitz
import sys
import os
from glob import glob

if len(sys.argv) > 1:
    arg = sys.argv[1]
else:
    print("no input folder")
    exit(0)

if not os.path.exists(arg):
    print("cant find path")
    exit(0)

basedir = os.path.abspath(arg)
pagedir = os.path.join(basedir, 'out')
pagefiles = glob(os.path.join(pagedir, '*.tif'))
outfile = arg + '.pdf'

doc = fitz.open()

for page in pagefiles:
    img = fitz.open(page)
    byts = img.convert_to_pdf()
    pdf = fitz.open("pdf", byts)
    doc.insert_pdf(pdf)

outpath = os.path.join(basedir, outfile)

doc.save(outpath)
