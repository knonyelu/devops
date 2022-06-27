lines = []

with open ('terraform.tfvars', 'rt') as myfile:
    contents = myfile.read()
    
for line in myfile:
    lines.append(line)
print(lines)