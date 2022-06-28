import re

def extract():
    with open("terraform.tfvars","r") as file:
        for line in file:
            if re.search('accountid', line):
                return line.split()[-1]

if __name__ == "__main__":
    extract()
