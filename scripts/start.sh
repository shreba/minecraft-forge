#docker service create -p 25565:25565 --mount type=bind,source=/Users/martinsteinmann/Documents/Projects/ml/minecraft-forge/world,destination=/home/minecraft/world --mount type=bind,source=/Users/martinsteinmann/Documents/Projects/ml/minecraft-forge/mods,destination=/home/minecraft/mods --name mc mc

docker run -it -d -p 25565:25565  -v ~/minecraft-forge/minecraft:/home/minecraft/server --name minecraft minecraft
