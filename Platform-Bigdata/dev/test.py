import argparse

parser = argparse.ArgumentParser(description='Process some integers.')

parser.add_argument('--sum', type=str)
parser.add_argument('--pro', type=str)

args = parser.parse_args()

print(args.sum)
print(args.pro)
