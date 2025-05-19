import json

counter = int(input("Input how many JSONs do you need: "))


rez = []
for i in range(counter):
    metadata ={
        "name": f"DAO Membership #{i+1}",
        "description": f"Member number #{i+1} of prestigious Decentralized Autonomous Organization",
        "image": "ipfs://bafybeihbwerd7vsp6ii4hbgp4izkzvatwbz5m5xiucp4ys6uwgglnef67y/1.png"
    }
    rez.append(metadata)

for meta in rez:
    print(json.dumps(meta,indent=4))