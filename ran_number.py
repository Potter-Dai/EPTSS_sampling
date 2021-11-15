import random
seq = list(range(400,601))
number = random.sample(seq,60)
number.sort()
R ='\n'.join(str(i) for i in number)
open ('number.txt','w').write(R)
	
