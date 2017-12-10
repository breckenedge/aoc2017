data = [l.split(' ') for l in open('08.txt', 'r').read().split('\n') if l.strip() != '']

regs = {}
max = 0

for r in data:
	regs[r[0]] = 0

for r in data:
	reg = r[0]
	act = 1
	if r[1] == 'dec':
		act = -1
	amt = int(r[2])
	conreg = r[4]
	concon = r[5]
	connum = int(r[6])
	
	if concon == '==':
		if regs[conreg] == connum:
			regs[reg] = regs[reg] + act * amt
	elif concon == '!=':
		if regs[conreg] != connum:
			regs[reg] = regs[reg] + act * amt
	elif concon == '>=':
		if regs[conreg] >= connum:
			regs[reg] = regs[reg] + act * amt
	elif concon == '<=':
		if regs[conreg] <= connum:
			regs[reg] = regs[reg] + act * amt
	elif concon == '>':
		if regs[conreg] > connum:
			regs[reg] = regs[reg] + act * amt
	elif concon == '<':
		if regs[conreg] < connum:
			regs[reg] = regs[reg] + act * amt
			
	if regs[reg] > max:
		max = regs[reg]
			
print(max)
