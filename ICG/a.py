f=open("3ac.txt","r")
f1=open("output.txt","w")
f1.close()
f1=open("output.txt","a")
#print(f.read())
for x in f:
	for i in x:
		#print(i)
		if i==" ":
			continue
		else:
			f1.write(str(i))
f1.close()
f.close()

f1=open("output.txt","r")
f2=open("output1.txt","w")
f2.close()
f2=open("output1.txt","a")
for x in f1:
	for i in x:
		#print(i)
		if i=="=":
			f2.write(str(x))
f1.close()
f2.close()

f1=open("output1.txt","r")
f2=open("output2.txt","w")
f2.close()
f2=open("output2.txt","a")
for x in f1:
	if(len(x)==6):
		f2.write(str(x))
	for i in range(0,len(x)):
		#print(i)
		
		if x[i]=="(" or x[i]==":":
			while(i<len(x)):
				#print(x[i])
				if(x[i]==")" or x[i]=="\n"):
					f2.write("\n")
					break
				else:
					f2.write(str(x[i+1]))
				i=i+1
f1.close()
f2.close()
		
f1=open("output2.txt","r")
f2=open("quad.txt","w")
f2.close()
f2=open("quad.txt","a")
print("*********Quadruple *************")
print("operator operand1 \toperand2 \tresult")
for x in f1:
	#for i in range(0,len(x)):
		if len(x)==4 or len(x)==5:
			print(x[1]+'\t\t'+x[2]+"\t\t"+"NULL"+"\t\t"+x[0])
			f2.write(x[1]+' '+x[2]+" "+"NULL"+" "+x[0]+"\n")
			
		if len(x)>5:
			print(x[4]+'\t\t'+x[3]+'\t\t'+x[5]+'\t\t'+x[0:2])
			f2.write(x[4]+' '+x[3]+' '+x[5]+' '+x[0:2]+"\n")
		
