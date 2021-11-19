import bibtexparser

with open("publications.bib") as fp:
	bibtex_database = bibtexparser.bparser.BibTexParser(interpolate_strings=False).parse_file(fp)

remove = [
	"bdsk-url-1",
	"bdsk-file-1",
	"date-modified",
	"date-added",
]
for entry in bibtex_database.entries:
	for key in remove:
		if key in entry:
			del entry[key]

bibtex_database.comments = list()
with open("publications.bib.clean", "w") as fp:
	writer = bibtexparser.bwriter.BibTexWriter(write_common_strings=True)
	writer.indent = "\t"
	bibtexparser.dump(bibtex_database, fp, writer)
	print(
		#bibtexparser.dumps(bibtex_database, writer)
	)
