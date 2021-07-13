
cd src;
  cat Dockerfile |sed "s/ARG AUDIO=\"\"/ARG AUDIO=\"true\"/g" > Dockerfile.AUDIO
  cat Dockerfile |sed "s/ARG AUDIO=\"\"/ARG AUDIO=\"true\"/g" |sed "s^ARG FULL=\"\"^ARG FULL=\"/..\"^g" > Dockerfile.FULL
cd ..
git add -A ./src/Dockerfile.*
git commit -m "syncGen for MultiBuild"

echo "push hub ing..."
git push hub dev