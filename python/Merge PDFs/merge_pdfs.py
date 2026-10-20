from PyPDF2 import PdfMerger

def merge_pdfs(pdf_list, output):
    merger = PdfMerger()
    for pdf in pdf_list:
        merger.append(pdf)
    merger.write(output)
    merger.close()

pdf_files = ['file1.pdf', 'file2.pdf', 'file3.pdf']
output_file = 'merged.pdf'
merge_pdfs(pdf_files, output_file)
