#!/usr/bin/python2

import re
data_re = re.compile(r"^((\s+(([0-9\.e+\-]+[tc]?)|min|max))+)\s*$")

def parse_line(line):
	res = []
	for data in line.split():
		try:
			res.append(float(data))
		except:
			res.append(data)
	return res

class Table:
	def __init__(self,title,names,data):
		self.title = title.replace("\t\t","\t").replace("\t"," ")
		self.names = names.split()
		self.data = data

	def max(self,column):
		return max( [ v[column] for v in self.data ] )


def parse(filename):
	mode = "scan"

	tables = []
	lines = []

	for line in open(filename):
		line = line.strip("\n")
		lines.append(line)
		if data_re.match(line):
			#print "+",repr(line)
			if mode == "scan":
				mode = "dump"
				table_data = []
				table = Table( lines[-3], lines[-2], table_data)
				tables.append(table)
			if mode == "dump":
				table_data.append(parse_line(line))
		else:
			#print "-",repr(line)
			mode = "scan"
		#print data_re.match(a)

	return tables


if __name__ == '__main__':


	import json
	tables = parse("traverse.out")


	for i,table in enumerate(tables):
		print i,table.title
		# print tables[.max(3)


	#print json.dumps(tables, indent=4)



